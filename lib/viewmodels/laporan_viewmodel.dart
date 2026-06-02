import 'package:flutter/material.dart';
import '../models/transaksi_model.dart';
import '../services/laporan_service.dart';

class LaporanViewModel extends ChangeNotifier {
  final LaporanService _service = LaporanService();

  DateTime? startDate;
  DateTime? endDate;

  // Stream laporan berdasarkan tanggal
  Stream<List<TransaksiModel>> get streamLaporan {
    if (startDate == null || endDate == null) {
      return const Stream.empty();
    }
    return _service.laporanRange(startDate!, endDate!);
  }

  void setStart(DateTime date) {
    startDate = date;
    notifyListeners();
  }

  void setEnd(DateTime date) {
    endDate = date;
    notifyListeners();
  }
}
