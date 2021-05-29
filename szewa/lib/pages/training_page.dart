import 'dart:io';

import 'package:flutter/material.dart';
import 'package:szewa/components/training/stats_presenter.dart';
import 'package:szewa/managers/run_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:szewa/managers/stats_calculator.dart';
import 'package:screenshot/screenshot.dart';

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
  bool _isFollowing;
  StatsCalculator _statsCalculator;
  final StopWatchTimer _stopwatchTimer = StopWatchTimer();
  ScreenshotController screenshotController;

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
    _isFollowing = true;
    _statsCalculator = StatsCalculator();
    screenshotController = ScreenshotController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatsPresenter(
          statsCalculator: _statsCalculator,
          stopwatchTimer: _stopwatchTimer,
        ),
        Expanded(
          flex: 4,
          child: Stack(
            children: <Widget>[
              Screenshot(
                controller: screenshotController,
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
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
                child: StreamBuilder<MapEvent>(
                  stream: _mapController.mapEventStream,
                  builder:
                      (BuildContext context, AsyncSnapshot<MapEvent> snapshot) {
                    if (snapshot.hasData) {
                      if (MapEventSource.onDrag == snapshot.data.source && _isFollowing) {
                        _isFollowing =  false;
                      }
                    }
                    return Visibility (
                      visible: !_isFollowing,
                      child: IconButton(
                          icon: Icon(Icons.gps_fixed, color: Color(0xFF00334E), ),
                          onPressed: () {
                            setState(() {
                              if(_runPositions.isNotEmpty) _mapController.move(_runPositions[_runPositions.length - 1], _mapController.zoom);
                              _isFollowing = !_isFollowing;
                            });
                          },
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        ),
        Expanded(
          flex: 2,
          // ignore: deprecated_member_use
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !_runManager.getIsRunning() && !_runManager.getIsRunPaused(),
                child: MaterialButton(
                  // padding ustawia promien przycisku
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  color: Color(0xFFFED049),
                  // if statement
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      //start run
                      _statsCalculator.clearStats();
                      _runPositions.clear();
                      _stopwatchTimer.onExecute.add(StopWatchExecute.reset);
                      _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                      _runManager.startRun(DateTime.now().millisecondsSinceEpoch);
                    });
                  },
                ),
              ),
              Visibility(
                visible: _runManager.getIsRunning() && !_runManager.getIsRunPaused(),
                child: MaterialButton(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  color: Color(0xFF00334E),
                    child: Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 40,
                    ),
                  onPressed: () {
                    //pause run
                    setState(() {
                      _stopwatchTimer.onExecute.add(StopWatchExecute.stop);
                      _mapController.fitBounds(StatsCalculator.getSquare(_runPositions));
                      _runManager.pauseRun();
                    });
                  },
                ),
              ),
              Visibility(
                visible: _runManager.getIsRunning() && _runManager.getIsRunPaused(),
                child: Expanded(
                  flex: 1,
                  child: MaterialButton(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    color: Color(0xFF00334E),
                    child: Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      //end run
                      _mapController.fitBounds(StatsCalculator.getSquare(_runPositions));
                      screenshotController.capture().then((File image) {
                        //Capture Done
                        image.readAsBytes().then((valueImage) {
                          _runManager.endRun(
                            _runManager.getId(),
                            _statsCalculator.distance,
                            _statsCalculator.avgVelocity,
                            _statsCalculator.calories.round(),
                            _statsCalculator.timePassed,
                            valueImage,
                          );
                          setState(() {
                            _stopwatchTimer.onExecute.add(StopWatchExecute.reset);
                            _statsCalculator.clearStats();
                            _runPositions.clear();
                            _runManager.changeIsRunPaused();
                          });
                        });
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: _runManager.getIsRunning() && _runManager.getIsRunPaused(),
                child: Expanded(
                  flex: 1,
                  child: MaterialButton(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    color: Color(0xFFFED049),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        //resume run
                        _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                        _runManager.resumeRun();
                      });
                    },
                  ),
                ),
              ),
            ],
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
        _statsCalculator.updatePosition(lastItem);
        _runPositions.add(lastItem);
        if (_isFollowing) _mapController.move(lastItem, _mapController.zoom);
      });
    }
  }
}
