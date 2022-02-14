import 'package:dio/dio.dart';
import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/utils/extension/generic_extension.dart';

abstract class BaseNetworkRepository {
  Future<T> handle<T>(Future<T> Function() call) async {
    try {
      final T result = await call();
      return result;
    } on DioError catch (e) {
      throw handleServerError(e);
    } catch (e) {
      // If other error, throw generic exception
      throw Exception(e);
    }
  }

  ServerError handleServerError(DioError e) {
    return ServerError(
      message: e.response?.data,
      description: (e.response?.statusMessage).safeUnwrapped('API Error'),
    );
  }
}
