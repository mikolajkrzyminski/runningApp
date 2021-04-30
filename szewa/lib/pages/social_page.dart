import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialPage extends StatefulWidget{

  SocialPage({Key key}) : super(key: key);

  @override
  _SocialPageState createState() {
    return _SocialPageState();
  }
}

class _SocialPageState  extends State<SocialPage>{
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("SPOLECZNOSC"));
  }
}