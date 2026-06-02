import 'package:flutter/material.dart';
import '../../models/transaksi_model.dart';
import 'package:intl/intl.dart';

class TransaksiDetailScreen extends StatelessWidget {
  final TransaksiModel transaksi;

  const TransaksiDetailScreen({super.key, required this.transaksi});

  String formatTanggal(DateTime date) {
    return DateFormat("dd MMMM yyyy - HH:mm", "id_ID").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final createdBy = transaksi.createdBy;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// INFO TRANSAKSI
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TANGGAL
                    Text(
                      "Tanggal",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    Text(
                      formatTanggal(transaksi.tanggal),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // TOTAL
                    const Text("Total"),
                    Text(
                      "Rp ${transaksi.total}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// 🔥 CREATED BY
                    if (createdBy.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 8),

                      Text(
                        "Dibuat oleh",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Text(
                        createdBy['nama'] ?? "-",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _roleLabel(createdBy['role']),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Item Transaksi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: transaksi.items.length,
                itemBuilder: (_, i) {
                  final item = transaksi.items[i];
                  return Card(
                    child: ListTile(
                      title: Text(item.namaBarang),
                      subtitle: Text("Qty: ${item.qty}"),
                      trailing: Text(
                        "Rp ${item.subtotal}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 HELPER ROLE
  String _roleLabel(int? role) {
    switch (role) {
      case 1:
        return "Admin";
      case 2:
        return "Karyawan";
      default:
        return "Unknown";
    }
  }
}
