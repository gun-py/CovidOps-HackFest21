import 'package:covigenix/helper.dart';
import 'package:covigenix/ui/custom_widgets/dialog.dart';
import 'package:covigenix/ui/custom_widgets/sidenav.dart';
import 'package:covigenix/ui/prediction/prediction.dart';
import 'package:covigenix/ui/provider/provider_profile.dart';
import 'package:covigenix/ui/provider/provider_services.dart';
import 'package:flutter/material.dart';
import 'package:covigenix/ui/Agreement_policy/disclaimer.dart';
import 'package:covigenix/ui/Agreement_policy/contact_us.dart';
import 'package:covigenix/ui/Agreement_policy/acc_use_policy.dart';
import 'package:covigenix/ui/Agreement_policy/privacy_policy .dart';
import 'package:covigenix/ui/Agreement_policy/t _and_c.dart';


import '../splash.dart';

class ProviderHome extends StatefulWidget {
  @override
  _ProviderHomeState createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {

  int navIndex = 0;
  String titleArg = "Prediction";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text(titleArg, style: TextStyle(fontSize: 24),)),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Log Out',
                  onPressed: () {
                    _showDialogConfirmation();
//<<<<<<< Updated upstream
                   // Helper.logOut();
//======

//>>>>>>> Stashed changes
                  },
                );
              }
            ),
          ]
      ),
      drawer: SideNav(navIndex, (int index) {
        setState(() {
          navIndex = index;
          switch(index){
            case 0: titleArg = "Prediction";
            break;
            case 1: titleArg = "Service Provider";
            break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6: titleArg = "CovidOps";
            break;
            case 7: titleArg = "My Profile";
            break;
          }
        });
      }),

      body: Builder(
        builder: (context){
          switch (navIndex) {
            case 0: return Prediction();
            case 1: return ProviderServices();
            case 2: return disclaimer();
            case 3: return acc_use_policy();
            case 4: return t_and_c();
            case 5: return privacy_policy();
            case 6: return contact_us();
            case 7: return ProviderProfile();
          }
          return Container();
        },
      )
    );
  }
  void _showDialogConfirmation()  async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomDialog(
          title: "Confirm Action",
          body: "Are you sure you want to log out?",
          yesTitle: "Yes",
//<<<<<<< Updated upstream
          yesFunction: () {
            Helper.logOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Splash()),
            );
          }
//=======

        );
      },
    );
  }
}