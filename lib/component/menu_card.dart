import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide kIsWasm;
import 'package:order_makan/helper.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart' as t;
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:path_provider/path_provider.dart';

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
          } else {}
        },
        onTap: editmode
            ? () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        TambahmenuDialog(editmode: true, menudata: menudata));
              }
            : () => BlocProvider.of<UseStrukBloc>(context)
                .add(AddOrderitems(item: StrukItem.fromMenuItems(menudata))),
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

class TambahmenuDialog extends StatefulWidget {
  final bool editmode;
  final MenuItems? menudata;
  const TambahmenuDialog({super.key, bool? editmode, this.menudata})
      : editmode = editmode ?? false;

  @override
  State<TambahmenuDialog> createState() => _TambahmenuDialogState();
}

class _TambahmenuDialogState extends State<TambahmenuDialog> {
  late TextEditingController namaMenuC;
  late TextEditingController deskripsi;
  String imgdir = '';
  late TextEditingController hargaC;
  List<String> category = [];
  @override
  void initState() {
    if (widget.editmode) {
      category.addAll(widget.menudata!.categories);
    } else if (widget.menudata!.categories.isNotEmpty) {
      category = widget.menudata!.categories;
    }

    namaMenuC = TextEditingController(
        text: widget.editmode ? widget.menudata!.title : '');
    deskripsi = TextEditingController(
        text: widget.editmode ? widget.menudata!.description : '');
    hargaC = TextEditingController(
        text: widget.editmode ? widget.menudata!.price.toString() : '');
    imgdir = widget.editmode ? widget.menudata!.imgDir : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      title: Row(
        children: [
          Text(widget.editmode ? 'Edit Menu' : 'Tambah Menu'),
          const Padding(padding: EdgeInsets.only(left: 16)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tag :',
                style: TextStyle(fontSize: 12),
              ),
              FutureBuilder(
                  future: RepositoryProvider.of<MenuItemRepository>(context)
                      .getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Text('Empty:null');
                    }
                    return Wrap(
                        children: List.generate(
                            category.length + 1,
                            (index) => index < category.length
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Chip(
                                        onDeleted: () {
                                          setState(() {
                                            category.remove(category[index]);
                                          });
                                        },
                                        labelPadding: EdgeInsets.zero,
                                        label: Text(
                                          category[index].firstUpcase,
                                          style: const TextStyle(fontSize: 12),
                                        )),
                                  )
                                : PopupMenuButton(
                                    onSelected: (value) {
                                      setState(() {
                                        category.contains(value)
                                            ? null
                                            : category.add(value);
                                      });
                                    },
                                    itemBuilder: (context) => List.generate(
                                        snapshot.data!.length,
                                        (i) => PopupMenuItem(
                                            value: snapshot.data![i],
                                            child: Text(snapshot
                                                .data![i].firstUpcase))),
                                    child: const Chip(
                                        labelPadding: EdgeInsets.zero,
                                        label: Text('+')),
                                  )));
                  }),
            ],
          )),
          ElevatedButton(
              onPressed: () {
                int? hargaInt = int.tryParse(hargaC.text);
                if (namaMenuC.text.length > 3 && hargaInt != null) {
                  var menuitem = MenuItems(
                    title: namaMenuC.text,
                    description: deskripsi.text,
                    imgDir: imgdir,
                    price: hargaInt,
                    categories: category,
                  );
                  if (widget.editmode) {
                    if (Platform.isAndroid) {
                      var pickedfile = File(imgdir);
                      getApplicationDocumentsDirectory().then((value) {
                        var copytodir = File(
                            p.join(value.path, 'imgres/${p.basename(imgdir)}'));
                        print(copytodir.path);
                        copytodir.create(recursive: true).then((value) {
                          value.writeAsBytesSync(pickedfile.readAsBytesSync());
                        });
                      });
                    } else if (kIsWasm) {}
                    BlocProvider.of<MenuBloc>(context).add(
                        EditMenu(menuitem.copywith(id: widget.menudata!.id)));
                    Navigator.pop(context);
                    BlocProvider.of<t.TopbarBloc>(context).add(t.Init());
                  } else {
                    BlocProvider.of<MenuBloc>(context).add(AddMenu(menuitem));
                    BlocProvider.of<t.TopbarBloc>(context).add(t.Init());
                    Navigator.pop(context);
                  }
                }
              },
              child: Text(widget.editmode ? 'Save' : 'Submit'))
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(4)),
                SizedBox(
                    width: 250,
                    child: TextField(
                      controller: namaMenuC,
                      decoration:
                          const InputDecoration(label: Text('Nama menu')),
                    )),
                const Padding(padding: EdgeInsets.all(4)),
                SizedBox(
                    width: 250,
                    child: TextField(
                      controller: hargaC,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(label: Text('Harga')),
                    )),
                const Padding(padding: EdgeInsets.all(4)),
                (imgdir.isEmpty)
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          var a = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (a != null) {
                            setState(() {
                              imgdir = a.path;
                            });
                          }
                        },
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Gambar'))
                    : SizedBox(
                        height: 110,
                        child: InkWell(
                          onTap: () async {
                            var a = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (a != null) {
                              setState(() {
                                imgdir = a.path;
                              });
                            }
                          },
                          child: imgdir.contains('assets')
                              ? Image.asset(imgdir)
                              : Image.file(File(imgdir)),
                        ),
                      ),

                // Text('imgField: img'),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: deskripsi,
                  decoration: InputDecoration(label: Text('Deskripsi')),
                ))
              ],
            )
          ],
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
                  Text('Categories : ' + menudata.categories.toString())
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
