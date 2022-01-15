import 'dart:collection';
import 'dart:convert';
import 'package:covigenix/ui/model/community_post_model.dart';
import 'package:covigenix/ui/model/patient_model.dart';
import 'package:covigenix/ui/model/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper{
  static const String BASE_URL = "covigenix-test-deploy.herokuapp.com";
  //static const String MODEL_BASE_URL = "sheltered-brook-16215.herokuapp.com";
  //static const String MODEL_BASE_URL = "192.168.1.6:5000";
  static const String MODEL_BASE_URL = "covidops-testing.herokuapp.com";
  static const String OXYGEN_URL = "https://www.covidfightclub.org/?search_key=&city_id=&medicine_id=4&type=1";
  static const String ICU_URL = "https://www.covidfightclub.org/?search_key=&city_id=&medicine_id=10&type=1";
  static const String AMBULANCE_URL = "https://www.covidfightclub.org/?search_key=&city_id=&medicine_id=1&type=1";
  static const String MAILER_URL = "mailto:covidops2021@gmail.com?subject=Report%20a%20Bug";
  static const String appName = "CovidOps";

  static const String LOGIN_STATUS = "LoginStatus";
  static const int TYPE_LOGOUT = -1, TYPE_PROVIDER = 0, TYPE_PATIENT = 1;
  static const int TYPE_REQUEST = 0, TYPE_AVAILABILITY = 1;

  static const String ID = "id", NAME = "name", PHONE = "phone", AREA = "area", LATITUDE = "latitude", LONGITUDE = "longitude", ADDRESS = "address";
  static const String LS_KEY = "Local.json", USER = "User", ESSENTIALS = "essentials";

  static const double textSize = 16, headSize = 24;

  static int getLoginStatus(){
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[LOGIN_STATUS] ?? -1;
    //return new LocalStorage(LS_KEY).getItem(LOGIN_STATUS) ?? -1;
  }

  static void setProfile({int loginStatus = -1, String id = "", String name = "", String phone = "", String area = "", double lati = 0.0, double longi = 0.0, String address = "", List<String>? essentials}){
    /*final LocalStorage localStorage = new LocalStorage(LS_KEY);
    Map<String, dynamic> map = (localStorage.getItem(USER) ?? Map<String, dynamic>());*/
    final GetStorage box = GetStorage();
    Map<String, dynamic> map = (box.read(USER) ?? Map<String, dynamic>());
    if(loginStatus != -1) map[LOGIN_STATUS] = loginStatus;
    if(id != "") map[ID] = id;
    if(name != "") map[NAME] = name;
    if(phone != "") map[PHONE] = phone;
    if(area != "") map[AREA] = area;
    if(longi != 0.0) map[LONGITUDE] = longi;
    if(lati != 0.0) map[LATITUDE] = lati;
    if(address != "") map[ADDRESS] = address;
    if(essentials != null){
      map[ESSENTIALS] = essentials;
    }
    //localStorage.setItem(USER, map);
    box.write(USER, map);
  }

  static void logOut(){
    final GetStorage box = GetStorage();
    Map<String, dynamic> map = (box.read(USER) ?? Map<String, dynamic>());
    map[LOGIN_STATUS] = TYPE_LOGOUT;
    box.write(USER, map);
  }

  static String getId(){
    //return (new LocalStorage(LS_KEY).getItem(USER) as Map<String, dynamic> ?? Map<String, dynamic>())[ID] ?? "";
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[ID] ?? "";
  }

  static String getName(){
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[NAME] ?? "";
  }

  static String getPhone(){
    //return (new LocalStorage(LS_KEY).getItem(USER) as Map<String, dynamic> ?? Map<String, dynamic>())[PHONE] ?? "";
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[PHONE] ?? "";
  }

  static String getArea(){
    //return (new LocalStorage(LS_KEY).getItem(USER) as Map<String, dynamic> ?? Map<String, dynamic>())[AREA] ?? "";
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[AREA] ?? "";
  }

  static double getLatitude(){
    //return (new LocalStorage(LS_KEY).getItem(USER) as Map<String, dynamic> ?? Map<String, dynamic>())[LATITUDE] ?? 0.0;
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[LATITUDE] ?? 0.0;
  }

  static double getLongitude() {
    //return (new LocalStorage(LS_KEY).getItem(USER) as Map<String, dynamic> ?? Map<String, dynamic>())[LONGITUDE] ?? 0.0;
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[LONGITUDE] ?? 0.0;
  }

  static String getAddress(){
    //return (new LocalStorage(LS_KEY).getItem(USER) as Map<String, dynamic> ?? Map<String, dynamic>())[ADDRESS] ?? "";
    return (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[ADDRESS] ?? "";
  }

  static List<String> getEssentials(){
    var list = (GetStorage().read(USER) as Map<String, dynamic>? ?? Map<String, dynamic>())[ESSENTIALS];
    var res = List<String>.empty(growable: true);
    for(String item in list){
      res.add(item);
    }
    return res;
  }

  static void setCoordinates(double longi, double lati){
    //final LocalStorage localStorage = new LocalStorage(LS_KEY);
    //Map<String, dynamic> map = (localStorage.getItem(USER) ?? Map<String, dynamic>());
    final GetStorage box = GetStorage();
    Map<String, dynamic> map = (box.read(USER) ?? Map<String, dynamic>());
    map[LONGITUDE] = longi;
    map[LATITUDE] = lati;
    //localStorage.setItem(USER, map);
    box.write(USER, map);
  }

  static void updateProfile({String area = "", String address = ""}){
    //final LocalStorage localStorage = new LocalStorage(LS_KEY);
    final GetStorage box = GetStorage();
    Map<String, dynamic> map = (box.read(USER) ?? Map<String, dynamic>());
    int type = (map[LOGIN_STATUS] ?? TYPE_PROVIDER);
    map[AREA] = area;
    if(type == TYPE_PATIENT){
      map[ADDRESS] = address;
    }
    box.write(USER, map);
  }

  static void editEssentials({required List<String> essentials}){
    final GetStorage box = GetStorage();
    Map<String, dynamic> map = (box.read(USER) ?? Map<String, dynamic>());
    map[ESSENTIALS] = essentials;
    box.write(USER, map);
  }

  static String argToProper(String arg){
    for(EssentialGridModel e in essentialsList){
      if(e.arg == arg)
        return e.proper;
    }
    return "Item";
  }

  static void goodToast(String message){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static List<EssentialGridModel> getEssentialsListForMap(){
    final GetStorage box = GetStorage();
    Map<String, dynamic> map = (box.read(USER) ?? Map<String, dynamic>());
    int type = (map[LOGIN_STATUS] ?? TYPE_LOGOUT);
    if(type==TYPE_LOGOUT){
      return essentialsList;
    }
    List<String> essentials = getEssentials();
    List<EssentialGridModel> res = List.from(essentialsList);
    for(int i=0; i<res.length; i++)
      res[i].checked = false;
    for(String item in essentials){
      for(int i = 0; i<res.length; i++){
        if(res[i].arg == item){
          res[i].checked = true;
          break;
        }
      }
    }
    return res;
  }

  static final List<EssentialGridModel> essentialsList = [
    EssentialGridModel("remdesivir", "Remdesivir",Image.asset("assets/images/remedivir.jpg"),"assets/images/remedivir.jpg"),
    EssentialGridModel("oxygen", "Medical Oxygen",Image.asset("assets/images/oxygen_tank.jpg"),"assets/images/oxygen_tank.jpg"),
    EssentialGridModel("hospital", "Hospital Facility",Image.asset("assets/images/hospital.jpg"),"assets/images/hospital.jpg"),
    EssentialGridModel("fabiflu","Fabiflu",Image.asset("assets/images/fabliflu.png"),"assets/images/fabiflu.jpg"),
    EssentialGridModel("icu","ICU Beds",Image.asset("assets/images/icu.jpg"),"assets/images/icu.jpg"),
    EssentialGridModel("ambulance","Ambulance",Image.asset("assets/images/ambulance.jpg"),"assets/images/ambulance.jpg")
  ];

  static Future<List<HospitalListModel>> getHospitalsFromJson() async{
    List<HospitalListModel> res = List<HospitalListModel>.empty(growable: true);
    String json = await rootBundle.loadString("assets/hospitals_data.json");
    res = (jsonDecode(json) as Iterable).map<HospitalListModel>((modelJson) => HospitalListModel.fromJson(modelJson)).toList();
    return res;
  }

  static List<Patient> sortListPatient(List<Patient> arg){
    double startLat = getLatitude(), startLong = getLongitude();
    arg.sort((a, b) {
      double dist1 = Geolocator.distanceBetween(startLat, startLong, a.location[1], a.location[0]);
      double dist2 = Geolocator.distanceBetween(startLat, startLong, b.location[1], b.location[0]);
      return dist1.compareTo(dist2);
    });
    return arg;
  }

  static List<Provider> sortListProvider(List<Provider> arg){
    double startLat = getLatitude(), startLong = getLongitude();
    arg.sort((a, b) {
      double dist1 = Geolocator.distanceBetween(startLat, startLong, a.coordinates[1], a.coordinates[0]);
      double dist2 = Geolocator.distanceBetween(startLat, startLong, b.coordinates[1], b.coordinates[0]);
      return dist1.compareTo(dist2);
    });
    return arg;
  }

  static List<CommunityPost> sortCommunityPosts(List<CommunityPost> arg){
    double startLat = getLatitude(), startLong = getLongitude();
    arg.sort((a, b) {
      double dist1 = Geolocator.distanceBetween(startLat, startLong, a.coordinates[1], a.coordinates[0]);
      double dist2 = Geolocator.distanceBetween(startLat, startLong, b.coordinates[1], b.coordinates[0]);
      return dist1.compareTo(dist2);
    });
    return arg;
  }

  static void call(String number) async{
    String _url = 'tel:$number';
    bool launchable = await canLaunch(_url);
    if(launchable){
      await launch(_url);
    }else{
      Helper.goodToast('Found no app to launch for calling.');
    }
  }

  static List<String> getStates(){
    List<String> res = List.empty(growable: true);
    for(String item in
      ['Andhra Pradesh',
        'Assam',
        'Bihar',
        'Chandigarh',
        'Delhi',
        'Gujarat',
        'Jharkhand',
        'Karnataka',
        'Kerala',
        'Madhya Pradesh',
        'Maharashtra',
        'Meghalaya',
        'Odisha',
        'Rajasthan',
        'Tamil Nadu',
        'Telangana',
        'Uttar Pradesh',
        'Uttarakhand',
        'West Bengal'
      ]){
      res.add(item);
    }
    return res;
  }

  static void openMailer() async{
    if(await canLaunch(MAILER_URL)){
      await launch(MAILER_URL);
    }else{
      Helper.goodToast('E-mail client was not found on your device.');
    }
  }

  static void openExternal(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }else{
      Helper.goodToast('Opening web links is not supported on your phone');
    }
  }
}

class EssentialGridModel{
  final String arg, proper,path;
  final Image image;
  bool checked = false;
  EssentialGridModel(this.arg, this.proper, this.image,this.path);
  @override
  String toString() {
    // TODO: implement toString
    return "{$arg = $checked}";
  }
}

class HospitalListModel{
  final String Name, City, State, Area;
  HospitalListModel(this.Name, this.City, this.State, this.Area);
  factory HospitalListModel.fromJson(Map<String, dynamic> json){
    return HospitalListModel(
      json["Name"],
      json["City"],
      json["State"],
      json["Area"],
    );
  }
}