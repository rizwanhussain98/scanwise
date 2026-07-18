import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  static Future<dynamic> navigateAndReplace(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  static Future<dynamic> navigateAndPop(String routeName) {
    final navigator = navigatorKey.currentState!;
    if (navigator.canPop()) {
      navigator.pop();
    }
    return navigator.pushNamed(routeName);
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
