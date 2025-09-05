// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/model/inputstock_model.dart';
import 'package:order_makan/pages/admin_panel/rangkum/rangkuman_periodik/dailyvisit_chart.dart';
import 'package:order_makan/pages/admin_panel/rangkum/rangkuman_periodik/excel_processor.dart';
import 'package:order_makan/pages/histori_struk.dart';

import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';

class RangkumanPeriodik extends StatelessWidget {
  final bool isHarian;
  const RangkumanPeriodik({super.key, this.isHarian = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rangkuman ${isHarian ? 'Harian' : 'Bulanan'}'),
        actions: [
          BlocBuilder<RangkumanBloc, RangkumanState>(
            builder: (context, state) {
              return ElevatedButton(
                  onPressed: () {
                    ExcelProcessor().printExcel(state);
                  },
                  child: Text('Rangkum Excel(belum)'));
            },
          )
        ],
      ),
      body: BlocBuilder<RangkumanBloc, RangkumanState>(
        builder: (context, state) {
          // debugPrint(state.struks.toString());
          if (state == RangkumanState.initial || state.filter.start == null) {
            return CircularProgressIndicator();
          }
          return Row(
            children: [
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Text('Struks (${state.struks.length})'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.struks.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => DisplayStruk(
                              data: state.struks[index],
                              viewonly: true,
                            ),
                          ),
                          title: Text(
                              '${state.struks[index].ordertime.formatLengkap()} ${state.struks[index].ordertime.clockOnly()}'),
                          subtitle: Text(state.struks[index].total
                                  ?.numberFormat(currency: true) ??
                              ''),
                        ),
                      ),
                    ),
                    Divider(),
                    Text('Daily visit'),
                    SizedBox(height: 220, child: DailyVisitChart(state: state))
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SummaryContainer(
                        state: state,
                        isHarian: isHarian,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
          // }
          // return Center(
          //   child: Text('empty'),
          // );
        },
      ),
    );
  }
}

class SummaryContainer extends StatefulWidget {
  final bool isHarian;
  final RangkumanState state;
  const SummaryContainer(
      {super.key, required this.state, this.isHarian = false});

  @override
  State<SummaryContainer> createState() => _SummaryContainerState();
}

