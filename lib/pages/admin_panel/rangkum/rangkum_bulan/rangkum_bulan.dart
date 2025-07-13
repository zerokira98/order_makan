import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';

class RangkumBulan extends StatelessWidget {
  const RangkumBulan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rangkuman Bulanan'),
      ),
      // bottomNavigationBar: BlocBuilder<RangkumanBloc, RangkumanState>(
      //   builder: (context, state) {
      //     return
      //   },
      // ),
      body: BlocBuilder<RangkumanBloc, RangkumanState>(
        builder: (context, state) {
          if (state.struks.isNotEmpty) {
            debugPrint(state.struks.toString());
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: state.struks.length,
                      itemBuilder: (context, index) => ListTile(
                          title:
                              Text(state.struks[index].toJson().toString()))),
                ),
                Expanded(
                  flex: 1,
                  child: SummaryContainer(
                    state: state,
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class SummaryContainer extends StatelessWidget {
  final RangkumanState state;
  const SummaryContainer({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    Map peritem = {};
    for (var e in state.struks) {
      for (var w in e.orderItems) {
        if (peritem.containsKey(w.title)) {
          peritem[w.title] += 1;
        } else {
          peritem.addAll({w.title: 1});
        }
      }
    }
    return Container(
      // height: 60,
      color: Colors.blue,
      child: Column(
        children: [
          Row(
            children: [
              Text('Pilih bulan : '),
              Flexible(
                child: TextField(
                  onTap: () {
                    showMonthYearPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now());
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), label: Text('Bulan')),
                ),
              ),
            ],
          ),
          Text('Item counts'),
          Text(peritem.toString()),
          Text('Total ${state.struks.fold(
                0,
                (previousValue, element) =>
                    previousValue + (element.total ?? 0),
              ).numberFormat(currency: true)}'),
          Text('Total tunai ${state.struks.where(
                (element) => element.tipePembayaran == TipePembayaran.tunai,
              ).fold(
                0,
                (previousValue, element) =>
                    previousValue + (element.total ?? 0),
              ).numberFormat(currency: true)}'),
          Text('Total qris${state.struks.where(
                (element) => element.tipePembayaran == TipePembayaran.qris,
              ).fold(
                0,
                (previousValue, element) =>
                    previousValue + (element.total ?? 0),
              ).numberFormat(currency: true)}'),
        ],
      ),
    );
  }
}
