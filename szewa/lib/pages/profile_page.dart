import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/pages/registry/register_page.dart';

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
      body: RegisterPage(null),
      //Center(child: Text("PROFIL")),
    );
  }
}