import 'package:android_id/android_id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:one_clock/one_clock.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/notif/notif_cubit.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import '../../repo/repo.dart';

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

  bool groupmenu = true;
  TextEditingController searchControl = TextEditingController();

  var searchNode = FocusNode(
    debugLabel: 'search node',
    onKeyEvent: (node, event) {
      debugPrint('search node');
      return KeyEventResult.handled;
    },
  );
  @override
  void initState() {
    if (!kIsWasm) {
      FirebaseMessaging.instance.getToken().then((token) async {
        debugPrint("en:$token");
        var androidId = await const AndroidId().getId();
        DeviceRepo(
          firestore: FirebaseFirestore.instance,
        ).updateToken((androidId ?? 'unknownid'), token!,
            await RepositoryProvider.of<KaryawanAuthRepo>(context).isAdmin());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        debugPrint('here');
        pageController.animateToPage(0,
            duration: Durations.medium4, curve: Curves.easeInOut);
      },
      child: BlocListener<UseStrukBloc, UseStrukState>(
        listenWhen: (p, c) => c.error == StrukError.success(),
        listener: (context, state) {
          debugPrint('here');
          if (mounted) {
            pageController.jumpToPage(0);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AntrianPage(
                    fromcheckout: true,
                  ),
                ));
            // Navigator.(context);
          }
        },
        child: Scaffold(
          drawer: UseDrawer(),
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.all(2)),
                FutureBuilder(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    // var a = snapshot.data?.getString('globalSetting') ?? '{}';
                    // var b = jsonDecode(a);
                    return Text('Koffie Coffeeshop');
                  },
                ),
                BlocBuilder<KaryawanauthBloc, KaryawanauthState>(
                  builder: (context, state) {
                    return Text(
                      '${DateTime.now().formatLengkap()} ${(state as KaryawanAuthenticated).user.namaKaryawan}',
                      style: TextStyle(fontSize: 10),
                    );
                  },
                ),
                // ElevatedButton(
                //     onPressed: () async {
                //       var a = await BackendApi.testHit();
                //       print(a.body);
                //     },
                //     child: Text('test'))
              ],
            ),
            actions: [
              DigitalClock(),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 24)),
              BlocBuilder<NotifCubit, NotifState>(
                builder: (context, state) {
                  if (state.notif.isEmpty) {
                    return SizedBox();
                  }
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
                      child: Text(
                          'Antrian Order (${state.antrianStruks.length})'));
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
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.msg.toString())));
                  BlocProvider.of<MenuBloc>(context).add(ClearMsg());
                }
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
                              Row(
                                children: [
                                  Expanded(flex: 4, child: TopTab()),
                                  Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                        // canRequestFocus: false,
                                        focusNode: searchNode,
                                        onTapOutside: (event) {
                                          FocusScope.of(context).unfocus();
                                          searchNode.unfocus();
                                        },
                                        onChanged: (value) {
                                          BlocProvider.of<MenuBloc>(context)
                                              .add(SearchQuery(query: value));
                                        },
                                        controller: searchControl,
                                        decoration: InputDecoration(
                                            // border: inputborder(),
                                            isDense: true,
                                            isCollapsed: true,
                                            contentPadding: EdgeInsets.all(0.0),
                                            suffix: IconButton(
                                                onPressed: () {
                                                  BlocProvider.of<MenuBloc>(
                                                          context)
                                                      .add(SearchQuery(
                                                          query: ''));

                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  searchNode.unfocus();
                                                  searchControl.clear();
                                                },
                                                icon: Icon(Icons.clear)),
                                            label: Text('Search')),
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          groupmenu = !groupmenu;
                                        });
                                      },
                                      icon: Icon(Icons.folder_copy))
                                ],
                              ),
                              // const Padding(padding: EdgeInsets.all(2)),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(top: BorderSide())),
                                  padding: const EdgeInsets.all(8.0),
                                  child: MenuList(
                                    newview: !groupmenu,
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

class MenuList extends StatelessWidget {
  final bool newview;
  const MenuList({super.key, this.newview = true});

  Widget newviewWidget(BuildContext context, MenuState state) {
    Map<String, List<MenuItems>> groupbyletter = {};

    for (var e in state.datas) {
      groupbyletter[e.title[0]] = (groupbyletter[e.title[0]] ?? []) + [e];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (String ez in groupbyletter.keys)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.center,
                                  colors: [
                                Colors.green.shade900,
                                Colors.transparent
                              ])),
                          child:
                              Text(ez, style: TextStyle(color: Colors.white)))),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        for (var i = 0; i < groupbyletter[ez]!.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.sizeOf(context).width / 6.1,
                            height: MediaQuery.sizeOf(context).height / 3,
                            child: MenuCard(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => ontapPreviewDialog(
                                        groupbyletter[ez]![i]));
                              },
                              menudata: groupbyletter[ez]![i],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget ontapPreviewDialog(MenuItems data) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            data.imgDir.contains('assets') || data.imgDir.isEmpty
                ? Image.asset(
                    data.imgDir.isEmpty ? 'assets/sate.jpg' : data.imgDir,
                    height: 80,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  )
                : Image(
                    image: CachedNetworkImageProvider(data.imgDir),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null);
                    },
                    height: 280,
                    fit: BoxFit.cover,
                  ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(data.title),
                Text(data.description ?? ''),
                Divider(),
                Text('Bahan'),
                for (var e in data.ingredientItems)
                  Text("~${e.title} ${e.count}${e.satuan}"),
                Divider(),
                Text('submenu'),
                for (var f in data.submenues) Text(f.title.toString()),
                Row(
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('Batal')),
                    ElevatedButton(onPressed: () {}, child: Text('Ok'))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          duration: Durations.medium4,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
                position:
                    Tween<Offset>(begin: Offset(-0.25, 0), end: Offset(0, 0))
                        .animate(animation),
                child: child),
          ),
          child: Container(
            key: Key(state.hashCode.toString()),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              key: Key(state.datas.toString()),
              child: newview
                  ? newviewWidget(context, state)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  for (var i = 0; i < state.datas.length; i++)
                                    SizedBox(
                                      // alignment: Alignment.centerLeft,
                                      width: MediaQuery.sizeOf(context).width /
                                          6.1,
                                      height:
                                          MediaQuery.sizeOf(context).height / 3,
                                      child: MenuCard(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  ontapPreviewDialog(
                                                      state.datas[i]));
                                        },
                                        menudata: state.datas[i],
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
