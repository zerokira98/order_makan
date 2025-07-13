import 'dart:io';
import 'package:flutter/foundation.dart' hide kIsWasm;
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/edit_app/cubit/menuedit_cubit.dart';
import 'package:order_makan/pages/admin_panel/edit_app/tambahedit_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/strukitem_model.dart';

class MenuCard extends StatelessWidget {
  final Function() onTap;
  final bool editmode;
  final MenuItems menudata;
  const MenuCard(
      {super.key, required this.onTap, required this.menudata, bool? editmode})
      : editmode = editmode ?? false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onLongPress: () {
          if (editmode) {
            showDialog(
              context: context,
              builder: (context) {
                return DeleteMenuDialog(
                  menudata: menudata,
                );
              },
            );
          } else {
            onTap();
          }
        },
        onTap: editmode
            ? () {
                showDialog(
                    context: context,
                    builder: (context) {
                      BlocProvider.of<MenueditCubit>(context).initiate(
                          MenueditState.initial().copyWith(
                              ingredients: menudata.ingredientItems,
                              submenu: menudata.submenues));
                      return TambahmenuDialog(
                          editmode: true, menudata: menudata);
                    });
              }
            : () {
                debugPrint(menudata.ingredientItems.toString());
                BlocProvider.of<UseStrukBloc>(context).add(
                    AddOrderitems(item: StrukItem.fromMenuItems(menudata)));
              },
        child: Container(
          // width: 12,
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: Text(
                        menudata.title.firstUpcase,
                        // textScaler: TextScaler.linear( 1.2,
                        style: const TextStyle(fontSize: 14, height: 1.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                      // height: 94,
                      // width: 95,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: menudata.imgDir.contains('assets') ||
                              menudata.imgDir.isEmpty
                          ? Image.asset(
                              menudata.imgDir.isEmpty
                                  ? 'assets/sate.jpg'
                                  : menudata.imgDir,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : (!kIsWeb)
                              ? Image.file(
                                  File(
                                    menudata.imgDir,
                                  ),
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/sate.jpg',
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                      // child: Center(child: Text('menu image')),
                      ),
                ),
              ),
              // Padding(padding: EdgeInsetsGeometry.all(2)),
              Text('Rp  ${menudata.price.toString().numberFormat()}')
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyMenuCard extends StatefulWidget {
  const EmptyMenuCard({super.key});

  @override
  State<EmptyMenuCard> createState() => _EmptyMenuCardState();
}

class _EmptyMenuCardState extends State<EmptyMenuCard> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          var ao = BlocProvider.of<TopbarBloc>(context).state.selected;

          showDialog(
              context: context,
              builder: (context) => TambahmenuDialog(
                    menudata:
                        MenuItems(title: '', imgDir: '', categories: [ao]),
                  ));
        },
        // onTap: () => BlocProvider.of<StrukBloc>(context)
        //     .add(AddOrderitems(item: menudata)),
        child: Container(
          width: 115,
          // margin: EdgeInsets.all(4),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: Text(
                        'Tambah menu',
                        // textScaler: TextScaler.linear( 1.2,
                        style: TextStyle(fontSize: 14, height: 1.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    height: 95,
                    // width: 95,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 48,
                        color: Colors.white54,
                      ),
                    ),
                    // child: Image.asset(
                    //   'assets/sate.jpg',
                    //   fit: BoxFit.cover,
                    // ),
                    // child: Center(child: Text('menu image')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteMenuDialog extends StatelessWidget {
  final MenuItems menudata;
  const DeleteMenuDialog({super.key, required this.menudata});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listenWhen: (previous, current) =>
          previous.datas.length != current.datas.length,
      listener: (context, state) {
        Navigator.pop(context);
      },
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Delete this menu?'),
                  Text('Categories : ${menudata.categories}')
                ],
              ),
              SizedBox(
                height: 170,
                width: 240,
                child: Stack(
                  children: [
                    MenuCard(
                      onTap: () {},
                      menudata: menudata,
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.green.withValues(alpha: 0.1),
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<MenuBloc>(context)
                            .add(DelMenu(menu: menudata));
                      },
                      child: const Text('Confirm')),
                  Padding(padding: EdgeInsetsGeometry.all(12)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
