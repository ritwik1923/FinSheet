import 'package:flutter/material.dart';

import 'Screen/dashboard.dart';
import 'bloc/finsheet_bloc.dart';
import 'data/provider/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) {
          return FinsheetBloc();
        },
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: const Color(0xff2c4260),

        // Define the default font family.
        fontFamily: 'Poppins',
        // textButtonTheme: TextButtonThemeData(
        //   style: TextButton.styleFrom(
        //     primary: Colors.lightBlueAccent,
        //   ),),
//         textButtonTheme:
//         TextButton(
//   style: ButtonStyle(
//     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//   ),
//   onPressed: () { },
//   child: Text('TextButton'),
// ),

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(),
          // textTheme: ButtonTextTheme.accent,
        ),
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          errorStyle: TextStyle(
            color: Colors.red,
            // fontSize: 15.0
          ),
          labelStyle: TextStyle(
            color: Colors.lightBlueAccent,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.lightBlueAccent,
            ),
          ),
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 137, 201, 231),
          ),
          helperStyle: TextStyle(
            color: Colors.lightBlueAccent,
          ),
        ),
      ),
      home: const DashBoard(title: 'FinSheet'),
    );
  }
}
