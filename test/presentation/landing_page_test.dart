import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_detail_use_case.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_list_use_case.dart';
import 'package:pokedex/presentation/landing/landing_page.dart';
import 'package:pokedex/presentation/landing/landing_page_view_model.dart';

import '../mock/data_model.dart';

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}

void main() {
  final GetPokemonDetailUseCase getPokemonDetailUseCase =
      MockGetPokemonDetailUseCase();
  final GetPokemonListUseCase getPokemonListUseCase =
      MockGetPokemonListUseCase();

  void setupDependencyInjection(GetIt instance) {
    instance
        .registerSingleton<GetPokemonDetailUseCase>(getPokemonDetailUseCase);
    instance.registerSingleton<GetPokemonListUseCase>(getPokemonListUseCase);
    instance.registerSingleton<LandingPageViewModel>(
        LandingPageViewModel(getPokemonDetailUseCase, getPokemonListUseCase));
  }

  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    await loadAppFonts();
    setupDependencyInjection(getIt);
    when(() => getPokemonListUseCase.getPokemonList(any(), any(), any()))
        .thenAnswer((_) async => const UseCaseResult.success(
            expectedOutputPokemonListHasNextIsFalse));

    when(() => getPokemonDetailUseCase.getPokemonDetail(any())).thenAnswer(
        (_) async => const UseCaseResult.success(expectedPokemonDetail));
  });

  testGoldens('LandingPage', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.iphone11,
      ])
      ..addScenario(
        widget: const MaterialApp(
          home: LandingPage(),
        ),
        name: 'When landed on the page, fetch api to get list of pokemon',
        onCreate: (scenarioWidgetKey) async {
          final navTitle = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text("Pokedex"));
          final listItem = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.byType(ListTile));
          await tester.pump(const Duration(seconds: 3));

          await expectLater(navTitle, findsOneWidget);
          await expectLater(listItem, findsNWidgets(2));

          /// Check if the mock name is presented in the UI
          final nameListTile = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text("bulbasaur"));

          expect(nameListTile, findsOneWidget);

          tester.pumpAndSettle();
          await screenMatchesGolden(tester, 'landing_page');
        },
      );

    await mockNetworkImagesFor(() async {
      await tester.pumpDeviceBuilder(builder);
    });
  });

  testGoldens('LandingPage when tapped on list tile', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.iphone11,
      ])
      ..addScenario(
        widget: const MaterialApp(
          home: LandingPage(),
        ),
        name:
            'Once finished loaded the list, tap on the list tile should show pokemon detail section',
        onCreate: (scenarioWidgetKey) async {
          /// Check if the mock name is presented in the UI
          final nameListTile = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text("bulbasaur"));

          expect(nameListTile, findsOneWidget);

          /// Tap on the tile
          await tester.tap(nameListTile);

          /// Buffer time for it to finish loading all the list from mock api
          await tester.pumpAndSettle();

          final images = find.descendant(
              of: find.byKey(scenarioWidgetKey), matching: find.byType(Image));

          /// Front and back image
          await expectLater(images, findsNWidgets(2));

          tester.pumpAndSettle();
          await screenMatchesGolden(tester, 'landing_page_on_tile_tapped');
        },
      );

    await mockNetworkImagesFor(() async {
      await tester.pumpDeviceBuilder(builder);
    });
  });
}
