// import 'package:faker/faker.dart';
// import 'dart:math';

// import 'package:finsheet/data/model/entities.dart';

// class FinData {
//   Future<List<FinModel>> getTodayFin() async {
//     return Future.delayed(Duration(seconds: 1), () {
//       List<FinModel> data = List<FinModel>.generate(
//           10,
//           (int model) => FinModel(
//               date: DateTime.now().add(Duration(minutes: Random().nextInt(60),hours: Random().nextInt(12))),
//               comments: faker.lorem.words(99).join(' '),
//               id: faker.randomGenerator.integer(5000),
//               tag: faker.lorem.words(1).join(' '),
//               price: faker.randomGenerator.decimal(scale: 4, min: 50)),
//           growable: true);
//       return data;
//     });
//   }

//   Future<List<FinModel>> getLastFin() async {
//     return Future.delayed(Duration(seconds: 1), () {
//       List<FinModel> data = List<FinModel>.generate(
//           30,
//           (int model) => FinModel(
//               date: DateTime.now().add(Duration(days: Random().nextInt(10))),
//               comments: faker.lorem.words(5).join(' '),
//               id: faker.randomGenerator.integer(5000),
//               tag: faker.lorem.words(1).join(' '),
//               price: faker.randomGenerator.decimal(scale: 4, min: 50)),
//           growable: true);
//       return data;
//     });
//   }
// }
