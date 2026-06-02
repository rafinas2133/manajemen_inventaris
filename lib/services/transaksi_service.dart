import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaksi_model.dart';
import '../models/transaksi_item_model.dart';

class TransaksiService {
  final _ref = FirebaseFirestore.instance.collection('transaksi');

  Stream<List<TransaksiModel>> streamTransaksi() {
    return _ref.orderBy('tanggal', descending: true).snapshots().map((snap) {
      return snap.docs
          .map((doc) => TransaksiModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addTransaksi({
    required List<TransaksiItemModel> items,
    required int total,
    required Map<String, dynamic> createdBy,
  }) async {
    await _ref.add({
      'tanggal': DateTime.now(),
      'total': total,
      'items': items.map((e) => e.toMap()).toList(),
      'createdBy': createdBy,
    });
  }
}
