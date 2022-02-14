class ServerError implements Exception {
  final String message;
  final String description;

  ServerError({
    required this.message,
    required this.description,
  });
}
