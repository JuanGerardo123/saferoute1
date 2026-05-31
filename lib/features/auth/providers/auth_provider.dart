import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/auth_repository.dart';

enum AuthStatus { idle, loading, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  AuthStatus status = AuthStatus.idle;
  String errorMessage = '';

  Stream<User?> get authStateChanges => _repo.authStateChanges;

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    status = AuthStatus.loading;
    errorMessage = '';
    notifyListeners();
    try {
      await _repo.register(
        username: username,
        email: email,
        password: password,
      );
      status = AuthStatus.idle;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      status = AuthStatus.error;
      errorMessage = _parseError(e.code);
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    status = AuthStatus.loading;
    errorMessage = '';
    notifyListeners();
    try {
      await _repo.login(email: email, password: password);
      status = AuthStatus.idle;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      status = AuthStatus.error;
      errorMessage = _parseError(e.code);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
  }

  String _parseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'invalid-email':
        return 'El correo no es válido.';
      default:
        return 'Ocurrió un error. Intenta de nuevo.';
    }
  }
}
