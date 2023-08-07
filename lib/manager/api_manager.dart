import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:travel_hour/manager/jwt_manager.dart';

class APIManager {
  String _baseUri = "http://127.0.0.1:8490";

  Future<dynamic> GET(String uri) async {

    String? accessToken = GetIt.instance.get<JWTManager>().accessToken;

    if(accessToken == null)
      return "";

    final http.Response httpResponse = await http.get(
        Uri.parse(_baseUri + uri),
        headers: <String, String>{'Authorization': 'Bearer $accessToken'});

    final response = json.decode(utf8.decode(httpResponse.bodyBytes));

    return httpResponse.statusCode == 200 ?  response["data"] : null;
  }

  Future<dynamic> POST(String uri, Map param) async {
    String? accessToken = GetIt.instance.get<JWTManager>().accessToken;

    if(accessToken == null)
      return "";

    final http.Response httpResponse = await http.post(
        Uri.parse(_baseUri + uri),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type' : 'application/json'
        },
        body: json.encode(param)
    );

    final response = json.decode(utf8.decode(httpResponse.bodyBytes));

    return httpResponse.statusCode == 200 ?  response["data"] : null;
  }

  Future<dynamic> PUT(String uri, Map param) async {
    String? accessToken = GetIt.instance.get<JWTManager>().accessToken;

    if(accessToken == null)
      return "";

    final http.Response httpResponse = await http.put(
        Uri.parse(_baseUri + uri),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type' : 'application/json'
        },
        body: json.encode(param)
    );


    final response = json.decode(utf8.decode(httpResponse.bodyBytes));

    return httpResponse.statusCode == 200 ?  response["data"] : null;
  }

  Future<dynamic> DELETE(String uri, Map param) async {
    String? accessToken = GetIt.instance.get<JWTManager>().accessToken;

    if(accessToken == null)
      return "";

    final http.Response httpResponse = await http.delete(
        Uri.parse(_baseUri + uri),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken',
          'Content-Type' : 'application/json'
        },
        body: json.encode(param)
    );

    final response = json.decode(utf8.decode(httpResponse.bodyBytes));

    return httpResponse.statusCode == 200 ?  response["data"] : null;
  }

}