extension SafeUnwrapped<T> on T? {
  /// This function without fallback value passed to it
  /// will only work on String, number, and boolean variable only
  /// If using on other type of object please provide the fallback value
  T safeUnwrapped([T? fallbackValue]) {
    final Object value;
    if (fallbackValue != null) {
      value = fallbackValue;
    } else if (T == String) {
      value = '';
    } else if (T == int || T == double) {
      value = 0;
    } else if (T == bool) {
      value = false;
    } else {
      throw Exception("Should provide fallback value");
    }
    return this ?? value as T;
  }
}
