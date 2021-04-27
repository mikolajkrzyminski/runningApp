import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/components/bottom_nav_bar.dart';

class StatisticsPage extends StatefulWidget{

  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() {
    return _StatisticsPageState();
  }
}

class _StatisticsPageState  extends State<StatisticsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("STATYSTYKI")),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}