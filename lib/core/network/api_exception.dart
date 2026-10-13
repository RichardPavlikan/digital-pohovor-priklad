/// Application-level error used by the presentation layer.
///
/// Repositories translate transport failures into this type so that the
/// UI never has to know which HTTP client is being used underneath.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException(${statusCode ?? '-'}): $message';
}
