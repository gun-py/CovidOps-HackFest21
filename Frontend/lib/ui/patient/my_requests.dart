import 'dart:convert';
import 'dart:core';
import 'package:covigenix/ui/custom_widgets/dialog.dart';
import 'package:covigenix/ui/custom_widgets/icons.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:covigenix/ui/custom_widgets/row_widget.dart';
import 'package:covigenix/ui/model/generic_response.dart';
import 'package:covigenix/ui/model/my_request_model.dart';
import 'package:covigenix/helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsState createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {

  //Set isLoading true during assignment setstate, not inside fetcher function.
  Future<List<MyRequestModel>>? _future;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _future = getMyRequests(Helper.getId());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Opacity(
              opacity: 0.2,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: ClipRRect(
                    //borderRadius: BorderRadius.circular(30.0),
                    child: Image.asset("assets/images/back2.png", fit: BoxFit.cover,)),
              )),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              _future = getMyRequests(Helper.getId());
            });
            return _future!;
          },
          child: FutureBuilder<List<MyRequestModel>>(
            future: _future,
            builder: (context, snapshot) {
                if(snapshot.hasData){
                  return Stack(
                    children: [
                      ListScreen(
                        list: snapshot.data!,
                        shareAddress: _showShareDialog,
                        deleteRequest: _showMyDialog,
                      ),
                      (isLoading ?
                      CustomProgressIndicator()
                          : Container()
                      )
                    ],
                  );
                }
                return CustomProgressIndicator();
              },
          ),
        ),
      ],
    );
  }

  //API Calls
  Future<List<MyRequestModel>> getMyRequests(String id) async{
    /*setState(() {
      isLoading = true;
    });*/

    final response = await http.get(
      Uri.https(Helper.BASE_URL, "request/patient/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      Response res = Response.fromJson(jsonDecode(response.body));
      //Helper.goodToast(res.message!);
      return res.requests!;
    }
    else
      throw Exception('Failed to create patient');
  }

  void _showShareDialog(String reqId) async{
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirm Share",
          body: "Are you sure you want to share your address with the given provider?",
          yesTitle: "Confirm",
          yesFunction: () => _shareAddress(reqId),
        );
      },
    );
  }

  void _shareAddress(String reqId) async{
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.https(Helper.BASE_URL, "request/share-address/$reqId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      GenericResponse res = GenericResponse.fromJson(jsonDecode(response.body));
      Helper.goodToast(res.message);

      setState(() {
        isLoading = true;
        _future = getMyRequests(Helper.getId());
      });
    }
  }

  Future<void> _showMyDialog(String reqId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirm Delete",
          body: "Are you sure you want to delete this request?",
          yesTitle: "Delete",
          yesFunction: () => _deleteRequest(reqId),
        );
      },
    );
  }

  void _deleteRequest(String reqId) async{
    setState(() {
      isLoading = true;
    });

    final response = await http.delete(
      Uri.https(Helper.BASE_URL, "request/$reqId"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      GenericResponse res = GenericResponse.fromJson(jsonDecode(response.body));
      Helper.goodToast(res.message);

      setState(() {
        isLoading = true;
        _future = getMyRequests(Helper.getId());
      });
    }
  }
}

class ListScreen extends StatelessWidget {
  final List<MyRequestModel> list;
  final Function shareAddress, deleteRequest;

  ListScreen({required this.list, required this.shareAddress, required this.deleteRequest});

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
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RowWidget(Icons.account_balance_rounded, "Provider: ${list[index].provider_name}"),
                      //RowWidget(Icons.phone, "Phone: ${list[index].provider_phone}"),
                      RowWidget(Icons.eco, "Essential: ${Helper.argToProper(list[index].essential)}"),

                      (list[index].sought_approval && (!list[index].approved)
                          ? TextButton.icon(
                          onPressed: () => shareAddress(list[index].id),
                          label: Text("Share Address"),
                          icon: Icon(Icons.share),)
                          : Container()),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CallIcon(list[index].provider_phone),
                    DeleteIcon(() => deleteRequest(list[index].id)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Response {
  int code;
  String message;
  List<MyRequestModel>? requests;

  Response({required this.code, required this.message, this.requests});

  factory Response.fromJson(Map<String, dynamic> json){
    Iterable requests = json["requests"];
    return Response(
        code: json["code"],
        message: json["message"],
        requests: requests.map<MyRequestModel>((modelJson) => MyRequestModel.fromJson(modelJson)).toList()
    );
  }
}