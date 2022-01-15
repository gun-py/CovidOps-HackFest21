import 'dart:convert';

import 'package:covigenix/ui/custom_widgets/button.dart';
import 'package:covigenix/ui/custom_widgets/formality_hypertext.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:covigenix/ui/patient/patient.dart';
import 'package:covigenix/helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class RegisterPatient extends StatefulWidget {
  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {
  final GlobalKey<FormState> _registerPatientKey = GlobalKey<FormState>();
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late String initialPhone, getLatitude, getLongitude;
  late Position? _currentPosition;
  bool _checkbox = false;
  bool isLoading = false;

  TextEditingController name = TextEditingController(),
      area = TextEditingController(),
      address = TextEditingController();

  @override
  void initState() {
    // TODO: initialPhone
    super.initState();
    _currentPosition = null;
    getLatitude = "Latitude: Not Known";
    getLongitude = "Longitude: Not Known";
    initialPhone = Helper.getPhone();
  }

  void getLocation() {
    setState(() {
      isLoading = true;
    });
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        getLatitude = "Latitude: ${position.latitude}";
        getLongitude = "Longitude: ${position.longitude}";
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });

      print(e);
    });
  }

  void register(BuildContext context) {
    if (_registerPatientKey.currentState!.validate()) {
      if(_currentPosition == null){
        Helper.goodToast("Please click on 'Get Location' to register.");
        return;
      }
      if(_checkbox==false){
        Helper.goodToast("Please accept the Terms and Conditions");
        return;
      }
      createPatient(name.text, initialPhone, area.text, address.text, _currentPosition!.longitude, _currentPosition!.latitude);
    }
  }

  void createPatient(String name, String phone, String area, String address, double longi, double lati) async{
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.https(Helper.BASE_URL, "patient/sign-up"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'phone': phone,
        'area': area,
        'address': address,
        'coordinates':[longi, lati]
      }),
    );

    setState(() {
      isLoading = false;
    });
    if(response.statusCode == 200) {
      Response res = Response.fromJson(jsonDecode(response.body));
      Helper.goodToast(res.message!);
      if(res.code == 200){
        goToPatientHome(context, res.id!);
      }
    }else {
      throw Exception('Failed to create patient');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Register', style: TextStyle(fontSize: 24),)),
      ),
      body: Stack(
        children: [
          Form(
            key: _registerPatientKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Full Name (e.g. John Doe)",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid name.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Phone",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    enabled: false,
                    initialValue: initialPhone,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: TextFormField(
                    controller: area,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "City and State (e.g. Patna, Bihar)",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid 'city, state'.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Complete Address",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid address.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                CustomButton('Get Location', getLocation),
                CustomButton('Register', () => register(context)),
                Container(
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: HyperText(),
                    value: _checkbox,
                    onChanged: (bool? value) {
                      setState(() {
                        _checkbox = value!;
                      });
                    },
                    //secondary: const Icon(Icons.hourglass_empty),
                  ),
                ),

                Container(
                  height:70,
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    image:DecorationImage(
                        image:AssetImage("assets/images/logo.png",),
                        fit:BoxFit.fitHeight

                    ),
                  ),
                ),

              ],
            ),
          ),
          (isLoading?CustomProgressIndicator():Container()),
        ],
      ),
    );
  }

  void goToPatientHome(BuildContext context, String id) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Helper.setProfile(
          loginStatus: Helper.TYPE_PATIENT,
          id: id,
          name: name.text,
          phone: initialPhone,
          area: area.text,
          address: address.text,
          longi: _currentPosition!.longitude,
          lati: _currentPosition!.latitude
      );
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PatientHome()));
    });
  }
}

class Response{
  int code;
  String? message, id;

  Response({required this.code, this.message, this.id});

  factory Response.fromJson(Map<String, dynamic> json){
    return Response(
      code: json["code"],
      message: json["message"],
      id: json["id"]
    );
  }
}
