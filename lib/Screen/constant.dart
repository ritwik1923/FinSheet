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
