import 'dart:ui';

class OnboardingModel {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> gradientColors;

  OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.gradientColors,
  });
}