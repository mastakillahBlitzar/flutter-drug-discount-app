import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArrowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 4, 0);
    path.lineTo(3 * (size.width / 4), 0);
    //path.lineTo(x, y)
    path.lineTo(size.width, size.height);
    /* final int sides = 3;
    final radius = 20;
    var path = Path();
    var angle = (math.pi * 2) / sides;
    path.moveTo(radius * math.cos(0.0), radius * math.sin(0.0));
    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i);
      double y = radius * math.sin(angle * i);
      path.lineTo(x, y);
    } */
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
