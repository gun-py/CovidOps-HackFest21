import 'package:covigenix/ui/community/community.dart';
import 'package:covigenix/ui/patient/my_requests.dart';
import 'package:covigenix/ui/patient/patient_essentials_home.dart';
import 'package:covigenix/ui/patient/patient_profile.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class PatientServices extends StatefulWidget {

  @override
  _PatientServicesState createState() => _PatientServicesState();
}

class _PatientServicesState extends State<PatientServices> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    PatientEssentialsHome(),
    Community(),
    MyRequests(),
    //PatientProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: MotionTabBar(
        labels: [
          "Home","Community","My Requests"
        ],
        initialSelectedTab: "Home",
        tabIconColor: Colors.blue,
        tabSelectedColor: Colors.yellow,
        onTabItemSelected: (int value){
          _onItemTapped(value);
        },
        icons: [
          Icons.home,Icons.people,Icons.request_page
        ],
        textStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
