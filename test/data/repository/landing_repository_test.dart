import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/data/model/detail_section/pokemon_details_response.dart';
import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:pokedex/data/repository/landing/landing_repository.dart';
import 'package:pokedex/data/service/landing/landing_services.dart';
import 'package:pokedex/domain/mapper/landing/landing_mapper.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';

class MockLandingService extends Mock implements LandingService {}

class MockLandingMapper extends Mock implements LandingMapper {}

void main() {
  final LandingService service = MockLandingService();
  final LandingMapper mapper = MockLandingMapper();
  late LandingRepository repository;

  final pokemonDetailResponse = PokemonDetailsResponse(
      name: "name",
      height: 10,
      weight: 20,
      sprites: Sprites(front_default: "url1", back_default: "url2"));
  const pokemonDetailExpectedResult = PokemonDetail(
    name: "name",
    frontImgUrl: "url1",
    backImgUrl: "url2",
    weight: 20,
    height: 10,
  );

  final pokemonListResponse = PokemonListResponse(
    next: "abc",
    results: [
      PokemonResponse(
        name: "name",
        url: "https://pokeapi.co/api/v2/pokemon/1/",
      ),
    ],
  );

  const pokemonListExpectedResult = PokemonList(
    hasNext: true,
    pokemonList: [PokemonListItem(name: "name", id: "1")],
  );

  setUp(() {
    repository = LandingRepositoryImpl(mapper, service);
  });

  test('return successful result after call GET pokemon list', () async {
    when(() => service.getPokemonList(any(), any()))
        .thenAnswer((_) => Future.value(pokemonListResponse));

    final result = await repository.getPokemonList(0, 20, true);

    verify(() => service.getPokemonList(0, 20));
    verifyNoMoreInteractions(service);
    expect(result, equals(pokemonListExpectedResult));
  });

  test('return successful result after call GET pokemon detail', () async {
    when(() => service.getPokemonDetail(any()))
        .thenAnswer((_) => Future.value(pokemonDetailResponse));

    final result = await repository.getPokemonDetail("1");

    verify(() => service.getPokemonDetail("1"));
    verifyNoMoreInteractions(service);
    expect(result, equals(pokemonDetailExpectedResult));
  });

  test(
      'return successful result after call GET pokemon detail with cache if same id is call second time',
      () async {
    when(() => service.getPokemonDetail(any()))
        .thenAnswer((_) => Future.value(pokemonDetailResponse));

    final result = await repository.getPokemonDetail("1");

    expect(result, equals(pokemonDetailExpectedResult));

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

    expect(result2, equals(pokemonDetailExpectedResult));

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

    expect(successResult, equals(pokemonDetailExpectedResult));

    /// Refresh pokemon list
    await repository.getPokemonList(10, 20, true);

    expect(() => repository.getPokemonDetail("1"), throwsA(isA<ServerError>()));
  });
}
