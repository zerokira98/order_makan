import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/pengeluaran/historipengeluaran/historipengeluaran_main.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/karyawan_authrepo.dart';

class PengeluaranPage extends StatelessWidget {
  final bool fromusemain;
  const PengeluaranPage({super.key, this.fromusemain = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: HistoriPengeluaranMain()),
          Expanded(child: PengeluaranInputForm(fromusemain: fromusemain))
        ],
      ),
    );
  }
}

class PengeluaranInputForm extends StatelessWidget {
  final bool fromusemain;
  final TextEditingController titlec = TextEditingController();
  final TextEditingController cost = TextEditingController();
  final TextEditingController date =
      TextEditingController(text: DateTime.now().toString());
  final GlobalKey<FormState> formkey = GlobalKey();
  final telo = CurrencyTextInputFormatter.simpleCurrency(
      decimalDigits: 0, locale: 'id_ID');
  PengeluaranInputForm({this.fromusemain = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Input Pengeluaran'),
              Row(
                children: [
                  Expanded(
                      child: TypeAheadField(
                    // focusNode: FocusScope.of(context),
                    suggestionsCallback: (search) async {
                      var a =
                          await RepositoryProvider.of<KasRepository>(context)
                              .getPengeluaranAll();
                      List<String> b = a.docs
                          .map((e) => (e.data()['title'] as String)
                                  .toLowerCase()
                                  .contains(search.toLowerCase())
                              ? (e.data()['title'] as String)
                              : null)
                          .nonNulls
                          .toList();
                      return b;
                    },
                    itemBuilder: (context, value) {
                      return ListTile(
                        title: Text(value),
                      );
                    },
                    builder: (context, controller, focusNode) => TextFormField(
                      validator: usernameValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(label: Text('Title')),
                    ),
                    onSelected: (String value) {
                      titlec.text = value;
                    },
                    controller: titlec,
                  )),
                ],
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: cost,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        numberValidator(telo.getUnformattedValue().toString()),
                    inputFormatters: [telo],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(label: Text('Cost')),
                  )),
                  Expanded(
                      child: TextFormField(
                    readOnly: true,
                    enabled: !fromusemain,
                    controller: date,
                    validator: usernameValidator,
                    onTap: fromusemain
                        ? null
                        : () {
                            showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime.now(),
                                    initialDate: DateTime.now())
                                .then(
                              (value) {
                                if (value != null) {
                                  date.text = value.toString();
                                }
                              },
                            );
                          },
                    onTapAlwaysCalled: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('Tanggal'),
                      // suffix: TextButton(
                      //   onPressed: () {},
                      //   child: Text('now'),
                      // ),
                    ),
                  )),
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formkey.currentState?.validate() ?? false) {
                      var userid =
                          RepositoryProvider.of<KaryawanAuthRepo>(context)
                              .currentUser
                              .namaKaryawan;
                      RepositoryProvider.of<KasRepository>(context)
                          .tambahPengeluaran(
                              titlec.text,
                              telo.getDouble().toInt(),
                              // int.parse(cost.text),
                              DateTime.parse(date.text),
                              userid)
                          .then(
                        (value) {
                          titlec.text = '';
                          date.text = '';
                          cost.text = '';
                        },
                      );
                    }
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
