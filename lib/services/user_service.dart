import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    "users",
  );

  Future<void> createUser(UserModel user) async {
    await users.doc(user.id).set({
      ...user.toJson(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUser(String id) async {
    final doc = await users.doc(id).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    await users.doc(id).update({
      ...data,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserToken(String id, String token) async {
    await users.doc(id).update({
      "fcmToken": token,
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  Future<List<UserModel>> getAllUsers() async {
    final query = await users.get();
    return query.docs
        .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}
