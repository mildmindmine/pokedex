import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/data/repository/landing/landing_repository.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_detail_use_case.dart';

import '../../mock/data_model.dart';

class MockLandingRepository extends Mock implements LandingRepository {}

void main() {
  final LandingRepository repository = MockLandingRepository();
  late GetPokemonDetailUseCaseImpl useCase;

  setUp(() {
    useCase = GetPokemonDetailUseCaseImpl(repository: repository);
  });

  test('Get pokemon detail with success data', () async {
    when(() => repository.getPokemonDetail(any()))
        .thenAnswer((_) async => expectedPokemonDetail);

    final result = await useCase.getPokemonDetail('1');

    verify(() => repository.getPokemonDetail(any()));
    verifyNoMoreInteractions(repository);
    expect(result, equals(const UseCaseResult.success(expectedPokemonDetail)));
  });

  test(
      'Get pokemon detail with fail result when repository throw error (Generic case)',
      () async {
    final error = Exception();
    when(() => repository.getPokemonDetail(any())).thenThrow(error);

    final result = await useCase.getPokemonDetail('1');

    verify(() => repository.getPokemonDetail('1'));
    verifyNoMoreInteractions(repository);
    expect(result, equals(UseCaseResult<PokemonDetail>.genericFailure(error)));
  });

  test(
      'Get pokemon detail with fail result when repository throw error (ServerError case)',
      () async {
    final error = ServerError(message: "message", description: "description");
    when(() => repository.getPokemonDetail(any())).thenThrow(error);

    final result = await useCase.getPokemonDetail('1');

    verify(() => repository.getPokemonDetail('1'));
    verifyNoMoreInteractions(repository);
    expect(result, equals(UseCaseResult<PokemonDetail>.serverFailure(error)));
  });
}
