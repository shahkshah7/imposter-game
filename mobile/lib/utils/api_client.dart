import 'dart:io' show Platform;
import 'package:dio/dio.dart';

class ApiClient {
  static final String _baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:8000/api"
      : "http://127.0.0.1:8000/api";

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {"Accept": "application/json"},
    ),
  );

  static Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      print("➡️ API REQUEST: POST $_baseUrl$path");
      print("Body: $data");

      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      print("⬅️ API RESPONSE: ${response.statusCode}");
      print(response.data);

      return response;
    } on DioException catch (e) {
      print(" API ERROR: $e");
      rethrow;
    }
  }
}
