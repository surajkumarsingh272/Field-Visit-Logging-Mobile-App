import 'package:flutter/material.dart';

class VisitAuthViewModel extends ChangeNotifier {
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;


  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }


  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }
}