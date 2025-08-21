import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/repo/firestore_kas.dart';

class HistoriPengeluaranMain extends StatefulWidget {
  const HistoriPengeluaranMain({super.key});

  @override
  State<HistoriPengeluaranMain> createState() => _HistoriPengeluaranMainState();
}

class _HistoriPengeluaranMainState extends State<HistoriPengeluaranMain> {
  late Future thefuture;
  var date = DateTime.now();
  @override
  void initState() {
    thefuture = futuremet();
    super.initState();
  }

  Future futuremet() {
    return RepositoryProvider.of<KasRepository>(context).getPengeluaran(
        start: DateTime(date.year, date.month),
        end: DateTime(date.year, date.month + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori Pengeluaran '),
        actions: [
          ElevatedButton(
              onPressed: () {
                showMonthYearPicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now())
                    .then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        date = value;
                        thefuture = futuremet();
                      });
                    }
                  },
                );
              },
              child: Text(DateFormat.MMMM('id_ID').format(date))),
          IconButton(
              onPressed: () {
                setState(() {
                  thefuture = futuremet();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: thefuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('empty'),
              );
            }
            debugPrint(snapshot.data.toString());
            return Column(
              children: [
                for (var e in snapshot.data!.docs)
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.data()['title'].toString()),
                        Text(
                            "${(e.data()['date'] as Timestamp).toDate().formatLengkap()} ${(e.data()['date'] as Timestamp).toDate().clockOnly()}"),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((e.data()['cost'] as int)
                            .numberFormat(currency: true)),
                        Text(
                            "poster: ${(e.data()['userid'] as String?) ?? ''}"),
                      ],
                    ),
                  ),
                // Text('total : ${snapshot.data!.fold(
                //   0,
                //   (previousValue, element) =>
                //       previousValue +
                //       (element.orderItems.fold(
                //         0,
                //         (previousValue1, element1) =>
                //             previousValue1 + (element1.count * element1.price),
                //       )),
                // )}')
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
