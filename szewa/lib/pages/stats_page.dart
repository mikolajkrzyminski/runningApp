import 'package:flutter/material.dart';
import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/run_model.dart';
import 'package:intl/intl.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DbManager _dbManager;
  Future<List<RunModel>> runs;
  DateFormat dateFormat;


  @override
  void initState() {
    _dbManager = DbManager();
    runs = _dbManager.getRuns();
    dateFormat = DateFormat("HH:mm yyyy-MM-dd ");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body : FutureBuilder<List<RunModel>>(
        future: runs,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SizedBox(child: CircularProgressIndicator(),);
          }
          if (snapshot.hasError) {
            return Text("error occurred", style : TextStyle(color: Colors.red));
          }
          if (snapshot.hasData) {
            return
              ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: getIcon(snapshot.data[snapshot.data.length - index - 1].avgVelocity),
                        title: Text("${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[snapshot.data.length - index - 1].dateTime))}"),
                        subtitle: Text((snapshot.data[snapshot.data.length - index - 1].avgVelocity).toStringAsFixed(2) + " [m/s]"),
                      ),
                    );
                  });
          } else {
            return Text("No data");
          }
        },
      ),
    );
  }
  Widget getIcon(double velocity) {
    if (velocity < 1.5) {
      return Icon(Icons.directions_walk, color: Colors.green,);
    } else if (velocity < 5.5) {
      return Icon(Icons.directions_run, color: Colors.orange,);
    } else if (velocity >= 5.5) {
      return Icon(Icons.directions_run, color: Colors.red,);
    }
  }
}