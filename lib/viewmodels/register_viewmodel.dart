import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final auth = AuthService();
  final userDb = UserService();

  bool loading = false;
  String? error;

  Future<bool> register(String nama, String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      final user = await auth.register(email, password);
      if (user == null) return false;

      final newUser = UserModel(
        id: user.uid,
        nama: nama,
        email: email,
        role: 2,
      );

      await userDb.createUser(newUser);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
