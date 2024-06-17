import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://154.26.128.108:8081/api/',
      connectTimeout: const Duration(seconds: 100000),
      receiveTimeout: const Duration(seconds: 2),
    ),
  );

  // Cấu hình Dio nếu cần, như thêm Interceptors
  dio.interceptors.add(LogInterceptor(responseBody: true));

  return dio;
});

