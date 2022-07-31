import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:finsheet/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import '../data/model/entities.dart';
import 'chart/bar_chart.dart';
import 'constant.dart';

class OrderDataTable extends StatefulWidget {
  final List<FinModel> orders;
  final void Function(int columnIndex, bool ascending) onSort;
  final Store store;
  final ReportType reporttype;
  const OrderDataTable({
    Key? key,
    required this.orders,
    required this.onSort,
    required this.store,
    required this.reporttype,
  }) : super(key: key);

  @override
  _OrderDataTableState createState() => _OrderDataTableState();
}

class _OrderDataTableState extends State<OrderDataTable> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _priceInputController = TextEditingController();
  final _commentInputController = TextEditingController();
  final _tagInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var newMap = groupBy(widget.orders, (FinModel obj) => obj.createdTime);
    double total = 0;

    // });
    SplayTreeMap<DateTime, double> finMap = SplayTreeMap<DateTime, double>();
    widget.orders.forEach((fin) {
      // group by only day
      DateTime key;
      if (widget.reporttype == ReportType.hourly)
        key = DateTime.utc(
          fin.createdTime.year,
          fin.createdTime.month,
          fin.createdTime.day,
          fin.createdTime.hour,
        );
      else if (widget.reporttype == ReportType.daily) {
        key = DateTime.utc(
          fin.createdTime.year,
          fin.createdTime.month,
          fin.createdTime.day,
        );
      } else if (widget.reporttype == ReportType.monthly) {
        key = DateTime.utc(
          fin.createdTime.year,
          fin.createdTime.month,
        );
      } else {
        key = DateTime.utc(
          fin.createdTime.year,
        );
      }
      if (finMap.containsKey(key)) {
        finMap[key] = finMap[key]! + fin.price;
      } else {
        finMap[key] = fin.price;
      }
      total += fin.price;
      print(total);
    });
    // print(finMap);
    print("finmap: ${finMap}");
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: EdgeInsets.all(const_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "₹${total.toStringAsFixed(2)}",
                    key: Key("${total.toStringAsFixed(2)}"),
                    style: TextStyle(
                        height: 1.0, fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  BarGraph(
                      xdata: finMap,
                      hourly: widget.reporttype == ReportType.hourly),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: Text('ID'),
                    onSort: _onDataColumnSort,
                  ),
                  DataColumn(
                    label: Text('tag'),
                  ),
                  DataColumn(
                    label: Text('Price'),
                    numeric: true,
                    onSort: _onDataColumnSort,
                  ),
                  DataColumn(
                    label: Text('Created Time'),
                    numeric: true,
                    onSort: _onDataColumnSort,
                  ),
                  DataColumn(
                    label: Text('Updated Time'),
                    numeric: true,
                    onSort: _onDataColumnSort,
                  ),
                  // DataColumn(
                  //   label: Text('Comment'),
                  //   numeric: true,
                  //   onSort: _onDataColumnSort,
                  // ),
                  DataColumn(
                    label: Container(),
                  ),
                  DataColumn(
                    label: Container(),
                  ),
                ],
                rows: widget.orders.map(
                  (order) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(order.id.toString()),
                        ),
                        DataCell(
                          Text(order.tag.target?.tag ?? 'NONE'),
                          onTap: () {
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
                          },
                        ),
                        DataCell(
                          Text(
                            '\$${order.price}',
                          ),
                        ),
                        DataCell(
                          Text(
                            '\$${order.createdTime}',
                          ),
                        ),
                        DataCell(
                          Text(
                            '\$${order.updatedTime}',
                          ),
                        ),
                        DataCell(
                          Icon(Icons.edit),
                          onTap: () {
                            _priceInputController.text = order.price.toString();
                            _commentInputController.text =
                                order.comments.toString();
                            _tagInputController.text = order.tag.target!.tag;
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
                                                        await _addprice(order);
                                                        validateAndSave();
                                                        Navigator.pop(context);
                                                      })
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                      )));
                                },
                                context: context);

                            /*
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: AlertDialog(
                                      scrollable: true,
                                      title: Text('Add Data'),
                                      content: DataEntry(),
                                      actions: [
                                        RaisedButton(
                                            child: Text("Submit"),
                                            onPressed: () async {
                                              // your code
                                              await _addprice(order);
                                              validateAndSave();
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ),
                                  );
                                });
                                  */
                            order.updatedTime = DateTime.now();
                            widget.store.box<FinModel>().put(order);
                            var _ = order;
                            print(
                                '${_.id}    ${_.tag.target?.tag}    \$${_.price}    \$${_.createdTime}    \$${_.updatedTime} \$${_.comments}');
                          },
                        ),
                        DataCell(
                          Icon(Icons.delete),
                          onTap: () {
                            widget.store.box<FinModel>().remove(order.id);
                            // TODO tag is not removing
                          },
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDataColumnSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }

  Future<void> _addprice(FinModel order) async {
    if (_priceInputController.text.isEmpty || _tagInputController.text.isEmpty)
      return;
    print(
        "${_priceInputController.text} ${_tagInputController.text} \n${_commentInputController.text}");
    order.price = double.parse(_priceInputController.text);
    var t = widget.store
        .box<TagModel>()
        .query(TagModel_.tag.equals(_tagInputController.text))
        .build()
        .find();
    if (t.isNotEmpty)
      order.tag.target = t[0];
    else
      order.tag.target = TagModel(tag: _tagInputController.text);
    order.comments = _commentInputController.text;
    widget.store.box<FinModel>().put(order);
    _priceInputController.text = '';
    _tagInputController.text = '';
    _commentInputController.text = '';
  }

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
}
