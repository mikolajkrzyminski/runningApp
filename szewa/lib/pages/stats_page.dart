import 'package:flutter/material.dart';
import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/run_model.dart';
import 'package:intl/intl.dart';
import 'package:szewa/pages/charts_tab.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  DbManager _dbManager;
  Future<List<RunModel>> runs;
  DateFormat dateFormat;
  DateFormat timeFormat;


  @override
  void initState() {
    _dbManager = DbManager();
    runs = _dbManager.getRuns();
    dateFormat = DateFormat("dd.MM.yyyy ");
    timeFormat = DateFormat("Hms");
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<RunModel>>(
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
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: Colors.white,
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: Container()),
                        TabBar(
                          indicatorWeight: 5,
                          indicatorColor: Color(0xFFFED049),
                          tabs: [
                            Tab(icon: Icon(Icons.directions_run, color: Color(0xFF00334E),)),
                            Tab(icon: Icon(Icons.show_chart, color: Color(0xFF00334E),)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: new TabBarView(
                children: <Widget>[
                  ListView.builder(
                  itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => print('tapped activity: ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].dateTime))}'),
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          elevation: 1,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Stack (
                                  children: [
                                    Center(
                                      child: Text(getDayDescription((snapshot.data[index].dateTime)), style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                                    ),
                                    getIcon(snapshot.data[index].avgVelocity, ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Run ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                                        ),
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Distance ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                                        ),
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Time ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                                        ),
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Avg Pace ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                                        ),
                                      ],
                                    ),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text("${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].dateTime))}r.", style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text((snapshot.data[index].distance / 1000).toStringAsFixed(2) + " km", style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text("${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].duration * 1000))}", style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text((0 == snapshot.data[index].avgVelocity ? 0 : (50 / 3) / snapshot.data[index].avgVelocity).toStringAsFixed(2) + " min/km", style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                                          ),
                                        ]
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image(
                                            image: MemoryImage(snapshot.data[index].picture),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ChartsTab(activities: snapshot.data),
                ],
              ),
            ),
          );

        } else {
          return Text("No data");
        }
      },
    );
  }
  Widget getIcon(double velocity) {
    if (velocity < 1.5) {
      return Icon(Icons.directions_walk, color: Colors.green, );
    } else if (velocity < 5.5) {
      return Icon(Icons.directions_run, color: Colors.orange, );
    } else if (velocity >= 5.5) {
      return Icon(Icons.directions_run, color: Colors.red, );
    }
  }

  String getDayDescription(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String desc = "";
    if (Duration(days: 7) >= DateTime.now().difference(date)) {
      desc += DateFormat('EEEE').format(date);
    }
    if (date.hour >= 5 && date.hour < 12) desc += " morning";
    if (date.hour >= 12 && date.hour < 18) desc += " afternoon";
    if (date.hour >= 18 && date.hour < 22) desc += " evening";
    if (date.hour >= 22 && date.hour < 5)  desc += " night";
    return desc += " activity";
  }
}