import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/repo/strukrepo.dart';

class HistoriPengeluaranMain extends StatelessWidget {
  const HistoriPengeluaranMain({super.key});
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori Pengeluaran Hari ini'),
      ),
      body: FutureBuilder(
        future: RepositoryProvider.of<StrukRepository>(context)
            .readStrukwithFilter(StrukFilter(
                start: DateTime(now.year, now.month, now.day),
                end: DateTime(now.year, now.month, now.day + 1))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            debugPrint(snapshot.data.toString());
            return Column(
              children: [
                for (var e in snapshot.data!) Kartu(e),
                Text('total : ${snapshot.data!.fold(
                  0,
                  (previousValue, element) =>
                      previousValue +
                      (element.orderItems.fold(
                        0,
                        (previousValue1, element1) =>
                            previousValue1 + (element1.count * element1.price),
                      )),
                )}')
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class Kartu extends StatelessWidget {
  final UseStrukState e;
  const Kartu(this.e, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(e.orderItems.toString()),
      ],
    ));
  }
}
