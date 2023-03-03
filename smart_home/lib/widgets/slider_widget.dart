
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/widgets/custom_draw.dart';

import '../utils.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}
String temperature = "0";
DatabaseReference dbRef = FirebaseDatabase.instance.ref();
class _SliderWidgetState extends State<SliderWidget> {
  double progressVal = 1;
  @override
  void initState() {
    super.initState();
    dbRef.onValue.listen((event) {
      // Handle the data update here
      DataSnapshot snapshot = event.snapshot;
      String dbtemperature = snapshot.child('Temperature').value.toString();
      // Update the UI with the new data
      setState(() {
        temperature = dbtemperature;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                startAngle: degToRad(0),
                endAngle: degToRad(184),
                colors: (double.parse(temperature) < 30) ? [Colors.blue, Colors.grey.withAlpha(50)] : [Colors.red, Colors.grey.withAlpha(50)],
                stops: [progressVal, progressVal],
                transform: GradientRotation(
                  degToRad(178),
                ),
              ).createShader(rect);
            },
            child: Center(
              child: CustomArc(),
            ),
          ),
          Center(
            child: Container(
              width: kDiameter - 30,
              height: kDiameter - 30,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 20,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 30,
                        spreadRadius: 10,
                        color: (double.parse(temperature) < 30) ? Colors.blue.withAlpha(
                            normalize(progressVal * 20000, 100, 255).toInt()) : Colors.red.withAlpha(
                            normalize(progressVal * 20000, 100, 255).toInt()),
                        offset: Offset(1, 3))
                  ]),
              child: SleekCircularSlider(
                min: kMinDegree,
                max: kMaxDegree,
                initialValue: double.parse(temperature),
                appearance: CircularSliderAppearance(
                  startAngle: 180,
                  angleRange: 180,
                  size: kDiameter - 30,
                  customWidths: CustomSliderWidths(
                    trackWidth: 10,
                    shadowWidth: 0,
                    progressBarWidth: 01,
                    handlerSize: 15,
                  ),
                  customColors: CustomSliderColors(
                    hideShadow: true,
                    progressBarColor: Colors.transparent,
                    trackColor: Colors.transparent,
                    dotColor: Colors.blue,
                  ),
                ),
                onChange: (temperature) {
                  setState(() {
                    progressVal = normalize(temperature, kMinDegree, kMaxDegree) ;

                  });
                },
                innerWidget: (temperature) {
                  return Center(
                    child: Text(
                      '${temperature.toInt()}°c',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}