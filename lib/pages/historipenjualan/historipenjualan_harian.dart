import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/strukrepo.dart';

class HistoriPenjualanHarian extends StatelessWidget {
  const HistoriPenjualanHarian({super.key});
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var filtertoday = StrukFilter(
        start: DateTime(now.year, now.month, now.day),
        end: DateTime(now.year, now.month, now.day + 1));
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori Penjualan Hari ini'),
      ),
      body: FutureBuilder(
        future: (
          RepositoryProvider.of<StrukRepository>(context).readStrukwithFilter(
            filtertoday,
          ),
          RepositoryProvider.of<KasRepository>(context)
              .getPengeluaran(start: filtertoday.start!, end: filtertoday.end!),
          RepositoryProvider.of<KasRepository>(context).getUangLaciHarian()
        ).wait,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ///datas
            List<UseStrukState> datastruks = snapshot.data!.$1;
            int uanglaci = ((snapshot.data?.$3.data()?['uang'] as int?) ?? 0);
            int pengeluaran = snapshot.data!.$2.docs.fold(
              0,
              (previousValue, element) =>
                  previousValue + (element.data()['cost'] as int),
            );
            int totalpendapatan = datastruks.fold(
              0,
              (previousValue, element) => previousValue + (element.total!),
            );

            ///widget
            return RefreshIndicator(
              onRefresh: () {
                return Future.delayed(Durations.medium1);
              },
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => DisplayStruk(
                                    data: datastruks[index],
                                    viewonly: true,
                                  ));
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                                    "Nomor Antrian: ${datastruks[index].nomorAntrian}")),
                            Text(datastruks[index]
                                    .total
                                    ?.numberFormat(currency: true) ??
                                '')
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(datastruks[index].orderItems.map(
                                (e) {
                                  return "${e.title}${e.submenues.isEmpty ? '' : '*'} ${e.count}x";
                                },
                              ).toString()),
                            ),
                            Text(datastruks[index].ordertime.formatLengkap()),
                            Text(datastruks[index].ordertime.clockOnly()),
                          ],
                        ),
                      ),
                      itemCount: datastruks.length,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration:
                              BoxDecoration(color: Colors.grey.withAlpha(125)),
                          child: Column(
                            children: [
                              Text(
                                'Total pendapatan: ${totalpendapatan.numberFormat(currency: true)}',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                  'Pengeluaran: ${pengeluaran.numberFormatCurrency}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Uang laci awal: ${uanglaci.numberFormat(currency: true)}'),
                                  Padding(
                                      padding: EdgeInsetsGeometry.symmetric(
                                          horizontal: 18)),
                                  Text(
                                      'Uang laci akhir: ${(uanglaci + totalpendapatan - pengeluaran).numberFormat(currency: true)} '),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
