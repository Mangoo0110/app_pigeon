class ServerException implements Exception {}

class CacheException implements Exception {}

class NoDataException implements Exception {}

class UnImplementedException implements Exception {
  final Exception ex;
  final Object error;
  UnImplementedException({required this.ex, required this.error});
}
