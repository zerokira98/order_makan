import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/bloc/struk/struk_state.dart';
import 'package:order_makan/model/strukitem_model.dart';
import 'package:order_makan/repo/strukrepo.dart';

class HistoriStruk extends StatelessWidget {
  const HistoriStruk({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Text('null');
                    }
                    // StringBuffer aw = StringBuffer('');
                    // for (var data in snapshot.data!) {
                    //   aw.write(data.key);
                    //   aw.write(data.value);
                    // }
                    return GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: 5,
                      crossAxisCount: 2,
                      children: snapshot.data!.map((e) {
                        List<StrukItem> ewe = e.orderItems;
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => DisplayStruk(
                                data: e,
                              ),
                            );
                          },
                          child: Card(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Nomor Struk#${e.strukId}',
                                    textScaler: TextScaler.linear(1.2),
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(child: Container()),
                                  Text(e.ordertime.toString())
                                ],
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      for (StrukItem ew in ewe)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(ew.title +
                                              ' x' +
                                              ew.count.toString()),
                                        ),
                                    ],
                                  ),
                                ],
                              )),
                              const Text('total: xxx')
                            ],
                          )),
                        );
                      }).toList(),
                    );
                  },
                  future: RepositoryProvider.of<StrukRepository>(context)
                      .readAllStruk(descending: true),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var after =
                        await RepositoryProvider.of<StrukRepository>(context)
                            .readAllStruk();
                    print(after);
                  },
                  child: const Text('press me!')),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayStruk extends StatelessWidget {
  final StrukState data;
  const DisplayStruk({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  'Struk',
                  textAlign: TextAlign.center,
                )),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close))
              ],
            ),
            Text('${data.strukId}'),
            Text(data.karyawanId),
            Text('${data.ordertime}'),
            Text('${data.orderItems.map(
              (e) => e.toJson(),
            )}'),
            // BlocBuilder<AntrianBloc, AntrianState>(
            //   builder: (context, state) {
            //     return Text(state.antrianStruks.toString());
            //   },
            // ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      BlocProvider.of<AntrianBloc>(context).add(Delete(data));
                      Navigator.pop(context);
                    },
                    child: Text('Batalkan Pesanan.')),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.green),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      BlocProvider.of<AntrianBloc>(context)
                          .add(OrderFinish(data.strukId!));
                    },
                    child: Text('Selesaikan Pesanan.')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
