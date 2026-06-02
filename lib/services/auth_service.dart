import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final UserService _userService = UserService();

  Future<User?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 🔥 setelah login: ambil token & simpan
    final fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      await _userService.updateUserToken(credential.user!.uid, fcmToken);
    }

    return credential.user;
  }

  Future<User?> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user; // token belum disimpan di sini
  }

  Future<void> logout() => _auth.signOut();

  Stream<User?> get userStream => _auth.authStateChanges();
}
