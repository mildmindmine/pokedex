import 'package:pokedex/data/repository/landing/landing_repository.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/use_case/common/handle_usecase_result.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';

abstract class GetPokemonDetailUseCase {
  Future<UseCaseResult<PokemonDetail>> getPokemonDetail(String id);
}

class GetPokemonDetailUseCaseImpl
    with HandleUseCaseResult<PokemonDetail>
    implements GetPokemonDetailUseCase {
  late final LandingRepository _landingRepository;

  /// Parameter for testing (and in case there is dependency injection)
  GetPokemonDetailUseCaseImpl({LandingRepository? repository}) {
    _landingRepository = repository ?? LandingRepositoryImpl();
  }

  @override
  Future<UseCaseResult<PokemonDetail>> getPokemonDetail(String id) async {
    return handleUseCaseResult(() => _landingRepository.getPokemonDetail(id));
  }
}
