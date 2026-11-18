import 'package:ez_validator/ez_validator.dart';
import 'package:flutter_getx_starter_template/app_config.dart';
import 'package:get/get.dart';

class EnvConfigValidationException implements Exception {
  EnvConfigValidationException(this.errors);

  final Map<dynamic, dynamic> errors;

  @override
  String toString() => 'EnvConfigValidationException($errors)';
}

class EnvConfigService extends GetxService {
  EnvConfigService(this.appConfig);

  static EnvConfigService get instance => Get.find<EnvConfigService>();

  final AppConfig appConfig;

  late final String baseUrl;

  Environment get environment => appConfig.environment;

  Future<EnvConfigService> init() async {
    final envSchema = EzSchema.shape({
      'BASE_URL': EzValidator<String>(label: 'Base URL').required(),
      'APP_NAME': EzValidator<String>(label: 'App Name').required(),
    });

    final (data, errors) = envSchema.validateSync(appConfig.envVars);
    if (errors.isNotEmpty) {
      throw EnvConfigValidationException(errors);
    }

    final String rawBaseUrl = data['BASE_URL'] as String;
    baseUrl = rawBaseUrl.trim().replaceAll(RegExp(r'/$'), '');

    return this;
  }

  bool get isDevelopment => appConfig.isDevelopment;
  bool get isStaging => appConfig.isStaging;
  bool get isProduction => appConfig.isProduction;
}