class _SummaryContainerState extends State<SummaryContainer> {
  var dtc = TextEditingController();
  DateTime now = DateTime.now();
  @override
  void initState() {
    var initdate = widget.state.filter.start;
    dtc.text = widget.isHarian
        ? initdate!.formatLengkap()
        : initdate!.formatMonthYear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> peritem = {};
    for (var e in widget.state.struks) {
      for (var w in e.orderItems) {
        if (w.submenues.isNotEmpty) {
          if (peritem.containsKey('${w.title}(custom)')) {
            peritem['${w.title}(custom)'] += 1;
          } else {
            peritem.addAll({'${w.title}(custom)': 1});
          }
        } else {
          if (peritem.containsKey(w.title)) {
            peritem[w.title] += 1;
          }
          peritem.addAll({w.title: 1});
        }
        // }
      }
    }
    var peritemlist = peritem.entries.toList()
      ..sort(
        (a, b) => a.key.compareTo(b.key),
      );
    var totalpendapatan = widget.state.struks.fold(
      0,
      (previousValue, element) => previousValue + (element.total ?? 0),
    );
    Map groupIngredient = {};
    for (var element in widget.state.struks) {
      for (var element2 in element.orderItems) {
        for (var element3 in element2.ingredientItems) {
          groupIngredient.update(
            element3.id,
            (value) => value + (element3.count * element2.count),
            ifAbsent: () => element3.count * element2.count,
          );
        }
      }
    }
    return Card.filled(
      color: Colors.blue.shade100,
      child: Container(
        // height: 60,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Pilih Tanggal : '),
                Flexible(
                  child: InkWell(
                    onTap: () {},
                    child: TextField(
                      controller: dtc,
                      readOnly: true,
                      // enabled: false,
                      onTap: () {
                        if (widget.isHarian) {
                          showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime.now())
                              .then(
                            (value) {
                              if (value != null) {
                                dtc.text = value.formatLengkap();
                                BlocProvider.of<RangkumanBloc>(context).add(
                                    ChangeFilterRangkuman(
                                        filter: widget.state.filter.copywith(
                                            start: DateTime(
                                                value.year, value.month),
                                            end: DateTime(
                                                value.year, value.month + 1))));
                                // setState(() {
                                // BlocProvider.of<SubjectBloc>(context)
                                // selecteddate = value;
                                // });
                              }
                            },
                          );
                        } else {
                          showMonthYearPicker(
                                  context: context,
                                  initialDate: widget.state.filter.start ?? now,
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime.now())
                              .then(
                            (value) {
                              if (value != null) {
                                dtc.text = value.formatMonthYear();
                                BlocProvider.of<RangkumanBloc>(context).add(
                                    ChangeFilterRangkuman(
                                        filter: widget.state.filter.copywith(
                                            start: DateTime(
                                                value.year, value.month),
                                            end: DateTime(
                                                value.year, value.month + 1))));
                                // setState(() {
                                // BlocProvider.of<SubjectBloc>(context)
                                // selecteddate = value;
                                // });
                              }
                            },
                          );
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), label: Text('Bulan')),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Item counts',
              textScaler: TextScaler.linear(1.1),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            for (var j = 0; j < peritem.length; j++)
              Text('${peritemlist[j].key} ${peritemlist[j].value}x'),
            Divider(),
            Text('Pendapatan dari penjualan ',
                textScaler: TextScaler.linear(1.1),
                style: TextStyle(fontWeight: FontWeight.w500)),
            Text('Total ${totalpendapatan.numberFormat(currency: true)}'),
            Text('Total tunai ${widget.state.struks.where(
                  (element) => element.tipePembayaran == TipePembayaran.tunai,
                ).fold(
                  0,
                  (previousValue, element) =>
                      previousValue + (element.total ?? 0),
                ).numberFormat(currency: true)}'),
            Text('Total qris${widget.state.struks.where(
                  (element) => element.tipePembayaran == TipePembayaran.qris,
                ).fold(
                  0,
                  (previousValue, element) =>
                      previousValue + (element.total ?? 0),
                ).numberFormat(currency: true)}'),
            Divider(),
            Text('Pengeluaran Umum',
                textScaler: TextScaler.linear(1.1),
                style: TextStyle(fontWeight: FontWeight.w500)),
            Column(
              children: [
                for (dynamic e in (widget.state.pengeluaranKas))
                  Row(
                    children: [
                      Expanded(child: Text(e.data()['title'].toString())),
                      Expanded(
                        child: Text((e.data()['cost'] as int)
                            .numberFormat(currency: true)),
                      ),
                      Expanded(
                        child: Text((e.data()['date'] as Timestamp)
                            .toDate()
                            .formatLengkap()),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Text('Total : '),
                    Text(widget.state.pengeluaranKas
                        .fold(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              (((element.data() as Map)['cost'] as int?) ?? 0),
                        )
                        .numberFormat(currency: true))
                  ],
                ),
              ],
            ),
            Text('Pengeluaran dari Pembelian Bahanbaku',
                textScaler: TextScaler.linear(1.1),
                style: TextStyle(fontWeight: FontWeight.w500)),
            Column(children: [
              for (InputstockModel e in widget.state.pengeluaranInputBahan)
                Row(
                  children: [
                    Expanded(child: Text(e.title)),
                    Expanded(child: Text(e.price.numberFormat(currency: true))),
                    Expanded(
                        child: Text(e.tanggalbeli.toDate().formatLengkap())),
                  ],
                ),
              Row(
                children: [
                  Text('Total : '),
                  Text(widget.state.pengeluaranInputBahan
                      .fold(
                        0.0,
                        (previousValue, element) =>
                            previousValue + element.price,
                      )
                      .numberFormat(currency: true))
                ],
              ),
            ]),
            Divider(),
            Text('Bersih Periode ini',
                textScaler: TextScaler.linear(1.1),
                style: TextStyle(fontWeight: FontWeight.w500)),
            Row(
              children: [
                Text('Total ${totalpendapatan.numberFormat(currency: true)}'),
                Text(" - "),
                Text(widget.state.pengeluaranKas
                    .fold(
                      0,
                      (previousValue, element) =>
                          previousValue +
                          (((element.data() as Map)['cost'] as int?) ?? 0),
                    )
                    .numberFormat(currency: true)),
                Text(" - "),
                Text(widget.state.pengeluaranInputBahan
                    .fold(
                      0.0,
                      (previousValue, element) => previousValue + element.price,
                    )
                    .numberFormat(currency: true)),
                Text(" = "),
                Text((totalpendapatan -
                        (widget.state.pengeluaranKas.fold(
                          0,
                          (previousValue, element) =>
                              previousValue +
                              (((element.data() as Map)['cost'] as int?) ?? 0),
                        )) -
                        (widget.state.pengeluaranInputBahan.fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.price,
                        )))
                    .numberFormatCurrency),
              ],
            ),
            Divider(),
            Text('Bahan baku'),
            Text('Expected usage:'),
            Text(groupIngredient.toString()),
            Text('Expected in stock:'),
            Text('(Stock InputPage)'),
          ],
        ),
      ),
    );
  }
}
