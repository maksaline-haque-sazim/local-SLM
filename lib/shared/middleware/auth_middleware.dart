import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/auth.service.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  final bool isAuthRequired;

  AuthMiddleware({required this.isAuthRequired});

  @override
  RouteSettings? redirect(String? route) {
    if (isAuthRequired && !AuthService.instance.isAuthenticated) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}
