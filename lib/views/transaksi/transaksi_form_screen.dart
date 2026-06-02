import 'package:flutter/material.dart';
import 'package:manajemen_inventaris/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/transaksi_viewmodel.dart';
import '../../models/barang_model.dart';

class TransaksiFormScreen extends StatefulWidget {
  const TransaksiFormScreen({super.key});

  @override
  State<TransaksiFormScreen> createState() => _TransaksiFormScreenState();
}

class _TransaksiFormScreenState extends State<TransaksiFormScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TransaksiViewModel>(context, listen: false).resetForm();
      Provider.of<TransaksiViewModel>(context, listen: false).loadBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransaksiViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Transaksi"),
      ),
      body: Column(
        children: [
          Expanded(
            child: vm.itemList.isEmpty
                ? const Center(
                    child: Text("Belum ada item. Tekan + untuk menambah."),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    scrollDirection: Axis.horizontal,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Barang")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Harga")),
                          DataColumn(label: Text("Subtotal")),
                          DataColumn(label: Text("Aksi")),
                        ],
                        rows: vm.itemList.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item.namaBarang)),
                              DataCell(Text(item.qty.toString())),
                              DataCell(Text(item.hargaJual.toString())),
                              DataCell(Text(item.subtotal.toString())),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    vm.removeItem(item.barangId);
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rp ${vm.totalHarga}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Simpan Transaksi"),
                onPressed: () async {
                  final trxVM = context.read<TransaksiViewModel>();
                  final authVM = context.read<LoginViewModel>();
                  final user = authVM.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User belum login"),
                      ),
                    );
                    return;
                  }
                  final res = await trxVM.simpanTransaksi(
                    userId: user.id,
                    userNama: user.nama,
                    userRole: user.role,
                  );
                  if (res == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Transaksi berhasil disimpan"),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 130),
        child: FloatingActionButton(
          onPressed: () => _openAddItemModal(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _openAddItemModal(BuildContext context) {
    final vm = Provider.of<TransaksiViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      // ✅ Builder pakai widget terpisah agar setState benar-benar rebuild list
      builder: (_) => _AddItemModal(vm: vm),
    );
  }
}

// ============================================================
// Widget modal dipisah jadi StatefulWidget sendiri
// ============================================================
class _AddItemModal extends StatefulWidget {
  final TransaksiViewModel vm;
  const _AddItemModal({required this.vm});

  @override
  State<_AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<_AddItemModal> {
  BarangModel? selectedBarang;
  final TextEditingController qtyCtrl = TextEditingController();
  final TextEditingController searchCtrl = TextEditingController();
  String search = "";
  bool showList = false; // kontrol tampil/sembunyi list

  @override
  void dispose() {
    qtyCtrl.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  List<BarangModel> get filteredBarang {
    final list = widget.vm.barangList.where((b) {
      return b.nama.toLowerCase().contains(search.toLowerCase());
    }).toList();

    list.sort((a, b) {
      int getNumber(String text) {
        final match = RegExp(r'^\d+').firstMatch(text);
        return match != null ? int.parse(match.group(0)!) : 0;
      }
      final numA = getNumber(a.nama);
      final numB = getNumber(b.nama);
      if (numA != numB) return numA.compareTo(numB);
      return a.nama.toLowerCase().compareTo(b.nama.toLowerCase());
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Tambah Item",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // ── Search field ──────────────────────────────────────
          TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              labelText: "Cari Barang",
              hintText: "Ketik nama barang...",
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              // Tampilkan tombol clear jika ada teks
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchCtrl.clear();
                          search = "";
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (v) {
              setState(() {
                search = v;
                showList = true; // otomatis buka list saat mengetik
              });
            },
            onTap: () {
              setState(() => showList = true);
            },
          ),

          // ── Chips barang terpilih ─────────────────────────────
          // if (selectedBarang != null) ...[
          //   const SizedBox(height: 8),
          //   Chip(
          //     label: Text(selectedBarang!.nama),
          //     deleteIcon: const Icon(Icons.close, size: 16),
          //     onDeleted: () {
          //       setState(() {
          //         selectedBarang = null;
          //         searchCtrl.clear();
          //         search = "";
          //       });
          //     },
          //     backgroundColor: Colors.blue.shade100,
          //   ),
          // ],

          // ── List hasil pencarian ──────────────────────────────
          if (showList && selectedBarang == null) ...[
            const SizedBox(height: 4),
            Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: filteredBarang.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text("Barang tidak ditemukan")),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredBarang.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final barang = filteredBarang[index];
                        return ListTile(
                          dense: true,
                          title: Text(barang.nama),
                          onTap: () {
                            setState(() {
                              selectedBarang = barang;
                              // Isi search field dengan nama barang terpilih
                              searchCtrl.text = barang.nama;
                              showList = false; // tutup list
                            });
                            // Tutup keyboard
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
            ),
          ],

          const SizedBox(height: 12),

          // ── Input Qty ─────────────────────────────────────────
          TextField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Qty",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          // ── Tombol Tambah ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedBarang == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pilih barang dulu")),
                  );
                  return;
                }
                final qty = int.tryParse(qtyCtrl.text);
                if (qty == null || qty <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Qty tidak valid")),
                  );
                  return;
                }
                final error = widget.vm.addItem(selectedBarang!, qty);
                Navigator.pop(context);
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Tambah"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}