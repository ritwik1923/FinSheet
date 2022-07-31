// import 'dart:io';

// import 'package:faker/faker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:objectbox/objectbox.dart';
// import 'package:objectbox_tutorial/bloc/finsheet_bloc.dart';
// import 'package:objectbox_tutorial/screen/constant.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart';

// import '../data/model/entities.dart';
// import '../objectbox.g.dart';
// import 'order_data_table.dart';

// // TODO: Bloc state
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final faker = Faker();

//   // late Store _store;
//   // late SyncClient _syncClient;
//   // bool hasBeenInitialized = false;

//   // late Stream<List<FinModel>> _stream;
//   // late Stream<List<TagModel>> _streamtag;

//   @override
//   void initState() {
//     super.initState();
//     setNewTagModel();
//     // getApplicationDocumentsDirectory().then((dir) {
//     // _store = Store(
//     //   getObjectBoxModel(),
//     //   directory: join(dir.path, 'objectbox'),
//     // );

//     // if (Sync.isAvailable()) {
//     //   _syncClient = Sync.client(
//     //     _store,
//     //     Platform.isAndroid ? 'ws://10.0.2.2:9999' : 'ws://127.0.0.1:9999',
//     //     SyncCredentials.none(),
//     //   );
//     //   _syncClient.start();
//     // }

//     // setState(() {
//     //   _stream = _store
//     //       .box<FinModel>()
//     //       .query()
//     //       .watch(triggerImmediately: true)
//     //       .map((query) => query.find());
//     //   hasBeenInitialized = true;
//     //   _streamtag = _store
//     //       .box<TagModel>()
//     //       .query()
//     //       .watch(triggerImmediately: true)
//     //       .map((query) => query.find());
//     //   hasBeenInitialized = true;
//     // });
//     // });
//   }

