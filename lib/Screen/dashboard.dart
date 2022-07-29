import 'package:collection/collection.dart';
import 'package:finsheet/Screen/chart/bar_chart.dart';
import 'package:finsheet/bloc/finsheet_bloc.dart';
import 'package:finsheet/data/model/fin_model.dart';
import 'package:finsheet/data/provider/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'chart/line_chart.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late TabController tabController;
  int _selectedIndex = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
        if (_selectedIndex == 0) {
          context.read<FinsheetBloc>().add(FinLoadDataEvent());
        } else if (_selectedIndex == 1) {
          context.read<FinsheetBloc>().add(FinLoadDataReportEvent());
        } else if (_selectedIndex == 2) {}
      });
      print("Selected Index: " + tabController.index.toString());
    });
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            controller: tabController,
            tabs: <Widget>[
              GestureDetector(
                onTap: () {
                  context.read<FinsheetBloc>().add(FinLoadDataEvent());
                },
                child: Tab(
                  icon: Icon(CupertinoIcons.square_pencil_fill, size: 25),
                  text: "Add expenditure",
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<FinsheetBloc>().add(FinLoadDataReportEvent());
                },
                child: Tab(
                  icon: Icon(CupertinoIcons.square_favorites_fill, size: 25),
                  text: "Report",
                ),
              ),
              Tab(
                icon: Icon(CupertinoIcons.question_square_fill, size: 25),
                text: "Add cuery",
              ),
            ],
          ),
        ),
        body: _selectedIndex == 0
            ? AddExpenditure()
            : _selectedIndex == 1
                ? Report()
                : _selectedIndex == 2
                    ? Query()
                    : Center(child: Text("${_selectedIndex}")));
  }

  Widget AddExpenditure() {
    return BlocBuilder<FinsheetBloc, FinsheetState>(
      builder: (context, state) {
        if (state is FinsheetInitialState) {
          context.read<FinsheetBloc>().add(FinLoadDataEvent());
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FinsheetLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FinsheetErrorState) {
          return const Center(
              child: Text('Something went wrong, please try again!'));
        } else if (state is FinsheetLoadedState) {
          return ListView(
            children: [
              for (FinModel fin in state.data)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black12))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                fin.tag,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                                // Provide a Key for the integration test
                                key: Key('list_item_${fin.tag}'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${fin.price.toStringAsPrecision(4)}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                // Provide a Key for the integration test
                                key: Key('list_item_${fin.price}'),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Added on ${fin.date}',
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          );
        }
        return Text('Someting went wrong');
      },
    );
  }

  Widget Report() {
    return BlocBuilder<FinsheetBloc, FinsheetState>(
      builder: (context, state) {
        print(state);
        // if (state is FinsheetInitialState) {

        //   return const Center(child: CircularProgressIndicator());
        // }
        if (state is FinsheetLoadingReportState) {
          print("report");

          return const Center(child: CircularProgressIndicator());
        } else if (state is FinsheetErrorState) {
          return const Center(
              child: Text('Something went wrong, please try again!'));
        } else if (state is FinsheetLoadedReportState) {
          // var jsonList = [];
          // for (var i in state.data) {
          //   jsonList.add(i.toJson());
          //   print(i.toJson()['date']);
          // }
          // print(jsonList);
          // var json = state.data.toJson(),
          var newMap = groupBy(state.data, (FinModel obj) => obj.date);
          Map<String, double> finMap = {};
          state.data.forEach((fin) {
            String key = DateFormat('yyyy-MM-dd').format(fin.date);
            if (finMap.containsKey(key)) {
              finMap[key] = finMap[key]! + fin.price;
            } else {
              finMap[key] = fin.price;
            }
          });
          print(finMap);
          // Map groupedAndSum = Map();

          // newMap.forEach((k, v) {
          //   groupedAndSum[k] = {
          //     'list': v,
          //     'sumOfisWatch': v.fold(0, (prev, element) => element.price),
          //   };
          // });

          // print(newMap);
          // print(groupedAndSum.toString());

          // print(newMap);
          return ListView(
            children: [
              // Container(height: 250, child: LineChartSample1(data: finMap)),
              BarChartSample3(data: finMap),
              for (FinModel fin in state.data)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black12))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18.0, horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                fin.tag,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                                // Provide a Key for the integration test
                                key: Key('list_item_${fin.tag}'),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${fin.price.toStringAsPrecision(4)}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                // Provide a Key for the integration test
                                key: Key('list_item_${fin.price}'),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Added on ${fin.date}',
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          );
        }
        return Text('Someting went wrong');
      },
    );
  }

  Widget Query() => Center(child: Text("${_selectedIndex}"));
}
