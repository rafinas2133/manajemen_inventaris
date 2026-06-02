import 'package:flutter/material.dart';
import '../models/transaksi_item_model.dart';
import '../models/transaksi_model.dart';
import '../models/barang_model.dart';
import '../services/transaksi_service.dart';
import '../services/barang_service.dart';
import '../services/notification_service.dart';

class TransaksiViewModel extends ChangeNotifier {
  final TransaksiService _trxService = TransaksiService();
  final BarangService _barangService = BarangService();
  final NotificationService _notifService = NotificationService();

  List<TransaksiItemModel> itemList = [];
  List<BarangModel> barangList = [];

  DateTime? startDate;
  DateTime? endDate;

  bool isLoading = false;

  // STREAM TRANSAKSI
  Stream<List<TransaksiModel>> streamTransaksi() {
    return _trxService.streamTransaksi();
  }

  // LOAD BARANG
  Future<void> loadBarang() async {
    isLoading = true;
    notifyListeners();

    _barangService.streamBarang().listen((data) {
      barangList = data;
      isLoading = false;
      notifyListeners();
    });
  }

  // TAMBAH ITEM TRANSAKSI
  String? addItem(BarangModel barang, int qty) {
    if (qty > barang.stok) {
      return "Stok tidak mencukupi! Stok tersedia: ${barang.stok}";
    }

    itemList.add(
      TransaksiItemModel(
        barangId: barang.id,
        namaBarang: barang.nama,
        qty: qty,
        hargaJual: barang.hargaJual,
        hargaModal: barang.hargaBeli,
        subtotal: qty * barang.hargaJual,
      ),
    );

    notifyListeners();
    return null;
  }

  // HAPUS ITEM
  void removeItem(String barangId) {
    itemList.removeWhere((e) => e.barangId == barangId);
    notifyListeners();
  }

  // TOTAL HARGA
  int get totalHarga => itemList.fold(0, (sum, item) => sum + item.subtotal);

  // SIMPAN TRANSAKSI (DITAMBAH NOTIFIKASI)
  Future<String?> simpanTransaksi({
    required String userId,
    required String userNama,
    required int userRole,
  }) async {
    try {

      for (var item in itemList) {
        // Kurangi stok
        await _barangService.updateStok(item.barangId, -item.qty);

        // Ambil barang terbaru setelah update
        final updatedBarang = await _barangService.getBarangById(item.barangId);

        // 🔥 TRIGGER NOTIFIKASI LOW STOCK
        if (updatedBarang.stok <= updatedBarang.minStok) {
          await _notifService.sendLowStockNotif(
            barangName: updatedBarang.nama,
            stok: updatedBarang.stok,
          );
        }
      }

      // Simpan transaksi di Firestore
      await _trxService.addTransaksi(
        items: itemList, 
        total: totalHarga, 
          createdBy: {
          "id": userId,
          "nama": userNama,
          "role": userRole,
        },
      );

      itemList.clear();
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void setStart(DateTime? date) {
  startDate = date;
  notifyListeners();
  }

  void setEnd(DateTime? date) {
    endDate = date;
    notifyListeners();
  }

  // RESET FORM TRANSAKSI
  void resetForm() {
    itemList.clear();
    notifyListeners();
  }
}
