import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:pokedex/presentation/landing/widget/pokemon_detail_section.dart';

import '../mock/data_model.dart';

void main() {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  setUpAll(() async {
    await loadAppFonts();
    _animationController = AnimationController(
      vsync: const TestVSync(),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  });

  testGoldens('Pokemon Detail Section', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.iphone11,
        Device.tabletPortrait,
        Device.tabletLandscape,
      ])
      ..addScenario(
        widget: PokemonDetailSection(
            detail: expectedPokemonDetail, animation: _animation),
        name: '',
      )
      ..addScenario(
        widget: PokemonDetailSection(
            detail: expectedPokemonDetail, animation: _animation),
        name:
            'Given pokemon detail finish loading and send data to this section',
        onCreate: (scenarioWidgetKey) async {
          /// Waiting for animation to render
          await tester.pumpAndSettle();

          /// Should display mock name
          final nameTitle = find.descendant(
              of: find.byKey(scenarioWidgetKey), matching: find.text("name"));

          await expectLater(nameTitle, findsOneWidget);

          final weight = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.text(
                "Weight: 10",
                findRichText: true,
              ));
          final height = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.text(
              "Height: 10",
              findRichText: true,
            ),
          );

          await expectLater(weight, findsOneWidget);
          await expectLater(height, findsOneWidget);

          final images = find.descendant(
              of: find.byKey(scenarioWidgetKey), matching: find.byType(Image));

          /// Front and back image
          await expectLater(images, findsNWidgets(2));

          tester.pumpAndSettle();

          await screenMatchesGolden(tester, 'pokemon_detail_section');
        },
      );

    await mockNetworkImagesFor(() async {
      await tester.pumpDeviceBuilder(builder);
    });
  });
}
