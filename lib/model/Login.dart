import 'package:admin_project/model/Connectapi.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Login{
  Login();
  
  Future<http.Response> adminLogin(String username, String password) async {
    String url = '${Connectapi().domain}/loginadmin';
    var body = {
      "username": username,
      "password": password,
    };

    return http.post(Uri.parse(url), body: body);
  }

  Future<http.Response> doLogin2(String username, String password) async {
    String url = '${Connectapi().domain}/login2';
    var body = {
      "username": username,
      "password": password,
    };

    return http.post(Uri.parse(url), body: body);
  }
}