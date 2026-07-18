import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scanwise/res/color.dart';

import '../../model/onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingPageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(data.imagePath),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: data.gradientColors,
                  stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          ),
        ),
        // Content
        Positioned(
          left: 24,
          right: 24,
          bottom: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100.w,
                child: Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 100.w,
                child: Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}