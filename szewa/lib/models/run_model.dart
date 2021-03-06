import 'dart:typed_data';

class RunModel {

  static final String fldId = 'id';
  static final String fldDateTime = 'dateTime';
  static final String _fldDescription = 'description';
  static final String _fldDistance = 'distance';
  static final String _fldAvgVelocity = 'avgVelocity';
  static final String _fldCalories = "calories";
  static final String _fldDuration = "duration";
  static final String _fldPicture = "picture";
  static final String _fldServerId = "serverId";

  static String tableName = 'runs';
  static String createStatement = 'CREATE TABLE $tableName '
      '('
      '$fldId INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$fldDateTime INTEGER, '
      '$_fldDescription TEXT, '
      '$_fldDistance DOUBLE, '
      '$_fldAvgVelocity DOUBLE, '
      '$_fldCalories INTEGER, '
      '$_fldDuration INTEGER, '
      '$_fldPicture BLOB,'
      '$_fldServerId INTEGER'
      ')';

  final int id;
  final int dateTime;
  final String description;
  final double distance;
  final double avgVelocity;
  final int calories;
  final int duration;
  final Uint8List picture;
  final int serverId;

  RunModel({
    this.id,
    this.dateTime,
    this.description,
    this.distance,
    this.avgVelocity,
    this.calories,
    this.duration,
    this.picture,
    this.serverId,
  });

  RunModel.fromMap(Map<String, dynamic> runMap) :
        id = runMap[fldId],
        dateTime = runMap[fldDateTime],
        description = runMap[_fldDescription],
        distance = runMap[_fldDistance],
        avgVelocity = runMap[_fldAvgVelocity],
        calories = runMap[_fldCalories],
        duration = runMap[_fldDuration],
        picture = runMap[_fldPicture],
        serverId = runMap[_fldServerId];

  Map<String, dynamic> toMap() {
    return {
      fldId: id,
      fldDateTime: dateTime,
      _fldDescription: description,
      _fldDistance: distance,
      _fldAvgVelocity: avgVelocity,
      _fldCalories: calories,
      _fldDuration: duration,
      _fldPicture: picture,
      _fldServerId: serverId,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      _fldDistance: distance,
      _fldAvgVelocity: avgVelocity,
      _fldCalories: calories,
      _fldDuration: duration,
      _fldPicture: picture,
    };
  }

  static String getUpdateString(int id, int serverId) {
    return 'UPDATE $tableName '
        'SET $_fldServerId = $serverId '
        'WHERE $fldId = $id';
  }

  String toString() {
    return (
        '$fldId: $id, '
            '$fldDateTime: ${DateTime.fromMillisecondsSinceEpoch(dateTime)}, '
            '$_fldDescription: $description, '
            '$_fldDistance: $distance, '
            '$_fldAvgVelocity: $avgVelocity, '
            '$_fldCalories: $calories, '
            '$_fldDuration: $duration, '
    );
  }

  factory RunModel.fromJson(Map<String, dynamic> json, Uint8List picture) {
    return RunModel(
      id: json[fldId] as int,
      dateTime: DateTime.parse(json["startTime"]).millisecondsSinceEpoch,
      description: json[_fldDescription] as String,
      distance: json[_fldDistance] as double,
      avgVelocity: json[_fldAvgVelocity] as double,
      calories: json[_fldCalories] as int,
      duration: json["durationSeconds"] as int,
      picture: picture,
      serverId: json["id"] as int,
    );
  }

    Map<String, dynamic> toJson(String email, var locations) =>
      {
        "avgVelocity": avgVelocity.toString(),
        "calories": calories.toString(),
        "description": description,
        "distance": distance.toString(),
        "durationSeconds": duration.toString(),
        "locations": locations,
        "startTime": DateTime.fromMillisecondsSinceEpoch(dateTime).toIso8601String() + 'Z',
        "userEmail": email
      };
}
