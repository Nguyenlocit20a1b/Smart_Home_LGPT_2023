import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class SmartDevices extends StatelessWidget {
  const SmartDevices({Key? key, required this.smartDeviceName, required this.iconDevice, required this.powerOn, required this.onChanged}) : super(key: key);
  final String smartDeviceName;
  final String iconDevice;
  final bool powerOn;
  final Function (bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(24),
        color: powerOn ? Colors.grey[900]: Colors.grey[400] ,
      )  ,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(iconDevice ,
              height: 65,
                color: powerOn ? Colors.white : Colors.grey.shade700,
            ),
            Row(
              children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(smartDeviceName ,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: powerOn ? Colors.white: Colors.black
                    ),),
                  )),
                Transform.rotate(angle: pi/2,
                child: CupertinoSwitch(
                  value: powerOn,
                  onChanged: onChanged,
                ),)
              ],
            )
          ],
        ),
      ),

    );
  }
}