//   late TagModel _tagModel;
//   @override
//   void dispose() {
//     // _store.close();
//     // _syncClient.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<FinsheetBloc, FinsheetState>(
//         builder: (context, state) {
//           print(state);
//           if (state is FinsheetInitialState) {
//             context.read<FinsheetBloc>().add(FinLoadDataDBEvent());
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is FinsheetLoadingDBState) {
//             return const Center(
//                 child: CircularProgressIndicator(
//               color: Colors.purple,
//             ));
//           } else if (state is FinsheetLoadedDBState) {
//             var _streamtag = state.getallTags();
//             var _stream = state.getMonthlyExpense();
//             var _store = state.store;

//             void addFakeOrderForCurrentTagModel() {
//               final order = FinModel(
//                 price: faker.randomGenerator.integer(500, min: 10) * 1.12,
//                 comments: faker.lorem.words(99).join(' '),
//                 createdTime: DateTime.now(),
//                 updatedTime: DateTime.now(),
//               );
//               order.tag.target = _tagModel;
//               print(order.id);
//               _store.box<FinModel>().put(order);
//             }

//             // setState(() {
//             //   setNewTagModel();
//             // });
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text('Orders App'),
//                 actions: [
//                   IconButton(
//                     icon: Icon(Icons.person_add_alt),
//                     onPressed: setNewTagModel,
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.attach_money),
//                     onPressed: addFakeOrderForCurrentTagModel,
//                   ),
//                 ],
//               ),
//               body: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     /*
//                     StreamBuilder<List<TagModel>>(
//                         stream: _streamtag,
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           return Wrap(
//                             // TODO: add tags
//                             children: [
//                               for (var tag in snapshot.data!)
//                                 if (tag.orders.length > 0)
//                                   GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         _tagModel = tag;
//                                       });
//                                     },
//                                     onLongPress: () => showModalBottomSheet(
//                                       context: context,
//                                       builder: (context) {
//                                         return Material(
//                                           child: ListView(
//                                             children: tag.orders.map(
//                                               (_) {
//                                                 print(
//                                                     '${_.id}    ${_.tag.target?.tag}    \$${_.price}    \$${_.createdTime}    \$${_.updatedTime} \$${_.comments}');
//                                                 return ListTile(
//                                                   title: Text(
//                                                       '${_.id}    ${_.tag.target?.tag}    \$${_.price}}'),
//                                                   // trailing: Text(
//                                                   //   "${_.comments}",
//                                                   //   overflow: TextOverflow.ellipsis,
//                                                   // ),
//                                                 );
//                                               },
//                                             ).toList(),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     child: Container(
//                                       margin: EdgeInsets.all(5),
//                                       padding: EdgeInsets.all(5),
//                                       decoration: BoxDecoration(
//                                         // color: Colors.green,
//                                         borderRadius: BorderRadius.circular(50),
//                                         border: Border.all(
//                                           color: _tagModel == tag
//                                               ? Colors.blue
//                                               : Colors.black45,
//                                           width: 1,
//                                           style: BorderStyle.solid,
//                                         ),
//                                       ),
//                                       child: Wrap(
//                                         crossAxisAlignment:
//                                             WrapCrossAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             height: 20.0,
//                                             width: 20.0,
//                                             child: Checkbox(
//                                                 splashRadius: 0,
//                                                 value: _tagModel == tag,
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.all(
//                                                             Radius.circular(
//                                                                 50.0))),
//                                                 onChanged: (bool? value) {
//                                                   setState(() {
//                                                     _tagModel = tag;
//                                                   });
//                                                 }),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: Text(tag.tag),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                             ],
//                           );
//                         }),
//                     StreamBuilder<List<FinModel>>(
//                         stream: state.getminExpense(),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           return OrderDataTable(
//                             orders: snapshot.data!,
//                             onSort: (columnIndex, ascending) {
//                               final newQueryBuilder = 
//                                   _store.box<FinModel>().query();
//                               final sortField = FinModel_.id;
//                               // columnIndex == 0 ? FinModel_.id: FinModel_.price;
//                               newQueryBuilder.order(
//                                 sortField,
//                                 flags: ascending ? 0 : Order.descending,
//                               );

//                               setState(() {
//                                 _stream = newQueryBuilder
//                                     .watch(triggerImmediately: true)
//                                     .map((query) => query.find());
//                               });
//                             },
//                             store: _store,
//                           );
//                         }),
//                         */
//                     StreamBuilder<List<FinModel>>(
//                         stream: state.getTodayExpense(65),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           return OrderDataTable(
//                             reporttype: ReportType.hourly,
//                             orders: snapshot.data!,
//                             onSort: (columnIndex, ascending) {
//                               final newQueryBuilder =
//                                   _store.box<FinModel>().query();
//                               final sortField = FinModel_.id;
//                               // columnIndex == 0 ? FinModel_.id: FinModel_.price;
//                               newQueryBuilder.order(
//                                 sortField,
//                                 flags: ascending ? 0 : Order.descending,
//                               );

//                               setState(() {
//                                 _stream = newQueryBuilder
//                                     .watch(triggerImmediately: true)
//                                     .map((query) => query.find());
//                               });
//                             },
//                             store: _store,
//                           );
//                         }),
             
//                     StreamBuilder<List<FinModel>>(
//                         stream: state.getMonthlyExpense(),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           }
//                           return OrderDataTable(
//                             reporttype: ReportType.monthly,
//                             orders: snapshot.data!,
//                             onSort: (columnIndex, ascending) {
//                               final newQueryBuilder =
//                                   _store.box<FinModel>().query();
//                               final sortField = FinModel_.id;
//                               // columnIndex == 0 ? FinModel_.id: FinModel_.price;
//                               newQueryBuilder.order(
//                                 sortField,
//                                 flags: ascending ? 0 : Order.descending,
//                               );

//                               setState(() {
//                                 _stream = newQueryBuilder
//                                     .watch(triggerImmediately: true)
//                                     .map((query) => query.find());
//                               });
//                             },
//                             store: _store,
//                           );
//                         }),
             
//                   //   StreamBuilder<List<FinModel>>(
//                   //       stream: _stream,
//                   //       builder: (context, snapshot) {
//                   //         if (!snapshot.hasData) {
//                   //           return Center(
//                   //             child: CircularProgressIndicator(),
//                   //           );
//                   //         }
//                   //         return OrderDataTable(
//                   //           orders: snapshot.data!,
//                   //           onSort: (columnIndex, ascending) {
//                   //             final newQueryBuilder =
//                   //                 _store.box<FinModel>().query();
//                   //             final sortField = FinModel_.id;
//                   //             // columnIndex == 0 ? FinModel_.id: FinModel_.price;
//                   //             newQueryBuilder.order(
//                   //               sortField,
//                   //               flags: ascending ? 0 : Order.descending,
//                   //             );

//                   //             setState(() {
//                   //               _stream = newQueryBuilder
//                   //                   .watch(triggerImmediately: true)
//                   //                   .map((query) => query.find());
//                   //             });
//                   //           },
//                   //           store: _store,
//                   //         );
//                   //       }),
//                   ],
//                 ),
//               ),
//             );
//           } else if (state is FinsheetErrorDBState) {
//             return Text('Error');
//           }
//           return Text('Someting went wrong');
//         },
//       ),
//     );
//   }

//   void setNewTagModel() {
//     String fakename = faker.person.name();
//     print(fakename);
//     _tagModel = TagModel(tag: fakename);
//   }
// }
