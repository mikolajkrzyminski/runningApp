import 'package:flutter/material.dart';
import 'package:szewa/pages/exercises_page.dart';
import 'package:szewa/pages/home_page.dart';
import 'package:szewa/pages/root_page.dart';
import 'package:szewa/pages/profile_page.dart';
import 'package:szewa/pages/social_page.dart';
import 'package:szewa/pages/statistics_page.dart';
import 'package:szewa/server_conn/connection.dart';

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
    // TODO: implement initState
    super.initState();
    // serverConnectionTestData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        fontFamily: 'Roboto',
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RootPage(),
        '/social': (context) => SocialPage(),
        '/statistics': (context) => StatisticsPage(),
        '/exercises': (context) => ExercisesPage(),
        '/profile': (context) => ProfilePage(),
      }, //SidebarLayout()
    );
  }
}