import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/prediction_content.dart';
import 'package:covigenix/ui/custom_widgets/prediction_progress.dart';
import 'package:covigenix/ui/model/prediction_response.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class Audio extends StatefulWidget {
  @override
  _AudioState createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  late FlutterAudioRecorder _recorder;
  late Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool isLoading = false;
  BuildContext? waitingContext = null;
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

// ----------------------  Here is the code for recording and playback -------

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }
  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    io.File file = io.File(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }

  void playSample() async{
    AudioCache cache = AudioCache(fixedPlayer: player);
    io.File file = await cache.fetchToMemory('sample.wav');
    await player.play(file.path);
  }

  void showResults(double pred) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return PredictionContent(pred);
      },
    );
    // await showDialog<void>(
    //     context: context,
    //     builder: (_) {
    //           return PredictionContent(pred)
    //     }
    //     });
  }

  void showWaiting() async{
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          waitingContext = context;
          return AlertDialog(
            content: PredictionProgressIndicator(),
          );
        }
    );
  }

//-----------------------------API----------------------------------------------
  void predictAudio() async {
    /*setState(() {
      isLoading = true;
    });*/
    showWaiting();

    var fout = io.File(_current.path!);
    var len = await fout.length();
    print(len);

    Future.delayed(Duration(milliseconds: 2000)).then((value) async {
      Uri uri = Uri.https(Helper.MODEL_BASE_URL, "prediction/audio");
      //Uri uri = Uri.http(Helper.MODEL_BASE_URL, "audio");
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', fout.path,
          //filename: "${Helper.getId()}.wav"
        ));

      http.Response response =
      await http.Response.fromStream(await request.send());
      print("response code ${response.statusCode}");

      /*setState(() {
        isLoading = false;
      });*/
      if(waitingContext!=null){
        Navigator.pop(waitingContext!);
        waitingContext = null;
      }

      try {
        print(response.body);
        PredictionResponse res =
        PredictionResponse.fromJson(jsonDecode(response.body));
        if (res.status == 500) {
          Helper.goodToast(
              'There was some error in prediction. Please try again later.');
        } else {
          if (res.status == 200) {
            var pred = double.parse(res.prediction);
            pred = (1 - pred) * 0.75;
            pred = pred * 100;
            //res.prediction = pred.toStringAsFixed(2);
            showResults(pred);
          }else if(res.status == 300){
            Helper.goodToast('Your file was not captured. Please click the submit button again to upload.');
          }
          else {
            Helper.goodToast(
                'There was some error in prediction. Please try again later.');
          }
        }
      } catch (Exception) {
        if(waitingContext!=null){
          Navigator.pop(waitingContext!);
          waitingContext = null;
        }
        Helper.goodToast('There was an error');
      }
    });
  }

// ----------------------------- UI --------------------------------------------

  void showInstructions() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Instructions"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "1. Upload your cough audio for a minimum duration of 3 seconds.\n"
                      "2. Please ensure you are in a quiet surrounding.\n"
                      "3. DON'T upload ambiguous audio as it may produce wrong results.\n"
                      "4. Press the record button to start recording.",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
                _init();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildText(RecordingStatus status) {
    var icon = Icon(Icons.power_settings_new, color: Colors.green.shade800);
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          icon = Icon(Icons.fiber_manual_record, color: Colors.red,);
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = Icon(Icons.pause);
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = Icon(Icons.fiber_manual_record, color: Colors.red,);
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = Icon(Icons.power_settings_new, color: Colors.green.shade800,);
          break;
        }
      default:
        break;
    }
    return icon;
  }

  String _buildToolTip(RecordingStatus status){
    String res = "Initialize";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          res = "Record";
          break;
        }
      case RecordingStatus.Recording:
        {
          res = "Pause";
          break;
        }
      case RecordingStatus.Paused:
        {
          res = "Resume";
          break;
        }
      case RecordingStatus.Stopped:
        {
          res = "Initialize";
          break;
        }
      default:
        break;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    Widget audioRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Sample Audio'),
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: playSample,
        ),
      ],
    );
    Widget buttonGroup = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(),
          flex: 1,
        ),
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(2),
          height: 80,
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {
              switch (_currentStatus) {
                case RecordingStatus.Initialized:
                  {
                    _start();
                    break;
                  }
                case RecordingStatus.Recording:
                  {
                    _pause();
                    break;
                  }
                case RecordingStatus.Paused:
                  {
                    _resume();
                    break;
                  }
                case RecordingStatus.Stopped:
                  {
                    showInstructions();
                    break;
                  }
                default:
                  {
                    showInstructions();
                    break;
                  }
              }
            },
            icon: _buildText(_currentStatus),
            tooltip: _buildToolTip(_currentStatus),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(2),
          height: 80,
          alignment: Alignment.center,
          child: IconButton(
            onPressed:
            _currentStatus != RecordingStatus.Unset ? _stop : null,
            icon: Icon(Icons.stop, color: _currentStatus != RecordingStatus.Unset ? Colors.red : Colors.grey),
            tooltip: "Stop",
          ),
        ),
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(2),
          height: 80,
          alignment: Alignment.center,
          child: IconButton(
            onPressed: onPlayAudio,
            icon: Icon(Icons.play_arrow, color: Colors.black),
            disabledColor: Colors.grey,
            tooltip: "Play",
          ),
        ),
        Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.all(2),
          height: 80,
          alignment: Alignment.center,
          child: IconButton(
            onPressed: _currentStatus == RecordingStatus.Stopped ? predictAudio: null,
            icon: Icon(Icons.check, color: _currentStatus == RecordingStatus.Stopped ? Colors.green: Colors.grey,),
            disabledColor: Colors.grey,
            tooltip: "Submit",
          ),
        ),
        Expanded(
          child: Container(),
          flex: 1,
        )
      ],
    );
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/audio.png"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Column(children:[
                    Opacity(opacity: 1.0, child: audioRow,),
                    Opacity(opacity: 0.0, child: audioRow,),
                  ], mainAxisAlignment: MainAxisAlignment.spaceBetween,),
              ),
              Expanded(
                child: buttonGroup,
              )
            ],
          ),
        ),
        //(isLoading ? CustomProgressIndicator() : Container()),
      ],
    );
  }
}
