import 'package:flutter_getx_starter_template/shared/services/env_config.service.dart';

class ApiEndpoints {
  static String get _baseUrl => EnvConfigService.instance.baseUrl;

  static String get login => '$_baseUrl/auth/login';
  static String get authRefresh => '$_baseUrl/auth/refresh';
  static String get me => '$_baseUrl/auth/me';

  static String userById(String userId) => '$_baseUrl/users/$userId';

  static String get users => '$_baseUrl/users';
  static String userProfile(String userId) => '$users/$userId/profile';

  static String cancelUser(String userId) => '$users/$userId/cancel';

  static String userItem(String userId, String itemId) =>
      '$users/$userId/items/$itemId';

  static String get products => '$_baseUrl/products';
  static String productById(String id) => '$products/$id';
}
