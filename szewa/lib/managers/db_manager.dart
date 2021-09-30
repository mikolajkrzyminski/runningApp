import 'dart:typed_data';

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
    _database = _open();
  }

  Future<Database> _open() async {
    return openDatabase(
      join(await getDatabasesPath(), 'szewa.db'),
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

  Future<void> clean() async {
    Database db = await _database;
    db.delete(RunModel.tableName);
    db.delete(GeolocationModel.tableName);
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

  Future<List<GeolocationModel>> getGeolocations() async {
    // Get a reference to the database.
    final Database db = await _database;
    // Query the table for all The Runs.
    final List<Map<String, dynamic>> geolocators = await db.query(GeolocationModel.tableName);
    if (geolocators.isNotEmpty) {
      // Convert the List<Map<String, dynamic> into a List<GeolocationModel>.
      return List.generate(geolocators.length, (i) {
        return GeolocationModel.fromMap(geolocators[i]);
      });
    } else return [];
  }

  Future<List<RunModel>> getRuns() async {
    // Get a reference to the database.
    final Database db = await _database;
    // Query the table for all The Runs.
    final List<Map<String, dynamic>> runs = await db.query(RunModel.tableName, orderBy: "${RunModel.fldDateTime} DESC");
    if (runs.isNotEmpty) {
      // Convert the List<Map<String, dynamic> into a List<RunModel>.
      return List.generate(runs.length, (i) {
        return RunModel.fromMap(runs[i]);
      });
    } else return [];
  }

  void printRuns() async {
    print('----------------');
    List<GeolocationModel> geolocators = await getGeolocations();
    int index = 0;
    geolocators.forEach((element) {
      print('$index: ${element.toString()}');
      index ++;
    });
    print('----------------');
    List<RunModel> runs = await getRuns();
    index = 0;
    runs.forEach((element) {
      print('$index: ${element.toString()}');
      index ++;
    });
  }

  Future<int> addRun(int id, int dateTime, String description, double distance, double avgVelocity, int calories, int duration, Uint8List picture) async {
    final run = RunModel(
      id: id,
      dateTime: dateTime,
      description: description,
      distance: distance,
      avgVelocity: avgVelocity,
      calories: calories,
      duration: duration,
      picture: picture,
    );
    return insertRun(run);
  }

  Future<int> insertRun(RunModel run) async {
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

  Future<void> updateActivity(int activityId, int serverId) async {
    Database db = await _database;
    db.rawQuery(RunModel.getUpdateString(activityId, serverId));
  }

  Future<int> getMaxRunId() async {
    final Database db = await _database;
    return Sqflite
        .firstIntValue(await db.rawQuery('SELECT MAX(${RunModel.fldId}) from ${RunModel.tableName}'));
  }

  Future<RunModel> getRunById(int id) async {
    final Database db = await _database;
    List<Map<String, Object>> activity = await db.query(
        RunModel.tableName, where: "${RunModel.fldId} == $id");
    if (activity.isNotEmpty) {
      return RunModel.fromMap(activity[0]);
    } else
      return null;
  }

    Future<List<GeolocationModel>> getGeolocationsById(int id) async {
      final Database db = await _database;
      List<Map<String, Object>> geolocations = await db.query(
          GeolocationModel.tableName, where: "${GeolocationModel.fldRunId} == $id");
      if (geolocations.isNotEmpty) {
        return List.generate(geolocations.length, (i) {
          return GeolocationModel.fromMap(geolocations[i]);
        });
      } else return [];
    }
}