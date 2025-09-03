import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/helper.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/firestore_kas.dart';
import 'package:order_makan/repo/strukrepo.dart';

class HistoriPenjualanHarian extends StatelessWidget {
  const HistoriPenjualanHarian({super.key});
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('Histori Penjualan Hari ini'),
      ),
      body: FutureBuilder(
        future: RepositoryProvider.of<StrukRepository>(context)
            .readStrukwithFilter(StrukFilter(
                start: DateTime(now.year, now.month, now.day),
                end: DateTime(now.year, now.month, now.day + 1))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // debugPrint(snapshot.data.toString());
            var data = snapshot.data;
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
                                    data: data[index],
                                    viewonly: true,
                                  ));
                          // Dialog.fullscreen(
                          //       child: Scaffold(
                          //         appBar: AppBar(
                          //           title: Text('Details'),
                          //         ),
                          //         body: Center(
                          //           child: SingleChildScrollView(
                          //               child: StrukDataTable(
                          //                   data: data[index])),
                          //         ),
                          //       ),
                          //     ));
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                                    "Nomor Antrian: ${data[index].nomorAntrian}")),
                            Text(data[index].ordertime.formatLengkap()),
                            Text(data[index].ordertime.clockOnly()),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data[index].orderItems.map(
                              (e) {
                                return "${e.title}${e.submenues.isEmpty ? '' : '*'} ${e.count}x";
                              },
                            ).toString()),
                            Text(data[index]
                                    .total
                                    // .orderItems
                                    // .fold(
                                    //   0,
                                    //   (previousValue, element) =>
                                    //       previousValue +
                                    //       (element.price * element.count),
                                    // )
                                    ?.numberFormat(currency: true) ??
                                '')
                          ],
                        ),
                      ),
                      itemCount: data!.length,
                      // children: [
                      //   Text('total : ${snapshot.data!.fold(
                      //     0,
                      //     (previousValue, element) =>
                      //         previousValue +
                      //         (element.orderItems.fold(
                      //           0,
                      //           (previousValue1, element1) =>
                      //               previousValue1 + (element1.count * element1.price),
                      //         )),
                      //   )}')
                      // ],
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
                                'Total: ${data.fold(
                                      0,
                                      (previousValue, element) =>
                                          previousValue + (element.total!),
                                    ).numberFormat(currency: true)}',
                                textAlign: TextAlign.center,
                              ),
                              FutureBuilder(
                                  future: RepositoryProvider.of<KasRepository>(
                                          context)
                                      .getUangLaciHarian(),
                                  builder: (context, asyncSnapshot) {
                                    if (asyncSnapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              'Uang laci awal: ${(asyncSnapshot.data?.data()?['uang'] as int?)?.numberFormat(currency: true)}'),
                                          Padding(
                                              padding:
                                                  EdgeInsetsGeometry.symmetric(
                                                      horizontal: 18)),
                                          Text('Uang laci akhir: ${(((asyncSnapshot.data?.data()?['uang'] as int?) ?? 0) + data.fold(
                                                0,
                                                (previousValue, element) =>
                                                    previousValue +
                                                    (element.total!),
                                              )).numberFormat(currency: true)}'),
                                        ],
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  }),
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
