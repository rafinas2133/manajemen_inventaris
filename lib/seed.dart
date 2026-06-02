import 'package:cloud_firestore/cloud_firestore.dart';

class BarangSeeder {
  final col = FirebaseFirestore.instance.collection('barang');

  Future<void> seed() async {
  final col = FirebaseFirestore.instance.collection('barang');

  // ✅ biar gak dobel
  final snapshot = await col.get();
  if (snapshot.docs.isNotEmpty) {
    print("Data sudah ada, skip");
    return;
  }

  final batch = FirebaseFirestore.instance.batch();

  final data = [
  {
    "kode": "BRG001",
    "nama": "50 ml SN",
    "kategori": "tutup pendek",
    "isiPerBal": 196,
    "hargaBeli": 115000,
    "hargaJual": 135000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG002",
    "nama": "80 ml LN",
    "kategori": "tutup pendek",
    "isiPerBal": 200,
    "hargaBeli": 128000,
    "hargaJual": 148000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG003",
    "nama": "100 ml SN",
    "kategori": "tutup pendek",
    "isiPerBal": 221,
    "hargaBeli": 130000,
    "hargaJual": 150000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG005",
    "nama": "150 ml Cantik SN",
    "kategori": "tutup pendek",
    "isiPerBal": 104,
    "hargaBeli": 55000,
    "hargaJual": 75000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG006",
    "nama": "150 ml Kotak SN",
    "kategori": "tutup pendek",
    "isiPerBal": 150,
    "hargaBeli": 77000,
    "hargaJual": 97000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG007",
    "nama": "150 ml Gendut SN",
    "kategori": "tutup pendek",
    "isiPerBal": 150,
    "hargaBeli": 73000,
    "hargaJual": 93000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG008",
    "nama": "150 ml Almond SN",
    "kategori": "tutup pendek",
    "isiPerBal": 125,
    "hargaBeli": 60000,
    "hargaJual": 80000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG009",
    "nama": "200 ml Cabe SN",
    "kategori": "tutup pendek",
    "isiPerBal": 140,
    "hargaBeli": 70000,
    "hargaJual": 90000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG011",
    "nama": "220 ml SN",
    "kategori": "tutup pendek",
    "isiPerBal": 126,
    "hargaBeli": 50000,
    "hargaJual": 70000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG013",
    "nama": "250 ml Gendut SN",
    "kategori": "tutup pendek",
    "isiPerBal": 96,
    "hargaBeli": 54000,
    "hargaJual": 74000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG014",
    "nama": "250 ml Almond SN",
    "kategori": "tutup pendek",
    "isiPerBal": 140,
    "hargaBeli": 60000,
    "hargaJual": 80000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG015",
    "nama": "250 ml Almond LN",
    "kategori": "tutup pendek",
    "isiPerBal": 140,
    "hargaBeli": 70000,
    "hargaJual": 90000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG016",
    "nama": "250 ml Cimory/Kotak LN",
    "kategori": "tutup pendek",
    "isiPerBal": 126,
    "hargaBeli": 80000,
    "hargaJual": 100000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG017",
    "nama": "250 ml Pier SN (144)",
    "kategori": "tutup pendek",
    "isiPerBal": 144,
    "hargaBeli": 70000,
    "hargaJual": 90000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG018",
    "nama": "250 ml Pier SN (100)",
    "kategori": "tutup pendek",
    "isiPerBal": 100,
    "hargaBeli": 42500,
    "hargaJual": 62500,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG019",
    "nama": "250 ml Madu LN",
    "kategori": "tutup pendek",
    "isiPerBal": 150,
    "hargaBeli": 89000,
    "hargaJual": 109000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG020",
    "nama": "250 ml Granat LN",
    "kategori": "tutup pendek",
    "isiPerBal": 72,
    "hargaBeli": 40000,
    "hargaJual": 60000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG021",
    "nama": "250 ml Kale",
    "kategori": "kale",
    "isiPerBal": 100,
    "hargaBeli": 150000,
    "hargaJual": 170000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG022",
    "nama": "250 ml Kale kotak",
    "kategori": "kale",
    "isiPerBal": 100,
    "hargaBeli": 150000,
    "hargaJual": 170000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG025",
    "nama": "330 ml Wave LN",
    "kategori": "tutup panjang",
    "isiPerBal": 98,
    "hargaBeli": 53000,
    "hargaJual": 73000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG026",
    "nama": "330 ml Classic LN",
    "kategori": "tutup panjang",
    "isiPerBal": 108,
    "hargaBeli": 45000,
    "hargaJual": 65000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG027",
    "nama": "330 ml Diamond SN",
    "kategori": "tutup pendek",
    "isiPerBal": 108,
    "hargaBeli": 45000,
    "hargaJual": 65000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG028",
    "nama": "330 ml Diamond LN",
    "kategori": "tutup panjang",
    "isiPerBal": 98,
    "hargaBeli": 53000,
    "hargaJual": 73000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG029",
    "nama": "350 ml Cantik Tebal SN",
    "kategori": "tutup pendek",
    "isiPerBal": 88,
    "hargaBeli": 80000,
    "hargaJual": 100000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG030",
    "nama": "350 ml Cantik Tipis LN",
    "kategori": "tutup panjang",
    "isiPerBal": 88,
    "hargaBeli": 50000,
    "hargaJual": 70000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG031",
    "nama": "350 ml Madu LN",
    "kategori": "tutup panjang",
    "isiPerBal": 112,
    "hargaBeli": 114000,
    "hargaJual": 134000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG032",
    "nama": "450 ml Cupir LN",
    "kategori": "tutup panjang",
    "isiPerBal": 91,
    "hargaBeli": 55000,
    "hargaJual": 75000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG033",
    "nama": "500 ml Sinom LN",
    "kategori": "tutup panjang",
    "isiPerBal": 80,
    "hargaBeli": 33000,
    "hargaJual": 53000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG034",
    "nama": "500 ml Almond SN",
    "kategori": "tutup pendek",
    "isiPerBal": 91,
    "hargaBeli": 80000,
    "hargaJual": 100000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG035",
    "nama": "500 ml Tibet LN",
    "kategori": "tutup panjang",
    "isiPerBal": 91,
    "hargaBeli": 85000,
    "hargaJual": 105000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG036",
    "nama": "500 ml Kale",
    "kategori": "kale",
    "isiPerBal": 100,
    "hargaBeli": 150000,
    "hargaJual": 170000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG038",
    "nama": "510 ml LN",
    "kategori": "tutup panjang",
    "isiPerBal": 91,
    "hargaBeli": 55000,
    "hargaJual": 75000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG040",
    "nama": "600 ml Aqua Wave LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 72,
    "hargaBeli": 45000,
    "hargaJual": 65000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG041",
    "nama": "600 ml Hexa LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 100,
    "hargaBeli": 60000,
    "hargaJual": 80000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG042",
    "nama": "600 ml Cantik SN",
    "kategori": "tutup pendek",
    "isiPerBal": 100,
    "hargaBeli": 90000,
    "hargaJual": 110000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG043",
    "nama": "750 ml Cupir LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 130,
    "hargaBeli": 125000,
    "hargaJual": 145000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG044",
    "nama": "800 ml Minyak LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 70,
    "hargaBeli": 67000,
    "hargaJual": 87000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG045",
    "nama": "900 ml Kotak/Minyak LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 77,
    "hargaBeli": 76000,
    "hargaJual": 96000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG046",
    "nama": "900 ml Kuda LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 98,
    "hargaBeli": 95000,
    "hargaJual": 115000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG047",
    "nama": "1000 ml LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 98,
    "hargaBeli": 95000,
    "hargaJual": 115000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG050",
    "nama": "1500 ml LN",
    "kategori": "tutup tinggi",
    "isiPerBal": 72,
    "hargaBeli": 70000,
    "hargaJual": 90000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG051",
    "nama": "250 ml HDPE",
    "kategori": "tutup pendek",
    "isiPerBal": 144,
    "hargaBeli": 369000,
    "hargaJual": 389000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG052",
    "nama": "500 ml HDPE",
    "kategori": "tutup pendek",
    "isiPerBal": 96,
    "hargaBeli": 239000,
    "hargaJual": 259000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG053",
    "nama": "1000 ml HDPE",
    "kategori": "tutup tinggi",
    "isiPerBal": 60,
    "hargaBeli": 202000,
    "hargaJual": 222000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG054",
    "nama": "Jerigen 500 ml kotak",
    "kategori": "jerigen",
    "isiPerBal": 104,
    "hargaBeli": 266000,
    "hargaJual": 286000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG055",
    "nama": "Jerigen 1 ltr kotak tinggi",
    "kategori": "jerigen",
    "isiPerBal": 72,
    "hargaBeli": 246000,
    "hargaJual": 266000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG056",
    "nama": "Jerigen 1 ltr kotak pendek",
    "kategori": "jerigen",
    "isiPerBal": 56,
    "hargaBeli": 187000,
    "hargaJual": 207000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG057",
    "nama": "Jerigen 5 liter",
    "kategori": "jerigen",
    "isiPerBal": 20,
    "hargaBeli": 150000,
    "hargaJual": 170000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG058",
    "nama": "150 ml sambal bulat",
    "kategori": "toples",
    "isiPerBal": 72,
    "hargaBeli": 102000,
    "hargaJual": 122000,
    "stok": 50,
    "minStok": 10
  },
  {
    "kode": "BRG059",
    "nama": "200 ml sambal kotak",
    "kategori": "toples",
    "isiPerBal": 72,
    "hargaBeli": 102000,
    "hargaJual": 122000,
    "stok": 50,
    "minStok": 10
  }
];

  for (var item in data) {
    final docRef = col.doc();
    batch.set(docRef, item);
  }

  await batch.commit();

  print("✅ Seed selesai");
}
}