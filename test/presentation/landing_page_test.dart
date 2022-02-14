import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:pokedex/presentation/landing/landing_page.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Landing Page - Snapshot Test', (WidgetTester tester) async {
    final builder = DeviceBuilder(bgColor: Colors.white)
      ..overrideDevicesForAllScenarios(devices: [
        Device.iphone11,
        const Device(
          name: '140 x 140',
          size: Size(140, 140),
        ),
        const Device(
          name: '200 x 200',
          size: Size(200, 200),
        ),
      ])
      ..addScenario(
        name: 'Landing Page',
        widget: const LandingPage(),
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'landing_page');
  });
}
