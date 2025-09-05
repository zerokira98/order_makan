import 'dart:convert';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/antrian/antrian_main.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

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
  ScrollController tablesc = ScrollController();
  int diskon = 0;
  int val = 0;
  var telo = CurrencyTextInputFormatter.simpleCurrency(
      decimalDigits: 0, locale: 'id_ID');
  TextEditingController uang = TextEditingController(text: '0');
  int total(UseStrukState theData) {
    int total = 0;
    var adjust = 0;
    for (var element in theData.orderItems) {
      total = total + (element.price * element.count);
      for (var f in element.submenues) {
        adjust += f.adjustHarga * element.count;
      }
    }
    return total + adjust;
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      tablesc
          .animateTo(tablesc.position.maxScrollExtent,
              duration: Durations.medium4, curve: Curves.easeIn)
          .then(
            (value) => tablesc.animateTo(0,
                duration: Durations.medium4, curve: Curves.easeIn),
          );
    });
    super.initState();
  }
  // num getTotal() {
  //                       var total = 0;
  //                       for (var e in state.orderItems) {
  //                         total = total + (e.price * e.count);

  //                       }
  //                       return (total + adjust);
  //                     }

// TextStyle biggerTxt = TextStyle()
  @override
  Widget build(BuildContext context) {
    return BlocListener<UseStrukBloc, UseStrukState>(
      listenWhen: (p, c) => c.orderItems.isEmpty,
      listener: (context, state) {
        if (mounted) {
          widget.pageController.jumpToPage(0);
          Navigator.push(
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
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Card.outlined(
                          elevation: 3,
                          margin: EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(18.0),
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: Column(
                              // mainAxisSize: MainAxisSize.max,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                    future:
                                        SharedPreferences.getInstance().then(
                                      (value) {
                                        var a =
                                            value.getString('globalSetting') ??
                                                '{}';
                                        var b = jsonDecode(a);
                                        return '${b['namaresto']}';
                                      },
                                    ),
                                    builder: (context, asyncSnapshot) {
                                      return Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'Koffie Coffeeshop',
                                          textScaler: TextScaler.linear(1.8),
                                        ),
                                      );
                                    }),
                                const Padding(padding: EdgeInsets.all(8.0)),
                                Row(
                                  children: [
                                    Text(
                                      ((BlocProvider.of<KaryawanauthBloc>(
                                                  context)
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: uang,
                                          inputFormatters: [telo],
                                          decoration: const InputDecoration(
                                              label: Text('Uang')),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                BlocBuilder<UseStrukBloc, UseStrukState>(
                                  buildWhen: (previous, current) =>
                                      previous.tipePembayaran !=
                                      current.tipePembayaran,
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              uang.text =
                                                  telo.formatDouble(0.0);
                                              BlocProvider.of<UseStrukBloc>(
                                                      context)
                                                  .add(ChangePembayaran(
                                                      tipe: TipePembayaran
                                                          .tunai));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width:
                                                          state.tipePembayaran ==
                                                                  TipePembayaran
                                                                      .tunai
                                                              ? 3
                                                              : 1,
                                                      color: Theme.of(context)
                                                          .buttonTheme
                                                          .colorScheme!
                                                          .primary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: TipePembayaran.tunai,
                                                    groupValue:
                                                        state.tipePembayaran,
                                                    onChanged: (value) {
                                                      // if (value != null) {
                                                      //   uang.text = '0';
                                                      //   BlocProvider.of<
                                                      //               UseStrukBloc>(
                                                      //           context)
                                                      //       .add(ChangePembayaran(
                                                      //           tipe: value));
                                                      // }
                                                    },
                                                  ),
                                                  Text('Tunai'),
                                                  Expanded(child: SizedBox()),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                        Icons.attach_money),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsetsGeometry.all(2)),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              uang.text = telo.formatString(
                                                  total(state).toString());
                                              setState(() {});
                                              BlocProvider.of<UseStrukBloc>(
                                                      context)
                                                  .add(ChangePembayaran(
                                                      tipe:
                                                          TipePembayaran.qris));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width:
                                                          state.tipePembayaran ==
                                                                  TipePembayaran
                                                                      .qris
                                                              ? 3
                                                              : 1,
                                                      color: Theme.of(context)
                                                          .buttonTheme
                                                          .colorScheme!
                                                          .primary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: TipePembayaran.qris,
                                                    groupValue:
                                                        state.tipePembayaran,
                                                    onChanged: (value) {
                                                      // if (value != null) {
                                                      //   uang.text = total(state)
                                                      //       .toString();
                                                      //   BlocProvider.of<
                                                      //               UseStrukBloc>(
                                                      //           context)
                                                      //       .add(ChangePembayaran(
                                                      //           tipe: value));
                                                      // }
                                                    },
                                                  ),
                                                  Text('Qris'),
                                                  Expanded(child: SizedBox()),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        Icon(Icons.qr_code_2),
                                                  )
                                                ],
                                              ),
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
                                      'Kembalian : Rp${((telo.getDouble()) - total(state)).numberFormat()}',
                                      textScaler: TextScaler.linear(1.25),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: () async {
                                          // debugPrint(state.orderItems.single.ingredientItems);
                                          widget.pageController.animateToPage(0,
                                              duration: Durations.extralong1,
                                              curve: Curves.easeInOut);
                                        },
                                        icon: Icon(Icons.arrow_back),
                                        label: const Text('Batal')),
                                    Padding(padding: EdgeInsetsGeometry.all(4)),
                                    ElevatedButton(
                                        onPressed: () async {
                                          print((telo.getDouble() -
                                              total(state)));
                                          if (((telo.getDouble() -
                                                  total(state)) <
                                              0.0)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'kembalian minus')));
                                            return;
                                          }
                                          // debugPrint(state.orderItems.single.ingredientItems);
                                          try {
                                            BlocProvider.of<UseStrukBloc>(
                                                    context)
                                                .add(SendtoDb());
                                            BlocProvider.of<AntrianBloc>(
                                                    context)
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
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
              child: Center(
                  child: VirtualKeyboard(
                      type: VirtualKeyboardType.Numeric,
                      postKeyPress: (key) {
                        if (key.keyType == VirtualKeyboardKeyType.String) {
                          uang.text = telo.formatString(
                              telo.getDouble().round().toString() +
                                  ((key.text) ?? ''));
                        } else if (key.keyType ==
                            VirtualKeyboardKeyType.Action) {
                          switch (key.action) {
                            case VirtualKeyboardKeyAction.Backspace:
                              var vals = telo.getDouble().round().toString();
                              uang.text = telo.formatString(
                                  vals.substring(0, vals.length - 1));
                              break;
                            case VirtualKeyboardKeyAction.Return:
                              // text = text + '\n';
                              break;
                            case VirtualKeyboardKeyAction.Space:
                              // text = text + (key.text ?? '');
                              break;
                            case VirtualKeyboardKeyAction.Shift:
                              // shiftEnabled = !shiftEnabled;
                              break;
                            default:
                          }
                        }
                        setState(() {});
                      })
                  // SimpleNumpad(
                  //   buttonWidth: 120,
                  //   buttonHeight: 120,
                  //   useBackspace: true,

                  //   // removeBlankButton: true,
                  //   onPressed: (p0) {
                  //     debugPrint(p0);
                  //     if (p0 == 'BACKSPACE') {
                  //       setState(() {
                  //         uang.text = uang.text.isNotEmpty
                  //             ? uang.text.substring(0, uang.text.length - 1)
                  //             : uang.text;
                  //       });
                  //     } else {
                  //       setState(() {
                  //         uang.text = uang.text + p0;
                  //       });
                  //     }
                  //   },
                  // ),
                  ))
        ],
      ),
    );
  }
}
