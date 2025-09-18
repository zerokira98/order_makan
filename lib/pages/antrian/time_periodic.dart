import 'dart:async';

import 'package:flutter/material.dart';
import 'package:order_makan/helper.dart';

class DateTimer extends StatefulWidget {
  final DateTime ordertime;
  const DateTimer({super.key, required this.ordertime});

  @override
  _DateTimerState createState() => _DateTimerState();
}

class _DateTimerState extends State<DateTimer> {
  late Timer timer;
  var now = DateTime.now();
  @override
  void initState() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(
        () {
          now = DateTime.now();
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      now.difference(widget.ordertime).clockDetails(),
      textAlign: TextAlign.end,
    );
  }
}
