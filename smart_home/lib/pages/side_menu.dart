import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_home/pages/Temperature_Humidity.dart';
import 'package:smart_home/pages/home.dart';
import 'package:smart_home/pages/root_app.dart';
import 'package:smart_home/widgets/ClockPainter.dart';
class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: 288,
          height: double.infinity,
          color: Color(0xFF17203A),
           child: SafeArea(
             child: Column(
               children:  [
                const  ListTile(leading: CircleAvatar(
                   backgroundColor: Colors.white,
                   child: Icon(CupertinoIcons.arrow_2_circlepath_circle_fill, color: Colors.black,),
                 ),
                   title: Text('GPBL 2023' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                   subtitle: Text('Team 3' , style:  TextStyle(color: Colors.white),),
                 ),
                 Column(
                   children: [
                      Divider(
                       color: Colors.white,
                       height: 1,
                     ),
                      Padding(
                       padding: const EdgeInsets.only(left: 20),
                       child: ListTile(
                         leading: SizedBox(
                           height: 34,
                           width: 34,
                           child: Icon(Icons.home_outlined , size: 30, color: Colors.white,)
                         ),
                         onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => RootApp()),
                         );},
                         title: Text(
                           "Home",
                           style: TextStyle(color: Colors.white),
                         ),
                       ),
                     ),
                      Padding(
                       padding: const EdgeInsets.only(left: 20),
                       child: ListTile(
                         leading: SizedBox(
                           height: 34,
                           width: 34,
                           child: Icon(Icons.sunny , size: 30, color: Colors.white,)
                         ),
                         onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => TemperatureMonitorScreen()),
                         );},
                         title: Text(
                           "Weather",
                           style: TextStyle(color: Colors.white),
                         ),
                       ),
                     ),
                      Padding(
                       padding: const EdgeInsets.only(left: 20),
                       child: ListTile(
                         leading: SizedBox(
                           height: 34,
                           width: 34,
                           child: Icon(Icons.lock_clock , size: 30, color: Colors.white,)
                         ),
                         onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Clock()),
                         );},
                         title: Text(
                           "Clock",
                           style: TextStyle(color: Colors.white),
                         ),
                       ),
                     ),
                      SizedBox(height: 30,
                      child:Divider(
                        color: Colors.white,
                        height: 1,
                      ),),

                      Padding(
                       padding: const EdgeInsets.only(left: 20),
                       child: ListTile(
                         leading: SizedBox(
                           height: 34,
                           width: 34,
                           child: Icon(Icons.chat , size: 30, color: Colors.white,)
                         ),
                         title: Text(
                           "Help",
                           style: TextStyle(color: Colors.white),
                         ),
                       ),
                     ),
                      Padding(
                       padding: const EdgeInsets.only(left: 20),
                       child: ListTile(
                         leading: SizedBox(
                           height: 34,
                           width: 34,
                           child: Icon(Icons.notifications , size: 30, color: Colors.white,)
                         ),
                         title: Text(
                           "Notifications",
                           style: TextStyle(color: Colors.white),
                         ),
                       ),
                     ),

                   ],
                 ),
               ],
             ),
           ),
        ),
    );
  }
}
