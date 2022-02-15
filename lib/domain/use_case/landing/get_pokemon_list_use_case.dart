import 'package:injectable/injectable.dart';
import 'package:pokedex/data/repository/landing/landing_repository.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/domain/use_case/common/handle_usecase_result.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';

abstract class GetPokemonListUseCase {
  Future<UseCaseResult<PokemonList>> getPokemonList(
    int offset,
    int limit,
    bool isRefresh,
  );
}

@Injectable(as: GetPokemonListUseCase)
class GetPokemonListUseCaseImpl
    with HandleUseCaseResult<PokemonList>
    implements GetPokemonListUseCase {
  late final LandingRepository _landingRepository;

  GetPokemonListUseCaseImpl(this._landingRepository);

  @override
  Future<UseCaseResult<PokemonList>> getPokemonList(
      int offset, int limit, bool isRefresh) async {
    return handleUseCaseResult(
        () => _landingRepository.getPokemonList(offset, limit, isRefresh));
  }
}
