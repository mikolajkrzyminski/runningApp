import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:szewa/constants.dart';


class ConnectionManager {
  //singleton
  static final _instance = ConnectionManager._connection();

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
  }

  Future<bool> getIsLogged() {
    return storage.read(key: Consts.jwtStorageKey).then((value) => value != null ? true : false);
  }

}