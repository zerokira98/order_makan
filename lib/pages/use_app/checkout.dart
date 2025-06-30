import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/karyawanauth/karyawanauth_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/antrian/antrian_main.dart';
import 'package:order_makan/pages/histori_struk.dart';

class CheckoutDialog extends StatefulWidget {
  // StrukState theData;
  const CheckoutDialog({
    super.key,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  int diskon = 0;
  int val = 0;
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
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
      child: BlocListener<UseStrukBloc, UseStrukState>(
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
        child: BlocBuilder<UseStrukBloc, UseStrukState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
                          ((BlocProvider.of<KaryawanauthBloc>(context).state
                                  as KaryawanAuthenticated)
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
                                        .add(ChangeMeja(meja: value ?? 0));
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
                            padding: EdgeInsets.symmetric(horizontal: 12)),
                        // Expanded(
                        //   flex: 1,
                        //   child: TextFormField(
                        //     decoration: const InputDecoration(
                        //         label: Text('Kode Diskon')),
                        //   ),
                        // ),
                        BlocBuilder<UseStrukBloc, UseStrukState>(
                          buildWhen: (previous, current) =>
                              previous.tipePembayaran != current.tipePembayaran,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Text('Tipe Pembayaran: '),
                                DropdownButton<TipePembayaran>(
                                  // isExpanded: true
                                  // style: TextStyle(ali),
                                  menuMaxHeight: 280,
                                  alignment: Alignment.center,
                                  items: [
                                    for (var i = 0;
                                        i < TipePembayaran.values.length;
                                        i++)
                                      DropdownMenuItem(
                                        value: TipePembayaran.values[i],
                                        child: Text(
                                          TipePembayaran
                                              .values[i].name.firstUpcase,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                  value: state.tipePembayaran,
                                  onChanged: (value) {
                                    BlocProvider.of<UseStrukBloc>(context).add(
                                        ChangePembayaran(
                                            tipe:
                                                value ?? TipePembayaran.tunai));
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text('Diskon : Rp ${diskon.toString().numberFormat()}'),
                    //   ],
                    // ),
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
                            BlocProvider.of<UseStrukBloc>(context)
                                .add(SendtoDb());
                            BlocProvider.of<AntrianBloc>(context)
                                .add(InitiateAntrian());
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text('Chekout!'))
                    // Text(widget.theData.toString()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
