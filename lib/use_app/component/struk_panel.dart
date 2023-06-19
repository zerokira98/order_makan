import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/use_app/bloc/struk/struk_bloc.dart';
import 'package:order_makan/use_app/component/ordertile.dart';
import 'package:order_makan/use_app/component/toptab.dart';

class StrukPanel extends StatelessWidget {
  const StrukPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 3,
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(2),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Struck',
                  textScaleFactor: 1.2,
                ),
              ),
              Expanded(
                child: BlocBuilder<StrukBloc, StrukState>(
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
                          data: state.orderItems[index]),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<StrukBloc, StrukState>(
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
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:${getTotal().numberFormat()} '),
                              ElevatedButton(
                                  onPressed: () {},
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
          ),
        ));
  }
}
