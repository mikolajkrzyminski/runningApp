import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:szewa/managers/db_manager.dart';


fetchAlbum() async {

  final response = await http.get(Uri.http('178.183.128.112:7080', '/api/activity/1'));

  if (response.statusCode == 200) {
    // Kiedy serwer zwróci 200 OK
    var js = jsonDecode(response.body);

    // wpisanie pobranej aktywności do lokalnej bazy
    DbManager _dbManager = DbManager();

    // konwersja daty z string do int
    String dateStr = js['startTime'];
    // lista lokalizacji
    var geolocations = js['locations'];

    DateTime date = DateTime.parse(dateStr);
    int dateTime = date.millisecondsSinceEpoch;

    // dodanie "pustego" biegu
    int _idRun = await _dbManager.addRun(dateTime, 'From server');
    // aktualizacja pól, bez przypisania wszystkich wartosci rekord się nie pojawi
    get(Uri.https('a.tile-cyclosm.openstreetmap.fr', '/cyclosm/12/2103/1347.png')).then((value) => _dbManager.updateRunInfo(_idRun, 0.0, 0.0, 0, 0, value.bodyBytes));

    // dodawanie poszczegolnych lokalizacji z aktywnosci
    geolocations.forEach((elem){
      Position position = Position(longitude: double.tryParse(elem['longitude']), latitude: double.tryParse(elem['latitude']), timestamp: DateTime.parse(elem['time']), accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
      _dbManager.addGeolocation(position, _idRun);
    });

    return jsonDecode(response.body);
  } else {
    // Kiedy pojawi sie bład w połączeniu
    throw Exception('Failed to load data');
  }
}
