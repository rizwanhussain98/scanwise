import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../color.dart';
import '../string.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  final Color color;
  final Color textColor;
  final double height;
  final double width;
  final bool iconVisibility;
  final Color borderColor;

  const RoundButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPress,
      this.color = AppColors.primaryColor,
      this.iconVisibility = false,
      this.textColor = AppColors.whiteColor,
      this.borderColor = Colors.transparent,
      this.height = 40,
      this.width = 200});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPress,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: color,
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 2.w,
            ),
            Center(
                child: loading
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(0.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        title,
                        style: TextStyle(
                            color: textColor, fontSize: Strings.normalTextSize),
                      )),
            Visibility(
              visible: iconVisibility,
              child: Container(
                height: 2.5.h,
                padding: const EdgeInsets.all(0),
                //I used some padding without fixed width and height
                child: Icon(
                  Icons.arrow_forward_outlined,
                  color: AppColors.whiteColor,
                  size: 2.h,
                ), // You can add a Icon instead of text also, like below.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
