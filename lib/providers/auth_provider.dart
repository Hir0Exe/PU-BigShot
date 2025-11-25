import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserType? _userType;
  bool _isLoading = false;
  String? _lastUserId; // Para evitar actualizaciones innecesarias

  User? get user => _user;
  UserType? get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      print('🔥 [AuthProvider] Auth state changed: ${user?.email ?? "signed out"}');
      
      // Solo actualizar si hay un cambio real en el usuario
      if (user?.uid != _lastUserId) {
        print('🔥 [AuthProvider] User ID changed from $_lastUserId to ${user?.uid}');
        _lastUserId = user?.uid;
        _user = user;
        
        if (user != null) {
          print('🔥 [AuthProvider] Getting user type for ${user.uid}...');
          _userType = await _authService.getUserType(user.uid);
          print('🔥 [AuthProvider] User type: $_userType');
        } else {
          _userType = null;
          print('🔥 [AuthProvider] User signed out, userType set to null');
        }
        
        print('🔥 [AuthProvider] Calling notifyListeners()');
        notifyListeners();
        print('🔥 [AuthProvider] notifyListeners() completed');
      } else {
        print('🔥 [AuthProvider] Ignoring duplicate auth state change for same user');
      }
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

      final result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        userType: userType,
      );

      _isLoading = false;
      notifyListeners();
      
      return result != null;
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

      final result = await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      
      // El listener de authStateChanges se encargará de actualizar _user
      return result != null;
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

      final result = await _authService.signInWithGoogle(userType: userType);

      _isLoading = false;
      notifyListeners();
      
      // El listener de authStateChanges se encargará de actualizar _user
      // Si result es null, el usuario canceló
      return result != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error en inicio de sesión con Google: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    await _authService.signOut();
    
    _isLoading = false;
    // El listener ya habrá actualizado _user y _userType a null
    notifyListeners();
  }
}

