import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/barang_viewmodel.dart';
import '../../viewmodels/transaksi_viewmodel.dart';
import '../../viewmodels/stok_viewmodel.dart';
import '../../models/barang_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final searchCtrl = TextEditingController();
  Timer? _debounce;
  String keyword = "";

  @override
  void initState() {
    super.initState();

    searchCtrl.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          keyword = searchCtrl.text;
        });
      });
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardVM = Provider.of<DashboardViewModel>(context);
    final barangVM = Provider.of<BarangViewModel>(context, listen: false);
    final transaksiVM = Provider.of<TransaksiViewModel>(context, listen: false);
    final stokVM = Provider.of<StokViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
          leading: Consumer<DashboardViewModel>(
            builder: (context, vm, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.pushNamed(context, "/notifications");
                    },
                  ),

                  if (vm.hasUnreadNotif)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await dashboardVM.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/login");
              }
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= SUMMARY =================
            StreamBuilder(
              stream: transaksiVM.streamTransaksi(),
              builder: (context, snapshot) {
                final list = snapshot.data ?? [];

                final today = DateTime.now();
                final transaksiHariIni = list.where(
                  (t) =>
                      t.tanggal.year == today.year &&
                      t.tanggal.month == today.month &&
                      t.tanggal.day == today.day,
                );

                final totalHariIni = transaksiHariIni.fold(
                  0,
                  (sum, t) => sum + t.total,
                );

                return GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  children: [
                    _summaryCard(
                      title: "Pendapatan Hari Ini",
                      value: "Rp $totalHariIni",
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                    _summaryCard(
                      title: "Transaksi Hari Ini",
                      value: transaksiHariIni.length.toString(),
                      icon: Icons.receipt_long,
                      color: Colors.blue,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // ================= SEARCH BAR =================
            const Text(
              "Cari Barang",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(
                hintText: "Ketik nama barang...",
                prefixIcon: Icon(Icons.search),
              ),
            ),

            const SizedBox(height: 12),

            /// ✅ TAMPILKAN HASIL HANYA JIKA ADA KEYWORD
            if (keyword.isNotEmpty)
              StreamBuilder<List<BarangModel>>(
                stream: barangVM.streamBarang(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final data = snapshot.data!
                      .where(
                        (b) => b.nama.toLowerCase().contains(
                          keyword.toLowerCase(),
                        ),
                      )
                      .toList();

                  if (data.isEmpty) {
                    return const Text("Barang tidak ditemukan");
                  }

                  return ListView.builder(
                    itemCount: data.length > 10 ? 10 : data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      final barang = data[i];

                      return Card(
                        child: ListTile(
                          onTap: () => _showDetailBarang(barang),
                          title: Text(barang.nama),
                          subtitle: Text("Stok: ${barang.stok}"),
                          trailing: Text("Rp ${barang.hargaJual}"),
                        ),
                      );
                    },
                  );
                },
              ),

            const SizedBox(height: 24),

            // ================= TRANSAKSI TERBARU =================
            const Text(
              "Transaksi Terakhir",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            StreamBuilder(
              stream: transaksiVM.streamTransaksi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("Belum ada transaksi");
                }

                final data = snapshot.data!.take(5).toList();

                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    final trx = data[i];
                    return Card(
                      child: ListTile(
                        title: Text("Rp ${trx.total}"),
                        subtitle: Text(
                          DateFormat(
                            "dd MMM yyyy - HH:mm",
                            "id_ID",
                          ).format(trx.tanggal),
                        ),
                        trailing: Text("${trx.items.length} item"),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // ================= AKTIVITAS STOK =================
            const Text(
              "Aktivitas Stok Terbaru",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            StreamBuilder(
              stream: stokVM.streamHistory(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("Belum ada aktivitas stok");
                }

                final data = snapshot.data!.take(5).toList();

                return ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    final hist = data[i];
                    return Card(
                      child: ListTile(
                        title: Text(hist["barangName"]),
                        subtitle: Text("Qty: ${hist["qty"]}"),
                        trailing: Text(hist["userName"] ?? "-"),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= POPUP DETAIL BARANG =================
  void _showDetailBarang(BarangModel barang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(barang.nama),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kode: ${barang.kode}"),
            const SizedBox(height: 8),
            Text("Kategori: ${barang.kategori}"),
            const SizedBox(height: 8),
            Text("Stok: ${barang.stok}"),
            const SizedBox(height: 8),
            Text("Harga Beli: Rp ${barang.hargaBeli}"),
            const SizedBox(height: 8),
            Text("Harga Jual: Rp ${barang.hargaJual}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  // ================= SUMMARY CARD =================
  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
