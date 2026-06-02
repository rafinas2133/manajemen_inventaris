class TransaksiItemModel {
  final String barangId;
  final String namaBarang;
  final int qty;
  final int hargaJual;
  final int hargaModal;
  final int subtotal; // hargaJual * qty

  int get profit => (hargaJual - hargaModal) * qty;

  TransaksiItemModel({
    required this.barangId,
    required this.namaBarang,
    required this.qty,
    required this.hargaJual,
    required this.hargaModal,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() => {
    "barangId": barangId,
    "namaBarang": namaBarang,
    "qty": qty,
    "hargaJual": hargaJual,
    "hargaModal": hargaModal,
    "subtotal": subtotal,
    "profit": profit,
  };

  static TransaksiItemModel fromMap(Map<String, dynamic> map) {
    return TransaksiItemModel(
      barangId: map['barangId'],
      namaBarang: map['namaBarang'],
      qty: map['qty'],
      hargaJual: map['hargaJual'],
      hargaModal: map['hargaModal'],
      subtotal: map['subtotal'],
    );
  }
}
