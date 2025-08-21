import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/pages/use_app/struk_panel/ordertile.dart';
import 'package:order_makan/helper.dart';

class StrukPanel extends StatelessWidget {
  final PageController pageController;
  const StrukPanel({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Card.outlined(
          elevation: 8,
          margin: const EdgeInsets.only(top: 10.0),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Order Summary',
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(1.3),
                        ),
                        // Icon(Icons.shopping_cart)
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            // backgroundColor: Colors.blueGrey[100],
                            actions: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.green),
                                  onPressed: () {
                                    BlocProvider.of<UseStrukBloc>(context).add(
                                        InitiateStruk(
                                            karyawanId:
                                                BlocProvider.of<UseStrukBloc>(
                                                        context)
                                                    .state
                                                    .karyawanId));
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes')),
                            ],
                            title: Text('r u sure?'),
                            content: Text('clear cart list.'),
                          ),
                        );
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(4)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: BlocBuilder<UseStrukBloc, UseStrukState>(
                  buildWhen: (previous, current) =>
                      previous.orderItems.length != current.orderItems.length,
                  builder: (context, state) {
                    if (state.orderItems.isEmpty) {
                      return const Center(
                        child: Text('Empty'),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.orderItems.length,
                      itemBuilder: (context, index) => OrderTile(
                        // menudata: ,
                        // key: Key('$index'),
                        index: index,
                        // data: state.orderItems[index]
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: BlocBuilder<UseStrukBloc, UseStrukState>(
                    builder: (context, state) {
                      num getTotal() {
                        var total = 0;
                        var adjust = 0;
                        for (var e in state.orderItems) {
                          total = total + (e.price * e.count);
                          for (var f in e.submenues) {
                            adjust += f.adjustHarga * e.count;
                          }
                        }
                        return (total + adjust);
                      }

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                              vertical: BorderSide(
                                  width: 8, color: Colors.red.shade600),
                              horizontal:
                                  BorderSide(color: Colors.red.shade100)),
                          color: Colors.red,
                        ),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: Rp${getTotal().numberFormat()} ',
                              textScaler: TextScaler.linear(1.2),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black),
                                onPressed: () {
                                  BlocProvider.of<UseStrukBloc>(context)
                                      .add(DateUpdate());
                                  if (state.orderItems.isNotEmpty) {
                                    pageController.animateToPage(
                                        ((pageController.page?.floor() ?? 0) +
                                                1) %
                                            2,
                                        duration: Durations.medium4,
                                        curve: Curves.easeInOut);
                                    // showDialog(
                                    //   // useSafeArea: false,
                                    //   context: context,
                                    //   builder: (c) => BlocProvider.value(
                                    //     value: BlocProvider.of<UseStrukBloc>(
                                    //         context),
                                    //     child: const CheckoutDialog(),
                                    //   ),
                                    // );
                                  }
                                },
                                icon: Icon(Icons.navigate_next),
                                label: const Text('Pembayaran'))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}
