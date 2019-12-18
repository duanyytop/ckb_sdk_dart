import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

var random = Random.secure();

class Rpc {
  String nodeUrl;
  var dio;

  Rpc(this.nodeUrl, {hasLogger = false, HttpClientAdapter adapter}) {
    if (adapter != null) {
      dio = Dio();
      dio.httpClientAdapter = adapter;
    } else {
      dio = Dio(BaseOptions(connectTimeout: 30000, headers: {'Content-type': 'application/json'}));
    }
    if (hasLogger) {
      dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  Future post(String url, List params) async {
    Map<String, dynamic> body = {
      "jsonrpc": "2.0",
      "id": random.nextInt(pow(10, 6)),
      "method": url,
      "params": params
    };
    var response = await dio.post(nodeUrl, data: body);

    if (response.statusCode == 200) {
      var res;
      if (response.data.runtimeType.toString() == 'String') {
        res = RpcResponse.fromJson(jsonDecode(response.data));
      } else {
        res = RpcResponse.fromJson(response.data);
      }
      if (res.error != null) {
        throw ('Rpc ${url} response error: ${res.error.toJson()}');
      }
      return res.result;
    } else {
      throw ("Rpc ${url} response error");
    }
  }
}

class RpcResponse {
  int id;
  String jsonrpc;
  dynamic result;
  Error error;

  RpcResponse({this.id, this.jsonrpc, this.result, this.error});

  static RpcResponse fromJson(Map<String, dynamic> json) {
    return RpcResponse(
        id: json['id'],
        jsonrpc: json['jsonrpc'],
        result: json['result'],
        error: Error.fromJson(json['error']));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'jsonrpc': jsonrpc,
      'result': result,
      'error': error
    };
  }
}

class Error {
  int code;
  String message;

  Error({this.code, this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : Error(code: json['code'], message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'code': code, 'message': message};
  }
}
