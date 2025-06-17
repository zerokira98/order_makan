import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/struk/struk_bloc.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
import 'package:order_makan/component/toptab.dart';
import 'package:order_makan/repo/strukrepo.dart';

class CheckoutPage extends StatefulWidget {
  // StrukState theData;
  const CheckoutPage({
    super.key,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int diskon = 0;
  int val = 0;
  int total(StrukState theData) {
    int total = 0;
    for (var element in theData.orderItems) {
      total = total + (element.price * element.count);
    }
    return total;
  }

// TextStyle biggerTxt = TextStyle()
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocBuilder<StrukBloc, StrukState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Card(
              // margin: EdgeInsets.symmetric(
              //     horizontal: MediaQuery.sizeOf(context).width * 0.2,
              //     vertical: MediaQuery.sizeOf(context).height * 0.1),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(18.0),
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nama Resto'),
                    ),
                    const Padding(padding: EdgeInsets.all(24.0)),
                    Row(
                      children: [
                        Text(
                          ((BlocProvider.of<KaryawanauthBloc>(context).state
                                  as KaryawanAuthenticated)
                              .user
                              .namaKaryawan),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Senin, 10 April 2030',
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            '10.12',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            fit: FlexFit.tight,
                            flex: 8,
                            child: Text('Nama menu')),
                        Flexible(child: Text(' pcs')),
                        Flexible(flex: 10, child: Text('Harga')),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(4)),
                    for (var a in state.orderItems)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              fit: FlexFit.tight,
                              flex: 8,
                              child: Text(
                                a.title.toString(),
                                textScaler: TextScaler.linear(1.2),
                              )),
                          Flexible(
                              flex: 0,
                              child: Text(
                                a.count.toString(),
                                textScaler: TextScaler.linear(1.2),
                              )),
                          Flexible(
                              // fit: FlexFit.tight,
                              flex: 10,
                              child: Text(
                                a.price.toString().numberFormat(),
                                textScaler: TextScaler.linear(1.2),
                              )),
                        ],
                      ),
                    // Text(
                    //   '_____',
                    //   textAlign: TextAlign.end,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            'Total : Rp${total(state).toString().numberFormat()}'),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Nomor meja: '),
                            DropdownButton(
                              menuMaxHeight: 280,
                              alignment: Alignment.center,
                              items: [
                                const DropdownMenuItem(
                                  value: 0,
                                  child: Text('Tanpa meja'),
                                ),
                                for (var i = 1; i <= 24; i++)
                                  DropdownMenuItem(
                                    value: i,
                                    child: Text(
                                      '$i',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ],
                              value: val,
                              onChanged: (value) {
                                setState(() {
                                  val = value ?? 0;
                                });
                              },
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12)),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                label: Text('Kode Diskon')),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Diskon : Rp ${diskon.toString().numberFormat()}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total : Rp${(total(state) - diskon).toString().numberFormat()}',
                          textScaler: TextScaler.linear(1.25),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            // print(state.toJson());
                            var before =
                                await RepositoryProvider.of<StrukRepository>(
                                        context)
                                    .getCount();
                            var a =
                                await RepositoryProvider.of<StrukRepository>(
                                        context)
                                    .sendtoDatabase(state);
                            var after =
                                await RepositoryProvider.of<StrukRepository>(
                                        context)
                                    .getCount();
                            // print(a);
                            if (before < after) {
                              print('inserted');
                              BlocProvider.of<StrukBloc>(context)
                                  .add(InitiateStruk());
                              Navigator.pop(context);
                            } else {
                              print('error, maybe not inserted');
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text('Chekout!'))
                    // Text(widget.theData.toString()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
