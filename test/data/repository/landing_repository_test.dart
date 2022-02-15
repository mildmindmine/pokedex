import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/data/repository/landing/landing_repository.dart';
import 'package:pokedex/data/service/landing/landing_services.dart';
import 'package:pokedex/domain/mapper/landing/landing_mapper.dart';

import '../../mock/data_model.dart';

class MockLandingService extends Mock implements LandingService {}

class MockLandingMapper extends Mock implements LandingMapper {}

void main() {
  final LandingService service = MockLandingService();
  final LandingMapper mapper = MockLandingMapper();
  late LandingRepository repository;

  setUpAll(() {
    repository = LandingRepositoryImpl(mapper, service);
    registerFallbackValue(pokemonListResponse);
    registerFallbackValue(expectedOutputPokemonList);
    registerFallbackValue(pokemonDetailResponse);
    registerFallbackValue(expectedPokemonDetail);
  });

  test('return successful result after call GET pokemon list', () async {
    when(() => service.getPokemonList(any(), any()))
        .thenAnswer((_) => Future.value(pokemonListResponse));
    when(() => mapper.mapPokemonList(any()))
        .thenAnswer((_) => expectedOutputPokemonList);

    final result = await repository.getPokemonList(0, 20, true);

    verify(() => service.getPokemonList(0, 20));
    verifyNoMoreInteractions(service);
    expect(result, equals(expectedOutputPokemonList));
  });

  test('return successful result after call GET pokemon detail', () async {
    when(() => service.getPokemonDetail(any()))
        .thenAnswer((_) => Future.value(pokemonDetailResponse));
    when(() => mapper.mapPokemonDetail(any()))
        .thenAnswer((_) => expectedPokemonDetail);

    final result = await repository.getPokemonDetail("1");

    verify(() => service.getPokemonDetail("1"));
    verifyNoMoreInteractions(service);
    expect(result, equals(expectedPokemonDetail));
  });

  test(
      'return successful result after call GET pokemon detail with cache if same id is call second time',
      () async {
        when(() => service.getPokemonDetail(any()))
        .thenAnswer((_) => Future.value(pokemonDetailResponse));
    when(() => mapper.mapPokemonDetail(any()))
        .thenAnswer((_) => expectedPokemonDetail);

    final result = await repository.getPokemonDetail("1");

    expect(result, equals(expectedPokemonDetail));

    /// Throw error second time it call GET pokemon detail
    when(() => service.getPokemonDetail(any())).thenThrow(
      DioError(
        response: Response(
          data: 'Something went wrong',
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final result2 = await repository.getPokemonDetail("1");

    expect(result2, equals(expectedPokemonDetail));

    /// Call to different ID for the first time
    expect(
        () => repository.getPokemonDetail("12"), throwsA(isA<ServerError>()));
  });

  test(
      'should clear all cached pokemon detail when get pokemon list is refreshed',
      () async {
        when(() => service.getPokemonList(any(), any()))
        .thenAnswer((_) => Future.value(pokemonListResponse));
    when(() => service.getPokemonDetail(any()))
        .thenAnswer((_) => Future.value(pokemonDetailResponse));
    when(() => mapper.mapPokemonDetail(any()))
        .thenAnswer((_) => expectedPokemonDetail);

    /// Call pokemon detail 1st time, value for id = 1 is cached
    await repository.getPokemonDetail("1");

    /// Throw error second time it call GET pokemon detail
    when(() => service.getPokemonDetail(any())).thenThrow(
      DioError(
        response: Response(
          data: 'Something went wrong',
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final successResult = await repository.getPokemonDetail("1");

    expect(successResult, equals(expectedPokemonDetail));

    /// Refresh pokemon list
    await repository.getPokemonList(10, 20, true);

    expect(() => repository.getPokemonDetail("1"), throwsA(isA<ServerError>()));
  });
}
