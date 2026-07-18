import 'dart:convert';

import 'package:scanwise/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreference? _instance;
  static SharedPreferences? _prefs;
  String? _cachedUserId;
  UserModel? _cachedUserDetails;
  bool _isInitialized = false;

  // Private constructor for singleton pattern
  SharedPreference._internal();

  // Get singleton instance
  static SharedPreference get instance {
    _instance ??= SharedPreference._internal();
    return _instance!;
  }

  // Initialize SharedPreferences and cache user data
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    final userJson = _prefs?.getString('userDetails');
    if (userJson != null) {
      _cachedUserDetails = UserModel.fromJson(jsonDecode(userJson));
      _cachedUserId = _cachedUserDetails!.id.toString();
    } else {
      _cachedUserDetails = null;
    }
    _isInitialized = true;
  }

  // Get userId (from cache, not SharedPreferences every time)
  String? get userId => _cachedUserId;
  UserModel? get userDetails => _cachedUserDetails;

  // Check if user is logged in
  bool get isUserLoggedIn => _cachedUserId != null && _cachedUserId!.isNotEmpty;

  Future<bool> setUserDetails(UserModel user) async {
    await _ensureInitialized();
    _cachedUserDetails = user;
    _cachedUserId = user.id.toString(); // update cache here
    return await _prefs!.setString('userDetails', jsonEncode(user));
    }

  // Clear user data (logout)
  Future<void> clearData() async {
    await _ensureInitialized();
    _cachedUserId = null;
    _cachedUserDetails = null;
    await _prefs!.remove('userId');
    await _prefs!.remove('userDetails');
  }

  // Ensure SharedPreferences is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }
}
