import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/run_model.dart';
import 'package:szewa/models/geolocation_model.dart';


sendActivity() async {

  List<RunModel> runs = await DbManager().getRuns();
  var run = runs[0];
  // List<GeolocationModel> geolocators = await DbManager().getGeolocations();
  // List<String> locations;

  // geolocators.forEach((element) {
  //   element.toMap();
  //   if (element.toMap()['id'] == run.id.toString()){
  //     locations.add(element.toString());
  //   }
  // });

  // DbManager().printRuns();


  // print("fdasfasfafasfsa  ^^^^^^^^^^^^^\n"+ geolocator.toString());

  final response = await http.post(
      // Uri.parse('http://178.183.128.112:7080/api/activity/new-activity'),
    Uri.http('178.183.128.112:7080', '/api/activity/new-activity'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, dynamic>{
        "id": run.id.toString(),
        "locations": [{
          'id' : '0',
          "latitude": "string",
          "longitude": "string",
          "time": "2021-05-27T18:03:38.363Z"
        }],
        "startTime": run.dateTime.toString()
      }),
  );

  if (response.statusCode == 200) {
    // poszlo ale nie stworzylo
    print("odp from serwer ^^^^^^^^^^^^^^^^^^\n" + jsonDecode(response.body));
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }

}