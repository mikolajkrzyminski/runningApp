import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:szewa/pages/navigation.dart';
import '../constants.dart';

class StartAppManager extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _StartAppManagerState();
  }
}

class _StartAppManagerState extends State<StartAppManager>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder:
              (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return getLoadingIndicator(context);
              default:
                if (!snapshot.hasError) {
                  //check if app is start for the first time
                  if (snapshot.data.getBool(Consts.firstRunKey) != null) {
                    return Navigation(NavigationStates.RootPage);
                  } else {
                    // todo
                    FlutterSecureStorage storage = FlutterSecureStorage();
                    storage.deleteAll();
                    return Navigation(NavigationStates.StartUpManager);
                  }

                } else {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
            }
          }
      ),
    );
  }
  Center getLoadingIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}



