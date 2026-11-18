import 'package:flutter_getx_starter_template/network/api_endpoints.dart';

class ApiConstants {
  static List<String> unauthenticatedPaths = [
    ApiEndpoints.login,
    ApiEndpoints.authRefresh,
  ];

  static List<String> languagePaths = [
    ApiEndpoints.userById('0'),
  ];

  static bool isUnauthenticatedPath(String requestPath) {
    final normalizedPath = requestPath.trim();
    return unauthenticatedPaths.any(
      (unauthenticated) => normalizedPath.startsWith(unauthenticated),
    );
  }
}
