import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/pages/login_page.dart';

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
      body: LoginPage(),
      //Center(child: Text("PROFIL")),
    );
  }
}