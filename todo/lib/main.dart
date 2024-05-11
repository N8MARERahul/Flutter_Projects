import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../screens/home.dart';

void main() async {

  //init the hive
  await Hive.initFlutter();

  //Open a box
  var box = await Hive.openBox('todoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO App',
      home: Home(),
      theme: ThemeData(primaryColor: Colors.yellow),
    );
  }
}
