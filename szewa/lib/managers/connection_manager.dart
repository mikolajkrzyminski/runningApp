import 'dart:convert';
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
  static String _adress = 'http://178.183.128.112:7080';

  factory ConnectionManager() {
    return _instance;
  }

  FlutterSecureStorage _storage;

  //constructor
  ConnectionManager._connection() {
    _storage = FlutterSecureStorage();
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

  Future<bool> authorizeUser(String password, String email) async {
    http.Response response = await http.post(
      Uri.parse('$_adress/api/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if(200 == response.statusCode) {
      _setResponse(response);
      return true;
    } else {
      return false;
    }
  }

  Future<void> _setResponse(http.Response response) async {
    _storage.write(key: Consts.jwtStorageKey, value: response.body);
    _storage.write(key: Consts.cookieStorageKey, value: response.headers[_cookieJsonKey]);
  }

  Future<bool> getIsLogged() {
    return _storage.read(key: Consts.jwtStorageKey).then((value) => value != null ? true : false);
  }

  Future<void> sendPhoto(int activityLocalId, int serverActivityId) async {
    RunModel activity = await DbManager().getRunById(activityLocalId);
    //create multipart request for POST or PATCH method
    for(int i = 0; i < 2; i++) {
      String token = "Bearer ";
      var value = await _storage.read(key: Consts.jwtStorageKey);
      token += jsonDecode(value)[_tokenJsonKey];
      var request = http.MultipartRequest('POST',
          Uri.parse(_adress + "/api/activity/$serverActivityId/add-picture"))
        ..files.add(http.MultipartFile(
            "picture",
            http.ByteStream.fromBytes(activity.picture),
            activity.picture.length,
            contentType: MediaType("application", "png"),
            filename: "abc.png"
        ));
      request.headers["Authorization"] = token;
      var response = await request.send();
      if (401 == response.statusCode)
        await refreshToken();
      else break;
    }
  }


  Future<int> sendActivity(int activityLocalId) async {
    RunModel activity = await DbManager().getRunById(activityLocalId);
    List<GeolocationModel> geolocations = await DbManager().getGeolocationsById(activityLocalId);
    var geolocationsJson = [];
    geolocations.forEach((element) {
      geolocationsJson.add(element.toJson());
    });
    String token;
    String email;
    for(int i = 0; i < 2; i++) {
      await _storage.read(key: Consts.jwtStorageKey).then((value) {
        token = jsonDecode(value)[_tokenJsonKey];
        email = jsonDecode(value)[_emailJsonKey];
      });
      var activityJson = activity.toJson(email, geolocationsJson);
      var jsonBody = jsonEncode(activityJson);
      http.Response response = await http.post(
        Uri.parse('$_adress/api/activity/new-activity'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonBody,
      );
      if (401 == response.statusCode) await refreshToken();
      else if (200 == response.statusCode) return jsonDecode(response.body)["id"] as int;
      }
    return null;
    }

  Future<String> getPhoto(int runId) async {
    String token;
    for(int i = 0; i < 2; i++) {
      await _storage.read(key: Consts.jwtStorageKey).then((value) {
        token = jsonDecode(value)[_tokenJsonKey];
      });
      http.Response response = await http.get(
        Uri.parse('$_adress/api/activity/$runId/get-picture'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      if (401 == response.statusCode) await refreshToken();
      else if (200 == response.statusCode) return response.body;
    }
    return null;
  }

  Future<dynamic> getAllActivities() async {
    String token;
    for(int i = 0; i < 2; i++) {
      await _storage.read(key: Consts.jwtStorageKey).then((value) {
        token = jsonDecode(value)[_tokenJsonKey];
      });
      http.Response response = await http.get(
        Uri.parse('$_adress/api/activity/all-activities'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (401 == response.statusCode) await refreshToken();
      else if (200 == response.statusCode) return jsonDecode(response.body);
    }
    return null;
  }

  Future<void> refreshToken() async {
    String rawCookie;
    String cookie;
    await _storage.read(key: Consts.cookieStorageKey).then((value) {
      rawCookie = value;
    });
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
    http.Response response = await http.post(
      Uri.parse('$_adress/api/auth/refresh-token'),
      headers: <String, String>{
        'cookie': cookie,
      },
      body: {},
    );
    if(200 == response.statusCode) {
      await _setResponse(response);
    } else {
      throw("token cannot be refreshed");
    }
  }

}