import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/barang_model.dart';

class BarangService {
  final col = FirebaseFirestore.instance.collection('barang');

  Stream<List<BarangModel>> streamBarang() {
    return col.snapshots().map((snap) {
      return snap.docs.map((d) => BarangModel.fromMap(d.data(), d.id)).toList();
    });
  }

  Future<void> addBarang({
    required String nama,
    required String kategori,
    required int isiPerBal,
    required int hargaBeli,
    required int hargaJual,
    required int stok,
    required int minStok,
  }) async {
    final doc = col.doc();

    await doc.set({
      'kode': doc.id.substring(0, 6).toUpperCase(),
      'nama': nama,
      'kategori': kategori,
      'isiPerBal': isiPerBal,
      'hargaBeli': hargaBeli,
      'hargaJual': hargaJual,
      'stok': stok,
      'minStok': minStok, // NEW
    });
  }

  Future<void> updateBarang({
    required String id,
    required String nama,
    required String kategori,
    required int isiPerBal,
    required int hargaBeli,
    required int hargaJual,
    required int stok,
    required int minStok,
  }) async {
    await col.doc(id).update({
      'nama': nama,
      'kategori': kategori,
      'isiPerBal': isiPerBal,
      'hargaBeli': hargaBeli,
      'hargaJual': hargaJual,
      'stok': stok,
      'minStok': minStok, // NEW
    });
  }

  Future<void> deleteBarang(String id) async {
    await col.doc(id).delete();
  }

  Future<void> addStock({required String barangId, required int qty}) async {
    await FirebaseFirestore.instance.runTransaction((t) async {
      final doc = await t.get(col.doc(barangId));
      final stokLama = doc['stok'] ?? 0;

      t.update(col.doc(barangId), {'stok': stokLama + qty});
    });
  }

  Future<void> updateStok(String id, int qty) async {
    final doc = await col.doc(id).get();
    final int stokNow = doc['stok'];
    await col.doc(id).update({'stok': stokNow + qty});
  }

  Future<BarangModel> getBarangById(String id) async {
    final doc = await col.doc(id).get();
    return BarangModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
