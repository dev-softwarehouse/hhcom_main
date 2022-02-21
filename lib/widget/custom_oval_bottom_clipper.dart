import 'package:flutter/material.dart';

class CustomOvalBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int val = 60;
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - val);
    path.quadraticBezierTo(size.width / 10, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - size.width / 10, size.height, size.width, size.height - val);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
