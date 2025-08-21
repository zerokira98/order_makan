import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:one_clock/one_clock.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/notif/notif_cubit.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/component/menu_card.dart';
import 'package:order_makan/component/screen_lock.dart';
import 'package:order_makan/pages/admin_panel/pengeluaran/pengeluaranpage.dart';
import 'package:order_makan/pages/notif.dart';
import 'package:order_makan/pages/use_app/struk_panel/struk_panel.dart';
import 'package:order_makan/component/toptab.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/pages/admin_panel/adminpanel_main.dart';
import 'package:order_makan/pages/antrian/antrian_main.dart';
import 'package:order_makan/pages/historipenjualan/historipenjualan_harian.dart';
import 'package:order_makan/pages/use_app/checkout.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'use_drawer.dart';

class UseMain extends StatefulWidget {
  const UseMain({super.key});

  @override
  State<UseMain> createState() => _UseMainState();
}

class _UseMainState extends State<UseMain> {
  PageController pageController = PageController();
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'tag',
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         PageRouteBuilder(
      //             barrierDismissible: true,
      //             opaque: false,
      //             fullscreenDialog: true,
      //             pageBuilder: (BuildContext context, a1, a2) {
      //               return CustomOrderDialog(a1: a1);
      //             }));
      //   },
      //   child: Column(
      //     children: [Icon(Icons.add), Text("Custom")],
      //   ),
      // ),
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
                return Text('Kafe ${b['namaresto']}');
              },
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
          DigitalClock(),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
          BlocBuilder<NotifCubit, NotifState>(
            builder: (context, state) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          state.notif.isEmpty ? Colors.grey : Colors.red),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifCenter(),
                        ));
                  },
                  child: Text('!'));
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
          BlocBuilder<AntrianBloc, AntrianState>(
            builder: (context, state) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: state.antrianStruks.isEmpty
                          ? Colors.grey
                          : Colors.red),
                  onPressed: state.antrianStruks.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AntrianPage(),
                              ));
                        },
                  child: Text('Antrian Order (${state.antrianStruks.length})'));
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide())),
        child: BlocListener<MenuBloc, MenuState>(
          listenWhen: (previous, current) => current.msg != null,
          listener: (context, state) {
            if (state.msg != null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.msg.toString())));
              BlocProvider.of<MenuBloc>(context).add(ClearMsg());
            }
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => AntrianPage(),
            //     ));
          },
          child: PageView(
              scrollBehavior: ScrollBehavior()
                  .copyWith(physics: NeverScrollableScrollPhysics()),
              allowImplicitScrolling: false,
              controller: pageController,
              children: [
                Row(
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
                          // const Padding(padding: EdgeInsets.all(2)),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(top: BorderSide())),
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
                                            for (var i = 0;
                                                i < state.datas.length;
                                                i++)
                                              MenuCard(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        Dialog(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(18.0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(state.datas[i]
                                                                .title),
                                                            Text(state.datas[i]
                                                                    .description ??
                                                                ''),
                                                            Divider(),
                                                            Text('Bahan'),
                                                            for (var e in state
                                                                .datas[i]
                                                                .ingredientItems)
                                                              Text(
                                                                  "~${e.title} ${e.count}${e.satuan}"),
                                                            Divider(),
                                                            Text('submenu'),
                                                            for (var f in state
                                                                .datas[i]
                                                                .submenues)
                                                              Text(f.title
                                                                  .toString()),
                                                            Row(
                                                              children: [
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                        'Batal')),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: Text(
                                                                        'Ok'))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
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
                    StrukPanel(
                      pageController: pageController,
                    )
                  ],
                ),
                CheckoutDialog(
                  pageController: pageController,
                )
              ]),
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
  MenuItems? selected;
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
                //var menuitems? check null
                if (selected == null) {
                  debugPrint('clicked null selected');
                  RepositoryProvider.of<MenuItemRepository>(context)
                      .addMenu(
                          MenuItems(
                              title: details.text,
                              imgDir: '',
                              price: int.tryParse(price.text)),
                          customOrder: true)
                      .then(
                    (value) {
                      value.get().then(
                        (value2) {
                          if (value2.data() != null) {
                            BlocProvider.of<UseStrukBloc>(context).add(
                                AddOrderitems(
                                    item: StrukItem.fromMenuItems(
                                        value2.data()!)));
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  );
                } else {
                  BlocProvider.of<UseStrukBloc>(context).add(
                      AddOrderitems(item: StrukItem.fromMenuItems(selected!)));
                  Navigator.pop(context);
                }
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
                controller: details,
                builder: (context, controller, focusNode) => TextFormField(
                  controller: controller,
                  onChanged: (value) {
                    setState(() {
                      selected = null;
                    });
                  },
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
                  selected = value;
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
              TextField(
                controller: price,
                onChanged: (value) {
                  setState(() {
                    selected = null;
                  });
                },
                decoration: InputDecoration(label: Text('Price')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
