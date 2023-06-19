import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:order_makan/use_app/bloc/struk/struk_bloc.dart';
import 'package:order_makan/use_app/component/toptab.dart';

import '../bloc/menuitem/menuitems_model.dart';

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
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Delete this menu?'),
                      SizedBox(
                        height: 170,
                        child: Stack(
                          children: [
                            MenuCard(
                              onTap: () {},
                              menudata: menudata,
                            ),
                            Positioned.fill(
                              child: Container(
                                color: Colors.green.withOpacity(0.1),
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<MenuBloc>(context)
                                .add(DelMenu(menu: menudata));
                          },
                          child: const Text('Confirm'))
                    ],
                  ),
                ),
              );
            },
          );
          editmode
              ? () => BlocProvider.of<MenuBloc>(context)
                  .add(DelMenu(menu: menudata))
              : null;
        },
        onTap: editmode
            ? () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        TambahmenuDialog(editmode: true, menudata: menudata));
              }
            : () => BlocProvider.of<StrukBloc>(context)
                .add(AddOrderitems(item: menudata)),
        child: Container(
          width: 115,
          // margin: EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8),
          //   color: Color.fromARGB(255, 151, 163, 168),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black,
          //     )
          //   ],
          // ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: Text(
                        menudata.title.firstUpcase(),
                        // textScaleFactor: 1.2,
                        style: const TextStyle(fontSize: 14, height: 1.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 95,
                  // width: 95,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    'assets/sate.jpg',
                    fit: BoxFit.cover,
                  ),
                  // child: Center(child: Text('menu image')),
                ),
              ),
              Text('Rp.${menudata.price}')
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
          showDialog(
              context: context, builder: (context) => const TambahmenuDialog());
        },
        // onTap: () => BlocProvider.of<StrukBloc>(context)
        //     .add(AddOrderitems(item: menudata)),
        child: Container(
          width: 115,
          // margin: EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              const Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: Text(
                        'Tambah menu',
                        // textScaleFactor: 1.2,
                        style: TextStyle(fontSize: 14, height: 1.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
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
  String imgdir = '';
  late TextEditingController hargaC;
  List<String> category = [];
  @override
  void initState() {
    widget.editmode ? category.addAll(widget.menudata!.categories) : null;

    namaMenuC = TextEditingController(
        text: widget.editmode ? widget.menudata!.title : '');
    hargaC = TextEditingController(
        text: widget.editmode ? widget.menudata!.price.toString() : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                style: TextStyle(fontSize: 14),
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
                                          category[index].firstUpcase(),
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
                                            child: Text(snapshot.data![i]
                                                .firstUpcase()))),
                                    child: const Chip(
                                        labelPadding: EdgeInsets.zero,
                                        label: Text('+')),
                                  )));
                  }),
            ],
          )),
          ElevatedButton(
              onPressed: () async {
                int? hargaInt = int.tryParse(hargaC.text);
                if (namaMenuC.text.length > 3 && hargaInt != null) {
                  var menuitem = MenuItems(
                    title: namaMenuC.text,
                    imgDir: imgdir,
                    price: hargaInt,
                    categories: category,
                  );
                  if (widget.editmode) {
                  } else {
                    BlocProvider.of<MenuBloc>(context).add(AddMenu(menuitem));
                  }
                }
              },
              child: Text(widget.editmode ? 'Save' : 'Submit'))
        ],
      ),
      content: Row(
        children: [
          // Text('TextField: title'),
          // Text('TextField: harga'),
          const Padding(padding: EdgeInsets.all(4)),
          SizedBox(
              width: 250,
              child: TextField(
                controller: namaMenuC,
                decoration: const InputDecoration(label: Text('Nama menu')),
              )),
          const Padding(padding: EdgeInsets.all(4)),
          SizedBox(
              width: 250,
              child: TextField(
                controller: hargaC,
                decoration: const InputDecoration(label: Text('Harga')),
              )),
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
                  height: 120,
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
                      child: Image.file(File(imgdir))),
                ),

          // Text('imgField: img'),
        ],
      ),
    );
  }
}
