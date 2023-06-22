// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:order_makan/bloc/topbarbloc/topbar_bloc.dart';

class TopTab extends StatefulWidget {
  final bool edit;
  const TopTab({super.key, bool? edit}) : edit = edit ?? false;

  @override
  State<TopTab> createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> {
  int currentSelection = 0;
  // List data = ['Meal', 'Cold Drink', 'Hot Drink', 'Snacks', 'Extra'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          // color: Theme.of(context).appBarTheme.backgroundColor,
          // boxShadow: [BoxShadow(blurRadius: 4, offset: Offset(-4, 0))],
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<TopbarBloc, TopbarState>(
              // future: RepositoryProvider.of<MenuItemRepository>(context)
              //     .getCategories(),
              builder: (context, state) {
            if (state.categories.isEmpty) {
              return widget.edit ? AddCategoryButton() : const Text('EMPTY');
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(
                    state.categories.length + 2,
                    (index) => index < state.categories.length + 1
                        ? index == 0
                            ? const TopBarMenuItem(nama: '[ALL]')
                            : TopBarMenuItem(nama: state.categories[index - 1])
                        : widget.edit
                            ? AddCategoryButton()
                            : const SizedBox()),
              ),
            );
          }),
          if (widget.edit)
            Container(
              width: double.maxFinite,
              color: Colors.yellow.shade900,
              child: const Text('Hint: longpress to delete category'),
            )
        ],
      ),
    );
  }
}

class AddCategoryButton extends StatelessWidget {
  final TextEditingController catControl = TextEditingController();
  AddCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        label: const Text('Add Category'),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Row(
                      children: [
                        const Text('Add Category'),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(4),
                        )),
                        ElevatedButton(
                            onPressed: () async {
                              if (catControl.text.length > 2) {
                                BlocProvider.of<TopbarBloc>(context)
                                    .add(AddCat(name: catControl.text));
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Submit'))
                      ],
                    ),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: catControl,
                        decoration:
                            const InputDecoration(label: Text('Category Name')),
                      ),
                      // child: Text('TextField'),
                    ),
                  ));
        },
        icon: const Icon(Icons.add_circle_outline));
  }
}

NumberFormat numfor = NumberFormat("###,###", 'ID_id');

extension Uppercasing on String {
  String firstUpcase() {
    String a = this[0].toUpperCase() + substring(1);

    return a;
  }

  String numberFormat() {
    int? a = int.tryParse(this);
    if (a != null) {
      return numfor.format(a);
    } else {
      throw Exception('cant parse to int');
    }
    // return this.
  }
  // ···
}

class TopBarMenuItem extends StatelessWidget {
  final String nama;
  const TopBarMenuItem({super.key, required this.nama});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<TopbarBloc, TopbarState>(
        buildWhen: (previous, current) => previous.selected != current.selected,
        builder: (context, state) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            color: state.selected == nama
                ? Theme.of(context).highlightColor
                : Colors.transparent,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            // padding: EdgeInsets.all(8),
            child: InkWell(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Alert'),
                    content:
                        const Text('Are you sure to delete this category?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<TopbarBloc>(context)
                                .add(DelCat(name: nama));
                            Navigator.pop(context);
                            // var a = await RepositoryProvider.of<MenuItemRepository>(
                            //         context)
                            //     .deleteCategory(nama);
                            // // print(a);
                            // if (a < 1) {
                            //   print('No record deleted');
                            // } else {
                            //   print('affected records:$a');
                            //   Navigator.pop(context);
                            // }
                          },
                          child: const Text('Confirm'))
                    ],
                  ),
                );
              },
              onTap: () {
                BlocProvider.of<TopbarBloc>(context)
                    .add(ChangeSelection(name: nama));
                // if (currentSelection == index) return;
                // setState(() {
                //   currentSelection = index;
                // });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  nama.firstUpcase(),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
