// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/user_model.dart';
import '../data/repositories/user_repository.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository _repository = UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Auto-login on app start
  Future<bool> autoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (userId != null && rememberMe) {
        _currentUser = await _repository.getUserById(userId);
        if (_currentUser != null) {
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Auto-login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login(
    String username,
    String password, {
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _repository.login(username, password);

      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user.id!);
        await prefs.setBool('remember_me', rememberMe);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid username or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;

    // Clear SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('remember_me');

    notifyListeners();
  }

  // Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verify old password
      if (_currentUser!.password != oldPassword) {
        _errorMessage = 'Current password is incorrect';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _repository.changePassword(_currentUser!.id!, newPassword);

      // Update current user
      _currentUser = _currentUser!.copyWith(password: newPassword);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to change password: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
