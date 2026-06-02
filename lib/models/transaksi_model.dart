import 'package:manajemen_inventaris/models/transaksi_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransaksiModel {
  final String id;
  final DateTime tanggal;
  final List<TransaksiItemModel> items;
  final int total;
  final Map<String, dynamic> createdBy;

  int get totalProfit {
    return items.fold(0, (sum, item) => sum + item.profit);
  }

  TransaksiModel({
    required this.id,
    required this.tanggal,
    required this.items,
    required this.total,
    required this.createdBy,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> map, String id) {
    final listItems = (map['items'] as List<dynamic>)
        .map((e) => TransaksiItemModel.fromMap(e))
        .toList();

    return TransaksiModel(
      id: id,
      tanggal: (map['tanggal'] as Timestamp).toDate(),
      items: listItems,
      total: map['total'],
      createdBy: Map<String, dynamic>.from(map['createdBy']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tanggal': tanggal,
      'items': items.map((e) => e.toMap()).toList(),
      'total': total,
      'createdBy': createdBy,
    };
  }
}
