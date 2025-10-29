import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserType? _userType;
  bool _isLoading = false;

  User? get user => _user;
  UserType? get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        _userType = await _authService.getUserType(user.uid);
      } else {
        _userType = null;
      }
      notifyListeners();
    });
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signUpWithEmail(
        email: email,
        password: password,
        userType: userType,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error en registro: $e');
      return false;
    }
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error en inicio de sesión: $e');
      return false;
    }
  }

  Future<bool> signInWithGoogle({UserType? userType}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.signInWithGoogle(userType: userType);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error en inicio de sesión con Google: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _userType = null;
    notifyListeners();
  }
}

