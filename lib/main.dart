import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../AllScreens/mainScreen.dart';
import '../AllScreens/mapSample.dart';
import '../Provider/appdata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      ChangeNotifierProvider(
        create: (context)=>AppData(),
        child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        // home: MapSample(),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
    ),
      );
  }
}
