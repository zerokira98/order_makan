import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/model/inputstock_model.dart';
import 'package:order_makan/pages/admin_panel/inputbelibahan/cubit/inputbeliform_cubit.dart';
import 'package:order_makan/repo/menuitemsrepo.dart';

class InputBeliBahanbaku extends StatefulWidget {
  const InputBeliBahanbaku({super.key});

  @override
  State<InputBeliBahanbaku> createState() => _InputBeliBahanbakuState();
}

class _InputBeliBahanbakuState extends State<InputBeliBahanbaku> {
  late Future<QuerySnapshot<InputstockModel>> thefuture;
  var date = DateTime.now();
  @override
  void initState() {
    thefuture = futuremet();
    super.initState();
  }

  Future<QuerySnapshot<InputstockModel>> futuremet() {
    return RepositoryProvider.of<MenuItemRepository>(context)
        .getInputstocksWithFilter(
            start: DateTime(date.year, date.month),
            end: DateTime(date.year, date.month + 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InputbeliformCubit, InputbeliformState>(
      listenWhen: (previous, current) =>
          current == InputbeliformState.initial(),
      listener: (context, state) {
        setState(() {});
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pembelian Bahanbaku'),
          actions: [
            IconButton.outlined(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('List Pembelian Bahanbaku'),
                        Expanded(child: SizedBox()),
                        ElevatedButton(
                            onPressed: () {
                              showMonthYearPicker(
                                      context: context,
                                      initialDate: date,
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime.now())
                                  .then(
                                (value) {
                                  if (value != null) {
                                    setState(() {
                                      date = value;
                                      thefuture = futuremet();
                                    });
                                  }
                                },
                              );
                            },
                            child: Text(DateFormat.MMMM('id_ID').format(date))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: thefuture,
                      builder: (context, snapshot) {
                        debugPrint(snapshot.data?.docs.toString());
                        if (snapshot.data == null ||
                            (snapshot.data?.docs.isEmpty ?? false)) {
                          return Center(
                            child: Text('Empty'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var thedata = snapshot.data!.docs[index].data();
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(thedata.title.toString()),
                                  Text(thedata.asIngredient.title.toString()),
                                ],
                              ),
                              subtitle: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(thedata.price
                                        .numberFormat(currency: true)),
                                  ),
                                  Expanded(
                                    child: Text(
                                      thedata.tanggalbeli
                                          .toDate()
                                          .formatBasic(),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      thedata.count.numberFormat() +
                                          thedata.asIngredient.satuan,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            VerticalDivider(),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text('List Stock Bahanbaku'),
                  Expanded(
                    child: FutureBuilder(
                      future: RepositoryProvider.of<MenuItemRepository>(context)
                          .getIngredients(),
                      builder: (context, snapshot) {
                        debugPrint(snapshot.data.toString());
                        if (snapshot.data == null ||
                            (snapshot.data?.isEmpty ?? false)) {
                          return Center(
                            child: Text('Empty'),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var thedata = snapshot.data![index];
                            return ListTile(
                              title: Text(thedata.title.toString().firstUpcase),
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    TextEditingController alert =
                                        TextEditingController(
                                            text: thedata.alert?.toString() ??
                                                '0');
                                    TextEditingController satuandialog =
                                        TextEditingController(
                                            text: thedata.satuan);
                                    return Dialog(
                                      insetPadding: EdgeInsets.all(24),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: SizedBox(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller: alert,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: numberValidator,
                                                  decoration: InputDecoration(
                                                      label: Text(
                                                          'Alert when less than')),
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  validator: numberValidator,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: satuandialog,
                                                  decoration: InputDecoration(
                                                      label: Text('Satuan')),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    RepositoryProvider.of<
                                                                MenuItemRepository>(
                                                            context)
                                                        .editIngredientsSatuan(
                                                            thedata.copyWith(
                                                          satuan:
                                                              satuandialog.text,
                                                          alert: () =>
                                                              int.parse(
                                                                  alert.text),
                                                        ))
                                                        .then(
                                                          (value) =>
                                                              Navigator.pop(
                                                                  context),
                                                        );
                                                  },
                                                  icon: Icon(Icons.save))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                              subtitle: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Stock: ${thedata.count.numberFormat()}'),
                                  Text(thedata.satuan),
                                  Expanded(child: SizedBox()),
                                  Text('Alert:${thedata.alert}'),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  InputBahanbakuField(
                      BlocProvider.of<InputbeliformCubit>(context).state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputBahanbakuField extends StatelessWidget {
  final TextEditingController ingredient;
  final TextEditingController nama;
  final TextEditingController tanggalbeli;
  final TextEditingController count;
  final TextEditingController harga;
  final TextEditingController tempatbeli;
  final GlobalKey<FormState> _formKey = GlobalKey();
  InputBahanbakuField(
    InputbeliformState state, {
    super.key,
  })  : ingredient = TextEditingController(text: state.ingredientItem.title),
        nama = TextEditingController(text: state.nama),
        tanggalbeli =
            TextEditingController(text: state.tanggalbeli.formatBasic()),
        count = TextEditingController(text: state.count.toString()),
        harga = TextEditingController(text: state.harga.toString()),
        tempatbeli = TextEditingController(text: state.tempatbeli);

  final telo = CurrencyTextInputFormatter.simpleCurrency(
      decimalDigits: 0, locale: 'id_ID');
  @override
  Widget build(BuildContext context) {
    var thecubit = context.watch<InputbeliformCubit>();
    // var thecubit = BlocProvider.of<InputbeliformCubit>(context);
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocListener<InputbeliformCubit, InputbeliformState>(
            listener: (context, state) {
              debugPrint(state.toString());
              if (nama.text != state.nama) {
                nama.text = state.nama;
                nama.selection =
                    TextSelection.collapsed(offset: state.nama.length);
              }
              if (tanggalbeli.text != state.tanggalbeli.formatBasic()) {
                tanggalbeli.text = state.tanggalbeli.formatBasic();
                // tanggalbeli.selection = TextSelection.collapsed(
                //     offset: state.tanggalbeli.formatBasic().length);
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadField(
                          builder: (context, controller, focusNode) =>
                              TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  onChanged: (value) {
                                    var ingreitem =
                                        thecubit.state.ingredientItem;
                                    thecubit.changeData(thecubit.state.copyWith(
                                        ingredientItem: ingreitem.copyWith(
                                            title: value.trim(),
                                            id: () => null)));
                                  },
                                  decoration: InputDecoration(
                                    suffix:
                                        thecubit.state.ingredientItem.id == null
                                            ? Icon(Icons.sd_card_alert_outlined)
                                            : Icon(Icons.check),
                                    label: Text('Untuk bahan baku:'),
                                  )),
                          itemBuilder: (context, value) {
                            return ListTile(
                              title: Text(value.title),
                            );
                          },
                          onSelected: (value) {
                            ingredient.text = value.title;
                            thecubit.changeData(
                                thecubit.state.copyWith(ingredientItem: value));
                          },
                          suggestionsCallback: (search) async {
                            var a = await RepositoryProvider.of<
                                    MenuItemRepository>(context)
                                .getIngredients()
                                .then(
                                  (value) => value
                                      .where(
                                        (element) =>
                                            (element.title.toLowerCase())
                                                .contains(search.toLowerCase()),
                                      )
                                      .toList(),
                                );
                            return a;
                          },
                          controller: ingredient,
                        ),
                      ),
                      Padding(padding: EdgeInsetsGeometry.all(8)),
                      Flexible(
                        child: TextFormField(
                          controller: tanggalbeli,
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime.now())
                                .then(
                              (value) {
                                if (value != null) {
                                  tanggalbeli.text = value.formatBasic();
                                  thecubit.changeData(thecubit.state
                                      .copyWith(tanggalbeli: value));
                                }
                              },
                            );
                          },
                          decoration:
                              InputDecoration(label: Text('Tanggal Pembelian')),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nama,
                          onChanged: (value) {
                            thecubit.changeData(
                                thecubit.state.copyWith(nama: value));
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'cant empty' : null,
                          decoration:
                              InputDecoration(label: Text('Nama/Merk Item')),
                        ),
                      ),
                      Padding(padding: EdgeInsetsGeometry.all(8)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: tempatbeli,
                          onChanged: (value) {
                            thecubit.changeData(
                                thecubit.state.copyWith(tempatbeli: (value)));
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration:
                              InputDecoration(label: Text('Tempat beli')),
                        ),
                      ),
                      Padding(padding: EdgeInsetsGeometry.all(8)),
                      Expanded(
                        child: TextFormField(
                          controller: count,
                          onChanged: (value) {
                            thecubit.changeData(thecubit.state
                                .copyWith(count: int.tryParse(value)));
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: numberValidator,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              label: Text('Count'),
                              suffix:
                                  Text(thecubit.state.ingredientItem.satuan)),
                        ),
                      ),
                      Padding(padding: EdgeInsetsGeometry.all(8)),
                      Expanded(
                        child: TextFormField(
                          controller: harga,
                          onChanged: (value) {
                            thecubit.changeData(thecubit.state
                                .copyWith(harga: telo.getDouble().round()));
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return numberValidator(
                                telo.getUnformattedValue().round().toString());
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [telo],
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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid data exist')));
                        }
                      },
                      child: Text('Submit pembelian'))
                ],
              ),
            )),
      ),
    );
  }
}
