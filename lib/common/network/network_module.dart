import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  /// Log for request and response from calling api
  @lazySingleton
  LogInterceptor get logInterceptor =>
      LogInterceptor(requestBody: true, responseBody: true);

  @lazySingleton
  Dio dio() {
    final dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/'));

    if (kDebugMode) {
      dio.interceptors.add(logInterceptor);
    }

    return dio;
  }
}
