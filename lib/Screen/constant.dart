import 'package:flutter/material.dart';

final barsGradient = const LinearGradient(
  colors: [
    Colors.lightBlueAccent,
    Colors.greenAccent,
  ],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

final kInnerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Colors.white),
  borderRadius: BorderRadius.circular(32),
);

final kGradientBoxDecoration = BoxDecoration(
  gradient: LinearGradient(colors: [Colors.black, Colors.redAccent]),
  border: Border.all(
    color: Colors.pink,
  ),
  borderRadius: BorderRadius.circular(32),
);

double const_padding = 10;

enum ReportType { yearly, monthly, daily, hourly }

extension DateTimeExtension on DateTime {
  String getMonthString() {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Err';
    }
  }

  String getWeekdayString() {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Err';
    }
  }
}
