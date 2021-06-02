import 'package:flutter/material.dart';
import 'package:szewa/managers/start_app_manager.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // serverConnectionTestData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF6F5F5),
        primaryColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: StartAppManager(),
    );
  }
}