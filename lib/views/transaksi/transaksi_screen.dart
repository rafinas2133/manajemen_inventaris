import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/transaksi_viewmodel.dart';
import '../../models/transaksi_model.dart';
import 'transaksi_form_screen.dart';
import 'transaksi_detail_screen.dart';

class TransaksiScreen extends StatelessWidget {
  const TransaksiScreen({super.key});

  String formatTanggal(DateTime date) {
    return DateFormat("dd MMMM yyyy - HH:mm", "id_ID").format(date);
  }

  List<TransaksiModel> applyFilter(
    List<TransaksiModel> list,
    TransaksiViewModel vm,
  ) {
    return list.where((t) {
      if (vm.startDate != null) {
        if (t.tanggal.isBefore(vm.startDate!)) return false;
      }

      if (vm.endDate != null) {
        final end = vm.endDate!.add(const Duration(days: 1));
        if (t.tanggal.isAfter(end)) return false;
      }

      return true;
    }).toList();
  }

  Future<void> pickStart(BuildContext context, TransaksiViewModel vm) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) vm.setStart(picked);
  }

  Future<void> pickEnd(BuildContext context, TransaksiViewModel vm) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: vm.endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) vm.setEnd(picked);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransaksiViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Transaksi"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// FILTER TANGGAL
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [

                    /// START DATE
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => pickStart(context, vm),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                vm.startDate == null
                                    ? "Tanggal Mulai"
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(vm.startDate!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// END DATE
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => pickEnd(context, vm),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                vm.endDate == null
                                    ? "Tanggal Akhir"
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(vm.endDate!),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// RESET FILTER
                if (vm.startDate != null || vm.endDate != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        vm.setStart(null);
                        vm.setEnd(null);
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text("Reset Filter"),
                    ),
                  ),
              ],
            ),
          ),

          /// LIST TRANSAKSI
          Expanded(
            child: StreamBuilder<List<TransaksiModel>>(
              stream: vm.streamTransaksi(),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filtered = applyFilter(snap.data!, vm);

                if (filtered.isEmpty) {
                  return const Center(child: Text("Tidak ada transaksi"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final t = filtered[i];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading:
                            const CircleAvatar(child: Icon(Icons.receipt_long)),
                        title: Text(
                          "Rp ${NumberFormat('#,###', 'id_ID').format(t.total).replaceAll(',', '.')}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(formatTanggal(t.tanggal)),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TransaksiDetailScreen(transaksi: t),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TransaksiFormScreen()),
          );
        },
      ),
    );
  }
}