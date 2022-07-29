// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  Map<DateTime, double> data;
  _LineChart({
    Key? key,
    required this.isShowingMainData,
    required this.data,
  }) : super(key: key);

  final bool isShowingMainData;

  List<FlSpot> xdata = [];
  List<DateTime> dateList = [];
  double? mx, mn;
  @override
  Widget build(BuildContext context) {
    mx = data[data.keys.first];
    mn = data[data.keys.first];
    var value = [];
    double indx = 0;
    data.forEach((DateTime date, double value) {
      print('index=$date, value=$value');
      dateList.add(date);
      xdata.add(FlSpot(indx, value));
      mx = max(mx!, value);
      mn = min(mn!, value);
      ++indx;
    });
    // xdata = [
    //   FlSpot(1, 1),
    //   FlSpot(3, 2.8),
    //   FlSpot(7, 1.2),
    //   FlSpot(10, 2.8),
    //   FlSpot(12, 2.6),
    //   FlSpot(13, 3.9),
    // ];
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        // maxX: mx,
        maxY: mx,
        minY: mn,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        // maxX: mx,
        maxY: mx,
        minY: mn,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        // lineChartBarData1_2,
        // lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        // lineChartBarData2_2,
        // lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    if (value.toInt() % 10 == 0) {
      String text;

      text = "${value.ceil()}";
      return Text(text, style: style, textAlign: TextAlign.center);
    }
    return Container();
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;

    if (value.toInt() % 7 == 0) {
      String text;

      text =
          "${dateList[value.ceil()].day} - ${dateList[value.ceil()].month} - ${dateList[value.ceil()].year}";
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(text),
      );
    }
    return Container();
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      isCurved: true,
      color: const Color(0xff4af699),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: xdata);
/*
  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0xffaa4cfc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: const Color(0x00aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: const Color(0xff27b6fc),
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );
*/
  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color(0x444af699),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: xdata,
      );
/*
  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
        isCurved: true,
        color: const Color(0x99aa4cfc),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: const Color(0x33aa4cfc),
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: const Color(0x4427b6fc),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(6, 5),
          FlSpot(10, 3.3),
          FlSpot(13, 4.5),
        ],
      );
*/
}

class LineChartSample1 extends StatefulWidget {
  final data;
  const LineChartSample1({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          gradient: LinearGradient(
            colors: [
              Color(0xff2c274c),
              Color(0xff46426c),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 37,
                ),
                const Text(
                  'Unfold Shop 2018',
                  style: TextStyle(
                    color: Color(0xff827daa),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Monthly Sales',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 37,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: _LineChart(
                        data: widget.data,
                        isShowingMainData: isShowingMainData),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
              ),
              onPressed: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
