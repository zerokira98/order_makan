part of 'antrian_main.dart';

class AntrianCard extends StatefulWidget {
  final StrukState e;
  const AntrianCard({super.key, required this.e});

  @override
  State<AntrianCard> createState() => _AntrianCardState();
}

class _AntrianCardState extends State<AntrianCard> {
  late Timer timer;
  var diff = 0;
  @override
  void initState() {
    diff = DateTime.now().difference(widget.e.ordertime).inMinutes;
    timer = Timer.periodic(
        Duration(minutes: 1),
        (timer) => setState(() {
              diff = DateTime.now().difference(widget.e.ordertime).inMinutes;
            }));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color.fromARGB(
            255, 90 + ((diff * 5) >= 150 ? 150 : (diff * 5)), 100, 90),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Text(
                      'Struk #${widget.e.strukId}',
                      textScaler: TextScaler.linear(1.2),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Flexible(child: DateTimer(ordertime: widget.e.ordertime))
                ],
              ),
              Expanded(
                  child: Row(
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      for (StrukItem ew in widget.e.orderItems)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(ew.title + ' x' + ew.count.toString()),
                        ),
                    ],
                  ),
                ],
              )),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'total: ${widget.e.orderItems.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + (element.count * element.price),
                    )}',
                    textAlign: TextAlign.end,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       ///edit antrian. changeToComplete
                  //       ///
                  //       // print(e.key);
                  //       // print('a');
                  //       if (e.strukId == null) throw Exception();
                  //       RepositoryProvider.of<StrukRepository>(context)
                  //           .finishAntrian(e.strukId!);
                  //     },
                  //     child: const Text('Complete order')),
                ],
              )
            ],
          ),
        ));
  }
}
