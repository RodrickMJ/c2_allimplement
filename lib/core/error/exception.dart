class ServerException implements Exception {
  final String message;
  ServerException([this.message = "Error en el servidor"]);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = "Error de red"]);
}
