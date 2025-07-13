import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/antrian/antrian_main.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:simple_numpad/simple_numpad.dart';

class CheckoutDialog extends StatefulWidget {
  final PageController pageController;
  // StrukState theData;
  const CheckoutDialog({
    super.key,
    required this.pageController,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  int diskon = 0;
  int val = 0;
  TextEditingController uang = TextEditingController();
  int total(UseStrukState theData) {
    int total = 0;
    for (var element in theData.orderItems) {
      total = total + (element.price * element.count);
    }
    return total;
  }

// TextStyle biggerTxt = TextStyle()
  @override
  Widget build(BuildContext context) {
    return BlocListener<UseStrukBloc, UseStrukState>(
      listenWhen: (p, c) => c.orderItems.isEmpty,
      listener: (context, state) {
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AntrianPage(
                  fromcheckout: true,
                ),
              ));
          // Navigator.(context);
        }
      },
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<UseStrukBloc, UseStrukState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8),
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
                            child: Text(
                              'Nama Resto',
                              textScaler: TextScaler.linear(1.8),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(18.0)),
                          Row(
                            children: [
                              Text(
                                ((BlocProvider.of<KaryawanauthBloc>(context)
                                        .state as KaryawanAuthenticated)
                                    .user
                                    .namaKaryawan),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  state.ordertime.formatLengkap(),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  state.ordertime.clockOnly(),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          StrukDataTable(data: state),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  'Total : Rp${total(state).toString().numberFormat()}'),
                            ],
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Nomor meja: '),
                                  BlocBuilder<UseStrukBloc, UseStrukState>(
                                    builder: (context, state) {
                                      return DropdownButton<int>(
                                        menuMaxHeight: 280,
                                        alignment: Alignment.center,
                                        items: [
                                          const DropdownMenuItem(
                                            value: 0,
                                            child: Text('Tanpa meja'),
                                          ),
                                          for (var i = 1; i <= 25; i++)
                                            DropdownMenuItem(
                                              value: i,
                                              child: Text(
                                                '$i',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                        ],
                                        value: state.nomorMeja,
                                        onChanged: (value) {
                                          BlocProvider.of<UseStrukBloc>(context)
                                              .add(
                                                  ChangeMeja(meja: value ?? 0));
                                          // setState(() {
                                          //   val = value ?? 0;
                                          // });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12)),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: uang,
                                  decoration: const InputDecoration(
                                      label: Text('Uang')),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Text('Diskon : Rp ${diskon.toString().numberFormat()}'),
                          //   ],
                          // ),
                          BlocBuilder<UseStrukBloc, UseStrukState>(
                            buildWhen: (previous, current) =>
                                previous.tipePembayaran !=
                                current.tipePembayaran,
                            builder: (context, state) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<UseStrukBloc>(context)
                                          .add(ChangePembayaran(
                                              tipe: TipePembayaran.tunai));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: state.tipePembayaran ==
                                                      TipePembayaran.tunai
                                                  ? 3
                                                  : 1,
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: TipePembayaran.tunai,
                                            groupValue: state.tipePembayaran,
                                            onChanged: (value) {
                                              if (value != null) {
                                                BlocProvider.of<UseStrukBloc>(
                                                        context)
                                                    .add(ChangePembayaran(
                                                        tipe: value));
                                              }
                                            },
                                          ),
                                          Text('Tunai')
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsetsGeometry.all(2)),
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<UseStrukBloc>(context)
                                          .add(ChangePembayaran(
                                              tipe: TipePembayaran.qris));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: state.tipePembayaran ==
                                                      TipePembayaran.qris
                                                  ? 3
                                                  : 1,
                                              color: Theme.of(context)
                                                  .buttonTheme
                                                  .colorScheme!
                                                  .primary),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: TipePembayaran.qris,
                                            groupValue: state.tipePembayaran,
                                            onChanged: (value) {
                                              if (value != null) {
                                                BlocProvider.of<UseStrukBloc>(
                                                        context)
                                                    .add(ChangePembayaran(
                                                        tipe: value));
                                              }
                                            },
                                          ),
                                          Text('Qris')
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total : Rp${(total(state) - diskon).toString().numberFormat()}',
                                textScaler: TextScaler.linear(1.25),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Kembalian : Rp${((int.tryParse(uang.text) ?? 0) - total(state)).toString().numberFormat()}',
                                textScaler: TextScaler.linear(1.25),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    // debugPrint(state.orderItems.single.ingredientItems);
                                    widget.pageController.animateToPage(0,
                                        duration: Durations.extralong1,
                                        curve: Curves.easeInOut);
                                  },
                                  child: const Text('Batal')),
                              Padding(padding: EdgeInsetsGeometry.all(4)),
                              ElevatedButton(
                                  onPressed: () async {
                                    // debugPrint(state.orderItems.single.ingredientItems);
                                    try {
                                      BlocProvider.of<UseStrukBloc>(context)
                                          .add(SendtoDb());
                                      BlocProvider.of<AntrianBloc>(context)
                                          .add(InitiateAntrian());
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  },
                                  child: const Text('Chekout!'))
                            ],
                          ),
                          // Text(widget.theData.toString()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
              child: Center(
            child: SimpleNumpad(
              buttonWidth: 120,
              buttonHeight: 120,
              useBackspace: true,

              // removeBlankButton: true,
              onPressed: (p0) {
                debugPrint(p0);
                if (p0 == 'BACKSPACE') {
                  setState(() {
                    uang.text = uang.text.isNotEmpty
                        ? uang.text.substring(0, uang.text.length - 1)
                        : uang.text;
                  });
                } else {
                  setState(() {
                    uang.text = uang.text + p0;
                  });
                }
              },
            ),
          ))
        ],
      ),
    );
  }
}
