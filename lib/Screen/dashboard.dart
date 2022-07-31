import 'package:collection/collection.dart';
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
import 'dart:collection';

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
  int _selectedIndex = 0;
  final _priceInputController = TextEditingController();
  final _commentInputController = TextEditingController();
  final _tagInputController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
        //   if (_selectedIndex == 0) {
        //     context.read<FinsheetBloc>().add(FinLoadDataEvent());
        //   } else if (_selectedIndex == 1) {
        //     context.read<FinsheetBloc>().add(FinLoadDataReportEvent());
        //   } else if (_selectedIndex == 2) {}
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

  Widget DataEntry() {
    double const_padding = 0;
    return SingleChildScrollView(
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
          Padding(
            padding: EdgeInsets.all(const_padding),
            child: Form(
              key: _formKey,
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
                          child: TextFormField(
                            controller: _tagInputController,
                            key: const Key('input'),
                            validator: (value) =>
                                value!.isEmpty ? 'tag cannot be blank' : null,
                            decoration: const InputDecoration(
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
                          child: TextFormField(
                            controller: _priceInputController,
                            key: const Key('input'),
                            validator: (value) =>
                                value!.isEmpty ? 'price cannot be blank' : null,
                            decoration: const InputDecoration(
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
                    child: TextFormField(
                      controller: _commentInputController,
                      key: const Key('input'),
                      keyboardType: TextInputType.multiline,
                      minLines: 3, //Normal textInputField will be displayed
                      maxLines:
                          5, // when user presses enter it will adapt to it
                      decoration: const InputDecoration(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
              /*
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  // popupmenu item 1
                  PopupMenuItem(
                    value: 1,
                    // row has two child icon and text.
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(
                          // sized box with width 10
                          width: 10,
                        ),
                        Text("Export")
                      ],
                    ),
                  ),
                  // popupmenu item 2
                  PopupMenuItem(
                    value: 2,
                    // row has two child icon and text
                    child: Row(
                      children: [
                        Icon(Icons.chrome_reader_mode),
                        SizedBox(
                          // sized box with width 10
                          width: 10,
                        ),
                        Text("Import")
                      ],
                    ),
                  ),
                ],
                offset: Offset(0, 100),
                color: Colors.grey,
                elevation: 2,
              ),
           
           */ // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Icons.more_vert_outlined),
              // )
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
                  updatedTime: DateTime.now());

              order.tag.target = TagModel(tag: _tagInputController.text);
              state.store.box<FinModel>().put(order);
              _priceInputController.text = '';
              _tagInputController.text = '';
              _commentInputController.text = '';
            }

            return TabBarView(
              controller: tabController,
              children: [
                // todo: add expenditure
                Scaffold(
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      // showModalBottomSheet(
                      //     context: context,
                      //     builder: (context) {
                      //       return Container(
                      //         child: Padding(
                      //           padding: EdgeInsets.only(
                      //               bottom: MediaQuery.of(context)
                      //                   .viewInsets
                      //                   .bottom),
                      //           child: TextField(
                      //             autofocus: true,
                      //           ),
                      //         ),
                      //       );
                      //     });

                      showModalBottomSheet(
                          // isDismissible: false, // <--- this line
                          isScrollControlled: true,
                          builder: (context) {
                            return FractionallySizedBox(
                                heightFactor: 0.7,
                                child: Container(
                                  // padding: EdgeInsets.only(
                                  //     bottom: MediaQuery.of(context)
                                  //         .viewInsets
                                  //         .bottom),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    child: Material(
                                        child: SingleChildScrollView(
                                      // title: Text('Add Data'),
                                      child: Column(
                                        children: [
                                          DataEntry(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              RaisedButton(
                                                  child: Text("Submit"),
                                                  onPressed: () async {
                                                    // your code
                                                    await _addprice();
                                                    validateAndSave();
                                                    Navigator.pop(context);
                                                  })
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                  ),
                                ));
                          },
                          context: context);
                    },
                    child: Icon(Icons.add),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*     Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 8, top: 8),
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
                                          padding:
                                              EdgeInsets.only(left: 8, top: 8),
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
                                      minLines:
                                          3, //Normal textInputField will be displayed
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
                    */
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<List<FinModel>>(
                                    stream: state.getMonthlyExpense(),
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
                Query()
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
