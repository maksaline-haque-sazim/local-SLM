import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { development, staging, production }

class AppConfig {
  AppConfig({
    required this.appName,
    required this.environment,
    required this.envVars,
  });

  final String appName;
  final Environment environment;
  final Map<String, String> envVars;

  static Future<AppConfig> create({
    required String appName,
    required Environment environment,
    required String envFile,
  }) async {
    await dotenv.load(fileName: envFile);
    return AppConfig(
      appName: appName,
      environment: environment,
      envVars: Map<String, String>.from(dotenv.env),
    );
  }

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;

  String? operator [](String key) => envVars[key];
}
