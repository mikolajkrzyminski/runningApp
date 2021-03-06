import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:szewa/managers/connection_manager.dart';
import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/run_model.dart';
import 'package:szewa/styles/text_theme.dart' as textTheme;
import 'package:szewa/styles/color_theme.dart' as colorTheme;

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
        backgroundColor: colorTheme.ColorTheme.loginPageBackgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 40.0),
                      child: Center(
                        child: Text("Szewa", style: textTheme.TextTheme.appLogoText,),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        style: textTheme.TextTheme.loginFormFieldText,
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
                        style: textTheme.TextTheme.loginFormFieldText,
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
                          foregroundColor: MaterialStateProperty.all<Color>(colorTheme.ColorTheme.loginFormButtonForegroundColor),
                          backgroundColor: MaterialStateProperty.all<Color>(colorTheme.ColorTheme.loginFormButtonBackgroundColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: colorTheme.ColorTheme.loginFormButtonBorder)
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            if(await _connection.authorizeUser(_password, _email)) {
                                DbManager().clean();
                                var activitiesList = await _connection.getAllActivities();
                                if(null != activitiesList) {
                                  if (activitiesList.isNotEmpty) {
                                    for(int i = 0; i < activitiesList.length; i ++) {
                                      String photo = await _connection.getPhoto(activitiesList[i]["id"]);
                                      if(null != photo) {
                                        List<int> photoBytes = photo.codeUnits;
                                        DbManager().insertRun(RunModel.fromJson(activitiesList[i], Uint8List.fromList(photoBytes)));
                                      }

                                    }
                                  }
                                }
                                widget.callback(NavigationStates.RootPage);
                            }
                          }
                        },
                        child: Text('Join us', style: textTheme.TextTheme.loginFormButtonText),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have account? ',
                          style: textTheme.TextTheme.loginFormFieldText,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Sign up!',
                              style: textTheme.TextTheme.linkUnderlineText,
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
      ),
    );
  }

  bool mailValid(String mail) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail);
  }

  InputDecoration getFieldDecorator(String labelText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.loginFormEnabledBorder, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.loginFormFocusedBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.loginFormErrorBorder, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.loginFormFocusedErrorBorder, width: 2),
      ),
      labelStyle: textTheme.TextTheme.loginFormFieldText,
      labelText: labelText,
    );
  }
}