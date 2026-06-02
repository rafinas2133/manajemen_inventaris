import 'package:flutter/material.dart';
import 'package:manajemen_inventaris/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../models/barang_model.dart';
import '../../viewmodels/stok_viewmodel.dart';

class TambahStokScreen extends StatefulWidget {
  final BarangModel barang;
  const TambahStokScreen({super.key, required this.barang});

  @override
  State<TambahStokScreen> createState() => _TambahStokScreenState();
}

class _TambahStokScreenState extends State<TambahStokScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StokViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Tambah Stok ${widget.barang.nama}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Jumlah Stok"),
                  ),
                  const SizedBox(height: 20),

                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {

                            final qty = int.tryParse(controller.text);
                            if (qty == null || qty <= 0) return;

                            final authVM = context.read<LoginViewModel>();
                            final user = authVM.currentUser;

                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("User belum login")),
                              );
                              return;
                            }

                            final err = await vm.addStock(
                              barangId: widget.barang.id,
                              barangName: widget.barang.nama,
                              qty: qty,
                              userId: user.id,
                              userName: user.nama,
                            );

                            if (err == null) {
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(err)));
                            }
                          },
                          child: const Text("Tambah Stok"),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
