import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String nama;
  final String email;
  final int role;
  final String? fcmToken; // <-- new
  final Timestamp? createdAt; // <-- new
  final Timestamp? updatedAt; // <-- new

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "email": email,
    "role": role,
    "fcmToken": fcmToken,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      nama: json["nama"],
      email: json["email"],
      role: json["role"],
      fcmToken: json["fcmToken"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}
