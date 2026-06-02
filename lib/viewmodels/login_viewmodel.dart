import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthService auth = AuthService();
  final UserService userService = UserService();

  bool loading = false;
  String? error;

  UserModel? currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<void> initUserFromAuth() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) return;

    try {
      currentUser = await userService.getUser(firebaseUser.uid);
      notifyListeners();
    } catch (_) {
      currentUser = null;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final firebaseUser = await auth.login(email, password);
      if (firebaseUser == null) {
        throw Exception("Login gagal");
      }

      final user = await userService.getUser(firebaseUser.uid);
      if (user == null) {
        throw Exception("Data user tidak ditemukan");
      }

      currentUser = user;

      return true;
    } catch (e) {
      error = e.toString();
      currentUser = null;
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await auth.logout();
    currentUser = null;
    notifyListeners();
  }
}
