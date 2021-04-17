class RunModel {

  static final String fldId = 'id';
  static final String _fldDateTime = 'dateTime';
  static final String _flDescription = 'description';

  static String tableName = 'runs';
  static String createStatement = 'CREATE TABLE $tableName ($fldId INTEGER PRIMARY KEY AUTOINCREMENT, $_fldDateTime INTEGER, $_flDescription TEXT)';

  final int id;
  final int dateTime;
  final String description;

  RunModel({
    this.id,
    this.dateTime,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      _fldDateTime: dateTime,
      _flDescription: description,
    };
  }
}