import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/struk/struk_bloc.dart';
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
  int total(StrukState theData) {
    int total = 0;
    for (var element in theData.orderItems) {
      total = total + (element.price * element.count);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StrukBloc, StrukState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.2,
                  vertical: MediaQuery.sizeOf(context).height * 0.1),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Nama Resto'),
                    ),
                    const Padding(padding: EdgeInsets.all(24)),
                    const Row(
                      children: [
                        Text(
                          'KaryawanName',
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
                        Flexible(child: Text('Nama menu')),
                        Flexible(child: Text('pcs')),
                        Flexible(child: Text('Harga')),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(4)),
                    for (var a in state.orderItems)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text(a.title.toString())),
                          Flexible(child: Text(a.count.toString())),
                          Flexible(child: Text(a.price.toString())),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            'Total : Rp${total(state).toString().numberFormat()}'),
                      ],
                    ),

                    TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Kode Diskon')),
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
                          textScaleFactor: 1.25,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          var a = await RepositoryProvider.of<StrukRepository>(
                                  context)
                              .sendtoDatabase(state);
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
