import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClockPainter(dateTime: _dateTime),
      size: Size.square(200),
    );
  }
}
class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter({required this.dateTime});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);

    // Draw the clock face
    final Paint circlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius / 30
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);

    // Draw the hour numbers
    final double fontSize = radius / 10;
    final TextStyle textStyle = TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold);
    final double angle = 2 * pi / 12;
    for (int i = 1; i <= 12; i++) {
      final double x =
          centerX + (radius - fontSize * 2) * cos(-pi / 2 + i * angle);
      final double y =
          centerY + (radius - fontSize * 2) * sin(-pi / 2 + i * angle);
      final String hour = '$i';
      final TextSpan span = TextSpan(text: hour, style: textStyle);
      final TextPainter textPainter =
      TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    // Draw the hour hand
    final double hourRadians =
        (dateTime.hour * pi / 6) + (dateTime.minute * pi / 360);
    final double hourHandLength = radius * 0.5;
    final hourHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius / 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(centerX, centerY),
        Offset(centerX + hourHandLength * cos(hourRadians),
            centerY + hourHandLength * sin(hourRadians)),
        hourHandPaint);

    // Draw the minute hand
    final double minuteRadians = dateTime.minute * pi / 30;
    final double minuteHandLength = radius * 0.7;
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = radius / 20
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(centerX, centerY),
        Offset(centerX + minuteHandLength * cos(minuteRadians),
            centerY + minuteHandLength * sin(minuteRadians)),
        minuteHandPaint);

    // Draw the second hand
    final double secondRadians = dateTime.second * pi / 30;
    final double secondHandLength = radius * 0.8;
    final secondHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = radius / 30
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(centerX, centerY),
        Offset(centerX + secondHandLength * cos(secondRadians),
            centerY + secondHandLength * sin(secondRadians)),
        secondHandPaint);

    // Draw the center point
    final centerPointPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(centerX, centerY), radius / 20, centerPointPaint);

}
  @override
  bool shouldRepaint( covariant CustomPainter oldDelegate) {
    return true;
  }

}
