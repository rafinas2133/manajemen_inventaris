import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/barang_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/barang_model.dart';

class BarangScreen extends StatefulWidget {
  const BarangScreen({super.key});

  @override
  State<BarangScreen> createState() => _BarangScreenState();
}

class _BarangScreenState extends State<BarangScreen> {
  late BarangViewModel vm;
  int role = 2;

  String search = "";
  Set<String> selectedKategori = {};

  final List<String> kategoriList = [
    'tutup pendek',
    'tutup tinggi',
    'jerigen',
    'kale',
    'toples',
  ];

  @override
  void initState() {
    super.initState();
    vm = Provider.of<BarangViewModel>(context, listen: false);
    _loadRole();
  }

  Future<void> _loadRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    final r = doc.data()?['role'];
    setState(() {
      role = (r is int) ? r : int.tryParse(r.toString()) ?? 2;
    });
  }

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
  void _openAddEditSheet({BarangModel? editing}) {
    final namaC = TextEditingController(text: editing?.nama ?? '');
    final isiC = TextEditingController(
      text: editing?.isiPerBal.toString() ?? '0',
    );
    final hargaBeliC = TextEditingController(
      text: editing?.hargaBeli.toString() ?? '0',
    );
    final hargaJualC = TextEditingController(
      text: editing?.hargaJual.toString() ?? '0',
    );
    final stokC = TextEditingController(text: editing?.stok.toString() ?? '0');
    final minStokC = TextEditingController(
      text: editing?.minStok.toString() ?? '0',
    );

    String kategori = editing?.kategori ?? 'tutup pendek';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    editing == null ? 'Tambah Barang' : 'Edit Barang',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _input(namaC, 'Nama'),
                  _dropdown(kategori, (v) => kategori = v),
                  _input(isiC, 'Isi per bal', isNumber: true),
                  _input(hargaBeliC, 'Harga Beli', isNumber: true),
                  _input(hargaJualC, 'Harga Jual', isNumber: true),
                  _input(stokC, 'Stok', isNumber: true),
                  _input(minStokC, 'Minimum Stok', isNumber: true),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      final nama = namaC.text.trim();
                      final isi = int.tryParse(isiC.text.trim()) ?? 0;
                      final hargaBeli =
                          int.tryParse(hargaBeliC.text.trim()) ?? 0;
                      final hargaJual =
                          int.tryParse(hargaJualC.text.trim()) ?? 0;
                      final stok = int.tryParse(stokC.text.trim()) ?? 0;
                      final minStok = int.tryParse(minStokC.text.trim()) ?? 0;

                      if (editing == null) {
                        final err = await vm.addBarang(
                          nama: nama,
                          kategori: kategori,
                          isiPerBal: isi,
                          hargaBeli: hargaBeli,
                          hargaJual: hargaJual,
                          stok: stok,
                          minStok: minStok,
                        );
                        if (err == null) Navigator.pop(ctx);
                      } else {
                        final err = await vm.updateBarang(
                          id: editing.id,
                          nama: nama,
                          kategori: kategori,
                          isiPerBal: isi,
                          hargaBeli: hargaBeli,
                          hargaJual: hargaJual,
                          stok: stok,
                          minStok: minStok,
                        );
                        if (err == null) Navigator.pop(ctx);
                      }
                    },
                    child: Text(editing == null ? 'Tambah' : 'Update'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _input(
    TextEditingController c,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  Widget _dropdown(String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: const [
          DropdownMenuItem(value: 'tutup pendek', child: Text('Tutup Pendek')),
          DropdownMenuItem(value: 'tutup tinggi', child: Text('Tutup Tinggi')),
          DropdownMenuItem(value: 'jerigen', child: Text('Jerigen')),
          DropdownMenuItem(value: 'kale', child: Text('Kale')),
          DropdownMenuItem(value: 'toples', child: Text('Toples')),
        ],
        onChanged: (v) => onChanged(v ?? value),
        decoration: const InputDecoration(labelText: 'Kategori'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang')),
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
              stream: vm.streamBarang(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = _applyFilter(snapshot.data!);

                if (filtered.isEmpty) {
                  return const Center(child: Text('Barang tidak ditemukan'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final b = filtered[i];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(b.nama),
                        subtitle:
                            Text("Kategori: ${b.kategori}\nStok: ${b.stok}"),
                        trailing: role == 1
                            ? PopupMenuButton(
                                onSelected: (v) async {
                                  if (v == 'edit') {
                                    _openAddEditSheet(editing: b);
                                  } else if (v == 'delete') {
                                    await vm.deleteBarang(b.id);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                      value: 'edit', child: Text('Edit')),
                                  PopupMenuItem(
                                      value: 'delete', child: Text('Hapus')),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: role == 1
          ? FloatingActionButton(
              onPressed: () => _openAddEditSheet(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}