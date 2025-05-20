import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const String apiVersion = '/api/v1';
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl + apiVersion,
        connectTimeout: const Duration(milliseconds: connectTimeout),
        receiveTimeout: const Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {
            // Token expirado ou inválido
            const storage = FlutterSecureStorage();
            storage.delete(key: 'token');
            // Redirecionar para login
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }
}
