import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../res/color.dart';
import '../services/navigation_service.dart';

class Utils {
  static late BuildContext dialogContext;
  static final BuildContext buildContext =
      NavigationService.navigatorKey.currentState!.context;

  // For Text Form Field Focus Change Through Keyboard Done
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);
  }

  static void flushBarMessage({required String message, bool isError = true}) {
    // 0 for error 1 for success
    showFlushbar(
        context: buildContext,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(15),
          message: message,
          duration: const Duration(seconds: 5),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: isError ? Colors.red : Colors.green,
          reverseAnimationCurve: Curves.easeOut,
          borderRadius: BorderRadius.circular(8),
          positionOffset: 20,
          icon: Icon(
            isError ? Icons.error : Icons.check,
            size: 28,
            color: Colors.white,
          ),
        )..show(buildContext));
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  static datePicker(BuildContext context, String? title, String firstDate,
      String initialDate, String lastDate) async {
    return await showDatePicker(
      context: context,
      helpText: title,
      initialDate:
          initialDate == "" ? DateTime.now() : DateTime.tryParse(initialDate)!,
      firstDate:
          firstDate == "" ? DateTime.now() : DateTime.tryParse(firstDate)!,
      lastDate: lastDate == "" ? DateTime(2100) : DateTime.tryParse(lastDate)!,
      barrierDismissible: false,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor, // <-- SEE HERE// <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static showProgressDialog({required String message}) async {
    try {
      showDialog(
          context: buildContext,
          barrierDismissible: false,
          barrierColor: Colors.white,
          builder: (BuildContext context) {
            dialogContext = context;
            return PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: Colors.white,
                content: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                    ),
                    Flexible(
                        flex: 8,
                        child: Text(
                          message,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            );
          });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw e.toString();
    }
  }

  static closeProgressDialog() {
    try {
      Navigator.of(buildContext, rootNavigator: true).pop();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      throw e.toString();
    }
  }

  static isNull(String? value) {
    if (value == null || value == "") {
      return true;
    } else {
      return false;
    }
  }
}
