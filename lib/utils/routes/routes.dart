import 'package:flutter/material.dart';
import 'package:scanwise/view/auth/login_view.dart';
import 'package:scanwise/view/auth/signup_view.dart';
import '../../view/home_view.dart';
import '../../view/splash/onboarding_view.dart';
import '../../view/splash/splash_view.dart';
import '../../view/splash/start_view.dart';
import 'route_animation.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.splashView:
        return AnimatedRoute(
          widget: const SplashView(),
          direction: AxisDirection.left,
        );
      case RoutesNames.onBoardingSliderView:
        return AnimatedRoute(
          widget: const OnboardingScreen(),
          direction: AxisDirection.left,
        );
      case RoutesNames.startView:
        return AnimatedRoute(
          widget: const StartView(),
          direction: AxisDirection.left,
        );
      case RoutesNames.signUpView:
        return AnimatedRoute(
          widget: const SignupView(),
          direction: AxisDirection.left,
        );
      case RoutesNames.logInView:
        return AnimatedRoute(
          widget: const LoginView(),
          direction: AxisDirection.left,
        );
      case RoutesNames.homeView:
        return AnimatedRoute(
          widget: const HomeView(),
          direction: AxisDirection.left,
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text('No Route Defined')),
            );
          },
        );
    }
  }
}
