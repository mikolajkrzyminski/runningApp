import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    );
  }
}