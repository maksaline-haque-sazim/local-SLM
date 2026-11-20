import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_getx_starter_template/network/api_endpoints.dart';
import 'package:flutter_getx_starter_template/network/service/api_client.service.dart';

class TokenService extends GetxService {
  static TokenService get instance => Get.find<TokenService>();

  String? authToken;
  String? refreshToken;
  final _box = GetStorage('auth');

  Future<TokenService> init() async {
    if (!GetStorage().hasData('init_auth_box')) {
      await GetStorage.init('auth');
      GetStorage().write('init_auth_box', true);
    }
    authToken = _box.read<String>('authToken');
    refreshToken = _box.read<String>('refreshToken');
    return this;
  }

  Future<bool> attemptRefreshToken() async {
    try {
      if (refreshToken == null || refreshToken!.isEmpty) return false;
      final res = await ApiClientService.instance.httpClientInstance
          .post<Map<String, dynamic>>(ApiEndpoints.authRefresh, {
            'refresh_token': refreshToken,
          });
      if (res.isOk && res.body is Map<String, dynamic>) {
        final body = res.body!;
        final newAccess = body['access_token'] as String?;
        final newRefresh = body['refresh_token'] as String?;
        if (newAccess != null && newAccess.isNotEmpty) {
          authToken = newAccess;
          _box.write('authToken', newAccess);
        }
        if (newRefresh != null && newRefresh.isNotEmpty) {
          refreshToken = newRefresh;
          _box.write('refreshToken', newRefresh);
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Refresh token failed: $e');
      return false;
    }
  }

  Future<void> saveTokens({
    required String authToken,
    String? refreshToken,
  }) async {
    this.authToken = authToken;
    await _box.write('authToken', authToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      this.refreshToken = refreshToken;
      await _box.write('refreshToken', refreshToken);
    }
  }

  Future<void> clearTokens() async {
    authToken = null;
    refreshToken = null;
    await _box.remove('authToken');
    await _box.remove('refreshToken');
  }
}
