import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../res/color.dart';
import '../../../res/components/round_button.dart';
import '../../../res/dimensions.dart';
import '../../../res/string.dart';
import '../../view_model/signup_view_model.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    double normalizedProgress = (80 / 100).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Consumer<SignupViewModel>(
          builder: (context, viewModel, child) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: viewModel.goBack,
            );
          },
        ),
        title: SizedBox(
          width: 80.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Progress bar
              SizedBox(
                width: 50.w,
                child: LinearProgressIndicator(
                  value: normalizedProgress,
                  backgroundColor: AppColors.progressBarBackgroundColor,
                  color: AppColors.primaryColor, // Change as per your theme
                  minHeight: 5,
                ),
              ),
              SizedBox(width: 2.w),
              // Percentage text
              Text(
                "80%",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<SignupViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Tell Us About Yourself',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please fill in your personal details to help us build your profile.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: viewModel.emailController,
                        label: 'Email',
                        hintText: 'Enter Email',
                        onChanged: viewModel.setEmail,
                      ),
                      const SizedBox(height: 15),
                      // Full Name
                      _buildTextField(
                        controller: viewModel.firstNameController,
                        label: 'First Name',
                        hintText: 'Enter First Name',
                        onChanged: viewModel.setFirstName,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: viewModel.lastNameController,
                        label: 'Last Name',
                        hintText: 'Enter Last Name',
                        onChanged: viewModel.setLastName,
                      ),
                      const SizedBox(height: 15),
                      // Password Field
                      Text(
                        Strings.password,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: Dimensions.textFieldHeight,
                        child: TextFormField(
                          controller: viewModel.passwordController,
                          obscureText: viewModel.obscurePassword,
                          onChanged: viewModel.setPassword,
                          obscuringCharacter: "*",
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: Strings.password,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 14),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Password visibility toggle
                                InkWell(
                                  onTap: viewModel.togglePasswordVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      viewModel.obscurePassword
                                          ? Icons.visibility_off_outlined
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

                      const SizedBox(height: 15),

                      // Confirm Password Field
                      Text(
                        Strings.confirmPassword,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: Dimensions.textFieldHeight,
                        child: TextFormField(
                          controller: viewModel.passwordConfirmationController,
                          obscureText: viewModel.obscureConfirmPassword,
                          onChanged: viewModel.setConfirmPassword,
                          obscuringCharacter: "*",
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: Strings.confirmPassword,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 14),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Password visibility toggle
                                InkWell(
                                  onTap:
                                      viewModel.toggleConfirmPasswordVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Icon(
                                      viewModel.obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
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

                      const SizedBox(height: 15),

                      // Date of Birth
                      _buildDatePicker(
                        context: context,
                        label: 'Date of Birth',
                        selectedDate: viewModel.signupData.dateOfBirth,
                        onDateSelected: viewModel.setDateOfBirth,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: RoundButton(
                          title: 'Continue',
                          loading: viewModel.isLoading,
                          color: viewModel.canProceedFromPersonalDetailsScreen()
                              ? AppColors.primaryColor
                              : Colors.grey[300]!,
                          iconVisibility: true,
                          height: Dimensions.buttonHeight,
                          width: Dimensions.buttonWidth,
                          onPress: viewModel.proceed,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime(1990),
              firstDate: DateTime(1950),
              lastDate: DateTime.now().subtract(const Duration(days: 6570)),
              // 18 years ago
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primaryColor,
                      // <-- Selected date color & header background
                      onPrimary: Colors.white,
                      // <-- Text color on selected date & header
                      onSurface: Colors.black, // <-- Default text color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            AppColors.primaryColor, // <-- Button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                      : 'Select Date',
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey[500],
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

}
