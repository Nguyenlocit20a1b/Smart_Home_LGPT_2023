import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_home/pages/Smart_door.dart';
import 'package:smart_home/pages/home.dart';
import 'package:smart_home/pages/side_menu.dart';


import 'Temperature_Humidity.dart';
class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getFooter() {
    return GNav(
      activeColor: Colors.white,
      tabBorderRadius: 15,
      rippleColor: Colors.grey,
      // tab button ripple color when pressed
      hoverColor: Colors.black45,
      tabBackgroundColor: Colors.black.withOpacity(0.5),
      curve: Curves.easeOutExpo,

      tabActiveBorder: Border.all(color: Colors.black, width: 1),
      tabs: [
        GButton(icon: Icons.home, text: 'Home',),
        GButton(icon: Icons.sunny, text: 'Weather',),
        GButton(icon: Icons.smart_toy_outlined, text: 'Smart',),
        GButton(icon: Icons.person, text: 'Profile',),
      ],
      selectedIndex: activeTab,
      onTabChange: (index) {
        setState(() {
          activeTab = index;
        });
      },
    );
  }
  Widget getBody() {
    return IndexedStack(
      index: activeTab,
      children: const   [
        HomePage(),
        TemperatureMonitorScreen(),
        SmartDoor(),
        SideMenu(),
      ],
    );
  }
}