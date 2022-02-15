import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/data/repository/landing/landing_repository.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_list_use_case.dart';

import '../../mock/data_model.dart';

class MockLandingRepository extends Mock implements LandingRepository {}

void main() {
  final LandingRepository repository = MockLandingRepository();
  late GetPokemonListUseCase useCase;

  setUp(() {
    useCase = GetPokemonListUseCaseImpl(repository);
  });

  test('Get pokemon list with success data', () async {
    when(() => repository.getPokemonList(any(), any(), any()))
        .thenAnswer((_) async => expectedOutputPokemonList);

    final result = await useCase.getPokemonList(0, 20, true);

    verify(() => repository.getPokemonList(any(), any(), any()));
    verifyNoMoreInteractions(repository);
    expect(
        result, equals(const UseCaseResult.success(expectedOutputPokemonList)));
  });

  test(
      'Get pokemon list with fail result when repository throw error (Generic case)',
      () async {
        final error = Exception();
    when(() => repository.getPokemonList(any(), any(), true)).thenThrow(error);

    final result = await useCase.getPokemonList(0, 20, true);

    verify(() => repository.getPokemonList(any(), any(), any()));
    verifyNoMoreInteractions(repository);
    expect(result, equals(UseCaseResult<PokemonList>.genericFailure(error)));
  });

  test(
      'Get pokemon list with fail result when repository throw error (ServerError case)',
      () async {
        final error = ServerError(message: "message", description: "description");
    when(() => repository.getPokemonList(any(), any(), true)).thenThrow(error);

    final result = await useCase.getPokemonList(0, 20, true);

    verify(() => repository.getPokemonList(any(), any(), any()));
    verifyNoMoreInteractions(repository);
    expect(result, equals(UseCaseResult<PokemonList>.serverFailure(error)));
  });
}
