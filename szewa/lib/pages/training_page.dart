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
import 'package:szewa/styles/color_theme.dart' as colorTheme;

class TrainingPage extends StatefulWidget {
  Function callback;
  TrainingPage(this.callback);

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> implements RunObserver {
  RunManager _runManager;
  MapController _mapController;
  List<LatLng> _runPositions;
  bool _isFollowing;
  StatsCalculator _statsCalculator;
  final StopWatchTimer _stopwatchTimer = StopWatchTimer();
  ScreenshotController screenshotController;
  LatLng _currPosition;

  @override
  void dispose() {
    super.dispose();
    _stopwatchTimer.dispose();
    _runManager.endStream();
  }

  @override
  void initState() {
    super.initState();
    _currPosition = LatLng(0, 0);
    _runManager = RunManager(this);
    _runPositions = [];
    _mapController = MapController();
    _isFollowing = true;
    _statsCalculator = StatsCalculator();
    screenshotController = ScreenshotController();
    _runManager.startStream();
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
                    center: _currPosition,
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
                            color: colorTheme.ColorTheme.trainingPageRoadColor),
                      ],
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 60.0,
                          height: 60.0,
                          point: _currPosition,
                          builder: (ctx) => Container(
                            child: Icon(_runManager.getIsRunPaused() ? Icons.radio_button_checked : Icons.directions_run),
                          ),
                        )
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
                          icon: Icon(Icons.gps_fixed, color: colorTheme.ColorTheme.trainingPageGpsFixIconColor, ),
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
              Spacer(
                flex: 1,
              ),
              Visibility(
                visible: !_runManager.getIsRunning() && !_runManager.getIsRunPaused(),
                child: MaterialButton(
                  // padding ustawia promien przycisku
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  color: colorTheme.ColorTheme.trainingPageStartButtonColor,
                  // if statement
                  child: Icon(
                    Icons.play_arrow,
                    color: colorTheme.ColorTheme.trainingPageButtonIconPlayColor,
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
                      widget.callback(false);
                    });
                  },
                ),
              ),
              Visibility(
                visible: _runManager.getIsRunning() && !_runManager.getIsRunPaused(),
                child: MaterialButton(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  color: colorTheme.ColorTheme.trainingPagePauseButtonColor,
                    child: Icon(
                      Icons.pause,
                      color: colorTheme.ColorTheme.trainingPageButtonIconPauseColor,
                      size: 40,
                    ),
                  onPressed: () {
                    //pause run
                    setState(() {
                      _stopwatchTimer.onExecute.add(StopWatchExecute.stop);
                      _mapController.fitBounds(StatsCalculator.getSquare(_runPositions));
                      _runManager.pauseStream();
                    });
                  },
                ),
              ),
              Visibility(
                visible: _runManager.getIsRunning() && _runManager.getIsRunPaused(),
                child: Expanded(
                  flex: 4,
                  child: MaterialButton(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    color: colorTheme.ColorTheme.trainingPageStopButtonColor,
                    child: Icon(
                      Icons.stop,
                      color: colorTheme.ColorTheme.trainingPageButtonIconStopColor,
                      size: 40,
                    ),
                    onPressed: () {
                      //end run
                      _mapController.fitBounds(StatsCalculator.getSquare(_runPositions));
                      screenshotController.capture().then((File image) {
                        //Capture Done
                        image.readAsBytes().then((valueImage) {
                          _runManager.endRun(
                            "test desc",
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
                            _runManager.resumeStream();
                            widget.callback(true);
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
                  flex: 4,
                  child: MaterialButton(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    color: colorTheme.ColorTheme.trainingPageStartButtonColor,
                    child: Icon(
                      Icons.play_arrow,
                      color: colorTheme.ColorTheme.trainingPageButtonIconPlayColor,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        //resume run
                        _stopwatchTimer.onExecute.add(StopWatchExecute.start);
                        _runManager.resumeStream();
                      });
                    },
                  ),
                ),
              ),
              Spacer(
                flex: 1,
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
        _currPosition = LatLng(position.latitude, position.longitude);
        if(_runManager.getIsRunning() && !_runManager.getIsRunPaused()) {
          _statsCalculator.updatePosition(_currPosition);
          _runPositions.add(_currPosition);
        }
        if (_isFollowing) _mapController.move(_currPosition, _mapController.zoom);
      });
    }
  }
}
