import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokedex/common/network/error/server_error.dart';

part 'use_case_result.freezed.dart';

@freezed
class UseCaseResult<T extends Object> with _$UseCaseResult<T> {
  const factory UseCaseResult.success(T data) = _$UseCaseResultSuccess;

  const factory UseCaseResult.serverFailure(ServerError error) =
      _$UseCaseResultServerFailure;

  const factory UseCaseResult.genericFailure(Exception error) =
      _$UseCaseResultGenericFailure;
}
