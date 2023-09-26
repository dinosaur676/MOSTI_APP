import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:travel_hour/manager/jwt_manager.dart';

class APIManager {
  static final String URL_WALLET_CONNECT_LOG = "/api/wallet-connect-log";
  static final String URL_WALLET = "/api/wallet";
  static final String URL_NOTICE = "/api/notice";
  static final String URL_TOKEN = "/api/token";

  String _baseUri = "http://127.0.0.1:8490";

  Future<dynamic> GET(String uri, {Map? param}) async {

    String? accessToken = GetIt.instance.get<JWTManager>().accessToken;

    if(accessToken == null)
      return "";

    String paramStr = "?";

    param?.forEach((key, value) {
      paramStr += "$key=$value&";
    });

    paramStr = paramStr.substring(0, paramStr.length - 1);

    final http.Response httpResponse = await http.get(
        Uri.parse(_baseUri + uri + paramStr),
        headers: <String, String>{'Authorization': 'Bearer $accessToken'}
    );

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