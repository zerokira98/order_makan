import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/ingredient_model.dart';
import 'package:order_makan/model/inputstock_model.dart';
import 'package:order_makan/pages/admin_panel/cubit/inputbeliform_cubit.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

class InputBeliBahanbaku extends StatelessWidget {
  const InputBeliBahanbaku({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembelian Bahanbaku'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text('List Bahanbaku'),
                Expanded(
                  child: FutureBuilder(
                    future: RepositoryProvider.of<MenuItemRepository>(context)
                        .getIngredients(),
                    builder: (context, snapshot) {
                      print(snapshot.data?.docs);
                      if (snapshot.data == null ||
                          (snapshot.data?.docs.isEmpty ?? false))
                        return Center(
                          child: Text('Empty'),
                        );
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => ListTile(
                            title: Text(
                                snapshot.data!.docs[index].data().toString())),
                      );
                    },
                  ),
                ),
                Text('List Pembelian Bahanbaku'),
                Expanded(
                  child: FutureBuilder(
                    future: RepositoryProvider.of<MenuItemRepository>(context)
                        .getInputstocks(),
                    builder: (context, snapshot) {
                      print(snapshot.data?.docs);
                      if (snapshot.data == null ||
                          (snapshot.data?.docs.isEmpty ?? false))
                        return Center(
                          child: Text('Empty'),
                        );
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => ListTile(
                            title: Text(
                                snapshot.data!.docs[index].data().toString())),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: InputBahanbakuField(
                BlocProvider.of<InputbeliformCubit>(context).state),
          ),
        ],
      ),
    );
  }
}

class InputBahanbakuField extends StatelessWidget {
  final TextEditingController ingredient;
  final TextEditingController nama;
  final TextEditingController count;
  final TextEditingController harga;
  final TextEditingController tempatbeli;
  final GlobalKey<FormState> _formKey = GlobalKey();
  InputBahanbakuField(
    InputbeliformState state, {
    super.key,
  })  : ingredient = TextEditingController(text: state.ingredientItem.title),
        nama = TextEditingController(text: state.nama),
        count = TextEditingController(text: state.count.toString()),
        harga = TextEditingController(text: state.harga.toString()),
        tempatbeli = TextEditingController(text: state.tempatbeli);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocListener<InputbeliformCubit, InputbeliformState>(
          listener: (context, state) {
            if (nama.text != state.nama) {
              nama.text = state.nama;
              nama.selection =
                  TextSelection.collapsed(offset: state.nama.length);
            }
            if (count.text != state.count.toString()) {
              count.text = state.count.toString();
              count.selection = TextSelection.collapsed(
                  offset: state.count.toString().length);
            }
            if (harga.text != state.harga.toString()) {
              harga.text = state.harga.toString();
              harga.selection = TextSelection.collapsed(
                  offset: state.harga.toString().length);
            }
            if (tempatbeli.text != state.tempatbeli) {
              tempatbeli.text = state.tempatbeli;
              tempatbeli.selection =
                  TextSelection.collapsed(offset: state.tempatbeli.length);
            }
            if (ingredient.text != state.ingredientItem.title) {
              ingredient.text = state.ingredientItem.title;
              ingredient.selection = TextSelection.collapsed(
                  offset: state.ingredientItem.title.length);
            }
          },
          child: BlocBuilder<InputbeliformCubit, InputbeliformState>(
            builder: (context, state) {
              print(state);

              var thecubit = BlocProvider.of<InputbeliformCubit>(context);
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: nama,
                            onChanged: (value) {
                              BlocProvider.of<InputbeliformCubit>(context)
                                  .changeData(state.copyWith(nama: value));
                            },
                            validator: (value) =>
                                value!.isEmpty ? 'cant empty' : null,
                            decoration:
                                InputDecoration(label: Text('Nama Item')),
                          ),
                        ),
                        Padding(padding: EdgeInsetsGeometry.all(8)),
                        Expanded(
                          child: TypeAheadField(
                            builder: (context, controller, focusNode) =>
                                TextFormField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    onChanged: (value) {
                                      var ingreitem = state.ingredientItem;
                                      thecubit.changeData(state.copyWith(
                                          ingredientItem: ingreitem.copyWith(
                                              id: () => null)));
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Untuk bahan baku:'),
                                    )),
                            itemBuilder: (context, value) {
                              return ListTile(
                                title: Text(value.data().title),
                              );
                            },
                            onSelected: (value) {
                              ingredient.text = value.data().title;
                              thecubit.changeData(
                                  state.copyWith(ingredientItem: value.data()));
                            },
                            suggestionsCallback: (search) async {
                              var a = RepositoryProvider.of<MenuItemRepository>(
                                      context)
                                  .getIngredients()
                                  .then(
                                    (value) => value.docs
                                        .where(
                                          (element) => (element.data().title)
                                              .contains(search),
                                        )
                                        .toList(),
                                  );
                              return a;
                            },
                            controller: ingredient,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tempatbeli,
                            decoration:
                                InputDecoration(label: Text('Tempat beli')),
                          ),
                        ),
                        Padding(padding: EdgeInsetsGeometry.all(8)),
                        Expanded(
                          child: TextFormField(
                            controller: count,
                            validator: numberValidator,
                            decoration: InputDecoration(label: Text('Count')),
                          ),
                        ),
                        Padding(padding: EdgeInsetsGeometry.all(8)),
                        Expanded(
                          child: TextFormField(
                            controller: harga,
                            validator: numberValidator,
                            decoration: InputDecoration(label: Text('Harga')),
                          ),
                        ),
                        Padding(padding: EdgeInsetsGeometry.all(8)),
                      ],
                    ),
                    Padding(padding: EdgeInsetsGeometry.all(8)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          var isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (isValid) {
                            thecubit.sendtoDB();
                          }
                        },
                        child: Text('Submit pembelian'))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
