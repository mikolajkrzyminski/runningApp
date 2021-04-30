import 'package:flutter/material.dart';
import 'package:szewa/managers/run_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:szewa/managers/stats_calculator.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

TextStyle _CircleButtonTextStyle() {
  return TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    fontSize: 22,
  );
}

class _TrainingPageState extends State<TrainingPage> implements RunObserver {
  RunManager _runManager;
  MapController _mapController;
  List<LatLng> _runPositions;
  int _timePassed;
  bool _isFollowing;
  StatsCalculator _statsCalculator;
  final StopWatchTimer _stopwatchTimer = StopWatchTimer();

  @override
  void dispose() {
    super.dispose();
    _stopwatchTimer.dispose();
  }

  @override
  void initState() {
    super.initState();
    _runManager = RunManager(this);
    _runPositions = [];
    _mapController = MapController();
    _timePassed = 0;
    _isFollowing = true;
    _statsCalculator = StatsCalculator();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<int>(
                  stream: _stopwatchTimer.rawTime,
                  initialData: _stopwatchTimer.rawTime.value,
                  builder: (context, snapshot) {
                    final displayTime = StopWatchTimer.getDisplayTime(
                        snapshot.data,
                        milliSecond: false);
                    _timePassed = (snapshot.data ~/ 1000);
                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: displayTime,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 75),
                          ),
                          TextSpan(
                            text: "\nTime",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 22,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _statsCalculator.distance.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                      ),
                      TextSpan(
                        text: "\nDistance (m)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _statsCalculator.calories.toStringAsFixed(0),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                      ),
                      TextSpan(
                        text: "\nCalorie (kcal)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 0 != _statsCalculator.avgVelocity
                            ? (1 / (_statsCalculator.avgVelocity) * (50 / 3))
                                .toStringAsFixed(1)
                            : '0',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 25),
                      ),
                      TextSpan(
                        text: "\nPace (min/km)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(0, 0),
              zoom: 16,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c']),
              PolylineLayerOptions(
                polylines: [
                  Polyline(
                      points: _runPositions,
                      strokeWidth: 4.0,
                      color: Colors.purple),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          // ignore: deprecated_member_use
          child: FlatButton(
            // padding ustawia promien przycisku
            padding: EdgeInsets.all(20.0),
            shape: CircleBorder(),
            color: Colors.yellow[600],
            // if statement
            child: _runManager.getIsRunning()
                ? Text(
                    "STOP",
                    style: _CircleButtonTextStyle(),
                  )
                : Text(
                    "START",
                    style: _CircleButtonTextStyle(),
                  ),
            onPressed: () {
              setState(() {
                if (!_runManager.getIsRunning())
                //start run
                {
                  _statsCalculator.clearStats();
                  _timePassed = 0;
                  _runPositions.clear();
                  _stopwatchTimer.onExecute.add(StopWatchExecute.reset);
                  _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                  _runManager.startRun(DateTime.now().millisecondsSinceEpoch);
                } else {
                  _stopwatchTimer.onExecute.add(StopWatchExecute.stop);
                  _runManager.endRun(
                      _runManager.getId(),
                      _statsCalculator.distance,
                      _statsCalculator.avgVelocity,
                      _statsCalculator.calories.round());
                }
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void onRunChanged(Position position) {
    if (null != position) {
      setState(() {
        LatLng lastItem = LatLng(position.latitude, position.longitude);
        _statsCalculator.updatePosition(lastItem, _timePassed);
        _runPositions.add(lastItem);
        if (_isFollowing) _mapController.move(lastItem, _mapController.zoom);
      });
    }
  }
}
