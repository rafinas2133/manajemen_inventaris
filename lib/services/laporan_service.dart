import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaksi_model.dart';

class LaporanService {
  final _ref = FirebaseFirestore.instance.collection('transaksi');

  Stream<List<TransaksiModel>> laporanRange(DateTime start, DateTime end) {
    return _ref
        .where('tanggal', isGreaterThanOrEqualTo: start)
        .where('tanggal', isLessThanOrEqualTo: end)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((e) => TransaksiModel.fromMap(e.data(), e.id))
              .toList(),
        );
  }
}
