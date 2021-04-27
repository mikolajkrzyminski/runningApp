import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/components/bottom_nav_bar.dart';

class ExercisesPage extends StatefulWidget{

  ExercisesPage({Key key}) : super(key: key);

  @override
  _ExercisesPageState createState() {
    return _ExercisesPageState();
  }
}

class _ExercisesPageState  extends State<ExercisesPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("CWICZENIA")),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}