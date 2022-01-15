import 'dart:convert';
import 'package:covigenix/ui/custom_widgets/dialog.dart';
import 'package:covigenix/ui/custom_widgets/icons.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:covigenix/ui/model/generic_response.dart';
import 'package:covigenix/ui/custom_widgets/row_widget.dart';
import 'package:covigenix/ui/model/provider_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helper.dart';

class PatientEssentialsList extends StatefulWidget {
  final EssentialGridModel model;
  PatientEssentialsList(this.model);

  @override
  _PatientEssentialsListState createState() => _PatientEssentialsListState();
}

class _PatientEssentialsListState extends State<PatientEssentialsList> {

  //Set isLoading true during assignment setstate, not inside fetcher function.
  Future<List<Provider>>? _future;
  bool isLoading = false;

  //API Calls
  Future<List<Provider>> _fetchList(String arg) async{
    /*setState(() {
      isLoading = true;
    });*/
    final response = await http.post(
      Uri.https(Helper.BASE_URL, "request/$arg/nearby"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'coordinates': [Helper.getLongitude(), Helper.getLatitude()]
      }),
    );

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      return ListResponse.fromJson(jsonDecode(response.body)).providers;
    }else{
      throw Exception("Failed to fetch list of providers.");
    }
  }

  void _showConfirmationDialog({required String providerId, required String providerName, required String providerPhone}) async{
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirm Request",
          body: "Are you sure you want to send a request for ${widget.model.proper} to this provider?",
          yesTitle: "Confirm",
          yesFunction: () => _createRequest(providerId: providerId, providerName: providerName, providerPhone: providerPhone),
        );
      },
    );
  }
  void _createRequest({required String providerId, required String providerName, required String providerPhone}) async{
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.https(Helper.BASE_URL, "request/${widget.model.arg}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'patientId': Helper.getId(),
        'patientName': Helper.getName(),
        'patientPhone': Helper.getPhone(),
        'patientAddress': Helper.getAddress(),
        'area': Helper.getArea(),

        'essential': widget.model.arg,
        'coordinates': [Helper.getLongitude(), Helper.getLatitude()],

        'providerName': providerName,
        'providerPhone': providerPhone,
        'providerId': providerId
      }),
    );

    setState(() {
      isLoading = false;
    });
    if(response.statusCode == 200){
      Helper.goodToast(GenericResponse.fromJson(jsonDecode(response.body)).message);
    }else{
      Helper.goodToast('There was an error');
    }
  }

  //Show in map
  void _showMap(List<double> coordinates) async{
    final availableMaps = await MapLauncher.installedMaps;
    await availableMaps.first.showMarker(
      coords: Coords(coordinates[1], coordinates[0]),
      title: "Provider",
    );
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _future = _fetchList(widget.model.arg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Center(child: Text(widget.model.proper, style: TextStyle(fontSize: 24),)),
        title: Text(widget.model.proper)
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Opacity(
                opacity: 0.2,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset("assets/images/back1.jpg", fit: BoxFit.cover,)),
                )),
          ),
          RefreshIndicator(
            onRefresh: () {
              setState(() {
                _future = _fetchList(widget.model.arg);
              });
              return _future!;
            },
            child: FutureBuilder<List<Provider>>(
              future: _future,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Stack(
                    children: [
                      ListScreen(
                        list: Helper.sortListProvider(snapshot.data!),
                        createRequest: _showConfirmationDialog,
                        showMap: _showMap,
                      ),
                      (isLoading?CustomProgressIndicator():Container()),
                    ],
                  );
                }
                return CustomProgressIndicator();
              },
            ),
          ),
        ],
      )
    );
  }
}

class ListScreen extends StatelessWidget {
  final List<Provider> list;
  final Function createRequest, showMap;

  ListScreen({required this.list, required this.createRequest, required this.showMap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RowWidget(Icons.account_circle, "Provider: ${list[index].name}"),
                      RowWidget(Icons.business_outlined, "Area: ${list[index].area}"),
                      //RowWidget(Icons.phone, list[index].phone),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextButton.icon(
                          label: Text('Create Request'),
                          icon: Icon(Icons.add),
                          onPressed: () => createRequest(
                            providerId: list[index].providerId,
                            providerPhone: list[index].phone,
                            providerName: list[index].name,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextButton.icon(
                          onPressed: () => showMap(list[index].coordinates),
                          icon: Icon(Icons.open_in_new),
                          label: Text('Show On Map'),
                          ),
                        ),
                    ],
                  ),
                ),
                CallIcon(list[index].phone),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ListResponse{
  int code;
  String message;
  List<Provider> providers;

  ListResponse({required this.code, required this.message, required this.providers});

  factory ListResponse.fromJson(Map<String, dynamic> json){
    Iterable providers = json["providers"];
    return ListResponse(
      code: json["code"],
      message: json["message"],
      providers: providers.map<Provider>((modelJson) => Provider.fromJson(modelJson)).toList(),
    );
  }
}