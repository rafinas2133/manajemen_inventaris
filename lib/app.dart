import 'package:flutter/material.dart';
import 'package:manajemen_inventaris/viewmodels/barang_viewmodel.dart';
import 'package:manajemen_inventaris/viewmodels/laporan_viewmodel.dart';
import 'package:manajemen_inventaris/viewmodels/notification_viewmodel.dart';
import 'package:manajemen_inventaris/viewmodels/stok_viewmodel.dart';
import 'package:manajemen_inventaris/viewmodels/transaksi_viewmodel.dart';
import 'package:manajemen_inventaris/views/dashboard/home_screen.dart';
import 'package:manajemen_inventaris/views/notifikasi/notification_screen.dart';
import 'package:provider/provider.dart';

import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/register_screen.dart';
import 'auth_gate.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => BarangViewModel()),
        ChangeNotifierProvider(create: (_) => StokViewModel()),
        ChangeNotifierProvider(create: (_) => TransaksiViewModel()),
        ChangeNotifierProvider(create: (_) => LaporanViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: AuthGate(
          loggedIn: const HomeScreen(),
          loggedOut: LoginScreen(),
        ),

        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),

          scaffoldBackgroundColor: const Color(0xFFF4F7FF),

          // ✅ GLOBAL APPBAR THEME (INI YANG KAMU BUTUHKAN)
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white, // teks & icon jadi putih
            elevation: 2,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),

          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        routes: {
          "/login": (_) => LoginScreen(),
          "/register": (_) => RegisterScreen(),
          "/dashboard": (_) => const HomeScreen(),
          "/notifications": (context) => const NotificationScreen(),
        },
      ),
    );
  }
}
