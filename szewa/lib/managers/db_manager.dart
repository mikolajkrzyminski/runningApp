import 'package:flutter/material.dart';
import 'package:szewa/models/geolocation_model.dart';
import 'package:szewa/models/run_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:geolocator/geolocator.dart';

class DbManager {

  static final _instance = DbManager._DbManager();

  Future<Database> _database;
  String _databasePath;

  factory DbManager() {
    return _instance;
  }

  DbManager._DbManager() {
    getDatabasesPath().then((value) {
      _databasePath = join(value, 'szewa.db');
      _open();
    });
  }

  void _open() async {

    _delete();

    _database = openDatabase(
      _databasePath,
      onCreate: (db, version) {
        _createTables(db);
      },
      version: 1,
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute(RunModel.createStatement, );
    await db.execute(GeolocationModel.createStatement, );
  }

  Future<void> _delete() async {
    await deleteDatabase(_databasePath);
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> addGeolocation(Position geolocator, int runId) async {
    final geoposition = GeolocationModel(
      runId,
      geolocator.timestamp.millisecondsSinceEpoch,
      geolocator.altitude,
      geolocator.latitude,
      geolocator.longitude,
      geolocator.speed,
    );
    await _insertGeolocation(geoposition);
  }

  Future<void> _insertGeolocation(GeolocationModel geolocation) async {
    // Get a reference to the database.
    Database db = await _database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      GeolocationModel.tableName,
      geolocation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GeolocationModel>> _getGeolocations() async {
    // Get a reference to the database.
    final Database db = await _database;
    // Query the table for all The Runs.
    final List<Map<String, dynamic>> maps = await db.query(GeolocationModel.tableName);
    // Convert the List<Map<String, dynamic> into a List<RunModel>.
    return List.generate(maps.length, (i) {
      return GeolocationModel.fromMap(maps[i]);
    });
  }

  void printRuns() async {
    print('----------------');
    List<GeolocationModel> runs = await _getGeolocations();
    int index = 0;
    runs.forEach((element) {
      print('$index: ${element.toString()}');
      index ++;
    });
  }

  Future<int> addRun(int dateTime, String description) async {
    final run = RunModel(
      id: null,
      dateTime: dateTime,
      description: description,
    );
    return _insertRun(run);
  }

  Future<int> _insertRun(RunModel run) async {
    // Get a reference to the database.
    Database db = await _database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    return db.insert(
      RunModel.tableName,
      run.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getMaxRunId() async {
    final Database db = await _database;
    return Sqflite
        .firstIntValue(await db.rawQuery('SELECT MAX(${RunModel.fldId}) from ${RunModel.tableName}'));
  }

}