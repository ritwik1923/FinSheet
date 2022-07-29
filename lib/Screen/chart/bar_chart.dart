// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

double total = 0;

class BarGraph extends StatefulWidget {
  final Map<String, double> xdata;
  const BarGraph({Key? key, required this.xdata}) : super(key: key);

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late Map<String, double> data;
  // List<FlSpot> xdata = [];
  List<String> dateList = [];
  double? mx, mn;
  @override
  Widget build(BuildContext context) {
    data = widget.xdata;
    return BarChart(
      BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: mx!, //+ 100.00,
          minY: mn),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    // String text;
    // Widget text;

    String text;

    text = "${dateList[value.ceil()]}"; // - ${dateList[value.ceil()].year
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text),
    );
    if (value.toInt() % 2 == 0) {}
    return Container();
    // switch (value.toInt()) {
    //   case 0:
    //     text = 'Mn';
    //     break;
    //   case 1:
    //     text = 'Te';
    //     break;
    //   case 2:
    //     text = 'Wd';
    //     break;
    //   case 3:
    //     text = 'Tu';
    //     break;
    //   case 4:
    //     text = 'Fr';
    //     break;
    //   case 5:
    //     text = 'St';
    //     break;
    //   case 6:
    //     text = 'Sn';
    //     break;
    //   default:
    //     text = '';
    //     break;
    // }
    // return SideTitleWidget(
    //   axisSide: meta.axisSide,
    //   space: 4.0,
    //   child: Text(text, style: style),
    // );
  }

  // Widget getTopTitles(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Color(0xff7589a2),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   // String text;
  //   // Widget text;

  //   String text;

  //   text = "Total: ${total}"; // - ${dateList[value.ceil()].year
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 10,
  //     child: Text(text),
  //   );
  //   if (value.toInt() % 2 == 0) {}
  //   return Container();
  //   // switch (value.toInt()) {
  //   //   case 0:
  //   //     text = 'Mn';
  //   //     break;
  //   //   case 1:
  //   //     text = 'Te';
  //   //     break;
  //   //   case 2:
  //   //     text = 'Wd';
  //   //     break;
  //   //   case 3:
  //   //     text = 'Tu';
  //   //     break;
  //   //   case 4:
  //   //     text = 'Fr';
  //   //     break;
  //   //   case 5:
  //   //     text = 'St';
  //   //     break;
  //   //   case 6:
  //   //     text = 'Sn';
  //   //     break;
  //   //   default:
  //   //     text = '';
  //   //     break;
  //   // }
  //   // return SideTitleWidget(
  //   //   axisSide: meta.axisSide,
  //   //   space: 4.0,
  //   //   child: Text(text, style: style),
  //   // );
  // }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups {
    mx = data[data.keys.first];
    mn = data[data.keys.first];
    List<BarChartGroupData> xdata = [];
    int indx = 0;
    data.forEach((String date, double value) {
      print('index=$indx, value=$value');
      dateList.add(date);
      xdata.add(
        BarChartGroupData(
          x: indx,
          barRods: [
            BarChartRodData(
              toY: value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
      mx = max(mx!, value);
      mn = min(mn!, value);
      setState(() {
        total = total + value;
      });
      ++indx;
    });

    return xdata;
  }
}

/*
class _BarChart extends StatelessWidget {
  final Map<String, double> data;
  _BarChart({
    Key? key,
    required this.data,
  }) : super(key: key);

  // List<FlSpot> xdata = [];
  List<String> dateList = [];
  double? mx, mn;
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: mx!, //+ 100.00,
          minY: mn),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    // String text;
    // Widget text;

    String text;

    text = "${dateList[value.ceil()]}"; // - ${dateList[value.ceil()].year
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text),
    );
    if (value.toInt() % 2 == 0) {}
    return Container();
    // switch (value.toInt()) {
    //   case 0:
    //     text = 'Mn';
    //     break;
    //   case 1:
    //     text = 'Te';
    //     break;
    //   case 2:
    //     text = 'Wd';
    //     break;
    //   case 3:
    //     text = 'Tu';
    //     break;
    //   case 4:
    //     text = 'Fr';
    //     break;
    //   case 5:
    //     text = 'St';
    //     break;
    //   case 6:
    //     text = 'Sn';
    //     break;
    //   default:
    //     text = '';
    //     break;
    // }
    // return SideTitleWidget(
    //   axisSide: meta.axisSide,
    //   space: 4.0,
    //   child: Text(text, style: style),
    // );
  }

  // Widget getTopTitles(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Color(0xff7589a2),
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   // String text;
  //   // Widget text;

  //   String text;

  //   text = "Total: ${total}"; // - ${dateList[value.ceil()].year
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 10,
  //     child: Text(text),
  //   );
  //   if (value.toInt() % 2 == 0) {}
  //   return Container();
  //   // switch (value.toInt()) {
  //   //   case 0:
  //   //     text = 'Mn';
  //   //     break;
  //   //   case 1:
  //   //     text = 'Te';
  //   //     break;
  //   //   case 2:
  //   //     text = 'Wd';
  //   //     break;
  //   //   case 3:
  //   //     text = 'Tu';
  //   //     break;
  //   //   case 4:
  //   //     text = 'Fr';
  //   //     break;
  //   //   case 5:
  //   //     text = 'St';
  //   //     break;
  //   //   case 6:
  //   //     text = 'Sn';
  //   //     break;
  //   //   default:
  //   //     text = '';
  //   //     break;
  //   // }
  //   // return SideTitleWidget(
  //   //   axisSide: meta.axisSide,
  //   //   space: 4.0,
  //   //   child: Text(text, style: style),
  //   // );
  // }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups {
    mx = data[data.keys.first];
    mn = data[data.keys.first];
    List<BarChartGroupData> xdata = [];
    int indx = 0;
    data.forEach((String date, double value) {
      print('index=$indx, value=$value');
      dateList.add(date);
      xdata.add(
        BarChartGroupData(
          x: indx,
          barRods: [
            BarChartRodData(
              toY: value,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
      mx = max(mx!, value);
      mn = min(mn!, value);

      total = total + value;
      ++indx;
    });

    return xdata;
  }
}

*/
class BarChartSample3 extends StatefulWidget {
  Map<String, double> data;
  BarChartSample3({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Total: $total"),
        // Container(
        //   height: 250,
        //   child: _BarChart(
        //     data: widget.data,
        //   ),
        // ),
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              color: const Color(0xff2c4260),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
                child: BarGraph(
                  xdata: widget.data,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
