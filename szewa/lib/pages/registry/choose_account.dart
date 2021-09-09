import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/pages/navigation.dart';
import 'package:szewa/styles/text_theme.dart' as textTheme;
import 'package:szewa/styles/color_theme.dart' as colorTheme;

class ChooseAccount extends StatefulWidget{
  Function callback;
  ChooseAccount(this.callback);

  @override
  _ChooseAccountState createState() {
    return _ChooseAccountState();
  }
}

class _ChooseAccountState  extends State<ChooseAccount>{
  TextStyle buttonText;
  TextStyle infoText;
  TextStyle joinButtonText;
  bool showInfo;
  bool showAccountInfo;

  @override void initState() {
    super.initState();
    showInfo = false;
    showAccountInfo = false;
    buttonText = textTheme.TextTheme.buttonText;
    infoText = textTheme.TextTheme.infoText;
    joinButtonText = textTheme.TextTheme.joinButtonText;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorTheme.ColorTheme.appInfoBackgroundColor,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(40.0),
              child: Center(
                child: Text("Szewa", style: textTheme.TextTheme.appLogoText),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showInfo = true;
                        showAccountInfo = true;
                      });
                    },
                    child: Text('Use app with account', style: buttonText),
                    style: ElevatedButton.styleFrom(
                      primary: colorTheme.ColorTheme.appInfoButtonBackground,
                      side: BorderSide(color: colorTheme.ColorTheme.appInfoButtonBorderColor, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showInfo && showAccountInfo,
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.all(5), child: Text("What you can do with account:", style: buttonText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • Communicate with friends", style: infoText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • Share traninig with your friends", style: infoText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • Take part in virtual races", style: infoText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • See your compited trainings on other devices", style: infoText,),),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: colorTheme.ColorTheme.appInfoElevatedButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Create account", style: joinButtonText,),
                          onPressed: (){widget.callback(NavigationStates.Register);},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        showInfo = true;
                        showAccountInfo = false;
                      });
                    },
                    child: Text('Use app without account', style: buttonText),
                    style: ElevatedButton.styleFrom(
                      primary: colorTheme.ColorTheme.appInfoButtonBackground,
                      side: BorderSide(color: colorTheme.ColorTheme.appInfoButtonBorderColor, width: 1),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showInfo && !showAccountInfo,
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.all(5), child: Text("What you can do without account:", style: buttonText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • During training your location wouldn’t be send to server", style: infoText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • Your trainings will be on local storage", style: infoText,),),
                    Padding(padding: EdgeInsets.all(5), child: Text("   • Can’t communicate with your friends", style: infoText,),),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: colorTheme.ColorTheme.appInfoElevatedButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Join without account", style: joinButtonText,),
                          onPressed: (){widget.callback(NavigationStates.RootPage);},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}