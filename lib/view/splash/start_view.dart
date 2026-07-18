import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../res/color.dart';
import '../../res/components/round_button.dart';
import '../../res/components/text_view.dart';
import '../../res/dimensions.dart';
import '../../res/string.dart';
import '../../utils/routes/routes_name.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> with TickerProviderStateMixin {
  String? userId;

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: getBody(),
    );
  }

  Widget getBody() {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Your custom action when back is pressed
          _onBackPressed();
        }
      },
      child: view(),
    );
  }

  view() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(Strings.startViewBackgroundImg),
          colorFilter: ColorFilter.mode(
            AppColors.whiteColor.withValues(alpha: 0.6),
            BlendMode.srcOver,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Top coral/pink color
              Color(0xFFFFFFFF).withValues(alpha: 0.3),
              Color(0xFFFFFFFF).withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15.h),
            Container(
              color: AppColors.secondaryColor,
              alignment: Alignment.center,
              width: 100.0.w,
              height: 30.0.h,
              // margin: const EdgeInsets.only(right: 10, left: 10),
              child: Image.asset(
                Strings.splashLogoImg,
                fit: BoxFit.fill,
                width: 100.0.w,
              ),
            ),
            Expanded(child: Container()),
            RoundButton(
              title: Strings.getStarted,
              loading: false,
              color: AppColors.secondaryColor,
              iconVisibility: true,
              height: Dimensions.buttonHeight,
              width: 80.w,
              onPress: () {
                Navigator.pushNamed(context, RoutesNames.signUpView);
              },
            ),
            SizedBox(height: 2.h),
            RoundButton(
              title: Strings.signIn,
              loading: false,
              color: AppColors.whiteColor,
              textColor: AppColors.primaryColor,
              borderColor: AppColors.secondaryColor,
              height: Dimensions.buttonHeight,
              width: 80.w,
              onPress: () {
                Navigator.pushNamed(context, RoutesNames.logInView);
              },
            ),
            SizedBox(height: 3.h),
            TextView(
              title:
                  "By continuing you agree to our Terms and \n Privacy Policy",
              color: AppColors.primaryColor,
              size: Strings.smallTextSize,
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  void _onBackPressed() {
    SystemNavigator.pop();
  }
}
