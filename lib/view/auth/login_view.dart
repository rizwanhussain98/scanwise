import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../res/color.dart';
import '../../res/components/round_button.dart';
import '../../res/components/text_view.dart';
import '../../res/dimensions.dart';
import '../../res/string.dart';
import '../../services/navigation_service.dart';
import '../../utils/routes/routes_name.dart';
import '../../utils/utils.dart';
import '../../view_model/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  String? userId;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
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

  Widget view() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          extendBody: true,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: double.infinity,
                height: double.infinity,
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
                        Color(0xFFFFFFFF).withValues(alpha: 0.3),
                        Color(0xFFFFFFFF).withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 8.h),
                            //LOGO
                            Container(
                              alignment: Alignment.center,
                              width: 100.0.w,
                              height: 30.0.h,
                              margin: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                              ),
                              child: Image.asset(
                                Strings.logoWithoutName,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            TextView(
                              title: "Welcome Back",
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                              size: 22.sp,
                            ),
                            SizedBox(height: 1.h),
                            // TextView(
                            //   title:
                            //       "Login to continue your journey to scan \n your x-ray reports",
                            //   color: AppColors.blackColor,
                            //   size: Strings.normalTextSize,
                            // ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              width: Dimensions.textFieldWidth,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Dimensions.textFieldHeight,
                                    child: TextFormField(
                                      controller: viewModel.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: viewModel.emailFocusNode,
                                      style: TextStyle(
                                        fontSize: Strings.normalTextSize,
                                      ),
                                      onChanged: (value) {
                                        // Clear errors when user starts typing
                                        if (viewModel.emailError != null) {
                                          viewModel.clearErrors();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: Strings.email,
                                        labelText: Strings.email,
                                        // errorText: viewModel.emailError,
                                        errorStyle: const TextStyle(height: 0),
                                        fillColor: AppColors.whiteColor,
                                        filled: true,
                                        contentPadding: const EdgeInsets.only(
                                          top: 15,
                                          left: 5,
                                          right: 5,
                                        ),
                                        hintStyle: TextStyle(
                                          fontSize: Strings.normalTextSize,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: BorderSide(
                                            color: viewModel.emailError != null
                                                ? Colors.red
                                                : AppColors.primaryColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: BorderSide(
                                            color: viewModel.emailError != null
                                                ? Colors.red
                                                : AppColors.primaryColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: viewModel.emailError != null
                                              ? Colors.red
                                              : AppColors.primaryColor,
                                          fontSize: Strings.normalTextSize,
                                        ),
                                        prefixIcon: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Icon(
                                            Icons.email,
                                            color: viewModel.emailError != null
                                                ? Colors.red
                                                : AppColors.primaryColor,
                                          ),
                                        ),
                                        // Success indicator when email is valid
                                        suffixIcon:
                                            viewModel.email.isNotEmpty &&
                                                viewModel.isEmailValid
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : null,
                                      ),
                                      onFieldSubmitted: (value) {
                                        viewModel.handleEmailFieldSubmitted(
                                          context,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  // Password Field
                                  SizedBox(
                                    height: Dimensions.textFieldHeight,
                                    child: TextFormField(
                                      controller: viewModel.passwordController,
                                      obscureText: viewModel.obscurePassword,
                                      obscuringCharacter: "*",
                                      focusNode: viewModel.passwordFocusNode,
                                      style: TextStyle(
                                        fontSize: Strings.normalTextSize,
                                      ),
                                      onChanged: (value) {
                                        // Clear errors when user starts typing
                                        if (viewModel.passwordError != null) {
                                          viewModel.clearErrors();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: Strings.password,
                                        labelText: Strings.password,
                                        // errorText: viewModel.passwordError,
                                        fillColor: AppColors.whiteColor,
                                        filled: true,
                                        hintStyle: TextStyle(
                                          fontSize: Strings.normalTextSize,
                                        ),
                                        contentPadding: const EdgeInsets.only(
                                          top: 15,
                                          left: 5,
                                          right: 5,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                viewModel.passwordError != null
                                                ? Colors.red
                                                : AppColors.primaryColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: BorderSide(
                                            color:
                                                viewModel.passwordError != null
                                                ? Colors.red
                                                : AppColors.primaryColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        errorStyle: const TextStyle(height: 0),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        labelStyle: TextStyle(
                                          color: viewModel.passwordError != null
                                              ? Colors.red
                                              : AppColors.primaryColor,
                                          fontSize: Strings.normalTextSize,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_clock_rounded,
                                          color: viewModel.passwordError != null
                                              ? Colors.red
                                              : AppColors.primaryColor,
                                        ),
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Success indicator when password is valid
                                            if (viewModel.password.isNotEmpty &&
                                                viewModel.isPasswordValid)
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 20,
                                                ),
                                              ),
                                            // Password visibility toggle
                                            InkWell(
                                              onTap: viewModel
                                                  .togglePasswordVisibility,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 12.0,
                                                ),
                                                child: Icon(
                                                  viewModel.obscurePassword
                                                      ? Icons
                                                            .visibility_off_outlined
                                                      : Icons.visibility,
                                                  color: AppColors.primaryColor,
                                                  size: 2.8.h,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onFieldSubmitted: (value) {
                                        // Trigger login when password field is submitted
                                      },
                                    ),
                                  ),
                                  // General error message
                                  if (viewModel.generalError != null) ...[
                                    SizedBox(height: 1.h),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.red.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              viewModel.generalError!,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            onPressed: viewModel.clearErrors,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    RoutesNames.forgotPasswordView,
                                  );
                                },
                                child: TextView(
                                  decoration: TextDecoration.underline,
                                  title: Strings.forgetPassword,
                                  size: Strings.normalTextSize,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            RoundButton(
                              title: Strings.getStarted,
                              loading: viewModel.isLoading,
                              color: AppColors.secondaryColor,
                              iconVisibility: true,
                              height: Dimensions.buttonHeight,
                              width: 80.w,
                              onPress: () {
                                viewModel.validateFields();
                                if (viewModel.emailError != null) {
                                  Utils.flushBarMessage(
                                    message: viewModel.emailError!,
                                  );
                                } else if (viewModel.passwordError != null) {
                                  Utils.flushBarMessage(
                                    message: viewModel.passwordError!,
                                  );
                                } else {
                                  viewModel.login();
                                }
                              },
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onBackPressed() {
    NavigationService.navigateAndReplace(RoutesNames.startView);
  }
}
