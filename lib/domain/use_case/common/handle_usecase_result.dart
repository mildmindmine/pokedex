import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';

mixin HandleUseCaseResult<T extends Object> {
  Future<UseCaseResult<T>> handleUseCaseResult(Function() call) async {
    try {
      final data = await call();
      return UseCaseResult.success(data);
    } on ServerError catch (e) {
      return UseCaseResult.serverFailure(e);
    } on Exception catch (e) {
      return UseCaseResult.genericFailure(e);
    }
  }
}
