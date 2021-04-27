import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/components/bottom_nav_bar.dart';

class HomePage extends StatefulWidget{

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState  extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Text("DOMOWY"))  ,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}