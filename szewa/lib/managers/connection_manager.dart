import 'dart:convert';
import 'package:http/http.dart' as http;

class Connection {
  //singleton
  static final _instance = Connection._connection();

  factory Connection() {
    return _instance;
  }

  String _adress;

  //constructor
  Connection._connection() {
    _adress = 'http://178.183.128.112:7080';
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
}