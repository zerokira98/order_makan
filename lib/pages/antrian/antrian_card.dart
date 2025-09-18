part of 'antrian_main.dart';

class AntrianCard extends StatefulWidget {
  final UseStrukState e;
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
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 75 + ((diff * 4) >= 150 ? 150 : (diff * 4)),
                  130 - ((diff * 2) >= 100 ? 100 : (diff * 2)), 70),
              Colors.grey
            ])),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Antrian : ${widget.e.nomorAntrian}',
                        textScaler: TextScaler.linear(1.5),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Flexible(child: DateTimer(ordertime: widget.e.ordertime))
                  ],
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: [
                          for (StrukItem ew in widget.e.orderItems)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('${ew.title} x${ew.count}'),
                                  Text('${ew.submenues.map(
                                        (e) => e.title,
                                      ).toList()}'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                )),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total: ${widget.e.orderItems.fold(
                            0,
                            (previousValue, element) =>
                                previousValue + (element.count * element.price),
                          ).numberFormat(currency: true)}',
                      textAlign: TextAlign.end,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
