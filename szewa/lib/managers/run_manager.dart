import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:szewa/constants.dart';
import 'package:szewa/managers/connection_manager.dart';
import 'package:szewa/managers/location_service.dart';
import 'db_manager.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';


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
    });
  }

  void pauseStream() {
    _isRunPaused = true;
    _positionStream.pause();
  }

  void resumeStream() {
    _isRunPaused = false;
    _positionStream.resume();
  }

  void endStream() {
    _positionStream.cancel();
  }

  Future<void> endRun(String description, double distance, double avgVelocity, int calories, int duration, Uint8List picture) async {
    _isRunning = !_isRunning;
    var connectivityResult = await (Connectivity().checkConnectivity());
    int serverRunId;
    //_positionStream.cancel();
    _dbManager.addRun(_runId, _startTime, description, distance, avgVelocity, calories, duration, picture);
    // check connection to network
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      // user is logged
      String emailStorage = await storage.read(key: Consts.emailStorageKey);
      if (emailStorage != null) {
        int serverRunId = await ConnectionManager().sendActivity(_runId);
        if(null != serverRunId) {
          await _dbManager.updateActivity(_runId, serverRunId);
          ConnectionManager().sendPhoto(_runId, serverRunId);
        }
      }
    }
    _runId = null;
    _dbManager.printRuns();
  }

  Future<void> _startStreamOld() async {
    _positionStream = Geolocator
        .getPositionStream(
      desiredAccuracy : LocationAccuracy.best,
      distanceFilter : 0,
      forceAndroidLocationManager : false,
      intervalDuration : Duration(seconds: 2),
      //timeLimit : Duration(seconds: 10)
    )
        .listen((position) {
      _addPosition(position);
    });
  }

  Future<void> startStream() async {
    _positionStream = LocationService().locationStream.listen((position) {
      if(null != _runObserver) {
        _runObserver.onRunChanged(position);
      }
      if(_isRunning && !_isRunPaused) {
        _addPosition(position);
      }
    });
  }

  void _addPosition(Position position) {
    _dbManager.addGeolocation(position, _runId);
    print("position has changed !Current: lat: ${position.latitude}, long: ${position.longitude}");
  }

}