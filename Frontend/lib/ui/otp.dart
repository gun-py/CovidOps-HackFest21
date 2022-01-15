import 'dart:convert';

import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:covigenix/ui/patient/patient.dart';
import 'package:covigenix/ui/patient/patient_register.dart';
import 'package:covigenix/ui/provider/provider_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:covigenix/ui/provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class OTPScreen extends StatefulWidget {
  final String phone;
  final int type;

  OTPScreen(this.phone, this.type);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  bool isLoading = false;
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  ConfirmationResult? confirmationResult = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Center(child: Text('OTP Verification', style: TextStyle(fontSize: 24),)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height:170,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/otp.png"),
                      fit:BoxFit.fitHeight
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: Center(
                  child: Text(
                    ' Please Enter the 6 digit OTP sent to +91-${widget.phone}',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: PinPut(
                  fieldsCount: 6,
                  textStyle:
                      const TextStyle(fontSize: 25.0, color: Colors.white),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 55.0,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: pinPutDecoration,
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.fade,
                  onSubmit: (pin) async {
                    try {
                      if (kIsWeb) {
                        setState(() {
                          isLoading = true;
                        });
                        await confirmationResult!.confirm(pin).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          if (value.user != null) {
                            _checkUserExists();
                          }
                        });
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: pin))
                            .then((value) async {
                          setState(() {
                            isLoading = false;
                          });
                          if (value.user != null) {
                            _checkUserExists();
                          }
                        });
                      }
                    } catch (e) {
                      print(e);
                      FocusScope.of(context).unfocus();
                      _scaffoldkey.currentState!
                          // ignore: deprecated_member_use
                          .showSnackBar(SnackBar(content: Text('Invalid OTP')));
                    }
                  },
                ),
              )
            ],
          ),
          (isLoading ? CustomProgressIndicator() : Container()),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              setState(() {
                isLoading = false;
              });
              _checkUserExists();
              /*Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ProviderHome()),
                      (route) => false);*/
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verficationID, int? resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
            isLoading = false;
          });
        },
        timeout: Duration(seconds: 120));
  }

  void _verifyPhoneWeb() async {
    confirmationResult =
        await FirebaseAuth.instance.signInWithPhoneNumber('+91${widget.phone}');
  }

  @override
  void initState() {
    super.initState();
    Helper.setProfile(phone: widget.phone);
    if (kIsWeb) {
      _verifyPhoneWeb();
    } else {
      _verifyPhone();
    }
  }

  void _checkUserExists() {
    if (widget.type == Helper.TYPE_PATIENT) {
      print("Check patient");
      _checkPatient(widget.phone);
    } else {
      print("Check provider");
      _checkProvider(widget.phone);
    }
  }

  void _checkPatient(String phone) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.https(Helper.BASE_URL, "patient/$phone/exists"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Response res = Response.fromJson(jsonDecode(response.body));
      if (res.code == 200) {
        //Update Local Storage
        print(res.message);
        Helper.setProfile(
            loginStatus: Helper.TYPE_PATIENT,
            id: res.id!,
            name: res.name!,
            phone: phone,
            area: res.area!,
            address: res.address!,
            longi: res.location![0],
            lati: res.location![1]);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => PatientHome()),
        );
      } else {
        print("Patient does not exist.");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterPatient()),
        );
      }
    } else {
      Helper.goodToast("There was some error!");
    }
  }

  void _checkProvider(String phone) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.https(Helper.BASE_URL, "provider/$phone/exists"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      Response res = Response.fromJson(jsonDecode(response.body));
      if (res.code == 200) {
        //Update Local Storage
        print(res.message);
        Helper.setProfile(
            loginStatus: Helper.TYPE_PROVIDER,
            id: res.id!,
            name: res.name!,
            phone: phone,
            area: res.area!,
            longi: res.location![0],
            lati: res.location![1],
          essentials: res.essentials!
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => ProviderHome()),
        );
      } else {
        print("Provider does not exist.");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => RegisterProvider()),
        );
      }
    } else {
      Helper.goodToast("There was some error!");
    }
  }
}

class Response {
  int code;
  String message;
  String? id, name, area, address;
  List<double>? location;
  List<String>? essentials;

  Response(this.code, this.message,
      {this.id, this.name, this.area, this.address, this.location, this.essentials});

  factory Response.fromJson(Map<String, dynamic> json) {
    List<String> ess = List<String>.empty(growable: true);
    if(json["essentials"] != null){
      //int len = json["location"].length;
      for(String item in json["essentials"]){
        ess.add(item);
      }
    }
    return Response(
      json["code"],
      json["message"],
      id: json["id"],
      name: json["name"],
      area: json["area"],
      address: json["address"],
      location: (json["location"] == null
          ? null
          : <double>[json["location"][0], json["location"][1]]),
      essentials: ess,
    );
  }
}
