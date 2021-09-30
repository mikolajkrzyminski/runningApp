import 'package:flutter/material.dart';
import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/run_model.dart';
import 'package:intl/intl.dart';
import 'package:szewa/pages/charts_tab.dart';
import 'package:szewa/styles/text_theme.dart' as textTheme;
import 'package:szewa/styles/color_theme.dart' as colorTheme;

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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator()
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Text("error occurred", style : textTheme.TextTheme.statsPageSnapshotErrorText);
        }
        if (snapshot.hasData) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: colorTheme.ColorTheme.statsPageTabColor,
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: Container()),
                        TabBar(
                          indicatorWeight: 5,
                          indicatorColor: colorTheme.ColorTheme.statsPageIndicatorColor,
                          tabs: [
                            Tab(icon: Icon(Icons.directions_run, color: colorTheme.ColorTheme.statsPageTabIconColor,)),
                            Tab(icon: Icon(Icons.show_chart, color: colorTheme.ColorTheme.statsPageTabIconColor,)),
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
                        onTap: () => print('tapped activity: ${null == snapshot.data[index].serverId ? "null" : snapshot.data[index].serverId}'),
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
                                      child: Text(getDayDescription((snapshot.data[index].dateTime)), style: textTheme.TextTheme.statsPageCardTitleText),
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
                                          child: Text("Run ", style: textTheme.TextTheme.statsPageText,),
                                        ),
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Distance ", style: textTheme.TextTheme.statsPageText,),
                                        ),
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Time ", style: textTheme.TextTheme.statsPageText,),
                                        ),
                                        Padding(padding: EdgeInsets.all(4.0),
                                          child: Text("Avg Pace ", style: textTheme.TextTheme.statsPageText,),
                                        ),
                                      ],
                                    ),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text("${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].dateTime))}r.", style: textTheme.TextTheme.statsPageValText,),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text((snapshot.data[index].distance / 1000).toStringAsFixed(2) + " km", style: textTheme.TextTheme.statsPageValText,),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text("${timeFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].duration * 1000))}", style: textTheme.TextTheme.statsPageValText,),

                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text((0 == snapshot.data[index].avgVelocity ? 0 : (50 / 3) / snapshot.data[index].avgVelocity).toStringAsFixed(2) + " min/km", style: textTheme.TextTheme.statsPageValText,),
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
      return Icon(Icons.directions_walk, color: colorTheme.ColorTheme.statsPageSlowIconColor, );
    } else if (velocity < 5.5) {
      return Icon(Icons.directions_run, color: colorTheme.ColorTheme.statsPageMediumIconColor, );
    } else if (velocity >= 5.5) {
      return Icon(Icons.directions_run, color: colorTheme.ColorTheme.statsPageFastIconColor, );
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