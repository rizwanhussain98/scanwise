import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanwise/model/user_model.dart';
import '../services/navigation_service.dart';
import '../storage/shared_preference.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class UserViewModel extends ChangeNotifier {
  bool _isLoading = false;
  int numberOfChildren = 0;
  String _error = "";
  UserModel _signupData = UserModel();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();


  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  TextEditingController get firstNameController => _firstNameController;
  final TextEditingController _firstNameController = TextEditingController();

  TextEditingController get lastNameController => _lastNameController;
  final TextEditingController _lastNameController = TextEditingController();

  TextEditingController get passwordController => _passwordController;
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Getters
  UserModel get signupData => _signupData;

  bool _obscurePassword = true;

  bool get obscurePassword => _obscurePassword;

  bool _obscureConfirmPassword = true;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  FocusNode get passwordFocusNode => _passwordFocusNode;

  FocusNode get confirmPasswordFocusNode => _confirmPasswordFocusNode;

  bool get isLoading => _isLoading;

  String get error => _error;

  File? get imageFile => _imageFile;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void routeToNextView(BuildContext context) {
    Navigator.pushNamed(context, RoutesNames.editUserProfileView);
    notifyListeners();
  }

  // void setValues() {
  //   _firstNameController.text = userProfile?.basicInfo?.firstName ?? '';
  //   _lastNameController.text = userProfile?.basicInfo?.lastName ?? '';
  //
  //   _signupData = _signupData.copyWith(
  //     firstName: _firstNameController.text,
  //     lastName: _lastNameController.text,
  //     dateOfBirth: userProfile?.basicInfo?.dateOfBirth != null
  //         ? DateTime.tryParse(userProfile!.basicInfo!.dateOfBirth!)
  //         : null,
  //   );
  //   notifyListeners();
  // }

  void setFirstName(String firstName) {
    _firstNameController.text = firstName;
    _signupData.copyWith(firstName: firstName);
    notifyListeners();
  }

  void setLastName(String lastName) {
    _lastNameController.text = lastName;
    _signupData.copyWith(lastName: lastName);
    notifyListeners();
  }

  void setPassword(String password) {
    _passwordController.text = password;
    notifyListeners();
  }

  void setConfirmPassword(String confirmPassword) {
    _confirmPasswordController.text = confirmPassword;
    notifyListeners();
  }

  void setDateOfBirth(DateTime? date) {
    _signupData = _signupData.copyWith(dateOfBirth: date);
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void handlePassWordFieldSubmitted(BuildContext context) {
    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
  }

  void validateFields() {
    if (passwordController.text.isEmpty) {
      Utils.flushBarMessage(message: "Please enter password");
      return;
    } else if (confirmPasswordController.text.isEmpty) {
      Utils.flushBarMessage(message: "Please enter confirm password");
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      Utils.flushBarMessage(
          message: "Password and Confirm-Password should be same");
      return;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        _imageFile = File(picked.path);
        uploadProfilePicture();
        // TODO: Call API to upload photo here
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void removeImage() {
    _imageFile = null;
    notifyListeners();
  }

  bool canProceedToUpdate() {
    return _signupData.firstName != null &&
        _signupData.firstName!.isNotEmpty &&
        _signupData.lastName != null &&
        _signupData.lastName!.isNotEmpty;
  }

  void proceedToUpdate() {
    if (canProceedToUpdate()) {
    }
  }

  void clearValues() {
    _passwordController.clear();
    _confirmPasswordController.clear();
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    _imageFile = null;
    notifyListeners();
  }

  Future<void> uploadProfilePicture() async {
    try {
      setLoading(true);
    } catch (e) {
      Utils.flushBarMessage(message: e.toString());
      setLoading(false);
    }
  }

  void logout() async {
    await SharedPreference.instance.clearData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService.navigateAndPop(RoutesNames.logInView);
    });
  }
}
