import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_makan/bloc/antrian/antrian_bloc.dart';
import 'package:order_makan/pages/histori_struk.dart';
import 'package:order_makan/repo/strukrepo.dart';

class AntrianPage extends StatelessWidget {
  const AntrianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Antrian')),
      body: BlocBuilder<AntrianBloc, AntrianState>(
        builder: (context, state) {
          return GridView.count(
            shrinkWrap: true,
            childAspectRatio: 5,
            crossAxisCount: 2,
            children: state.antrianStruks.map((e) {
              return InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const DisplayStruk(),
                  );
                },
                child: Card(
                    child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Nomor Struk#$e',
                          textScaleFactor: 1.2,
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
                            for (dynamic ew in e.orderItems)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(ew['title'] +
                                    ' x' +
                                    ew['count'].toString()),
                              ),
                          ],
                        ),
                      ],
                    )),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('total: xxx'),
                        ElevatedButton(
                            onPressed: () {
                              ///edit antrian. changeToComplete
                              ///
                              // print(e.key);
                              // print('a');
                              RepositoryProvider.of<StrukRepository>(context)
                                  .antrianFinish(e.strukId);
                            },
                            child: const Text('Complete order')),
                      ],
                    )
                  ],
                )),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
