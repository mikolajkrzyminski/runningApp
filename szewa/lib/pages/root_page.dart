import 'package:flutter/material.dart';
import 'package:szewa/components/navbar/destination.dart';
import 'package:szewa/managers/connection_manager.dart';
import 'package:szewa/pages/exercises_page.dart';
import 'package:szewa/pages/profile_page.dart';
import 'package:szewa/pages/social_page.dart';
import 'package:szewa/pages/statistics_page.dart';
import 'package:szewa/pages/training_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

enum NavigationStates {
  SocialPage,
  StatisticsPage,
  TrainingPage,
  ExercisesPage,
  ProfilePage,
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex;
  bool _showNavbar;
  //Future<bool> _isLogged;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;
    _showNavbar = true;
  }

  // zwraca id wybranego elementu z navbar i wywoluje odpowiadajacy mu widok z _list
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //_isLogged = ConnectionManager().getIsLogged();
    return Scaffold(
      // wyslwietla widok o zadanym id
      body: getView(_selectedIndex),
      // kolor zmienia tylko tekst bo ikona ma kolor ustawiony w destination
      bottomNavigationBar: Offstage(
        offstage: !_showNavbar,
        child: BottomNavigationBar(
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
      ),
    );
  }

  void callback(bool showNavbar) {
    setState(() {
      _showNavbar = showNavbar;
    });
  }

  Widget getView(int index) {
    Widget view;
    if(2 == index) {

    }
    switch (index) {
      case 0:
        view = SocialPage();
        break;
      case 1:
        view = StatisticsPage();
        break;
      case 2:
        view = TrainingPage(callback);
        break;
      case 3:
        view = ExercisesPage();
        break;
      case 4:
        view = ProfilePage();
        break;
    }
    return view;
  }
}
