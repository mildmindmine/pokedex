import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex/common/network/error/server_error.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_detail_use_case.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_list_use_case.dart';
import 'package:pokedex/presentation/landing/landing_page_view_model.dart';

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}

void main() {
  final GetPokemonDetailUseCase getPokemonDetailUseCase =
      MockGetPokemonDetailUseCase();
  final GetPokemonListUseCase getPokemonListUseCase =
      MockGetPokemonListUseCase();
  late LandingPageViewModel viewModel;

  /// Variables
  const pokemonDetail = PokemonDetail(
    name: "name",
    frontImgUrl: "frontImgUrl",
    backImgUrl: "backImgUrl",
    weight: 10,
    height: 10,
  );

  const pokemonList = [PokemonListItem(name: "name", id: "1")];

  final serverError =
      ServerError(message: "message", description: "description");

  final genericError = Exception("Test Error");

  setUp(() {
    viewModel = LandingPageViewModel(
      getPokemonListUseCase: getPokemonListUseCase,
      getPokemonDetailUseCase: getPokemonDetailUseCase,
    );
    registerFallbackValue(pokemonList);
    registerFallbackValue(pokemonDetail);
  });

  group('getPokemonList', () {
    test('When calling getPokemonList and got success data', () async {
      when(() => getPokemonListUseCase.getPokemonList(any(), any(), any()))
          .thenAnswer((_) async => const UseCaseResult.success(pokemonList));

      scheduleMicrotask(() => viewModel.getPokemonList(true));

      expectLater(viewModel.isLoading, emitsInOrder([false, true, false]));

      /// Reset pokemon list, then fetch new list
      expectLater(viewModel.pokemonList, emitsInOrder([null, pokemonList]));
    });

    test('When calling getPokemonList and got error data', () async {
      when(() => getPokemonListUseCase.getPokemonList(any(), any(), any()))
          .thenAnswer((_) async => UseCaseResult.genericFailure(genericError));

      scheduleMicrotask(() => viewModel.getPokemonList());

      expectLater(viewModel.isLoading, emitsInOrder([false, true, false]));
      expectLater(viewModel.showError, emits(genericError.toString()));
    });
  });

  group('getPokemonDetail', () {
    test('When calling getPokemonDetail and got success data', () async {
      when(() => getPokemonDetailUseCase.getPokemonDetail(any()))
          .thenAnswer((_) async => const UseCaseResult.success(pokemonDetail));

      scheduleMicrotask(() => viewModel.getPokemonDetail("1"));

      expectLater(viewModel.isLoading, emitsInOrder([false, true, false]));
      expectLater(viewModel.pokemonDetail, emits(pokemonDetail));
    });

    test('When calling getPokemonDetail and got error data', () async {
      when(() => getPokemonDetailUseCase.getPokemonDetail(any()))
          .thenAnswer((_) async => UseCaseResult.serverFailure(serverError));

      scheduleMicrotask(() => viewModel.getPokemonDetail("1"));

      expectLater(viewModel.isLoading, emitsInOrder([false, true, false]));
      expectLater(viewModel.showError, emits(serverError.description));
    });
  });

  group('getPokemonDetail', () {
    test('When calling getPokemonDetail and got success data', () async {
      when(() => getPokemonDetailUseCase.getPokemonDetail(any()))
          .thenAnswer((_) async => const UseCaseResult.success(pokemonDetail));

      scheduleMicrotask(() => viewModel.getPokemonDetail("1"));

      expectLater(viewModel.isLoading, emitsInOrder([false, true, false]));
      expectLater(viewModel.pokemonDetail, emits(pokemonDetail));
    });

    test('When calling getPokemonDetail and got error data', () async {
      when(() => getPokemonDetailUseCase.getPokemonDetail(any()))
          .thenAnswer((_) async => UseCaseResult.serverFailure(serverError));

      scheduleMicrotask(() => viewModel.getPokemonDetail("1"));

      expectLater(viewModel.isLoading, emitsInOrder([false, true, false]));
      expectLater(viewModel.showError, emits(serverError.description));
    });
  });

  group('clearDisplayedPokemonDetail', () {
    test(
        'When calling clearDisplayedPokemonDetail, should clear pokemon detail',
        () async {
      viewModel.clearDisplayedPokemonDetail();
      expectLater(viewModel.pokemonDetail, emits(null));
    });
  });

  group('onListTileTapped', () {
    test(
        'When calling onListTileTapped, should get pokemon detail of the selected id and open the pokemon detail section',
        () async {
      when(() => getPokemonDetailUseCase.getPokemonDetail(any()))
          .thenAnswer((_) async => const UseCaseResult.success(pokemonDetail));

      scheduleMicrotask(() => viewModel.onListTileTapped("1"));

      expectLater(viewModel.openPokemonDetailSection, emits(null));
      expectLater(viewModel.pokemonDetail, emits(pokemonDetail));
    });
  });
}
