import 'package:flutter/material.dart';
import '../services/stok_service.dart';

class StokViewModel extends ChangeNotifier {
  final StokService _service = StokService();

  bool isLoading = false;

  Future<String?> addStock({
    required String barangId,
    required String barangName,
    required int qty,
    required String userId,
    required String userName,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.addStock(
        barangId: barangId,
        barangName: barangName,
        qty: qty,
        userId: userId,
        userName: userName,
      );

      return null;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // stream semua history
  Stream<List<Map<String, dynamic>>> streamHistory() {
    return _service.streamHistory();
  }

  // stream history berdasarkan barang tertentu
  Stream<List<Map<String, dynamic>>> streamHistoryByBarang(String barangId) {
    return _service.streamHistoryByBarang(barangId);
  }
}
