import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/utils/extension/generic_extension.dart';

void main() {
  String? nullStringValue;
  int? nullIntValue;
  bool? nullBoolValue;
  List<String>? nullListValue;

  test('Expect to return fallback value passed to extension function', () {
    expect(nullStringValue.safeUnwrapped("Fallback"), "Fallback");
    expect(nullIntValue.safeUnwrapped(100), 100);
    expect(nullBoolValue.safeUnwrapped(true), true);
    expect(nullListValue.safeUnwrapped(["A"]), ["A"]);
  });

  test(
      'Expect to return default fallback value when not passing any fallback value',
      () {
    expect(nullStringValue.safeUnwrapped(), "");
    expect(nullIntValue.safeUnwrapped(), 0);
    expect(nullBoolValue.safeUnwrapped(), false);
  });

  test(
      'Expect to throw error if using unwrapped function on'
      ' other type of object that is not String, num, and bool,'
      ' without providing fallback value', () {
    expect(() => nullListValue.safeUnwrapped(), throwsA(isA<Exception>()));
  });
}
