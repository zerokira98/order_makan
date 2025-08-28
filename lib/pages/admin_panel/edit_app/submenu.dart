import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/submenuitem_model.dart';
import 'package:order_makan/pages/admin_panel/edit_app/cubit/menuedit_cubit.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

class SubMenuInputRow extends StatefulWidget {
  final SubMenuItem submenu;
  const SubMenuInputRow(this.submenu, {super.key});

  @override
  State<SubMenuInputRow> createState() => _SubMenuInputRowState();
}

class _SubMenuInputRowState extends State<SubMenuInputRow> {
  TextEditingController title = TextEditingController();

  TextEditingController adjustHarga = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (widget.submenu.title != title.text) {
      title.text = widget.submenu.title;
    }
    if (widget.submenu.adjustHarga.toString() != adjustHarga.text) {
      adjustHarga.text = widget.submenu.adjustHarga.toString();
    }
    return Card.outlined(
      margin: EdgeInsets.all(4),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: title,
                          validator: usernameValidator,
                          onChanged: (value) {
                            BlocProvider.of<MenueditCubit>(context).editSubmenu(
                                data: widget.submenu.copyWith(title: value));
                          },
                          decoration:
                              InputDecoration(label: Text('Nama submenu')),
                        )),
                    Padding(padding: EdgeInsetsGeometry.all(2)),
                    Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: adjustHarga,
                          validator: numberValidator,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            BlocProvider.of<MenueditCubit>(context).editSubmenu(
                                data: widget.submenu.copyWith(
                                    adjustHarga: int.tryParse(value)));
                          },
                          decoration:
                              InputDecoration(label: Text('Adjust harga')),
                        )),
                  ],
                ),
                Divider(),
                Text('adjust ingredient'),
                BlocBuilder<MenueditCubit, MenueditState>(
                  buildWhen: (previous, current) =>
                      previous.submenu.firstWhere(
                        (element) => element.cardId == widget.submenu.cardId,
                        orElse: () {
                          return SubMenuItem.empty;
                        },
                      ).adjustIngredient !=
                      current.submenu
                          .firstWhere(
                            (element) =>
                                element.cardId == widget.submenu.cardId,
                            orElse: () => SubMenuItem.empty,
                          )
                          .adjustIngredient,
                  builder: (context, state) {
                    var adjustingredients = state.submenu
                        .firstWhere(
                          (element) => element.cardId == widget.submenu.cardId,
                        )
                        .adjustIngredient;
                    debugPrint(adjustingredients.toString());
                    return Column(
                      children: List<Widget>.generate(
                            adjustingredients.length,
                            (idx) => SubmenuIngredientInputRow(
                              key: Key(widget.submenu.cardId.toString() +
                                  adjustingredients[idx]
                                      .incrementindex
                                      .toString()),
                              data: adjustingredients[idx],
                              submenu: state.submenu.firstWhere(
                                (element) =>
                                    element.cardId == widget.submenu.cardId,
                              ),
                              title: TextEditingController(),
                              satuan: TextEditingController(),
                              count: TextEditingController(),
                            ),
                          ) +
                          [
                            IconButton(
                                onPressed: () {
                                  BlocProvider.of<MenueditCubit>(context)
                                      .addSubmenuIngredients(widget.submenu);
                                },
                                icon: Icon(Icons.add))
                          ],
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () {
                  BlocProvider.of<MenueditCubit>(context)
                      .removeSubmenu(cardId: widget.submenu.cardId);
                },
                icon: Icon(Icons.delete),
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}

class SubmenuIngredientInputRow extends StatelessWidget {
  final SubMenuItem submenu;
  final IngredientItem data;
  final TextEditingController title;
  final TextEditingController count;
  final TextEditingController satuan;
  const SubmenuIngredientInputRow(
      {super.key,
      required this.data,
      required this.submenu,
      required this.title,
      required this.satuan,
      required this.count});

  @override
  Widget build(BuildContext context) {
    if (data.title != title.text) {
      title.text = data.title;
      title.selection = TextSelection.collapsed(offset: data.title.length);
    }
    if (data.satuan != satuan.text) {
      satuan.text = data.satuan;
      satuan.selection = TextSelection.collapsed(offset: data.satuan.length);
    }
    if (data.count.toString() != count.text) {
      count.text = data.count.toString();
    }
    count.selection =
        TextSelection.collapsed(offset: data.count.toString().length);
    return Row(
      children: [
        Expanded(
          child: TypeAheadField(
            builder: (context, controller, focusNode) => TextFormField(
                controller: controller,
                focusNode: focusNode,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (data.id == null) {
                    return 'Please Select';
                  }
                  return usernameValidator(value);
                },
                onChanged: (value) {
                  BlocProvider.of<MenueditCubit>(context)
                      .editSubmenuIngredients(
                          submenu: submenu,
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
              BlocProvider.of<MenueditCubit>(context).editSubmenuIngredients(
                submenu: submenu,
                data: value.copyWith(
                    incrementindex: data.incrementindex, count: 0),
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
          ),
        ),
        Expanded(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.always,
            validator: numberValidator,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              BlocProvider.of<MenueditCubit>(context).editSubmenuIngredients(
                  submenu: submenu,
                  data: data.copyWith(count: int.tryParse(value) ?? 0));
            },
            controller: count,
            decoration: InputDecoration(label: Text('count')),
          ),
        ),
        Expanded(
            flex: 1,
            child: TextFormField(
              enabled: false,
              autovalidateMode: AutovalidateMode.always,
              // validator: (value) {
              //   if (int.tryParse(value ?? '') == null) return 'not number';
              // },
              onChanged: (value) {
                BlocProvider.of<MenueditCubit>(context).editSubmenuIngredients(
                    submenu: submenu, data: data.copyWith(satuan: (value)));
              },
              controller: satuan,
              decoration: InputDecoration(label: Text('satuan')),
            )),
        IconButton(
            onPressed: () {
              BlocProvider.of<MenueditCubit>(context)
                  .removeSubmenuIngredients(data: data, submenu: submenu);
            },
            icon: Icon(Icons.remove))
      ],
    );
  }
}
