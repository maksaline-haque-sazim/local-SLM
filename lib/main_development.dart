import 'package:flutter_getx_starter_template/app_config.dart';
import 'package:flutter_getx_starter_template/main.dart' as app;

// After running `./flutterfire.config.sh development <project-id>`, uncomment:
// import 'package:flutter_getx_starter_template/firebase_options_development.dart';

void main() async {
  final config = await AppConfig.create(
    appName: 'Local SLM Dev',
    environment: Environment.development,
    envFile: '.env.development',
  );
  await app.main(
    config: config,
    // firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
