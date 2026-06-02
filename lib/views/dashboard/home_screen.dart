import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manajemen_inventaris/views/barang/barang_screen.dart';
import 'package:manajemen_inventaris/views/dashboard/dashboard_screen.dart';
import 'package:manajemen_inventaris/views/laporan/laporan_screen.dart';
import 'package:manajemen_inventaris/views/stok/stok_screen.dart';
import 'package:manajemen_inventaris/views/transaksi/transaksi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? role; // 1 = Owner, 2 = User

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      role = doc.data()?['role'];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // BOTTOM NAV BAR ITEMS
    final ownerPages = [
      const DashboardScreen(),
      const BarangScreen(),
      const StokScreen(),
      const TransaksiScreen(),
      const LaporanScreen(),
    ];

    final userPages = [
      const DashboardScreen(),
      const StokScreen(),
      const TransaksiScreen(),
    ];

    final ownerNavItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: "Dashboard",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "Barang"),
      BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Stok"),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long),
        label: "Transaksi",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Laporan"),
    ];

    final userNavItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: "Dashboard",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Stok"),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long),
        label: "Transaksi",
      ),
    ];

    final pages = role == 1 ? ownerPages : userPages;
    final navItems = role == 1 ? ownerNavItems : userNavItems;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: navItems,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
