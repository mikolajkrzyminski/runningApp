import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:szewa/managers/connection_manager.dart';
import 'db_manager.dart';
import 'package:http/http.dart' as http;


abstract class RunObserver {
  void onRunChanged(Position position);
}

class RunManager {
  int _runId;
  StreamSubscription<Position> _positionStream;
  DbManager _dbManager;
  bool _isRunning;
  bool _isRunPaused;
  RunObserver _runObserver;
  int _startTime;

  //singleton
  static final RunManager _instance = RunManager._RunManager();

  factory RunManager(RunObserver runObserver) {
    _instance._runObserver = runObserver;
    return _instance;
  }

  RunManager._RunManager() {
    _runObserver = null;
    _dbManager = DbManager();
    _isRunning = false;
    _isRunPaused = false;
    _runId = null;
    _startTime = 0;
  }

  bool getIsRunning() {
    return _isRunning;
  }

  bool getIsRunPaused() {
    return _isRunPaused;
  }

  void changeIsRunPaused() {
    _isRunPaused = !_isRunPaused;
  }

  int getId() {
    return _runId;
  }

  void startRun(int dateTime) async {
    _startTime = dateTime;
    _isRunning = !_isRunning;
    _dbManager.getMaxRunId().then((value) {
      if (value != null) _runId = value + 1;
      else _runId = 0;
      _startStream();
    });
  }

  void pauseRun() {
    changeIsRunPaused();
    _positionStream.cancel();
  }

  void resumeRun() {
    changeIsRunPaused();
    _startStream();
  }

  Future<void> endRun(String description, double distance, double avgVelocity, int calories, int duration, Uint8List picture) async {
    _isRunning = !_isRunning;
    _dbManager.addRun(_runId, _startTime, description, distance, avgVelocity, calories, duration, picture);
    var response = await ConnectionManager().sendActivity(_runId);
    response.body;
    ConnectionManager().sendPhoto(_runId, jsonDecode(response.body)["id"]);
    var getResponse = await ConnectionManager().getAllActivities();
    getResponse.body;
    //var refreshTokenReponse = await ConnectionManager().refreshToken();
    //refreshTokenReponse.body;
    _positionStream.cancel();
    _runId = null;
    _dbManager.printRuns();
  }

  Future<void> _startStream() async{
    _positionStream = Geolocator
        .getPositionStream(
      desiredAccuracy : LocationAccuracy.best,
      distanceFilter : 0,
      forceAndroidLocationManager : false,
      intervalDuration : Duration(seconds: 2),
      //timeLimit : Duration(seconds: 10)
    )
        .listen((position) {
      _dbManager.addGeolocation(position, _runId);
      if(null != _runObserver) {
        _runObserver.onRunChanged(position);
      }
      print("position has changed !Current: lat: ${position.latitude}, long: ${position.longitude}");
    });
  }



}