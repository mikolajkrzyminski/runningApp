import 'package:flutter/material.dart';
import 'package:szewa/components/navbar/bottom_nav_bar.dart';
import 'package:szewa/components/navbar/destination.dart';
import 'package:szewa/pages/exercises_page.dart';
import 'package:szewa/pages/home_page.dart';
import 'package:szewa/pages/profile_page.dart';
import 'package:szewa/pages/social_page.dart';
import 'package:szewa/pages/statistics_page.dart';

class RootPage extends StatefulWidget{

  const RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>{
  int _selectedIndex = 2;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _list = [
    SocialPage(),
    StatisticsPage(),
    HomePage(),
    ExercisesPage(),
    ProfilePage(),

    // Text(
    //   'Index 0: Social',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index 1: Statistics',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index 2: Training',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index 3: Exercises',
    //   style: optionStyle,
    // ),
    // Text(
    //   'Index 3: Profile',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

     return Scaffold(
       body: _list.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
        items: allDestinations.map((Destination destination) {
            return BottomNavigationBarItem(
            icon: destination.icon,
            label: destination.label,
            );
          }
        ).toList(),
      ),
    );
  }
}