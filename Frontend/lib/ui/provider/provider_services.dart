import 'package:covigenix/ui/community/community.dart';
import 'package:covigenix/ui/provider/edit.dart';
import 'package:covigenix/ui/provider/provider_profile.dart';
import 'package:covigenix/ui/provider/provider_requests.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

/// This is the main application widget.

/// This is the stateful widget that the main application instantiates.
class ProviderServices extends StatefulWidget {

  @override
  _ProviderServicesState createState() => _ProviderServicesState();

}

/// This is the private State class that goes with MyStatefulWidget.
class _ProviderServicesState extends State<ProviderServices> {
  late MotionTabController _tabController;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    ProviderRequestsList(),
    Community(),
    Edit(),
    //ProviderProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Requests',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'Community',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'Essentials',
      //       backgroundColor: Colors.black
      //     ),
      //     /*BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle_outlined),
      //       label: 'Profile',
      //     ),*/
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
      bottomNavigationBar: MotionTabBar(
        labels: [
          "My Requests","Community","Essentials"
        ],
        initialSelectedTab: "My Requests",
        tabIconColor: Colors.blue,
        tabSelectedColor: Colors.yellow,
        onTabItemSelected: (int value){
               _onItemTapped(value);
        },
        icons: [
          Icons.request_page,Icons.people,Icons.local_hospital
        ],
        textStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
