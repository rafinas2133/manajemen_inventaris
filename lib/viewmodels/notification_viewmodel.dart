import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/notification_service.dart';
import '../models/notification_model.dart';
import 'package:uuid/uuid.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();
  final List<NotificationModel> _list = [];

  List<NotificationModel> get list => _list;

  NotificationViewModel() {
    _init();
  }

  void _init() {
    // 🔥 Menerima notifikasi real-time ketika app aktif
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        saveIncomingNotification(
          title: message.notification!.title ?? "No title",
          body: message.notification!.body ?? "No body",
        );
      }
    });

    // 🔥 Stream notifikasi dari Firestore
    _service.streamNotifications().listen((data) {
      _list
        ..clear()
        ..addAll(data);

      notifyListeners();
    });
  }

  Future<void> saveIncomingNotification({
    required String title,
    required String body,
  }) async {
    final notif = NotificationModel(
      id: const Uuid().v4(),
      title: title,
      body: body,
      createdAt: DateTime.now().toIso8601String(),
    );

    await _service.saveNotification(notif);
  }
}
