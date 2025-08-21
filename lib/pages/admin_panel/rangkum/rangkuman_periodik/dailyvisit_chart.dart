import 'package:flutter/material.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyVisitChart extends StatefulWidget {
  final List<UseStrukState> struks;
  final RangkumanState state;
  DailyVisitChart({super.key, required this.state}) : struks = state.struks;

  @override
  State<DailyVisitChart> createState() => _DailyVisitChartState();
}

class _DailyVisitChartState extends State<DailyVisitChart> {
  List<MyChartData> data = [];
  List<MyChartData> data2 = [];
  @override
  void initState() {
    //get max and min
    Map perday = Map();
    data = List.generate(
      widget.state.filter.end!.subtract(Duration(days: 1)).day,
      (index) =>
          MyChartData(min: 0, weekday: 1, day: index + 1, max: 0, avg: 0),
    );
    print(data);
    widget.struks.forEach(
      (element) {
        perday[element.ordertime.day] = {
          'count': ((perday[element.ordertime.day]?['count'] as int?) ?? 0) + 1,

          // 'perhour':
          //     (perday[element.ordertime.day]['perhour'] as Map).updateAll()
        };
        // Map perhour = Map();
        // perhour[element.ordertime.hour] = {
        //   'count': (perhour[element.ordertime.hour]['count'] ?? 0) + 1,
        //   'total':
        //       (perhour[element.ordertime.hour]['total'] ?? 0) + element.total
        // };
        // perday[element.ordertime.day] = {
        //   'count': (perhour[element.ordertime.hour]['count'] ?? 0) + 1,
        //   'perhour': (perday[element.ordertime.day]['perhour'] as Map).updateAll()
        // };
      },
    );
    perday.forEach(
      (key, value) {
        data[key] = MyChartData(
            min: 10,
            max: 15,
            avg: value['count'],
            day: key,
            weekday: DateTime(widget.state.filter.start!.year,
                    widget.state.filter.start!.month, key)
                .weekday);
      },
    );
    // data = [
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 17, avg: 15),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 18, avg: 15),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 15, avg: 12),
    //   MyChartData(min: 10, max: 16, avg: 15),
    //   MyChartData(min: 10, max: 15, avg: 12),
    // ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: <CartesianSeries<MyChartData, num>>[
        // ColumnSeries<MyChartData, num>(
        //   dataSource: data,
        //   name: 'min',
        //   color: Colors.green,
        //   xValueMapper: (datum, index) => index,
        //   yValueMapper: (datum, index) => datum.min,
        // ),

        LineSeries<MyChartData, num>(
          dataSource: data,
          name: 'avg',
          // pointColorMapper: (datum, index) =>
          //     datum.weekday == 7 ? Colors.red : Colors.black,
          xValueMapper: (datum, index) => datum.day,
          yValueMapper: (datum, index) => datum.avg,
        ),
        BubbleSeries<MyChartData, num>(
          dataSource: data,
          name: 'avg',
          pointColorMapper: (datum, index) =>
              datum.weekday == 7 ? Colors.red : Colors.black,
          xValueMapper: (datum, index) => datum.day,
          yValueMapper: (datum, index) => datum.avg,
        ),
        // ColumnSeries<MyChartData, num>(
        //   dataSource: data,
        //   name: 'max',
        //   color: Colors.red,
        //   xValueMapper: (datum, index) => index,
        //   yValueMapper: (datum, index) => datum.max,
        // ),
      ],
    );
  }
}

class MyChartData {
  int day;
  int weekday;
  int min;
  int max;
  int avg;
  MyChartData({
    required this.min,
    required this.weekday,
    required this.day,
    required this.max,
    required this.avg,
  });
}
