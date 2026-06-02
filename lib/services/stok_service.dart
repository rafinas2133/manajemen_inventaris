import 'package:cloud_firestore/cloud_firestore.dart';

class StokService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // tambah stok + catat history
  Future<void> addStock({
    required String barangId,
    required String barangName,
    required int qty,
    required String userId,
    required String userName,
  }) async {
    final batch = _db.batch();

    // referensi barang
    final barangRef = _db.collection('barang').doc(barangId);

    // update stok barang
    batch.update(barangRef, {'stok': FieldValue.increment(qty)});

    // simpan history stok
    final historyRef = _db.collection('stock_history').doc();
    batch.set(historyRef, {
      'id': historyRef.id,
      'barangId': barangId,
      'barangName': barangName,
      'qty': qty,
      'userId': userId,
      'userName': userName,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // stream seluruh history
  Stream<List<Map<String, dynamic>>> streamHistory() {
    return _db
        .collection('stock_history')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  // stream history berdasarkan barang
  Stream<List<Map<String, dynamic>>> streamHistoryByBarang(String barangId) {
    return _db
        .collection('stock_history')
        .where('barangId', isEqualTo: barangId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }
}
