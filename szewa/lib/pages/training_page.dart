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
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
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
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                ),
                child: _runManager.getIsRunning() ?
                Text("STOP", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),) :
                Text("START", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),),
                onPressed: () {
                  setState(() {
                    if(!_runManager.getIsRunning())
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
                      _runManager.endRun(_runManager.getId(), _statsCalculator.distance, _statsCalculator.avgVelocity, _statsCalculator.calories.round());
                    }
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<int>(
                            stream: _stopwatchTimer.rawTime,
                            initialData: _stopwatchTimer.rawTime.value,
                            builder: (context, snapshot) {
                              final displayTime = StopWatchTimer.getDisplayTime(snapshot.data, milliSecond: false);
                              _timePassed = (snapshot.data ~/ 1000);
                              return Text(displayTime, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 35));
                            }),
                        Text("(hh:minmin:ss)", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                      ],
                    ),
                  ),
                  Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_statsCalculator.distance.toStringAsFixed(2),
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                              Text("(m)", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_statsCalculator.calories.toStringAsFixed(0),
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                              Text("(kcal)", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(0 != _statsCalculator.avgVelocity ? (1/(_statsCalculator.avgVelocity) * (50/3)).toStringAsFixed(1) : '0',
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                              Text("(min/km)", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12)),
                            ],
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onRunChanged(Position position) {
    if(null != position) {
      setState(() {
        LatLng lastItem = LatLng(position.latitude, position.longitude);
        _statsCalculator.updatePosition(lastItem, _timePassed);
        _runPositions.add(lastItem);
        if(_isFollowing) _mapController.move(lastItem, _mapController.zoom);
      });
    }
  }
}
