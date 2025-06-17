import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/component/menu_card.dart';
import 'package:order_makan/component/struk_panel.dart';
import 'package:order_makan/component/toptab.dart';
import 'package:order_makan/pages/admin_panel/adminpanel_main.dart';
import 'package:order_makan/pages/antrian/antrianpage.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UseMain extends StatefulWidget {
  const UseMain({super.key});

  @override
  State<UseMain> createState() => _UseMainState();
}

class _UseMainState extends State<UseMain> {
  int listLength = 1;
  void ontap() {
    setState(() {
      listLength = listLength + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
            child: Column(
          children: [
            const Text('Hello'),
            ListTile(
              title: const Text('LogOut'),
              onTap: () {
                BlocProvider.of<KaryawanauthBloc>(context).add(SignOut());
              },
            )
          ],
        )),
      ),
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       ScaffoldState().openDrawer();
        //       // Scaffold.of(context).openDrawer();
        //     },
        //     icon: const Icon(Icons.menu)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(2)),
            FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                var a = snapshot.data?.getString('globalSetting') ?? '{}';
                var b = jsonDecode(a);
                return Text('Resto ${b['namaresto']}');
              },
              // child: Text('Resto [NAME]')
            ),
            const Text(
              'Senin, 32 Januari 2023',
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoriStruk(),
                    ));
              },
              child: const Text('Histori Struk')),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AntrianPage(),
                    ));
              },
              child: const Text('Antrian Order (1)')),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminPanel(),
                    ));
              },
              child: const Text('Admin Panel'))
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Expanded(child: TopTab()),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(2)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<MenuBloc, MenuState>(
                          builder: (context, state) {
                            // if (state.menus.isEmpty) {
                            //   return const Center(child: Text('empty'));
                            // }
                            return Expanded(
                              child: GridView.count(
                                childAspectRatio: 0.98,
                                crossAxisCount: 4,
                                children: [
                                  for (var i = 0; i < state.datas.length; i++)
                                    MenuCard(
                                      onTap: ontap,
                                      menudata: state.datas[i],
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 24,
                        color: Colors.orange,
                        child: const Text('BottomBar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const StrukPanel()
        ],
      ),
    );
  }
}
