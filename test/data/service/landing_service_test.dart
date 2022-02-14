import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:mocktail/mocktail.dart";
import 'package:pokedex/data/model/detail_section/pokemon_details_response.dart';
import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:pokedex/data/service/landing/landing_services.dart';

class MockLandingService extends Mock implements LandingService {}

void main() {
  late MockLandingService _mockLandingService;

  /// Pokemon list
  final pokemonListResponseFile =
      File('test/mock/service_response/get_pokemon_list_response.json')
          .readAsStringSync();
  final PokemonListResponse stubPokemonListResponse =
      PokemonListResponse.fromJson(
          jsonDecode(pokemonListResponseFile) as Map<String, dynamic>);

  /// Pokemon detail response
  final pokemonDetailResponseFile =
      File('test/mock/service_response/get_pokemon_detail_response.json')
          .readAsStringSync();
  final PokemonDetailsResponse stubPokemonDetailResponse =
      PokemonDetailsResponse.fromJson(
          jsonDecode(pokemonDetailResponseFile) as Map<String, dynamic>);

  setUp(() async {
    registerFallbackValue(Uri());
    _mockLandingService = MockLandingService();
  });

  group('GET pokemon list', () {
    test(
      'should perform a GET request on /v2/pokemon with success response',
      () async {
        when(
          () => _mockLandingService.getPokemonList(0, 20),
        ).thenAnswer(
          (_) async => stubPokemonListResponse,
        );

        final response = await _mockLandingService.getPokemonList(0, 20);

        verify(() => _mockLandingService.getPokemonList(0, 20));
        verifyNoMoreInteractions(_mockLandingService);
        expect(response, stubPokemonListResponse);
      },
    );

    test(
      'should throw a ServerError when the response code is failed (http status other than 200',
      () async {
        when(() => _mockLandingService.getPokemonList(0, 20)).thenThrow(
          DioError(
            response: Response(
              data: 'Something went wrong',
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(
          () => _mockLandingService.getPokemonList(0, 20),
          throwsA(isA<DioError>()),
        );
      },
    );
  });

  group('GET pokemon detail', () {
    test(
      'should perform a GET request on /v2/pokemon/{id} with success response',
      () async {
        when(
          () => _mockLandingService.getPokemonDetail("1"),
        ).thenAnswer(
          (_) async => stubPokemonDetailResponse,
        );

        final response = await _mockLandingService.getPokemonDetail("1");

        verify(() => _mockLandingService.getPokemonDetail("1"));
        verifyNoMoreInteractions(_mockLandingService);
        expect(response, stubPokemonDetailResponse);
      },
    );

    test(
      'should throw a ServerError when the response code is failed (http status other than 200',
      () async {
        when(() => _mockLandingService.getPokemonDetail("1")).thenThrow(
          DioError(
            response: Response(
              data: 'Something went wrong',
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );
        expect(
          () => _mockLandingService.getPokemonDetail("1"),
          throwsA(isA<DioError>()),
        );
      },
    );
  });
}
