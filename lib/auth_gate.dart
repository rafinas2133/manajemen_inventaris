import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manajemen_inventaris/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  final Widget loggedIn;
  final Widget loggedOut;

  const AuthGate({
    super.key,
    required this.loggedIn,
    required this.loggedOut,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<LoginViewModel>().initUserFromAuth();
          });
          
          return loggedIn;
        }

        return loggedOut;
      },
    );
  }
}
