import 'dart:math';

import 'package:collection/collection.dart';
import 'package:faker/faker.dart';
import 'package:finsheet/Screen/addData.dart';
import 'package:finsheet/Screen/chart/bar_chart.dart';
import 'package:finsheet/Screen/constant.dart';
import 'package:finsheet/Screen/order_data_table.dart';
import 'package:finsheet/bloc/finsheet_bloc.dart';
import 'package:finsheet/data/model/entities.dart';
// import 'package:finsheet/data/model/fin_model.dart';
import 'package:finsheet/data/provider/database.dart';
import 'package:finsheet/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'chart/line_chart.dart';

// TODO check graph accuricy
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
  int _selectedIndex = 0;
  final _priceInputController = TextEditingController();
  final _commentInputController = TextEditingController();
  final _tagInputController = TextEditingController();
  bool type = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });
      print("Selected Index: " + tabController.index.toString());
    });
  }

  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            // expandedHeight: 260.0,
            primary: true,
            // pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                widget.title,
              ),
            ),
            leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            actions: [
              PopupMenuButton(
                  onSelected: (String value) {
                    // do something with the selected value here
                  },
                  itemBuilder: (BuildContext ctx) => [
                        const PopupMenuItem(
                            value: '1', child: Text('Option 1')),
                        const PopupMenuItem(
                            value: '2', child: Text('Option 2')),
                        const PopupMenuItem(
                            value: '3', child: Text('Option 3')),
                        const PopupMenuItem(
                            value: '4', child: Text('Option 4')),
                      ])
            ],
          ),
          SliverAppBar(
            // expandedHeight: 260.0,
            primary: true,
            pinned: true,
            flexibleSpace: TabBar(
              controller: tabController,
              tabs: [
                Tab(
                  icon: Icon(CupertinoIcons.square_pencil_fill, size: 25),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(CupertinoIcons.square_favorites_fill, size: 25),
                  text: "Report",
                ),
                Tab(
                  icon: Icon(CupertinoIcons.question_square_fill, size: 25),
                  text: "Add cuery",
                ),
              ],
            ),
          ),
        ];
      },
      body: BlocBuilder<FinsheetBloc, FinsheetState>(
        builder: (context, state) {
          print(state);
          if (state is FinsheetInitialState) {
            context.read<FinsheetBloc>().add(FinLoadDataDBEvent());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FinsheetLoadingDBState) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.purple,
            ));
          } else if (state is FinsheetLoadedDBState) {
            var _streamtag = state.getallTags();
            var _stream = state.getMonthlyExpense();
            var _store = state.store;
            Future<void> _addprice() async {
              if (_priceInputController.text.isEmpty ||
                  _tagInputController.text.isEmpty) return;
              print(
                  "${_priceInputController.text} ${_tagInputController.text} \n${_commentInputController.text}");
              FinModel order = FinModel(
                  price: double.parse(_priceInputController.text),
                  comments: _commentInputController.text,
                  createdTime: DateTime.now(),
                  updatedTime: DateTime.now(),
                  type: type);

              order.tag.target = TagModel(tag: _tagInputController.text);
              state.addFin(order);
              _priceInputController.text = '';
              _tagInputController.text = '';
              _commentInputController.text = '';
            }

            List<TagModel> tags = [
              TagModel(tag: "food"),
              TagModel(tag: "books"),
              TagModel(
                tag: "travel",
              ),
              TagModel(
                tag: "cloth",
              ),
              TagModel(
                tag: "college",
              ),
              TagModel(
                tag: "personal",
              ),
              TagModel(tag: "grooming"),
            ];
            // TODO creating same tag again baal amar
            Future<void> _addfakeprice() async {
              var faker = Faker();
              var rng = Random();
              DateTime time = DateTime.utc(
                  DateTime.now().year - rng.nextInt(1),
                  rng.nextInt(12) + 1,
                  rng.nextInt(15) + 1,
                  rng.nextInt(24),
                  rng.nextInt(60));

              FinModel order = FinModel(
                  price: rng.nextInt(200) * 1.00,
                  comments: lorem(paragraphs: 1, words: 5),
                  createdTime: time,
                  updatedTime: time,
                  type: rng.nextInt(200) % 2 == 0);

              order.tag.target = tags[rng.nextInt(tags.length)];
              state.addFin(order);
              print(
                  "${_priceInputController.text} ${_tagInputController.text} \n${_commentInputController.text}");

              // state.store.box<FinModel>().put(order);
            }

            return TabBarView(
              controller: tabController,
              children: [
                // todo: add expenditure
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddData()));
                    },
                    child: Icon(Icons.add),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<List<FinModel>>(
                              stream: state.getAllExpense(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                double debit, credit;
                                debit = credit = 0;
                                for (var f in snapshot.data!) {
                                  if (f.type) {
                                    debit += f.price;
                                  } else {
                                    credit += f.price;
                                  }
                                }
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${debit}",
                                                  style:
                                                      TextStyle(fontSize: 40),
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(.5)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .call_received_outlined,
                                                      color: Colors.blueAccent,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "debit".toUpperCase(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "${credit}",
                                                  style:
                                                      TextStyle(fontSize: 40),
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(.5)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                    ),
                                                    child: Icon(
                                                      Icons.call_made_outlined,
                                                      color: Colors.redAccent,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "credit".toUpperCase(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    for (int i = 0; i < 20; ++i)
                                      await _addfakeprice();
                                  },
                                  icon: Icon(Icons.add)),
                              IconButton(
                                  onPressed: () async {
                                    await state.delFinAll();
                                  },
                                  icon: Icon(Icons.minimize)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Today Expenditure Chart",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: EdgeInsets.all(const_padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder<List<FinModel>>(
                                      stream: state.getTodayExpense(65),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return OrderDataTable(
                                          reporttype: ReportType.hourly,
                                          orders: snapshot.data!,
                                          onSort: (columnIndex, ascending) {
                                            final newQueryBuilder =
                                                _store.box<FinModel>().query();
                                            final sortField = FinModel_.id;
                                            // columnIndex == 0 ? FinModel_.id: FinModel_.price;
                                            newQueryBuilder.order(
                                              sortField,
                                              flags: ascending
                                                  ? 0
                                                  : Order.descending,
                                            );

                                            setState(() {
                                              _stream = newQueryBuilder
                                                  .watch(
                                                      triggerImmediately: true)
                                                  .map((query) => query.find());
                                            });
                                          },
                                          store: _store,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Last 7 days Expenditure Chart",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: EdgeInsets.all(const_padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder<List<FinModel>>(
                                      stream: state.getWeeklyExpense(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return OrderDataTable(
                                          reporttype: ReportType.hourly,
                                          orders: snapshot.data!,
                                          onSort: (columnIndex, ascending) {
                                            final newQueryBuilder =
                                                _store.box<FinModel>().query();
                                            final sortField = FinModel_.id;
                                            // columnIndex == 0 ? FinModel_.id: FinModel_.price;
                                            newQueryBuilder.order(
                                              sortField,
                                              flags: ascending
                                                  ? 0
                                                  : Order.descending,
                                            );

                                            setState(() {
                                              _stream = newQueryBuilder
                                                  .watch(
                                                      triggerImmediately: true)
                                                  .map((query) => query.find());
                                            });
                                          },
                                          store: _store,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // TODO: Report
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(height: 250, child: LineChartSample1(data: finMap)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Monthly Expenditure",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 400),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder<List<FinModel>>(
                                        stream: state.getAllExpense(),
                                        // stream: state.getAllExpense(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          var orders = snapshot.data!;
                                          var newMap = groupBy(
                                              orders,
                                              (FinModel obj) =>
                                                  obj.createdTime);
                                          double total = 0;

                                          SplayTreeMap<DateTime, double>
                                              debitMap =
                                              SplayTreeMap<DateTime, double>();
                                          SplayTreeMap<DateTime, double>
                                              creditMap =
                                              SplayTreeMap<DateTime, double>();
                                          List<DateTime> months = [];
                                          orders.forEach((fin) {
                                            // group by only day
                                            DateTime key;

                                            key = DateTime.utc(
                                              fin.createdTime.year,
                                              fin.createdTime.month,
                                            );
                                            months.add(key);
                                            if (fin.type) {
                                              if (debitMap.containsKey(key)) {
                                                debitMap[key] =
                                                    debitMap[key]! + fin.price;
                                              } else {
                                                debitMap[key] = fin.price;
                                              }
                                            } else {
                                              if (creditMap.containsKey(key)) {
                                                creditMap[key] =
                                                    creditMap[key]! + fin.price;
                                              } else {
                                                creditMap[key] = fin.price;
                                              }
                                            }
                                            print(total);
                                          });
                                          months = months.toSet().toList();
                                          return SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                for (DateTime month in months)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          // Text("${month}"),
                                                          Text(
                                                              "${month.getMonthString()} ${month.year}"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .5)),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5)),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .call_received_outlined,
                                                              color: Colors
                                                                  .blueAccent,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                              "${debitMap[month]}"),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .5)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .call_made_outlined,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 18,
                                                            ),
                                                          ),
                                                          Text(
                                                              "${creditMap[month]}"),
                                                        ],
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Divider(),
                                                      ),
                                                    ],
                                                  )
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tag Baised Expenditure",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 400),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StreamBuilder<List<FinModel>>(
                                        stream: state.getAllExpense(),
                                        // stream: state.getAllExpense(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          var newMap = groupBy(snapshot.data!,
                                              (FinModel obj) => obj.tag);
                                          double total = 0;
                                          var orders = snapshot.data!;
                                          // });
                                          SplayTreeMap<String, double> finMap =
                                              SplayTreeMap<String, double>();
                                          orders.forEach((fin) {
                                            // group by only day
                                            String key;
                                            bool type = fin.type;
                                            key = fin.tag.target!.tag;
                                            if (finMap.containsKey(key)) {
                                              finMap[key] =
                                                  finMap[key]! + fin.price;
                                            } else {
                                              finMap[key] = fin.price;
                                            }
                                            total += fin.price;
                                            print(total);
                                          });

                                          return SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                for (var key in finMap.keys)
                                                  Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          // Text("$v\t ${finMap[v]}"),
                                                          TextButton(
                                                              onPressed: () {
                                                                // TODO: Tag detail
                                                                /*    
                                                                                   showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Material(
                                        child: ListView(
                                          
                                          children: order.tag.target!.orders.map(
                                            (_) {
                                              print(
                                                      '${_.id}    ${_.tag.target?.tag}    \$${_.price}    \$${_.createdTime}    \$${_.updatedTime} \$${_.comments}');
                                              return ListTile(
                                                title: Text(
                                                        '${_.id}    ${_.tag.target?.tag}    \$${_.price}}'),
                                                // trailing: Text(
                                                //   "${_.comments}",
                                                //   overflow: TextOverflow.ellipsis,
                                                // ),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      );

                                    },
                                  );
                                  */
                                                              },
                                                              child: Text(key)),
                                                          Text("${finMap[key]}")
                                                        ],
                                                      ),
                                                      Divider(),
                                                    ],
                                                  )

                                                // for (var v in finMap.values)
                                                //   Text("$v")
                                                // finMap.
                                                //                                       finMap.forEach((level, players) =>
                                                //  print(level);
                                                //  print(players);

                                                // )
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(height: 250, child: LineChartSample1(data: finMap)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Pick Date to see Expenditure",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        // TODO Show data on picker date
                        /*
                        Container(
                          constraints: BoxConstraints(maxHeight: 400),
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                height: 80,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Selected date: $_selectedDate'),
                                    Text('Selected date count: $_dateCount'),
                                    Text('Selected range: $_range'),
                                    Text('Selected ranges count: $_rangeCount')
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 80,
                                right: 0,
                                bottom: 0,
                                child: SfDateRangePicker(
                                  onSelectionChanged: _onSelectionChanged,
                                  selectionMode:
                                      DateRangePickerSelectionMode.range,
                                  initialSelectedRange: PickerDateRange(
                                      DateTime.now()
                                          .subtract(const Duration(days: 4)),
                                      DateTime.now()
                                          .add(const Duration(days: 3))),
                                ),
                              )
                            ],
                          ),
                        ),
                   */
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<List<FinModel>>(
                                    stream: state.getDateExpense(
                                        DateTime.now(), DateTime.now()),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return OrderDataTable(
                                        showchart: false,
                                        reporttype: ReportType.hourly,
                                        orders: snapshot.data!,
                                        onSort: (columnIndex, ascending) {
                                          final newQueryBuilder =
                                              _store.box<FinModel>().query();
                                          final sortField = FinModel_.id;
                                          // columnIndex == 0 ? FinModel_.id: FinModel_.price;
                                          newQueryBuilder.order(
                                            sortField,
                                            flags: ascending
                                                ? 0
                                                : Order.descending,
                                          );

                                          setState(() {
                                            _stream = newQueryBuilder
                                                .watch(triggerImmediately: true)
                                                .map((query) => query.find());
                                          });
                                        },
                                        store: _store,
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        /*
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: EdgeInsets.all(const_padding),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          for (FinModel fin in state.data)
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black12))),
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
                            )
                        ]),
                      ),
                    ),
                  ),
                  
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
              */
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Text('Someting went wrong');
          }
        },
      ),
    ));
  }

