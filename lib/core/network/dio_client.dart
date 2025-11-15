import 'package:dio/dio.dart';

Dio buildDioClient() {
  final options = BaseOptions(
    baseUrl: 'https://reqres.in/api',
    connectTimeout: const Duration(seconds: 7),
    receiveTimeout: const Duration(seconds: 12),
    sendTimeout: const Duration(seconds: 7),
    responseType: ResponseType.json,
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "x-api-key": "reqres-free-v1",
    },
    validateStatus: (status) => true,
  );

  final dio = Dio(options);
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  return dio;
}
