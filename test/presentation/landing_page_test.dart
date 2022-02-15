import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pokedex/domain/use_case/common/use_case_result.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_detail_use_case.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_list_use_case.dart';
import 'package:pokedex/presentation/landing/landing_page.dart';

import '../mock/data_model.dart';

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}

void main() {
  final GetPokemonDetailUseCase getPokemonDetailUseCase =
      MockGetPokemonDetailUseCase();
  final GetPokemonListUseCase getPokemonListUseCase =
      MockGetPokemonListUseCase();

  setUpAll(() async {
    await loadAppFonts();
    when(() => getPokemonListUseCase.getPokemonList(any(), any(), any()))
        .thenAnswer((_) async =>
            const UseCaseResult.success(expectedOutputPokemonList));

    when(() => getPokemonDetailUseCase.getPokemonDetail(any())).thenAnswer(
        (_) async => const UseCaseResult.success(expectedPokemonDetail));
  });

  testGoldens('LandingPage', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addScenario(
        widget: MaterialApp(
          home: LandingPage(
            key: const Key("Landing"),
            getPokemonDetailUseCase: getPokemonDetailUseCase,
            getPokemonListUseCase: getPokemonListUseCase,
          ),
        ),
        name: 'Landing page',
      )
      ..addScenario(
        widget: MaterialApp(
          home: LandingPage(
            key: const Key("Landing"),
            getPokemonDetailUseCase: getPokemonDetailUseCase,
            getPokemonListUseCase: getPokemonListUseCase,
          ),
        ),
        name: 'Check landing components',
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
          final nameListTitle = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text("bulbasaur"));
          expect(nameListTitle, findsOneWidget);
          tester.pumpAndSettle();
          await screenMatchesGolden(tester, 'landing_page');
        },
      )
      ..addScenario(
          widget: MaterialApp(
            home: LandingPage(
              key: const Key("Landing"),
              getPokemonDetailUseCase: getPokemonDetailUseCase,
              getPokemonListUseCase: getPokemonListUseCase,
            ),
          ),
          name: 'Tapping on list tile',
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
                of: find.byKey(scenarioWidgetKey),
                matching: find.byType(Image));

            /// Front and back image
            await expectLater(images, findsNWidgets(2));

            await screenMatchesGolden(tester, 'landing_page');
          });

    await mockNetworkImagesFor(() async {
      await tester.pumpDeviceBuilder(builder);
    });
  });
}
