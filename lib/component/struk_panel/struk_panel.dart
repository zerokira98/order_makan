import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/component/struk_panel/ordertile.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/use_app/checkout.dart';

class StrukPanel extends StatelessWidget {
  const StrukPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(6.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Cart',
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(1.2),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      BlocProvider.of<UseStrukBloc>(context).add(InitiateStruk(
                          karyawanId: BlocProvider.of<UseStrukBloc>(context)
                              .state
                              .karyawanId));
                    },
                    icon: Icon(Icons.delete))
              ],
            ),
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
                      String getTotal() {
                        var total = 0;
                        for (var e in state.orderItems) {
                          total = total + (e.price * e.count);
                        }
                        return total.toString();
                      }

                      return Container(
                        color: Colors.red,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: Rp${getTotal().numberFormat()} ',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<UseStrukBloc>(context)
                                      .add(DateUpdate());
                                  if (state.orderItems.isNotEmpty) {
                                    showDialog(
                                      // useSafeArea: false,
                                      context: context,
                                      builder: (c) => BlocProvider.value(
                                        value: BlocProvider.of<UseStrukBloc>(
                                            context),
                                        child: const CheckoutDialog(),
                                      ),
                                    );
                                  }
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (c) => BlocProvider.value(
                                  //         value: BlocProvider.of<StrukBloc>(
                                  //             context),
                                  //         child: const CheckoutPage(),
                                  //       ),
                                  //     ));
                                },
                                child: const Text('CheckOut'))
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
