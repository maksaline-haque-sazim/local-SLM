import 'package:flutter_getx_starter_template/data/response_model/authenticated_user_model.dart';
import 'package:flutter_getx_starter_template/shared/services/token.service.dart';
import 'package:flutter_getx_starter_template/utils/constants/enums.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get instance => Get.find();

  final Rx<AuthenticatedUser?> _user = Rx<AuthenticatedUser?>(null);

  bool get isAuthenticated => _user.value != null;

  AuthenticatedUser? get user => _user.value;

  Future<void> login({required String email, required String password}) async {
    final trimmedEmail = email.trim();
    _user.value = AuthenticatedUser(
      id: 'demo-user',
      email: trimmedEmail.isEmpty ? 'demo@example.com' : trimmedEmail,
      role: EUserRole.admin,
    );
    await TokenService.instance.saveTokens(
      authToken: 'demo-access-token',
      refreshToken: 'demo-refresh-token',
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    _user.value = AuthenticatedUser(
      id: 'demo-user',
      email: trimmedEmail.isEmpty ? 'demo@example.com' : trimmedEmail,
      role: EUserRole.admin,
    );
    await TokenService.instance.saveTokens(
      authToken: 'demo-access-token',
      refreshToken: 'demo-refresh-token',
    );
  }

  void logout() => _user.value = null;

  Future<void> logoutWithoutRefreshToken() async {
    _user.value = null;
    await TokenService.instance.clearTokens();
  }
}
