import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/components/navbar/bottom_nav_bar.dart';

class ProfilePage extends StatefulWidget{

  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState  extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("PROFIL")),
      // bottomNavigationBar: BottomNavBar(),
    );
  }
}