import 'dart:convert';
import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/patient/patient_essentials_list.dart';
import 'package:covigenix/ui/patient/patient_hardcoded_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../custom_widgets/essential_grid.dart';

class PatientEssentialsHome extends StatelessWidget {

  void _onEssentialClick(BuildContext context, EssentialGridModel model){
    Future.delayed(const Duration(milliseconds: 500), () async{
      if(model.arg == "oxygen"){
        Helper.openExternal(Helper.OXYGEN_URL);
      } else if(model.arg == "ambulance"){
        Helper.openExternal(Helper.AMBULANCE_URL);
      } else if(model.arg == "icu"){
        Helper.openExternal(Helper.ICU_URL);
      }else if(model.arg == "hospital") {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PatientHardcodedList()));
      }else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PatientEssentialsList(model)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EssentialGrid(_onEssentialClick),
    );
  }
}
