// CREDIT: Yeasin Sheikh on stackoverflow 'https://stackoverflow.com/questions/73068502/how-to-create-widget-with-transparent-hole-in-flutter'
//

import 'package:flutter/material.dart';

class HolePuncher extends CustomClipper<Path> {
  late final double dimension;
  late final double offset;
  HolePuncher({
    required this.dimension,
    required this.offset,
  });

  @override
  Path getClip(Size size) {
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(
        Rect.fromCenter(
            center: Offset(size.width / offset, size.height / offset),
            width: dimension,
            height: dimension),
      )
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant HolePuncher oldClipper) {
    return dimension != oldClipper.dimension;
  }
}
