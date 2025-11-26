import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

/// Controlador singleton de autenticación que NUNCA se destruye
/// Este vive fuera del widget tree y siempre escucha Firebase Auth
class AuthController extends ChangeNotifier {
  static final AuthController _instance = AuthController._internal();
  factory AuthController() => _instance;
  
  final _authService = AuthService();
  User? _currentUser;
  UserType? _userType;
  bool _isLoading = true;
  
  User? get currentUser => _currentUser;
  UserType? get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  
  AuthController._internal() {
    print('🎯 [AuthController] Singleton created - Setting up Firebase listener');
    
    // Este listener NUNCA se destruye porque AuthController es singleton
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      print('🎯 [AuthController] ===== FIREBASE EVENT: ${user?.email ?? "signed out"} =====');
      
      _currentUser = user;
      _isLoading = true;
      notifyListeners();
      
      if (user != null) {
        print('🎯 [AuthController] Getting user type for ${user.uid}');
        _userType = await _authService.getUserType(user.uid);
        print('🎯 [AuthController] User type: $_userType');
      } else {
        _userType = null;
        print('🎯 [AuthController] User signed out, userType = null');
      }
      
      _isLoading = false;
      notifyListeners();
      print('🎯 [AuthController] State updated, notified listeners');
    });
  }
}




