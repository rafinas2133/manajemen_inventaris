import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginViewModel>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // ✅ LOGO
              Image.asset("assets/images/logo.png", height: 120),

              const SizedBox(height: 20),

              const Text(
                "Login",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // ✅ CARD FORM
              Card(
                elevation: 6,
                shadowColor: Colors.blue.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailC,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordC,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 30),

                      vm.loading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                final messenger = ScaffoldMessenger.of(context);

                                final ok = await vm.login(
                                  emailC.text,
                                  passwordC.text,
                                );

                                if (!context.mounted) return;

                                if (ok) {
                                  Navigator.pushReplacementNamed(context, "/dashboard");
                                } else {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(vm.error ?? "Login gagal"),
                                    ),
                                  );
                                }
                              },
                              child: const Text("Login"),
                            ),

                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                          context,
                          "/register",
                        ),
                        child: const Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
