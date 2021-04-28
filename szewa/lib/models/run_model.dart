class RunModel {

  static final String fldId = 'id';
  static final String _fldDateTime = 'dateTime';
  static final String _fldDescription = 'description';
  static final String _fldDistance = 'distance';
  static final String _fldAvgVelocity = 'avgVelocity';
  static final String _fldCalories = "calories";

  static String tableName = 'runs';
  static String createStatement = 'CREATE TABLE $tableName ($fldId INTEGER PRIMARY KEY AUTOINCREMENT, $_fldDateTime INTEGER, $_fldDescription TEXT, $_fldDistance DOUBLE, $_fldAvgVelocity DOUBLE, $_fldCalories INTEGER)';

  final int id;
  final int dateTime;
  final String description;
  final double distance;
  final double avgVelocity;
  final int calories;

  RunModel({
    this.id,
    this.dateTime,
    this.description,
    this.distance,
    this.avgVelocity,
    this.calories,
  });

  RunModel.fromMap(Map<String, dynamic> runMap) :
        id = runMap[fldId],
        dateTime = runMap[_fldDateTime],
        description = runMap[_fldDescription],
        distance = runMap[_fldDistance],
        avgVelocity = runMap[_fldAvgVelocity],
        calories = runMap[_fldCalories];

  Map<String, dynamic> toMap() {
    return {
      fldId: id,
      _fldDateTime: dateTime,
      _fldDescription: description,
      _fldDistance: distance,
      _fldAvgVelocity: avgVelocity,
      _fldCalories: calories,
    };
  }

  static String getUpdateString(int id, double distance, double avgVelocity, int calories) {
    return 'UPDATE $tableName '
        'SET $_fldDistance = $distance, '
        '$_fldAvgVelocity = $avgVelocity, '
        '$_fldCalories = $calories '
        'WHERE $fldId = $id';
  }

  String toString() {
    return (
        '$fldId: $id, '
            '$_fldDateTime: ${DateTime.fromMillisecondsSinceEpoch(dateTime)}, '
            '$_fldDescription: $description, '
            '$_fldDistance: $distance, '
            '$_fldAvgVelocity: $avgVelocity, '
            '$_fldCalories: $calories'
    );
  }

}
