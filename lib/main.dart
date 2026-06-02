import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/user_service.dart';
import 'services/notification_local_service.dart';
import 'package:provider/provider.dart';
import 'viewmodels/dashboard_viewmodel.dart';

bool _openNotifOnStart = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void setUnreadNotifGlobal() {
  final context = navigatorKey.currentContext;
  if (context != null) {
    context.read<DashboardViewModel>().setUnreadNotif(true);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // INIT LOCAL NOTIF
  await LocalNotificationService.init();

  // SUBSCRIBE TOPIC
  await FirebaseMessaging.instance.subscribeToTopic("admin");

  // REQUEST PERMISSION
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // BACKGROUND HANDLER
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  // 🔥 CASE 1: APP MATI → TAP NOTIF
  final initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  if (initialMessage != null) {
    _openNotifOnStart = true;
  }

  runApp(const AppRoot());

  // ⏭ NAVIGATE SETELAH APP SIAP
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_openNotifOnStart) {
      navigatorKey.currentState?.pushNamed("/notifications");
    }
  });

  // 🔥 CASE 2: APP BACKGROUND → TAP
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    navigatorKey.currentState?.pushNamed("/notifications");
  });

  // 🔥 CASE 3: FOREGROUND
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final title = message.notification?.title ?? "No title";
    final body = message.notification?.body ?? "No body";

    LocalNotificationService.show(
      title: title,
      body: body,
    );

    setUnreadNotifGlobal();
  });

  // TOKEN REFRESH
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await UserService().updateUserToken(user.uid, newToken);
    }
  });
}
