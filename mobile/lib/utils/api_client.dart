import 'dart:io' show Platform;

import 'package:dio/dio.dart';

class ApiClient {
  static final String _baseUrl =
      Platform.isAndroid ? "http://10.0.2.2:8000/api" : "http://127.0.0.1:8000/api";

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      headers: {
        "Accept": "application/json",
      },
    ),
  );
}
