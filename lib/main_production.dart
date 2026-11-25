import 'package:flutter_getx_starter_template/app_config.dart';
import 'package:flutter_getx_starter_template/main.dart' as app;

// After running `./flutterfire.config.sh production <project-id>`, uncomment:
// import 'package:flutter_getx_starter_template/firebase_options_production.dart';

void main() async {
  final config = await AppConfig.create(
    appName: 'Local SLM',
    environment: Environment.production,
    envFile: '.env.production',
  );
  await app.main(
    config: config,
    // firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
