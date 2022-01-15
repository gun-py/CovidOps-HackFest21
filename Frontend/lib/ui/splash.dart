import 'dart:convert';
import 'package:version/version.dart';
import 'package:http/http.dart' as http;
import 'package:covigenix/ui/login_screen.dart';
import 'package:covigenix/ui/patient/patient.dart';
import 'package:covigenix/ui/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:covigenix/helper.dart';
import 'package:package_info/package_info.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<Version>? _latest;

  late Version current;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder<Version>(
        //future: _latest,
        future: _latest,
        builder: (buildContext, snapshot){
          if(snapshot.hasError){
            print(snapshot.error);
            _showMessageDialog(context,
                title: "Failed to check for updates",
                body: "Please check your internet connection."
            );
          }
          else if(snapshot.hasData) {
            if(current < snapshot.data){
              _showMessageDialog(context,
                  title: "Update Available",
                  body: "An updated version of the app is available. Please update the app for better interactivity."
              );
            }else{
              enterApp(context);
            }
          }
          return Center(
            child: Image.asset("assets/images/logo.png", fit: BoxFit.fitWidth,),
          );
        }
      ),
    );
  }

  Future<Version> checkVersion() async{
    String currentVersion = (await PackageInfo.fromPlatform()).version;
    setState(() {
      current = Version.parse(currentVersion);
    });

    final response = await http.get(
      Uri.https(Helper.BASE_URL, "version"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode != 200){
      return Future.error("Failed");
    }

    final res = Response.fromJson(jsonDecode(response.body));
    return Future.value(Version.parse(res.version));
  }

  @override
  void initState() {
    super.initState();
    _latest = checkVersion();
  }

  void _showMessageDialog(BuildContext widContext, {required String title, required String body}) async{
    Future.delayed(const Duration(milliseconds: 500), () async {
      await showDialog<void>(
        context: widContext,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(body),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  enterApp(widContext);
                },
              ),
            ],
          );
        },
      );
    });
  }

  void enterApp(BuildContext context){
    Future.delayed(const Duration(milliseconds: 500), () async {
      int status = Helper.getLoginStatus();
      if(status == Helper.TYPE_LOGOUT){
        //Go to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        );
      }else if(status == Helper.TYPE_PROVIDER){
        //Go to provider
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => ProviderHome()),
        );
      }else{
        //Go to patient
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => PatientHome()),
        );
      }
    });
  }
}

class Response{
  final String version;
  Response(this.version);

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(json["version"]);
  }
}