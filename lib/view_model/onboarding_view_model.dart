import 'package:flutter/cupertino.dart';

import '../model/onboarding_model.dart';
import '../res/string.dart';
import '../storage/shared_preference.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  PageController get pageController => _pageController;
  int get currentPage => _currentPage;

  VoidCallback? _onNavigateToLogin;
  VoidCallback? _onNavigateToHome;

  final List<Color> _gradientColors = [
    Color(0xFFF37565).withValues(alpha: 0.3),
    Color(0xFFF37565).withValues(alpha: 0.2),
    // Middle transition blend
    Color(0xFF8B659A).withValues(alpha: 0.0), // Blend of both colors
    Color(0xFF6B7BA3).withValues(alpha: 0.8),  // More toward primary
    // Bottom primary color (deep blue)
    Color(0xFF3D53A4).withValues(alpha: 0.7),
    Color(0xFF3D53A4).withValues(alpha: 0.8),
  ];

  List<OnboardingModel> get onboardingData => [
    OnboardingModel(
      title: "Advance Medical Imaging",
      subtitle: "Analyze medical images with AI powered precision for quick diagnosis.",
      imagePath: Strings.onboardingOneImg,
      gradientColors: _gradientColors,
    ),
    OnboardingModel(
      title: "Offline AI Analysis",
      subtitle: "Conduct AI analysis of medical images without an internet connection.",
      imagePath: Strings.onboardingTwoImg,
      gradientColors: _gradientColors,
    ),
    OnboardingModel(
      title: "Instant Report Generation",
      subtitle: "Create detailed report with the help of Gemini, finding and impressions with preventions.",
      imagePath: Strings.onboardingThreeImg,
      gradientColors: _gradientColors,
    ),
  ];

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Handle completion - navigate to main app
      onOnboardingCompleted();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void setNavigationCallbacks({
    required VoidCallback onNavigateToLogin,
    required VoidCallback onNavigateToHome,
  }) {
    _onNavigateToLogin = onNavigateToLogin;
    _onNavigateToHome = onNavigateToHome;
  }

  void skipOnboarding() {
    onOnboardingCompleted();
  }

  void onOnboardingCompleted() {
    // Navigate to main app
    String? userId = SharedPreference.instance.userId;
    userId == null
        ? _onNavigateToLogin?.call()
        : _onNavigateToHome?.call();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}