import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircleTimer extends CustomPainter {
  
  int valorCurrent;
  CircleTimer(this.valorCurrent);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..strokeWidth = 7
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    
    Paint circleFull = Paint()
      ..strokeWidth = 15
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2, size.height/2) - 7;

    canvas.drawCircle(center, radius, circle);

    double angle = 2 * pi * (valorCurrent/30000);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi/2, angle, false, circleFull);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
  
}