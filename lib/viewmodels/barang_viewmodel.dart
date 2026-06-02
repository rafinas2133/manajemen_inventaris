import 'package:flutter/material.dart';
import '../services/barang_service.dart';
import '../models/barang_model.dart';

class BarangViewModel extends ChangeNotifier {
  final BarangService _service = BarangService();

  Stream<List<BarangModel>> streamBarang() => _service.streamBarang();

  Future<String?> addBarang({
    required String nama,
    required String kategori,
    required int isiPerBal,
    required int hargaBeli,
    required int hargaJual,
    required int stok,
    required int minStok,
  }) async {
    try {
      await _service.addBarang(
        nama: nama,
        kategori: kategori,
        isiPerBal: isiPerBal,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        stok: stok,
        minStok: minStok,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateBarang({
    required String id,
    required String nama,
    required String kategori,
    required int isiPerBal,
    required int hargaBeli,
    required int hargaJual,
    required int stok,
    required int minStok,
  }) async {
    try {
      await _service.updateBarang(
        id: id,
        nama: nama,
        kategori: kategori,
        isiPerBal: isiPerBal,
        hargaBeli: hargaBeli,
        hargaJual: hargaJual,
        stok: stok,
        minStok: minStok,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteBarang(String id) async {
    try {
      await _service.deleteBarang(id);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
