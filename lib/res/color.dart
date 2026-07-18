import 'package:flutter/material.dart';


class AppColors with ChangeNotifier {
  static const Color primaryColor = Color(0xFF0F6CBD);
  static const Color secondaryColor = Color(0xFF2BB0A6);
  static const Color splashImageColor = Color(0xff2F3030);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Colors.grey;
  static const Color transparent = Colors.transparent;
  static const Color greyLightColor = Color(0xffE0E0E0);
  static const Color darkBlueColor = Color(0xff0AA2F8);
  static const Color progressBarColor = Color(0xFFF37565);
  static Color progressBarBackgroundColor = Color.lerp(const Color(0xFF0F6CBD), Colors.white, 0.3)!;
}

