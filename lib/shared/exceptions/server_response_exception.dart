class ServerResponseException implements Exception {
  final String message;
  ServerResponseException(this.message);
  @override
  String toString() => 'ServerResponseException: $message';
}



