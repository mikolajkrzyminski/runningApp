import 'package:szewa/models/run_model.dart';

class GeolocationModel {
  //col names from db
  static final String fldRunId = 'runId';
  static final String _fldDateTime = 'dateTime';
  static final String _fldAltitude = 'altitude';
  static final String _fldLatitude = 'latitude';
  static final String _fldLongitude = 'longitude';
  static final String _fldSpeed = 'speed';
  //db table name
  static String tableName = 'geolocations';
  //create script
  static String createStatement = 'CREATE TABLE $tableName('
      '$fldRunId INTEGER, '
      '$_fldDateTime INTEGER, '
      '$_fldAltitude DOUBLE, '
      '$_fldLatitude DOUBLE, '
      '$_fldLongitude DOUBLE, '
      '$_fldSpeed DOUBLE, '
      'PRIMARY KEY($fldRunId, $_fldDateTime), '
      'FOREIGN KEY($fldRunId) REFERENCES ${RunModel.tableName}(${RunModel.fldId}))';

  final int _id;
  final int _dateTime;
  final double _altitude;
  final double _latitude;
  final double _longitude;
  final double _speed;

  GeolocationModel(
      this._id,
      this._dateTime,
      this._altitude,
      this._latitude,
      this._longitude,
      this._speed,
      );

  GeolocationModel.fromMap(Map<String, dynamic> geolocationMap) :
        _id = geolocationMap[fldRunId],
        _dateTime = geolocationMap[_fldDateTime],
        _altitude = geolocationMap[_fldAltitude],
        _latitude = geolocationMap[_fldLatitude],
        _longitude = geolocationMap[_fldLongitude],
        _speed = geolocationMap[_fldSpeed];

  Map<String, dynamic> toMap() {
    return {
      fldRunId: _id,
      _fldDateTime: _dateTime,
      _fldAltitude: _altitude,
      _fldLatitude: _latitude,
      _fldLongitude: _longitude,
      _fldSpeed: _speed,
    };
  }

  String toString() {
    return (
        '$fldRunId: $_id, '
            '$_fldDateTime: ${DateTime.fromMillisecondsSinceEpoch(_dateTime)}, '
            '$_fldAltitude: $_altitude, '
            '$_fldLatitude: $_latitude, '
            '$_fldLongitude: $_longitude, '
            '$_fldSpeed $_speed'
    );
  }

  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(
      json["id"] as int,
      json["time"] as int,
      0 as double,
      json[_fldLatitude] as double,
      json[_fldLongitude] as double,
      0 as double,
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "latitude": _latitude.toString(),
        "longitude": _longitude.toString(),
        "time": DateTime.fromMillisecondsSinceEpoch(_dateTime).toIso8601String() + 'Z',
      };
}