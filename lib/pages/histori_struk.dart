import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        List ewe = e['orderItems'] as List;
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
                                    'Nomor Struk#${e.key}',
                                    textScaleFactor: 1.2,
                                    textAlign: TextAlign.left,
                                  ),
                                  Expanded(child: Container()),
                                  Text(e['timestamp'].toString())
                                ],
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: [
                                      for (dynamic ew in ewe)
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
  const DisplayStruk({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('display struk'),
      ),
    );
  }
}
