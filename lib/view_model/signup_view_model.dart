import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../model/signup_model.dart';
import '../services/navigation_service.dart';
import '../storage/database.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class SignupViewModel extends ChangeNotifier {
  SignupModel _signupData = SignupModel();
  int _currentStep = 1;
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final logger = Logger();
  // Getters
  SignupModel get signupData => _signupData;

  int get currentStep => _currentStep;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String? _verificationCode;

  String? get verificationCode => _verificationCode;

  bool get obscurePassword => _obscurePassword;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  double get progressPercentage => (_currentStep / 7) * 100;

  TextEditingController get firstNameController => _firstNameController;
  final TextEditingController _firstNameController = TextEditingController();

  TextEditingController get lastNameController => _lastNameController;
  final TextEditingController _lastNameController = TextEditingController();

  TextEditingController get passwordController => _passwordController;
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get passwordConfirmationController =>
      _passwordConfirmationController;
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  TextEditingController get emailController => _emailController;
  final TextEditingController _emailController = TextEditingController();

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Toggle Confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  // Step 1: Phone & Email
  void updatePhoneAndEmail(
      String phoneNumber, String email) {
    _signupData = _signupData.copyWith(
      phoneNumber: phoneNumber,
      email: email,
    );
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void updateProfileImage(String imagePath) {
    _signupData = _signupData.copyWith(profilePicPath: imagePath);
    notifyListeners();
  }

  void proceed() {
    if (canProceedFromPersonalDetailsScreen()) {
      if(!_isValidEmail(_signupData.email!)){
        Utils.flushBarMessage(
            message: "Please enter valid email", isError: true);
      }
      else if (_signupData.password!.length < 8) {
        Utils.flushBarMessage(
            message: "Minimum 8 digits required for password", isError: true);
        return;
      } else if (_signupData.password != _signupData.passwordConfirmation) {
        Utils.flushBarMessage(
            message: "password and conform password are not same",
            isError: true);
        return;
      }
      completeSignup();
      notifyListeners();
    }
  }

  // Navigation helpers
  void goBack() {
    NavigationService.goBack();
    notifyListeners();
  }

  // Error handling
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Reset
  void reset() {
    _signupData = SignupModel();
    _currentStep = 1;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setEmail(String email) {
    _emailController.text = email;
    _signupData = _signupData.copyWith(email: email);
    notifyListeners();
  }

  void setFirstName(String firstName) {
    _firstNameController.text = firstName;
    _signupData = _signupData.copyWith(firstName: firstName);
    notifyListeners();
  }

  void setLastName(String lastName) {
    _lastNameController.text = lastName;
    _signupData = _signupData.copyWith(lastName: lastName);
    notifyListeners();
  }

  void setPassword(String password) {
    _passwordController.text = password;
    _signupData = _signupData.copyWith(password: password);
    notifyListeners();
  }

  void setConfirmPassword(String password) {
    _passwordConfirmationController.text = password;
    _signupData = _signupData.copyWith(passwordConfirmation: password);
    notifyListeners();
  }

  void setDateOfBirth(DateTime? date) {
    _signupData = _signupData.copyWith(dateOfBirth: date);
    notifyListeners();
  }

  bool canProceedFromPersonalDetailsScreen() {
    return _signupData.email != null &&
        _signupData.firstName != null &&
        _signupData.firstName!.isNotEmpty &&
        _signupData.lastName != null &&
        _signupData.lastName!.isNotEmpty &&
        _signupData.password != null &&
        _signupData.password!.isNotEmpty &&
        _signupData.passwordConfirmation != null &&
        _signupData.passwordConfirmation!.isNotEmpty &&
        _signupData.dateOfBirth != null;
  }

  // Final submission
  Future<void> completeSignup() async {
    setLoading(true);
    clearError();
    try {
      int signUp = await DatabaseHelper.instance.signup(
        email: _signupData.email!,
        firstName: _signupData.firstName!,
        lastName: _signupData.lastName!,
        // profilePath: _signupData.profilePicPath!,
        profilePath: "",
        password: _signupData.password!,
      );
      if(signUp != 0){
        NavigationService.navigateTo(RoutesNames.logInView);
      }else{
        Utils.flushBarMessage(message: "Some Error Occurred, please try again");
      }
    } catch (e) {
      Utils.flushBarMessage(message: e.toString());
      logger.e(e.toString());
      setLoading(false);
    }
  }
}
