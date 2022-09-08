// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:finsheet/Screen/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


class BarGraph extends StatefulWidget {
  final Map<DateTime, double> xdata;
  final bool hourly;
  const BarGraph({Key? key, required this.xdata, required this.hourly})
      : super(key: key);

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late Map<DateTime, double> data;
  // List<FlSpot> xdata = [];
  List<DateTime> dateList = [];
  double? mx, mn;
  double total = 0;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    data = widget.xdata;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        padding: const EdgeInsets.fromLTRB(5, 50, 5, 20),
        child: data.isNotEmpty
            ? BarChart(
                BarChartData(
                    barTouchData: barTouchData,
                    titlesData: titlesData,
                    borderData: borderData,
                    barGroups: barGroups,
                    gridData: FlGridData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                    maxY: mx!, //+ 100.00,
                    minY: 0 //min(mn!, mx! / 2),
                    ),
              )
            : Center(child: Text("Enter data")),
      ),
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
    var w = MediaQuery.of(context).size.width;
    print("w: $w len: ${data.length}");
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    // String text;
    // Widget text;

    String text;
    if (widget.hourly)
      text =
          "${dateList[value.ceil()].hour}-${dateList[value.ceil()].day}"; // - ${dateList[value.ceil()].year
    else
      text =
          "${dateList[value.ceil()].day}-${dateList[value.ceil()].getMonthString()}"; // - ${dateList[value.ceil()].year
    return Transform.rotate(
      // turns: AlwaysStoppedAnimation( / 360),
      angle: w < 400 ? -pi / 2 : 0,
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Container(
          margin: EdgeInsets.only(right: w < 400 ? 15.0 : 0),
          child: Text(text,
              style: TextStyle(
                  height: 1.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

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

  List<BarChartGroupData> get barGroups {
    var w = MediaQuery.of(context).size.width;
    print("w: $w len: ${data.length}");
    mx = data[data.keys.first];
    mn = data[data.keys.first];
    List<BarChartGroupData> xdata = [];
    int indx = 0;
    data.forEach((DateTime date, double value) {
      print('index=$indx, value=$value');
      dateList.add(date);
      xdata.add(
        BarChartGroupData(
          x: indx,
          barRods: [
            BarChartRodData(
              toY: value,
              gradient: barsGradient,
              width: max(8, w / (data.length + 5)),
              borderRadius: BorderRadius.zero,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
      mx = max(mx!, value);
      mn = min(mn!, value);
      setState(() {
        total = total + value;
        print(total);
      });
      ++indx;
    });

    return xdata;
  }
}
