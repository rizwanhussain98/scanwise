
import 'package:flutter/material.dart';
import 'package:scanwise/utils/utils.dart';
import '../model/user_model.dart';
import '../services/navigation_service.dart';
import '../storage/database.dart';
import '../storage/shared_preference.dart';
import '../utils/routes/routes_name.dart';

class LoginViewModel extends ChangeNotifier {
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Focus nodes
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Observable states
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  // Getters
  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  FocusNode get emailFocusNode => _emailFocusNode;

  FocusNode get passwordFocusNode => _passwordFocusNode;

  bool get obscurePassword => _obscurePassword;

  bool get isLoading => _isLoading;

  String? get emailError => _emailError;

  String? get passwordError => _passwordError;

  String? get generalError => _generalError;

  // Email validation
  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  bool get isEmailValid => _isValidEmail(email);

  bool get isPasswordValid => password.length >= 6;

  bool get isFormValid => isEmailValid && isPasswordValid;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Validate email
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate fields and set errors
  void validateFields() {
    _emailError = null;
    _passwordError = null;

    if (email.isEmpty) {
      _emailError = 'Email is required';
    } else if (!isEmailValid) {
      _emailError = 'Please enter a valid email';
    }

    if (password.isEmpty) {
      _passwordError = 'Password is required';
    }
    else if (!isPasswordValid) {
      _passwordError = 'Password must be at least 6 characters';
    }

    notifyListeners();
  }

  void validateEmail() {
    _emailError = null;

    if (email.isEmpty) {
      _emailError = 'Email is required';
    } else if (!isEmailValid) {
      _emailError = 'Please enter a valid email';
    }
    notifyListeners();
  }

  // Clear errors
  void clearErrors() {
    _emailError = null;
    _passwordError = null;
    _generalError = null;
    notifyListeners();
  }

  // Handle field focus change
  void handleEmailFieldSubmitted(BuildContext context) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  // Login action
  Future<void> login() async {
    try {
      setLoading(true);
      clearErrors();
      UserModel authData = UserModel(
        email: email,
        password: password,
      );
      // Simulate API call
      // Login
      final user = await DatabaseHelper.instance.login(
        email: authData.email!,
        password: authData.password!,
      );
      setLoading(false);
      if (user != null) {
        debugPrint('Welcome ${user.firstName}');
        await SharedPreference.instance.setUserDetails(user);
        _passwordController.text = "";
        notifyListeners();
        NavigationService.navigateAndReplace(RoutesNames.homeView);
      }else{
        Utils.flushBarMessage(message: "Please Enter Valid Email and Password");
      }
    } catch (e) {
      _generalError = 'Login failed: ${e.toString()}';
      notifyListeners();
    }
  }

  // Dispose resources
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
