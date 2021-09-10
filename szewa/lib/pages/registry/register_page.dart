import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:szewa/managers/connection_manager.dart';
import 'package:szewa/managers/db_manager.dart';
import '../navigation.dart';
import 'package:szewa/styles/text_theme.dart' as textTheme;
import 'package:szewa/styles/color_theme.dart' as colorTheme;

class RegisterPage extends StatefulWidget{
  Function callback;
  RegisterPage(this.callback);

  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState  extends State<RegisterPage>{
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
        backgroundColor: colorTheme.ColorTheme.registerPageBackgroundColor,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(60.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 40.0),
                    child: Center(
                      child: Text("BECOME A SZEWA MEMBER", textAlign: TextAlign.center, style: textTheme.TextTheme.RegisterPageMainText,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      style: textTheme.TextTheme.registerFormFieldText,
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
                      style: textTheme.TextTheme.registerFormFieldText,
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
                    child: TextFormField(
                      style: textTheme.TextTheme.registerFormFieldText,
                      decoration: getFieldDecorator("Confirm password"),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } if (_password != value) {
                          return 'Passwords don\'t match.';
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
                        foregroundColor: MaterialStateProperty.all<Color>(colorTheme.ColorTheme.registerFormButtonForegroundColor),
                        backgroundColor: MaterialStateProperty.all<Color>(colorTheme.ColorTheme.registerFormButtonBackgroundColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: colorTheme.ColorTheme.registerFormButtonBorderColor)
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          _connection.createUser(_password, _email).then((responseRegister) async {
                            if (responseRegister.statusCode == 200) {
                              /*ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('Account has been created!'), backgroundColor: Colors.green, duration: Duration(seconds: 3),));*/
                              if (await _connection.authorizeUser(_password, _email)) {
                                DbManager().getRuns().then((runs) {
                                  if(runs.isNotEmpty) {
                                    runs.forEach((element) {
                                      _connection.sendActivity(element.id);
                                     // _connection.sendPhoto(element.id);
                                    });
                                  }
                                });
                                widget.callback(NavigationStates.RootPage);
                                } else {
                                widget.callback(NavigationStates.Login);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Try again later'), backgroundColor: colorTheme.ColorTheme.snackBarBackgroundColor,));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text('E-mail is in use'), backgroundColor: colorTheme.ColorTheme.snackBarBackgroundColor,));
                            }
                          });
                        }
                      },
                      child: Text('Join us', style: textTheme.TextTheme.registerFormButtonText),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: textTheme.TextTheme.registerFormFieldText,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign in!',
                            style: textTheme.TextTheme.linkUnderlineText,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.callback(NavigationStates.Login);
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
        borderSide: BorderSide(color: colorTheme.ColorTheme.registerFormEnabledBorder, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.registerFormFocusedBorder, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.registerFormErrorBorder, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorTheme.ColorTheme.registerFormFocusedErrorBorder, width: 2),
      ),
      labelStyle: textTheme.TextTheme.registerFormFieldText,
      labelText: labelText,
    );
  }
}