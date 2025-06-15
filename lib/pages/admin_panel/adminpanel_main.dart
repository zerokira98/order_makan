import 'package:flutter/material.dart';
import 'package:order_makan/main.dart';
import 'package:order_makan/pages/admin_panel/karyawan_manage/karyawanmanage_main.dart';
import 'package:order_makan/pages/edit_app/edit_main.dart';

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
        title: Text('Admin Panel [${a[selectedIndex]}]'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Close AdminPanel'))
        ],
      ),
      drawer: Drawer(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: List.generate(
                a.length,
                (index) => ListTile(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      Navigator.pop(context);
                    },
                    title: Text(a[index]))),
          ),
        ),
      ),
      body: switch (selectedIndex) {
        0 => const EditMain(),
        1 => const KaryawanManageMain(),
        int() => const EditMain(),
      },
    );
  }
}
