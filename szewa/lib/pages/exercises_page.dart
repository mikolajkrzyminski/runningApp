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
      body: Image.asset("assets/images/exercisesImg.png",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}