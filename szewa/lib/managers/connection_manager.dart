import 'dart:convert';
import 'dart:html';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:szewa/constants.dart';
import 'package:szewa/managers/db_manager.dart';
import 'package:szewa/models/geolocation_model.dart';
import 'package:szewa/models/run_model.dart';
import 'package:http_parser/http_parser.dart';

class ConnectionManager {
  //singleton
  static final _instance = ConnectionManager._connection();
  static final _cookieJsonKey = "set-cookie";
  static final _tokenJsonKey = "token";
  static final _emailJsonKey = "email";


  factory ConnectionManager() {
    return _instance;
  }

  String _adress;
  FlutterSecureStorage storage;

  //constructor
  ConnectionManager._connection() {
    _adress = 'http://178.183.128.112:7080';
    storage = FlutterSecureStorage();
  }

  Future<http.Response> createUser(String password, String email) {
    return http.post(
      Uri.parse('$_adress/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  Future<http.Response> authorizeUser(String password, String email) {
    return http.post(
      Uri.parse('$_adress/api/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
  }

  Future<void> setResponse(http.Response response) {
    storage.write(key: Consts.jwtStorageKey, value: response.body);
    storage.write(key: Consts.cookieStorageKey, value: response.headers[_cookieJsonKey]);
  }

  Future<bool> getIsLogged() {
    return storage.read(key: Consts.jwtStorageKey).then((value) => value != null ? true : false);
  }

  /*
  Future<http.Response> sendPhoto(int activityLocalId, int serverActivityId) async {
    RunModel activity = await DbManager().getRunById(activityLocalId);
    //create multipart request for POST or PATCH method
    String token = "Bearer ";
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      token += jsonDecode(value)[_tokenJsonKey];
    });
    var request = http.MultipartRequest('POST', Uri.parse(_adress + "/api/activity/$serverActivityId/add-picture"))
      ..files.add(await http.MultipartFile.fromBytes(
          "picture", activity.picture, contentType: MediaType("application", "octet-stream"),
          ));
    request.headers['Content-Type'] = 'multipart/form-data; charset=UTF-8';
    request.headers["Authorization"] = token;
    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }
*/

  Future<http.Response> sendPhoto(int activityLocalId, int serverActivityId) async {
    RunModel activity = await DbManager().getRunById(activityLocalId);
    //create multipart request for POST or PATCH method
    String token = "Bearer ";
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      token += jsonDecode(value)[_tokenJsonKey];
    });
    var request = http.MultipartRequest('POST', Uri.parse(_adress + "/api/activity/$serverActivityId/add-picture"));
    request.files.add(await http.MultipartFile.fromBytes('image', (await rootBundle.load('assets/images/catGrey.png')).buffer.asUint8List(), filename: "catGrey.png",));
    request.headers['Content-Type'] = 'multipart/form-data; charset=UTF-8';
    request.headers["Authorization"] = token;
    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }

  Future<http.Response> sendActivity(int activityLocalId) async {
    RunModel activity = await DbManager().getRunById(activityLocalId);
    List<GeolocationModel> geolocations = await DbManager().getGeolocationsById(activityLocalId);
    var geolocationsJson = [];
    geolocations.forEach((element) {
      geolocationsJson.add(element.toJson());
    });
    String token;
    String email;
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      token = jsonDecode(value)[_tokenJsonKey];
      email = jsonDecode(value)[_emailJsonKey];
    });
    var activitiJson = activity.toJson(email, geolocationsJson);
    var jsonBody = jsonEncode(activitiJson);
    return http.post(
      Uri.parse('$_adress/api/activity/new-activity'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
  }

  Future<http.Response> getPhoto(int runId) async {
    String token;
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      token = jsonDecode(value)[_tokenJsonKey];
    });
    return http.get(
      Uri.parse('$_adress/api/activity/${runId}/get-picture'),
      headers: <String, String>{
        'Content-Type': 'multipart/form-data; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.StreamedResponse> getPicture() async {
    //create multipart request for POST or PATCH method
    String token = "Bearer ";
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      token += jsonDecode(value)[_tokenJsonKey];
    });
    var request = http.MultipartRequest('GET', Uri.parse(_adress + "/api/activity/7/get-picture"));
    request.headers['Content-Type'] = 'multipart/form-data; charset=UTF-8';
    request.headers["Authorization"] = token;
    return request.send();
  }

  Future<http.Response> getAllActivities() async {
    String token;
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      token = jsonDecode(value)[_tokenJsonKey];
    });
    return http.get(
      Uri.parse('$_adress/api/activity/all-activities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
  }

  //TODO
  Future<http.Response> refreshToken() async {
    String cookie;
    await storage.read(key: Consts.jwtStorageKey).then((value) {
      cookie = jsonDecode(value)[_tokenJsonKey];
    });
    return http.post(
      Uri.parse('$_adress/api/auth/refresh-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        _cookieJsonKey: cookie,
      },
    ).then((response) {
      setResponse(response);
      return response;
    });
  }

}