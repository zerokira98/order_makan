import 'package:flutter/material.dart';
import 'package:order_makan/bloc/use_struk/struk_state.dart';
import 'package:order_makan/pages/admin_panel/rangkum/bloc/rangkuman_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyVisitChart extends StatelessWidget {
  final List<UseStrukState> struks;
  final RangkumanState state;
  DailyVisitChart({super.key, required this.state}) : struks = state.struks;

  @override
  Widget build(BuildContext context) {
    List<MyChartData> data = [];
    Map perday = {};
    data = List.generate(
      state.filter.end!.subtract(Duration(days: 1)).day,
      (index) =>
          MyChartData(min: 0, weekday: 1, day: index + 1, max: 0, avg: 0),
    );
    print(data);
    for (var element in struks) {
      perday[element.ordertime.day] = {
        'count': ((perday[element.ordertime.day]?['count'] as int?) ?? 0) + 1,
      };
    }
    perday.forEach(
      (key, value) {
        data[key] = MyChartData(
            min: 10,
            max: 15,
            avg: value['count'],
            day: key,
            weekday: DateTime(
                    state.filter.start!.year, state.filter.start!.month, key)
                .weekday);
      },
    );
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
