import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../res/color.dart';
import '../res/string.dart';

class ProgressDialog {
  BuildContext context;
  bool isShowing = false;

  ProgressDialog(this.context);

  void show() {
    if (!isShowing) {
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return PopScope(
                canPop: false,
                child: AlertDialog(
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
                            Strings.wait,
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
      }
      isShowing = true;
    }
  }

  void hide() {
    if (isShowing) {
      Navigator.of(context).pop();
      isShowing = false;
    }
  }
}