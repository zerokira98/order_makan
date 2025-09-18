import 'package:flutter/material.dart';
import 'package:order_makan/main.dart';
// import 'package:order_makan/pages/admin_panel/karyawan_manage/karyawanmanage_main.dart';
import 'package:order_makan/pages/admin_panel/edit_app/edit_main.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int selectedIndex = 0;
  List a = ['Edit Menu', 'Manage Karyawan'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page [${a[selectedIndex]}]'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyApp(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Close AdminPage'))
        ],
      ),
      // drawer: AdminDrawer(),
      body: EditMain(),
      // switch (selectedIndex) {
      //   0 => const EditMain(),
      //   // 1 => const KaryawanManageMain(),
      //   int() => const EditMain(),
      // },
    );
  }
}
