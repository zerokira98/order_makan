import 'package:flutter/material.dart';
import 'package:order_makan/main.dart';
// import 'package:order_makan/pages/admin_panel/karyawan_manage/karyawanmanage_main.dart';
import 'package:order_makan/pages/edit_app/edit_main.dart';
import 'package:order_makan/pages/histori_struk.dart';

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
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoriStruk(),
                        ));
                  },
                  child: const Text('Histori Struk')),
              ListTile(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                  title: Text(a[0])),
              ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          final FocusNode focusNode = FocusNode();
                          focusNode.requestFocus();
                          return Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: SizedBox(
                                width: 100,
                                child: TextFormField(
                                  // controller: tct,

                                  validator: (value) {
                                    if (value == null) {
                                      return 'uninitialized';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'not number/format error';
                                    }
                                  },
                                  // initialValue: state
                                  //     .orderItems[widget.index].count
                                  //     .toString(),

                                  onFieldSubmitted: (value) {
                                    print(value);
                                    // BlocProvider.of<UseStrukBloc>(
                                    //         context)
                                    //     .add(ChangeCount(
                                    //         item: state.orderItems[
                                    //             widget.index],
                                    //         count:
                                    //             int.parse(value)));
                                    // Navigator.pop(context);
                                  },
                                  focusNode: focusNode,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(label: Text('Uang Laci')),
                                ),
                              ),
                            ),
                          );
                        });
                    // setState(() {
                    //   selectedIndex = 0;
                    // });
                    // Navigator.pop(context);
                  },
                  title: Text('Set Uang Laci Hari ini')),
            ],
            // children: List.generate(
            //     a.length,
            //     (index) => ),
          ),
        ),
      ),
      body: switch (selectedIndex) {
        0 => const EditMain(),
        // 1 => const KaryawanManageMain(),
        int() => const EditMain(),
      },
    );
  }
}
