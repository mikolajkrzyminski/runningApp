import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:szewa/models/run_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:szewa/managers/stats_calculator.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class ChartsTab extends StatefulWidget{
  final List<RunModel> activities;
  const ChartsTab ({@required this.activities});

  @override
  _ChartsTabState createState() {
    return _ChartsTabState();
  }
}

class _ChartsTabState  extends State<ChartsTab>{
  DateTime _dateFrom;
  DateTime _dateTo;
  bool _onlyActivities;
  StatsCalculator _statsCalculator;

  @override
  void initState() {
    super.initState();
    _dateFrom = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).subtract(Duration(days : 7));
    _dateTo = DateTime.now();
    _onlyActivities = true;
    _statsCalculator = StatsCalculator();
  }

  @override
  Widget build(BuildContext context) {
    var _activityData = _statsCalculator.createData(widget.activities, DateTime(_dateFrom.year, _dateFrom.month, _dateFrom.day), DateTime(_dateTo.year, _dateTo.month, _dateTo.day), _onlyActivities);
    return ListView(
      shrinkWrap: true,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Show from: "),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () { DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2000, 1, 1),
                  maxTime: _dateTo, onChanged: (date) {
                    setState(() {
                      _dateFrom = date;
                    });
                  }, onConfirm: (date) {
                    setState(() {
                      _dateFrom = date;
                    });
                  }, currentTime: _dateFrom, locale: LocaleType.en);
              },
              child: Text(DateFormat('dd-MM-yyy').format(_dateFrom), style: TextStyle(color : Colors.black),)),
            Text(", to: "),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              onPressed: () { DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: _dateFrom,
                  maxTime: DateTime.now(), onChanged: (date) {
                    setState(() {
                      _dateTo = date;
                    });
                  }, onConfirm: (date) {
                    setState(() {
                      _dateTo = date;
                    });
                  }, currentTime: _dateTo, locale: LocaleType.en);
              },
              child: Text(DateFormat('dd-MM-yyyy').format(_dateTo), style: TextStyle(color : Colors.black),)),
          ],
        ),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.7,
          child: Card(
            elevation: 1,
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: Colors.white,
            child: charts.TimeSeriesChart(
              [_activityData.activitySeries[0]],
              animate: true,
              defaultRenderer: new charts.BarRendererConfig<DateTime>(),
              defaultInteractions: false,
              behaviors: [
                charts.SlidingViewport(),
                charts.ChartTitle('distance km',
                    behaviorPosition: charts.BehaviorPosition.top,
                    titleOutsideJustification: charts.OutsideJustification.start)
              ],
              domainAxis: new charts.DateTimeAxisSpec(
                tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                  minute: new charts.TimeFormatterSpec(
                    transitionFormat: 'kk:mm',
                    format: 'kk:mm',
                  ),
                ),
              ),
            ),
          ),
        ),
        Card(
          elevation: 1,
          margin: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Only activities: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Sum calories: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Sum distance km: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Sum duration: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Avg duration: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Avg distance km: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                        Padding(padding: EdgeInsets.all(4.0),
                          child: Text("Number of activities: ", style: TextStyle(fontSize: 18, color: Color(0xFF969696), fontWeight: FontWeight.w300),),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FlutterSwitch(
                          width: 55,
                          height: 30,
                          value: _onlyActivities,
                          onToggle: (value) {
                            setState(() {
                              _onlyActivities = value;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("${_activityData.sumCalories}", style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text((_activityData.sumDistance / 1000).toStringAsFixed(2), style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(Duration(seconds: _activityData.sumDuration).toString().split('.').first.padLeft(8, "0"), style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(Duration(seconds: _activityData.avgDuration).toString().split('.').first.padLeft(8, "0"), style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text((_activityData.avgDistance / 1000).toStringAsFixed(2), style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("${_activityData.numberOfActivities}", style: TextStyle(fontSize: 18, color: Color(0xFF003259), fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
