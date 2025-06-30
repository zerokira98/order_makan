import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/component/menu_card.dart';
import 'package:order_makan/component/screen_lock.dart';
import 'package:order_makan/component/struk_panel.dart';
import 'package:order_makan/component/toptab.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/pages/admin_panel/adminpanel_main.dart';
import 'package:order_makan/pages/antrian/antrian_main.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/pages/historipenjualan/historipenjualan_harian.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'use_drawer.dart';

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
      drawer: UseDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'tag',
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  barrierDismissible: true,
                  opaque: false,
                  fullscreenDialog: true,
                  pageBuilder: (BuildContext context, a1, a2) {
                    return CustomOrderDialog(a1: a1);
                  }));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
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
            BlocBuilder<KaryawanauthBloc, KaryawanauthState>(
              builder: (context, state) {
                return Text(
                  'Senin, 32 Januari 2023 ${(state as KaryawanAuthenticated).user.namaKaryawan}',
                  style: TextStyle(fontSize: 10),
                );
              },
            )
          ],
        ),
        actions: [
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
          ElevatedButton(onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AntrianPage(),
                ));
          }, child: BlocBuilder<AntrianBloc, AntrianState>(
            builder: (context, state) {
              return Text('Antrian Order (${state.antrianStruks.length})');
            },
          )),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
        ],
      ),
      body: BlocListener<MenuBloc, MenuState>(
        listenWhen: (previous, current) => current.msg != null,
        listener: (context, state) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AntrianPage(),
              ));
        },
        child: Row(
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
                ],
              ),
            ),
            const StrukPanel()
          ],
        ),
      ),
    );
  }
}

class CustomOrderDialog extends StatefulWidget {
  final Animation<double> a1;
  const CustomOrderDialog({super.key, required this.a1});

  @override
  State<CustomOrderDialog> createState() => _CustomOrderDialogState();
}

class _CustomOrderDialogState extends State<CustomOrderDialog> {
  TextEditingController details = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.a1,
      child: AlertDialog(
        insetPadding: EdgeInsets.all(0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Custom order"),
            ElevatedButton(
              onPressed: () {
                print('clicked');
                //var menuitems? check null
                RepositoryProvider.of<MenuItemRepository>(context).addMenu(
                    MenuItems(
                        title: details.text,
                        imgDir: '',
                        price: int.tryParse(price.text)));
                //end check
                RepositoryProvider.of<MenuItemRepository>(context)
                    .getAllMenus(customOrder: true);

                Navigator.pop(context);
              },
              child: Hero(
                tag: "tag",
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TypeAheadField(
                builder: (context, controller, focusNode) => TextFormField(
                  controller: controller,
                  onChanged: (value) {},
                  focusNode: focusNode,
                  decoration: InputDecoration(label: Text('Details')),
                ),
                // decorationBuilder: (context, child) => ,
                itemBuilder: (context, value) {
                  return ListTile(
                    title: Text(value.title),
                    subtitle: Text(value.price.numberFormat(currency: true)),
                  );
                },
                onSelected: (value) {
                  details.text = value.title;
                  price.text = value.price.toString();
                },
                hideOnEmpty: true,
                suggestionsCallback: (search) async {
                  var data =
                      await RepositoryProvider.of<MenuItemRepository>(context)
                          .getAllMenus(customOrder: true);
                  return data;
                },
              ),
              // TextField(
              //   decoration:
              //       InputDecoration(label: Text('Details')),
              // ),
              TextField(
                controller: price,
                decoration: InputDecoration(label: Text('Cost')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
