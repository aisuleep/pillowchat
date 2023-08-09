// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dark {
  static Rx<Color> accent = const Color(0xffffd6671).obs;
  static Rx<Color> background = const Color(0xfff181818).obs;
  static Rx<Color> foreground = const Color(0xFFFF6f6f6).obs;
  static Rx<Color> primaryBackground = const Color(0xfff242424).obs;
  static Rx<Color> primaryHeader = const Color(0xfff363636).obs;
  static Rx<Color> secondaryBackground = const Color(0xfff1e1e1e).obs;
  static Rx<Color> secondaryForeground = const Color(0xfffc8c8c8).obs;
  static Rx<Color> secondaryHeader = const Color(0xfff2d2d2d).obs;
  static Rx<Color> error = const Color(0xfffed4245).obs;
  static Rx<Color> online = const Color(0xfff31bf7e).obs;
  static Rx<Color> away = const Color(0xffffae352).obs;
  static Rx<Color> dnd = const Color(0xfffe91e63).obs;
  static Rx<Color> focus = const Color(0xfff4799f0).obs;
  static Rx<Color> offline = const Color(0xfffa5a5a5).obs;
}

class IconBorder {
  static Rx<double> radius = 50.0.obs;

  static final IconBorder controller = Get.put(IconBorder());

  setRadius(double double) {
    radius.value = double;
  }
}
