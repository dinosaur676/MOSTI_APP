import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  Offset start;
  Offset end;
  
  MyPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    var myPaint = Paint();
    myPaint.color = Colors.red;
    myPaint.strokeWidth = 5.0;
    canvas.drawLine(start, end, myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}