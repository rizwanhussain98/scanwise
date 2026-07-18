import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanwise/res/color.dart';

import '../../res/components/onboarding_page_widget.dart';
import '../../res/components/page_indicator_widget.dart';
import '../../utils/routes/routes_name.dart';
import '../../view_model/onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingViewModel>(
      builder: (context, viewModel, child) {
        // Set navigation callbacks
        WidgetsBinding.instance.addPostFrameCallback((_) {
          viewModel.setNavigationCallbacks(
            onNavigateToLogin: () =>
                Navigator.pushNamed(context, RoutesNames.startView),
            onNavigateToHome: () =>
                Navigator.pushNamed(context, RoutesNames.startView),
          );
        });
        return Scaffold(
          body: Stack(
            children: [
              // PageView
              PageView.builder(
                controller: viewModel.pageController,
                onPageChanged: viewModel.onPageChanged,
                itemCount: viewModel.onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    data: viewModel.onboardingData[index],
                  );
                },
              ),
              // Skip button
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 24,
                child: GestureDetector(
                  onTap: viewModel.skipOnboarding,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Page indicator
              Positioned(
                left: 24,
                right: 24,
                bottom: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button or spacer
                    PageIndicatorWidget(
                      currentPage: viewModel.currentPage,
                      totalPages: viewModel.onboardingData.length,
                    ),
                    // Next button
                    GestureDetector(
                      onTap: viewModel.nextPage,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