/*
  Widget AddExpenditure() {
    // var newMap = groupBy(state., (FinModel obj) => obj.date);
    // double total = 0;

    // // });
    // SplayTreeMap<DateTime, double> finMap =
    //     SplayTreeMap<DateTime, double>();
    // state.data.forEach((fin) {
    //   // group by only day
    //   DateTime key = DateTime.utc(
    //     fin.date.year,
    //     fin.date.month,
    //     fin.date.day,
    //     fin.date.hour,
    //   );
    //   if (finMap.containsKey(key)) {
    //     finMap[key] = finMap[key]! + fin.price;
    //   } else {
    //     finMap[key] = fin.price;
    //   }
    //   total += fin.price;
    // });
    // print(finMap);
    // print(finMap);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addprice(),
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add Expenditure",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: Padding(
                  padding: EdgeInsets.all(const_padding),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, top: 8),
                              child: TextField(
                                controller: _tagInputController,
                                key: const Key('input'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      // borderSide: BorderSide(color: Colors.teal),
                                      ),
                                  hintText: 'Enter Tag',
                                  helperText: 'Write new tag here.',
                                  labelText: 'Tag',
                                  // prefixIcon: const Icon(
                                  //   Icons.person,
                                  //   color: Colors.green,
                                  // ),
                                  // prefixText: ' ',
                                  // suffixText: 'USD',
                                  // suffixStyle: const TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, top: 8),
                              child: TextField(
                                controller: _priceInputController,
                                key: const Key('input'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      // borderSide: BorderSide(color: Colors.teal),
                                      ),
                                  hintText: 'Enter Price',
                                  helperText: 'Write Price here.',
                                  labelText: 'Price',
                                  // prefixIcon: const Icon(
                                  //   Icons.person,
                                  //   color: Colors.green,
                                  // ),
                                  // prefixText: ' ',
                                  // suffixText: 'USD',
                                  // suffixStyle: const TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: TextField(
                          controller: _commentInputController,
                          key: const Key('input'),
                          keyboardType: TextInputType.multiline,
                          minLines: 3, //Normal textInputField will be displayed
                          maxLines:
                              5, // when user presses enter it will adapt to it
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                // borderSide: BorderSide(color: Colors.teal),
                                ),
                            hintText: 'Enter comment',
                            helperText: 'Write comment here.',
                            labelText: 'comment',
                            // prefixIcon: const Icon(
                            //   Icons.person,
                            //   color: Colors.green,
                            // ),
                            // prefixText: ' ',
                            // suffixText: 'USD',
                            // suffixStyle: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: RaisedButton(
                      //       // padding: EdgeInsets.all(50),
                      //       onPressed: () => _addprice(),
                      //       child: Text("Add"),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Today Expenditure Chart",
                  style: TextStyle(fontSize: 20),
                ),
              ),

              /*       Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: EdgeInsets.all(const_padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${total.toStringAsFixed(2)}",
                              key: Key("${total.toStringAsFixed(2)}"),
                              style: TextStyle(
                                  height: 1.0,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            BarGraph(xdata: finMap, hourly: true),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: EdgeInsets.all(const_padding),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            for (FinModel fin in state.data)
                              Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.black12))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
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
                              )
                          ]),
                        ),
                      ),
                    ),
           
           */
            ],
          ),
        ),
      ),
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
          var newMap = groupBy(state.data, (FinModel obj) => obj.date);
          double total = 0;
          SplayTreeMap<DateTime, double> finMap =
              SplayTreeMap<DateTime, double>();
          state.data.forEach((fin) {
            // group by only day
            DateTime key = DateTime.utc(
              fin.date.year,
              fin.date.month,
              fin.date.day,
            );
            if (finMap.containsKey(key)) {
              finMap[key] = finMap[key]! + fin.price;
            } else {
              finMap[key] = fin.price;
            }
            total += fin.price;
          });
          print(finMap);
          // finMap = SplayTreeMap<Datetime,double>.from(finMap, (a, b) => a < b));
          return 
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(height: 250, child: LineChartSample1(data: finMap)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Monthly Expenditure",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${total.toStringAsFixed(2)}",
                            key: Key("${total.toStringAsFixed(2)}"),
                            style: TextStyle(
                                height: 1.0,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          BarGraph(xdata: finMap, hourly: true),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    child: Padding(
                      padding: EdgeInsets.all(const_padding),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          for (FinModel fin in state.data)
                            Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black12))),
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
                            )
                        ]),
                      ),
                    ),
                  ),
                  /* 
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
              */
                ],
              ),
            ),
          );
        }
        return Text('Someting went wrong');
      },
    );
  }
*/
  Widget Query() => Center(child: Text("${_selectedIndex}"));
}
