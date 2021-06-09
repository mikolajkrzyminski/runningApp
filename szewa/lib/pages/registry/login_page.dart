import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:szewa/managers/connection_manager.dart';
import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/run_model.dart';

import '../navigation.dart';

class LoginPage extends StatefulWidget{
  Function callback;
  LoginPage(this.callback);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState  extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  ConnectionManager _connection;

  @override void initState() {
    super.initState();
    _connection = ConnectionManager();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF00334E),
        body: Form(
          key: _formKey,
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(40.0),
            child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 40.0),
                    child: Center(
                      child: Text("Szewa", style: TextStyle(fontSize: 96, color: Colors.white, fontWeight: FontWeight.w300),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      style: getFieldTextStyle(),
                      decoration: getFieldDecorator("Mail"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        _email = value;
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } if (!mailValid(value)) {
                          return 'Please enter valid mail';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      style: getFieldTextStyle(),
                      decoration: getFieldDecorator("Password"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        _password = value;
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } if (value.length < 3) {
                          return 'Minimum password length is 3';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          _connection.authorizeUser(_password, _email).then((response) async {
                            if (response.statusCode == 200) {
                              DbManager().clean();
                              //ScaffoldMessenger.of(context)
                                 // .showSnackBar(SnackBar(content: Text('Ok!'), backgroundColor: Colors.green, duration: Duration(seconds: 3),));
                              await _connection.setResponse(response);
                              _connection.getAllActivities().then((activitiesJson) async {
                                if (activitiesJson.body.isNotEmpty) {
                                  for(int i = 0; i < jsonDecode(activitiesJson.body).length; i ++) {
                                    var json = jsonDecode(activitiesJson.body)[i];
                                    //DbManager().insertRun(RunModel.fromJson(json, bytes));
                                    _connection.getPhoto(json["id"]).then((responsePhoto) {
                                      List<int> photoBytes = responsePhoto.body.codeUnits;
                                      DbManager().insertRun(RunModel.fromJson(json, Uint8List.fromList(photoBytes)));
                                    });
                                    //GeolocationModel.fromJson(jsonDecode(activitiesJson.body[i]));
                                  }
                                }
                              });
                              widget.callback(NavigationStates.RootPage);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Login failed'), backgroundColor: Colors.red,));
                            }
                          });
                        }
                      },
                      child: Text('Sign in', style: TextStyle(color: Color(0xFF00334E))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        text: 'Don\'t have account? ',
                        style: getFieldTextStyle(),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign up!',
                            style: getLinkTextStyle(),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.callback(NavigationStates.Register);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

  bool mailValid(String mail) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail);
  }

  TextStyle getFieldTextStyle() {
    return TextStyle(color: Colors.white,);
  }

  TextStyle getLinkTextStyle() {
    return TextStyle(color: Colors.blue, decoration: TextDecoration.underline);
  }

  InputDecoration getFieldDecorator(String labelText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Color(0xFFFFFFFF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: TextStyle(
        color: Color(0xFFFAFFFF),
      ),
      labelText: labelText,
    );
  }
}