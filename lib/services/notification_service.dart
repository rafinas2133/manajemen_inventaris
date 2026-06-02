import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import '../models/notification_model.dart';

class NotificationService {
  final _ref = FirebaseFirestore.instance.collection('notifications');

  static Map<String, dynamic>? _serviceAccount;

  /// 🔥 Load service-account JSON (untuk FCM HTTP v1)
  static Future<void> init() async {
    final data = await rootBundle.loadString('assets/service_account.json');
    _serviceAccount = jsonDecode(data);
  }

  /// 🔥 Stream Notifikasi dari Firestore
  Stream<List<NotificationModel>> streamNotifications() {
    return _ref.orderBy("createdAt", descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromJson({"id": doc.id, ...doc.data()});
      }).toList();
    });
  }

  /// 🔥 Simpan Notifikasi Secara Manual (dipanggil dari ViewModel)
  Future<void> saveNotification(NotificationModel notif) async {
    await _ref.doc(notif.id).set(notif.toJson());
  }

  /// 🔥 Ambil OAuth Token untuk FCM v1
  Future<String> _getAccessToken() async {
    if (_serviceAccount == null) {
      await NotificationService.init();
    }

    final privateKey = _serviceAccount!["private_key"];
    final clientEmail = _serviceAccount!["client_email"];
    final tokenUri = _serviceAccount!["token_uri"];

    final iat = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final exp = iat + 3600;

    final jwt = JWT({
      "iss": clientEmail,
      "scope": "https://www.googleapis.com/auth/firebase.messaging",
      "aud": tokenUri,
      "iat": iat,
      "exp": exp,
    });

    final jwtString = jwt.sign(
      RSAPrivateKey(privateKey),
      algorithm: JWTAlgorithm.RS256,
    );

    final response = await http.post(
      Uri.parse(tokenUri),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
        "assertion": jwtString,
      },
    );

    final jsonRes = jsonDecode(response.body);
    return jsonRes["access_token"];
  }

  /// 🔥 Kirim Notifikasi Low Stock (HTTP v1)
  Future<void> sendLowStockNotif({
    required String barangName,
    required int stok,
  }) async {
    final token = await _getAccessToken();

    final projectId = _serviceAccount!["project_id"];

    final url = Uri.parse(
      "https://fcm.googleapis.com/v1/projects/$projectId/messages:send",
    );

    final body = {
      "message": {
        "topic": "admin",
        "notification": {
          "title": "Stok Hampir Habis",
          "body": "$barangName tersisa $stok",
        },
      },
    };

    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    // Simpan ke Firestore
    await _ref.add({
      "title": "Stok Hampir Habis",
      "body": "$barangName tersisa $stok",
      "createdAt": DateTime.now().toIso8601String(),
    });
  }
}
