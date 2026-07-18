import 'package:flutter/material.dart';

import '../color.dart';

class TextView extends StatelessWidget {
  final String title;
  final double size;
  final Color? color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final TextDecoration decoration;
  final TextOverflow overflow;
  // final double? height;

  const TextView(
      {super.key,
      required this.title,
      required this.size,
      this.color = Colors.white,
        this.textAlign = TextAlign.center,
      this.fontWeight = FontWeight.normal,
      this.decoration = TextDecoration.none,
      this.overflow = TextOverflow.fade,
        // this.height = 1.4
      });

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          decoration: decoration,
          decorationColor: AppColors.blackColor,
          overflow: overflow,
          // height: height
        ));
  }
}
