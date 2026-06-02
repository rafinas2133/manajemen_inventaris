import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/stok_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StockHistoryScreen extends StatelessWidget {
  const StockHistoryScreen({super.key});

  String formatTanggal(dynamic createdAt) {
    try {
      if (createdAt is Timestamp) {
        final date = createdAt.toDate();
        return DateFormat("dd MMMM yyyy - HH:mm", "id_ID").format(date);
      } else if (createdAt is String) {
        final date = DateTime.parse(createdAt);
        return DateFormat("dd MMMM yyyy - HH:mm", "id_ID").format(date);
      } else {
        return "-";
      }
    } catch (e) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<StokViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Tambah Stok")),
      body: StreamBuilder(
        stream: vm.streamHistory(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!;
          if (data.isEmpty) {
            return const Center(child: Text("Belum ada history"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, i) {
              final h = data[i];

              final tanggalFormatted = formatTanggal(h['createdAt']);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text("${h['barangName']} (+${h['qty']})"),
                  subtitle: Text("Oleh: ${h['userName']}\n$tanggalFormatted"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
