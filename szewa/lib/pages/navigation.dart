import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:szewa/pages/registry/choose_account.dart';
import 'package:szewa/pages/registry/login_page.dart';
import 'package:szewa/pages/registry/register_page.dart';
import 'package:szewa/pages/root_page.dart';

import '../constants.dart';

class Navigation extends StatefulWidget{
  NavigationStates page;
  Navigation(this.page);

  @override
  _NavigationState createState() {
    return _NavigationState();
  }
}

enum NavigationStates {
  StartUpManager,
  Register,
  Login,
  RootPage,
  FirstRun,

}

class _NavigationState  extends State<Navigation>{
  NavigationStates view;
  @override
  void initState() {
    super.initState();
    if(widget.page != null) view = widget.page;
    else view = NavigationStates.StartUpManager;
  }

  @override
  Widget build(BuildContext context) {
    if (NavigationStates.StartUpManager == view) return ChooseAccount(callback);
    else if (NavigationStates.Register == view) return RegisterPage(callback);
    else if (NavigationStates.Login == view) return LoginPage(callback);
    else {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool(Consts.firstRunKey, false);
      });
      return RootPage();
    }
  }

  void callback(NavigationStates state) {
    setState(() {
      view = state;
    });
  }

}