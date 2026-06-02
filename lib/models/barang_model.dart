class BarangModel {
  final String id;
  final String kode;
  final String nama;
  final String kategori;
  final int isiPerBal;
  final int hargaBeli;
  final int hargaJual;
  final int stok;
  final int minStok;

  BarangModel({
    required this.id,
    required this.kode,
    required this.nama,
    required this.kategori,
    required this.isiPerBal,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
    required this.minStok,
  });

  factory BarangModel.fromMap(Map<String, dynamic> map, String docId) {
    return BarangModel(
      id: docId,
      kode: map['kode'] ?? '',
      nama: map['nama'] ?? '',
      kategori: map['kategori'] ?? '',
      isiPerBal: map['isiPerBal'] ?? 0,
      hargaBeli: map['hargaBeli'] ?? 0,
      hargaJual: map['hargaJual'] ?? 0,
      stok: map['stok'] ?? 0,
      minStok: map['minStok'] ?? 0, // NEW
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kode': kode,
      'nama': nama,
      'kategori': kategori,
      'isiPerBal': isiPerBal,
      'hargaBeli': hargaBeli,
      'hargaJual': hargaJual,
      'stok': stok,
      'minStok': minStok, // NEW
    };
  }
}
