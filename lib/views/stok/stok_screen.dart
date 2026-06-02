import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/barang_viewmodel.dart';
import '../../models/barang_model.dart';
import 'tambah_stok_screen.dart';
import 'stock_history_screen.dart';

class StokScreen extends StatefulWidget {
  const StokScreen({super.key});

  @override
  State<StokScreen> createState() => _StokScreenState();
}

class _StokScreenState extends State<StokScreen> {

  String search = "";
  Set<String> selectedKategori = {};

  final List<String> kategoriList = [
    'tutup pendek',
    'tutup tinggi',
    'jerigen',
    'kale'
  ];

  void _openFilterDialog() {
    final tempSelected = Set<String>.from(selectedKategori);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Filter Kategori"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: kategoriList.map((k) {
                  return CheckboxListTile(
                    title: Text(k),
                    value: tempSelected.contains(k),
                    onChanged: (v) {
                      setStateDialog(() {
                        if (v == true) {
                          tempSelected.add(k);
                        } else {
                          tempSelected.remove(k);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedKategori = tempSelected;
                });
                Navigator.pop(ctx);
              },
              child: const Text("Terapkan"),
            ),
          ],
        );
      },
    );
  }

  List<BarangModel> _applyFilter(List<BarangModel> list) {
    final result = list.where((b) {
      final matchSearch =
          b.nama.toLowerCase().contains(search.toLowerCase());

      final matchKategori = selectedKategori.isEmpty
          ? true
          : selectedKategori.contains(b.kategori);

      return matchSearch && matchKategori;
    }).toList();

    result.sort((a, b) {
      int getNumber(String text) {
        final match = RegExp(r'^\d+').firstMatch(text);
        return match != null ? int.parse(match.group(0)!) : 0;
      }

      final numA = getNumber(a.nama);
      final numB = getNumber(b.nama);

      if (numA != numB) {
        return numA.compareTo(numB); // sort berdasarkan angka
      }

      return a.nama.toLowerCase().compareTo(b.nama.toLowerCase()); // fallback
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {

    final barangVM = Provider.of<BarangViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stok Barang"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StockHistoryScreen()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Cari barang...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) {
                      setState(() {
                        search = v;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _openFilterDialog,
                  ),
                ),

              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<BarangModel>>(
              stream: barangVM.streamBarang(),
              builder: (context, snap) {

                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = _applyFilter(snap.data!);

                if (filtered.isEmpty) {
                  return const Center(child: Text("Barang tidak ditemukan"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (c, i) {

                    final b = filtered[i];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(b.nama),
                        subtitle: Text("Stok: ${b.stok}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TambahStokScreen(barang: b),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}