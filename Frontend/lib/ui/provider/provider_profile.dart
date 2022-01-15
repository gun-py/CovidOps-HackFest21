import 'dart:convert';

import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/button.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:covigenix/ui/model/generic_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ProviderProfile extends StatefulWidget {
  @override
  _ProviderProfileState createState() => _ProviderProfileState();
}

class _ProviderProfileState extends State<ProviderProfile> {
  final GlobalKey<FormState> _providerKey = GlobalKey<FormState>();
  //final GeolocatorPlatform geolocator;
  late String initialPhone, initialName, initialArea;
  late String getLatitude, getLongitude;
  late Position _currentPosition;
  bool isLoading = false;

  TextEditingController area = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialPhone = Helper.getPhone();
    initialName = Helper.getName();
    initialArea = Helper.getArea();
    area.text = initialArea;

    getLongitude = "Longitude: ${Helper.getLongitude()}";
    getLatitude = "Latitude: ${Helper.getLatitude()}";
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
        getLatitude = "Latitude: ${_currentPosition.latitude}";
        getLongitude = "Longitude: ${_currentPosition.longitude}";

        Helper.setCoordinates(_currentPosition.longitude, _currentPosition.latitude);
        isLoading = false;
      });
    }).catchError((e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    });
  }

  void update(BuildContext context){
    if(_providerKey.currentState!.validate()){
      String ar = area.text;
      Helper.updateProfile(area: ar);

      updateProvider(Helper.getId(), ar, Helper.getLongitude(), Helper.getLatitude());
    }
  }

  void updateProvider(String id, String area, double longi, double lati) async{
    setState(() {
      isLoading = true;
    });

    final response = await http.patch(
      Uri.https(Helper.BASE_URL, "provider/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'area': area,
        'coordinates':[longi, lati]
      }),
    );

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      GenericResponse res = GenericResponse.fromJson(jsonDecode(response.body));
      Helper.goodToast(res.message);
    }
    else {
      //throw Exception('Failed to update provider');
      Helper.goodToast('There was an error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Form(
            key: _providerKey,
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    enabled: false,
                    initialValue: initialName,
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
                      hintText: "Area",
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid area.";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                /*Container(
                  child: Text(
                    getLatitude,
                    style: TextStyle(fontSize: 16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                Container(
                  child: Text(
                    getLongitude,
                    style: TextStyle(fontSize: 16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),*/
                CustomButton('Get Location', getLocation),
                CustomButton('Update', () => update(context)),
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
        ),
        (isLoading?CustomProgressIndicator():Container()),
      ],
    );
    //return Container();
  }
}
