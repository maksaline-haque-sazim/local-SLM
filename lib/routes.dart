import 'package:flutter_getx_starter_template/features/auth/login/bindings/login_binding.dart';
import 'package:flutter_getx_starter_template/features/auth/login/pages/login_page.dart';
import 'package:flutter_getx_starter_template/features/auth/sign_up/bindings/sign_up_binding.dart';
import 'package:flutter_getx_starter_template/features/auth/sign_up/pages/sign_up_page.dart';
import 'package:flutter_getx_starter_template/features/home/bindings/home_binding.dart';
import 'package:flutter_getx_starter_template/features/home/pages/home_page.dart';
import 'package:flutter_getx_starter_template/features/products/bindings/create_product_binding.dart';
import 'package:flutter_getx_starter_template/features/products/pages/create_product_page.dart';
import 'package:flutter_getx_starter_template/features/settings/bindings/settings_binding.dart';
import 'package:flutter_getx_starter_template/features/settings/pages/settings_page.dart';
import 'package:flutter_getx_starter_template/shared/middleware/auth_middleware.dart';
import 'package:get/get.dart';

class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String settings = '/settings';
  static const String createProduct = '/products/create';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware(isAuthRequired: true)],
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware(isAuthRequired: true)],
    ),
    GetPage(
      name: Routes.createProduct,
      page: () => const CreateProductPage(),
      binding: CreateProductBinding(),
      middlewares: [AuthMiddleware(isAuthRequired: true)],
    ),
  ];
}
