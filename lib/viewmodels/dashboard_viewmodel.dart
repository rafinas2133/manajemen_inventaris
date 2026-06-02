import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DashboardViewModel extends ChangeNotifier {
  final auth = AuthService();

  bool _hasUnreadNotif = false;
  bool get hasUnreadNotif => _hasUnreadNotif;

  void setUnreadNotif(bool value) {
    _hasUnreadNotif = value;
    notifyListeners();
  }

  Future<void> logout() async {
    await auth.logout();
  }
}
