import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';
import 'package:order_makan/bloc/menu/menu_bloc.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart' as t;
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/menuitems_model.dart';
import 'package:order_makan/pages/admin_panel/edit_app/cubit/menuedit_cubit.dart';
import 'package:order_makan/pages/admin_panel/edit_app/submenu.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                ElevatedButton(onPressed: () {}, child: Text('Cancel')),
                ElevatedButton(onPressed: () {}, child: Text('Close')),
              ],
            );
          },
        );
        // BlocProvider.of<MenueditCubit>(context).clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.editmode ? 'Edit Menu' : 'Tambah Menu'),
          actions: [
            BlocBuilder<MenueditCubit, MenueditState>(
              builder: (context, state) {
                // debugPrint(state);
                return ElevatedButton(
                    onPressed: () {
                      if ((formkey.currentState?.validate() ?? false) ==
                          false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('There\'s invalid data')));
                      }
                      if (formkey.currentState?.validate() ?? false) {
                        int? hargaInt = int.tryParse(hargaC.text);
                        if (namaMenuC.text.length > 3 && hargaInt != null) {
                          var ingredients = state.ingredients;
                          if (ingredients.any(
                            (element) => element.id == null,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Nama bahanbaku jangan di-edit setelah memilih')));
                            throw Exception('Nama bahanbaku jangan diedit');
                          }
                          var menuitem = MenuItems(
                            submenues: state.submenu,
                            ingredientItems: ingredients,
                            title: namaMenuC.text,
                            description: deskripsi.text,
                            imgDir: imgdir,
                            price: hargaInt,
                            categories: category,
                          );

                          if (widget.editmode) {
                            if (!kIsWeb) {
                              if (imgdir.isNotEmpty) {
                                var pickedfile = File(imgdir);
                                getApplicationDocumentsDirectory()
                                    .then((value) {
                                  var copytodir = File(p.join(value.path,
                                      'imgres/${p.basename(imgdir)}'));
                                  debugPrint(copytodir.path);
                                  copytodir
                                      .create(recursive: true)
                                      .then((value) {
                                    value.writeAsBytesSync(
                                        pickedfile.readAsBytesSync());
                                  });
                                });
                              }
                            } else if (kIsWasm) {}
                            BlocProvider.of<MenuBloc>(context).add(EditMenu(
                                menuitem.copywith(id: widget.menudata!.id)));
                            BlocProvider.of<t.TopbarBloc>(context)
                                .add(t.Init());
                            Navigator.pop(context);
                          } else {
                            BlocProvider.of<MenuBloc>(context)
                                .add(AddMenu(menuitem));
                            BlocProvider.of<t.TopbarBloc>(context)
                                .add(t.Init());
                            Navigator.pop(context);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    child: Text(widget.editmode ? 'Save' : 'Submit'));
              },
            ),
            Padding(padding: EdgeInsetsGeometry.all(8)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: Text('Cancel'))
          ],
        ),
        // insetPadding: EdgeInsets.all(0),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 16)),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  )),
                ],
              ),
              Expanded(
                child: BlocBuilder<MenueditCubit, MenueditState>(
                  builder: (context, state) {
                    return Form(
                      key: formkey,
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Padding(padding: EdgeInsets.all(4)),
                              SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: namaMenuC,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: usernameValidator,
                                    decoration: const InputDecoration(
                                        label: Text('Nama menu')),
                                  )),
                              const Padding(padding: EdgeInsets.all(4)),
                              SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: hargaC,
                                    validator: numberValidator,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        label: Text('Harga')),
                                  )),
                              const Padding(padding: EdgeInsets.all(4)),
                              Expanded(
                                child: (imgdir.isEmpty)
                                    ? ElevatedButton.icon(
                                        onPressed: () async {
                                          var a = await ImagePicker().pickImage(
                                              source: ImageSource.gallery);
                                          if (a != null) {
                                            setState(() {
                                              imgdir = a.path;
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.camera_alt_outlined),
                                        label: const Text('Gambar'))
                                    : SizedBox(
                                        height: 110,
                                        child: InkWell(
                                          onTap: () async {
                                            var a = await ImagePicker()
                                                .pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (a != null) {
                                              setState(() {
                                                imgdir = a.path;
                                              });
                                            }
                                          },
                                          child: (!kIsWasm || !kIsWeb)
                                              ? const Icon(
                                                  Icons.camera_alt_outlined)
                                              : imgdir.contains('assets')
                                                  ? Image.asset(imgdir)
                                                  : Image.file(File(imgdir)),
                                        ),
                                      ),
                              ),

                              // Text('imgField: img'),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: deskripsi,
                                  decoration:
                                      InputDecoration(label: Text('Deskripsi')),
                                ),
                              )),
                              Text(
                                'Tag :',
                                style: TextStyle(fontSize: 12),
                              ),
                              Expanded(
                                child: FutureBuilder(
                                    future: RepositoryProvider.of<
                                            MenuItemRepository>(context)
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0),
                                                      child: Chip(
                                                          onDeleted: () {
                                                            setState(() {
                                                              category.remove(
                                                                  category[
                                                                      index]);
                                                            });
                                                          },
                                                          labelPadding:
                                                              EdgeInsets.zero,
                                                          label: Text(
                                                            category[index]
                                                                .firstUpcase,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          )),
                                                    )
                                                  : PopupMenuButton(
                                                      onSelected: (value) {
                                                        setState(() {
                                                          category.contains(
                                                                  value)
                                                              ? null
                                                              : category
                                                                  .add(value);
                                                        });
                                                      },
                                                      itemBuilder: (context) =>
                                                          List.generate(
                                                              snapshot
                                                                  .data!.length,
                                                              (i) => PopupMenuItem(
                                                                  value: snapshot
                                                                      .data![i],
                                                                  child: Text(
                                                                      snapshot
                                                                          .data![
                                                                              i]
                                                                          .firstUpcase))),
                                                      child: const Chip(
                                                          labelPadding:
                                                              EdgeInsets.zero,
                                                          label: Text('+')),
                                                    )));
                                    }),
                              ),
                            ],
                          ),
                          Divider(),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Ingredients'),
                                      Expanded(
                                          flex: 1,
                                          child: ListView.builder(
                                            itemCount:
                                                state.ingredients.length + 1,
                                            itemBuilder: (context, index) =>
                                                index < state.ingredients.length
                                                    ? Row(
                                                        children: [
                                                          Text((index + 1)
                                                                  .toString() +
                                                              '.'),
                                                          Expanded(
                                                            child:
                                                                IngredientInputRow(
                                                              key: Key(state
                                                                  .ingredients[
                                                                      index]
                                                                  .incrementindex
                                                                  .toString()),
                                                              data: state
                                                                      .ingredients[
                                                                  index],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child:
                                                            IconButton.filled(
                                                                onPressed: () {
                                                                  BlocProvider.of<
                                                                              MenueditCubit>(
                                                                          context)
                                                                      .addIngredients();
                                                                },
                                                                icon: Icon(
                                                                    Icons.add)),
                                                      ),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: VerticalDivider(
                                    width: 2,
                                    thickness: 2,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text('Submenu (${state.submenu.length})'),
                                      Expanded(
                                          flex: 1,
                                          child: ListView.builder(
                                            itemCount: state.submenu.length + 1,
                                            itemBuilder: (context, index) =>
                                                index < state.submenu.length
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Text(
                                                                  '${index + 1}.'),
                                                            ),
                                                            Expanded(
                                                              child: SubMenuInputRow(
                                                                  state.submenu[
                                                                      index],
                                                                  key: Key(state
                                                                      .submenu[
                                                                          index]
                                                                      .cardId
                                                                      .toString())),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child:
                                                            IconButton.filled(
                                                                onPressed: () {
                                                                  BlocProvider.of<
                                                                              MenueditCubit>(
                                                                          context)
                                                                      .addSubmenu();
                                                                },
                                                                icon: Icon(
                                                                    Icons.add)),
                                                      ),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientInputRow extends StatefulWidget {
  final IngredientItem data;
  const IngredientInputRow({
    super.key,
    required this.data,
  });

  @override
  State<IngredientInputRow> createState() => _IngredientInputRowState();
}

class _IngredientInputRowState extends State<IngredientInputRow> {
  TextEditingController title = TextEditingController();
  TextEditingController satuan = TextEditingController();
  TextEditingController count = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.title != title.text) {
      title.text = widget.data.title;
    }
    if (widget.data.satuan != satuan.text) {
      satuan.text = widget.data.satuan;
    }
    if (widget.data.count.toString() != count.text) {
      count.text = widget.data.count.toString();
    }
    return Row(
      // key: GlobalKey(),
      children: [
        // Text(widget.data.incrementindex.toString() + '.'),
        Padding(padding: EdgeInsetsGeometry.all(4)),
        Expanded(flex: 4, child: _NamaInput(data: widget.data, title: title)),
        Padding(padding: EdgeInsetsGeometry.all(8)),
        Expanded(flex: 2, child: _CountInput(data: widget.data, count: count)),
        Padding(padding: EdgeInsetsGeometry.all(8)),
        Expanded(
            flex: 1,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              enabled: false,
              // validator: (value) {
              //   if (int.tryParse(value ?? '') == null) return 'not number';
              // },
              onChanged: (value) {
                BlocProvider.of<MenueditCubit>(context).editIngredients(
                    data: widget.data.copyWith(satuan: (value)));
              },
              controller: satuan,
              decoration: InputDecoration(label: Text('satuan')),
            )),
        IconButton(
            onPressed: () {
              BlocProvider.of<MenueditCubit>(context)
                  .removeIngredient(item: widget.data);
            },
            icon: Icon(Icons.remove))
      ],
    );
  }
}

class _NamaInput extends StatelessWidget {
  final IngredientItem data;
  final TextEditingController title;
  const _NamaInput({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      builder: (context, controller, focusNode) => TextFormField(
          controller: controller,
          focusNode: focusNode,
          autovalidateMode: AutovalidateMode.always,
          validator: (value) {
            if (data.id == null) {
              return 'Please select';
            }
            return usernameValidator(value);
          },
          onChanged: (value) {
            BlocProvider.of<MenueditCubit>(context).editIngredients(
                data: data.copyWith(title: value, id: () => null));
          },
          decoration: InputDecoration(
            label: Text('Select Ingredient'),
          )),
      itemBuilder: (context, value) {
        return ListTile(
          title: Text(value.title),
        );
      },
      onSelected: (value) {
        title.text = value.title;
        BlocProvider.of<MenueditCubit>(context).editIngredients(
          data: value.copyWith(
            incrementindex: data.incrementindex,
            count: 0,
            id: () => value.id,
          ),
        );
      },
      suggestionsCallback: (search) async {
        var a = await RepositoryProvider.of<MenuItemRepository>(context)
            .getIngredients()
            .then(
              (value) => value
                  .where(
                    (element) => (element.title).contains(search),
                  )
                  .toList(),
            );
        return a;
      },
      controller: title,
    );
  }
}

class _CountInput extends StatelessWidget {
  final IngredientItem data;
  final TextEditingController count;
  const _CountInput({super.key, required this.data, required this.count});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      validator: numberValidator,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        BlocProvider.of<MenueditCubit>(context).editIngredients(
            data: data.copyWith(count: int.tryParse(value) ?? 0));
      },
      controller: count,
      decoration: InputDecoration(label: Text('count')),
    );
  }
}
