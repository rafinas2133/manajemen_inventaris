import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/notification_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ CLEAR DOT BADGE SAAT MASUK
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().setUnreadNotif(false);
    });

    final notifVM = Provider.of<NotificationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: notifVM.list.isEmpty
          ? const Center(child: Text("Belum ada notifikasi"))
          : ListView.builder(
        itemCount: notifVM.list.length,
        itemBuilder: (_, i) {
          final n = notifVM.list[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: Text(
                DateFormat("dd MMM HH:mm")
                    .format(DateTime.parse(n.createdAt)),
              ),
            ),
          );
        },
      ),
    );
  }
}
