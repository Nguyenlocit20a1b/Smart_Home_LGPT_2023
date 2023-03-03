
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:smart_home/pages/SmartDevices.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => HomePageState();
}
int setMinutes = 0;
final DatabaseReference databaseReference = FirebaseDatabase.instance.ref('light');
class HomePageState extends State<HomePage> {

  List SmartDevicesList  = [
    ["Smart Light" , "lib/assets/icons/light-bulb.png", true],
    ["Smart AC" , "lib/assets/icons/air-conditioner.png", false],
    ["Smart Fan" , "lib/assets/icons/fan.png", false],
    ["Smart TV" , "lib/assets/icons/smart-tv.png", false],
  ];

  bool showSetTime = false ;
  void setTime() {
    setState(() {
      showSetTime = !showSetTime;
    });
  }
  void startDeviceOnTime(Duration duration) {
    Timer(duration, () {
      powerSwitchChanged(false, 0);
    });
  }
  void setTimeOnDevice () {
    if (SmartDevicesList[0][2]) {
      startDeviceOnTime(Duration(seconds: setMinutes));
    }
  }
  void turnOnLight() {
    databaseReference.update({
      'status': 1,
    });
  }

  void turnOffLight() {
    databaseReference.update({
      'status': 0,
    });
  }
  void powerSwitchChanged(bool value , int index) {
    setState(() {
      SmartDevicesList[index][2] = value;
    });
    if (value) {
      turnOnLight();

    } else {
      turnOffLight();

    }
  }

  void showAlertSuccess() {
    QuickAlert.show(context: context,
        text:"Device are being used ",
        type: QuickAlertType.success);
  }

  void showAlertConfirm() {
    QuickAlert.show(context: context,
        text:"Are you sure you want to turn off the device? ",
        type: QuickAlertType.confirm);
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
        children: [
          // TemperatureMonitorScreen(callback: turnOnAC),
          SizedBox(height: 25,),
          // app bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){
                  setTime();
                },
                  icon: Icon(Icons.lock_clock , color: Colors.grey[800],),
                  iconSize: 50,
                ),
                IconButton(onPressed: (){},
                  icon: Icon (Icons.person, color: Colors.grey[800],),
                  iconSize: 50,
                ),
              ],
            ),
          ),
         const SizedBox(height: 20,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                Text("Wellcome Smart Home", style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500, color: Colors.black),),
                Text("GPBL 2023" , style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300 , color: Colors.black),),
                SizedBox(height: 20,),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Smart Devices' , style: TextStyle(color: Colors.black), ),
                  ],
                ),),
                const SizedBox(height: 20,),
              ],
            ),

          ),
         Expanded(
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1/1.3,
              ),
                physics:  NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: SmartDevicesList.length,
                itemBuilder: (context ,index)  {
                  return SmartDevices(
                      smartDeviceName: SmartDevicesList[index][0],
                      iconDevice: SmartDevicesList[index][1],
                      powerOn: SmartDevicesList[index][2],
                      onChanged: (value) {
                        powerSwitchChanged(value, index);
                        if (value) {
                          showAlertSuccess();
                        } else {
                          showAlertConfirm();
                        }
                      }

                  );
                },
              ),
            ),
          if(showSetTime)startDeviceOnTimer() ,
        ],
      ),
    );
  }
  Widget startDeviceOnTimer () {
    return Container(
      height: 180,
      width: 327,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
          boxShadow:  [
      BoxShadow(
      color: Colors.black12.withOpacity(0.1),
      spreadRadius: 15,
      blurRadius: 10,
      offset: Offset(0, 3), // changes position of shadow
    ),
        ],
        color: Colors.black12
      ),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text("Timer to turn off the device", style:  TextStyle(color: Colors.black , fontSize: 20),),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white54,
              boxShadow:  [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: 100,
            child: TextField(
              style: TextStyle(fontSize: 20),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  setMinutes = int.tryParse(value) ?? 0;
                });
              },
            ),
          ),

          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
            setTimeOnDevice();
            setTime();
          },
            style:  ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              overlayColor: MaterialStateProperty.all(Colors.white)
              ),
            child: Text("Seconds"),
          )
        ],
      ),
    );
  }
}
