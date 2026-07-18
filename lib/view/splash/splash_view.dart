import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../res/color.dart';
import '../../res/string.dart';
import '../../../utils/routes/routes_name.dart';
import '../../storage/shared_preference.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  String? userId;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    getValidationData();
    super.initState();
  }

  Future getValidationData() async {
    loadData();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    // Navigator.popAndPushNamed(context, RoutesNames.signUpView8);
    if (SharedPreference.instance.userId != null) {
      Navigator.pushNamed(context, RoutesNames.homeView);
    } else {
      Navigator.popAndPushNamed(context, RoutesNames.onBoardingSliderView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.whiteColor,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Strings.splashBGImg),
        //     fit: BoxFit.cover,
        //     colorFilter: ColorFilter.mode(
        //       AppColors.blackColor.withValues(alpha: 0.6),
        //       BlendMode.srcOver,
        //     ),
        //   ),
        // ),
        child: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //     colors: [
          //       Color(0xFFF37565).withValues(alpha: 0.8),
          //       Color(0xFFF37565).withValues(alpha: 0.7),
          //       Color(0xFF8B659A).withValues(alpha: 0.75),
          //       Color(0xFF6B7BA3).withValues(alpha: 0.8),
          //       Color(0xFF3D53A4).withValues(alpha: 0.9),
          //       Color(0xFF3D53A4).withValues(alpha: 0.95),
          //     ],
          //     stops: [0, 0.2, 0.4, 0.6, 0.8, 1],
          //   ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),
              Container(
                alignment: Alignment.center,
                width: 80.0.w,
                height: 25.0.h,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  Strings.splashLogoImg,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(child: SizedBox()),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      )
        ,
      // body: Container(
      //   width: double.infinity,
      //   height: double.infinity,
      //   constraints: const BoxConstraints.expand(),
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: const AssetImage(Strings.splashBGImg),
      //         colorFilter: ColorFilter.mode(
      //             AppColors.blackColor.withValues(alpha: 0.6),
      //             BlendMode.srcOver),
      //         fit: BoxFit.fill),
      //   ),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [
      //           // Top coral/pink color
      //           Color(0xFFF37565).withValues(alpha: 0.8),
      //           Color(0xFFF37565).withValues(alpha: 0.7),
      //           // Middle transition blend
      //           Color(0xFF8B659A).withValues(alpha: 0.75),
      //           // Blend of both colors
      //           Color(0xFF6B7BA3).withValues(alpha: 0.8),
      //           // More toward primary
      //           // Bottom primary color (deep blue)
      //           Color(0xFF3D53A4).withValues(alpha: 0.9),
      //           Color(0xFF3D53A4).withValues(alpha: 0.95),
      //         ],
      //         stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      //       ),
      //     ),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Expanded(
      //           child: Container(),
      //         ),
      //         Container(
      //           alignment: Alignment.center,
      //           width: 80.0.w,
      //           height: 25.0.h,
      //           margin: const EdgeInsets.only(right: 10, left: 10),
      //           child: Image.asset(Strings.splashLogoImg, fit: BoxFit.contain),
      //         ),
      //         Expanded(
      //           child: Container(),
      //         ),
      //         SizedBox(height: 3.h),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
