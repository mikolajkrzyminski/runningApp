import 'package:flutter/material.dart';
import 'package:szewa/components/navbar/destination.dart';
import 'package:szewa/pages/exercises_page.dart';
import 'package:szewa/pages/home_page.dart';
import 'package:szewa/pages/profile_page.dart';
import 'package:szewa/pages/social_page.dart';
import 'package:szewa/pages/statistics_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 2;

  List<Widget> _list = [
    SocialPage(),
    StatisticsPage(),
    HomePage(),
    ExercisesPage(),
    ProfilePage(),
  ];

  // zwraca id wybranego elementu z navbar i wywoluje odpowiadajacy mu widok z _list
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // wyslwietla widok o zadanym id
      body: _list.elementAt(_selectedIndex),
      // kolor zmienia tylko tekst bo ikona ma kolor ustawiony w destination
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
        }).toList(),
      ),
    );
  }
}
