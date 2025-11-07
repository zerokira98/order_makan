import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/pengeluaran/cubit/pengeluaran_cubit.dart';

class HistoriPengeluaranMain extends StatefulWidget {
  const HistoriPengeluaranMain({super.key});

  @override
  State<HistoriPengeluaranMain> createState() => _HistoriPengeluaranMainState();
}

class _HistoriPengeluaranMainState extends State<HistoriPengeluaranMain> {
  var date = DateTime.now();
  @override
  void initState() {
    BlocProvider.of<PengeluaranCubit>(context).initiate();
    debugPrint('initiatet');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori Pengeluaran '),
        actions: [
          BlocBuilder<PengeluaranCubit, PengeluaranState>(
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    showMonthYearPicker(
                            context: context,
                            initialDate: state.filter.start!,
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now())
                        .then(
                      (value) {
                        if (value != null) {
                          BlocProvider.of<PengeluaranCubit>(context)
                              .changeFilter(state.filter.copywith(
                                  start: value,
                                  end: DateTime(value.year, value.month + 1)));
                        }
                      },
                    );
                  },
                  child: Text(DateFormat.MMMM('id_ID')
                      .format(state.filter.start ?? DateTime.now())));
            },
          ),
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: BlocBuilder<PengeluaranCubit, PengeluaranState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.datas.isEmpty) {
            return Center(
              child: Text('empty'),
            );
          }
          return Column(
            children: [
              for (var e in state.datas)
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
                      Text("poster: ${(e.data()['userid'] as String?) ?? ''}"),
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
