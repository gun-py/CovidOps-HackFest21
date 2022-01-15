import 'dart:convert';

import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/button.dart';
import 'package:covigenix/ui/custom_widgets/essential_checklist.dart';
import 'package:covigenix/ui/custom_widgets/progress.dart';
import 'package:covigenix/ui/model/generic_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  EssentialChecklist screen = EssentialChecklist();
  bool isLoading = false;

  void _editEssentials(BuildContext context) async{
    setState(() {
      isLoading = true;
    });

    List<String> essentials = List<String>.empty(growable: true);
    screen.status.forEach((key, value) {if(value == true) essentials.add(key);});
    Helper.editEssentials(essentials: essentials);

    final response = await http.put(
      Uri.https(Helper.BASE_URL, "provider/${Helper.getId()}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'essentials': essentials,
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
      Helper.goodToast('There was some error');
    }
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

        Column(
            children: [
              Expanded(
                child: screen,
              ),

              CustomButton('Update', () => _editEssentials(context),),
              SizedBox(height:50),
            ],
        ),
        (isLoading?CustomProgressIndicator():Container()),
      ],
    );
  }
}
