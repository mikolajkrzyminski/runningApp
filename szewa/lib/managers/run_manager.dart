import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'db_manager.dart';

abstract class RunObserver {
  void onRunChanged(Position position);
}

class RunManager {
  int _runId;
  StreamSubscription<Position> _positionStream;
  DbManager _dbManager;
  bool _isRunning;
  RunObserver _runObserver;

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
  }

  void changeState() async {
    _isRunning = !_isRunning;
    if (_isRunning) {
      _startRun(DateTime.now().millisecondsSinceEpoch);
    } else {
      _endRun();
    }
  }

  bool getIsRunning() {
    return _isRunning;
  }

  void _startRun(int dateTime) async {
    _runId = await _dbManager.addRun(dateTime, "Test desc");
    _startStream();
  }

  void _endRun() {
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
      intervalDuration : Duration(seconds: 5),
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