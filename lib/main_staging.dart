import 'package:flutter_getx_starter_template/app_config.dart';
import 'package:flutter_getx_starter_template/main.dart' as app;

// After running `./flutterfire.config.sh staging <project-id>`, uncomment:
// import 'package:flutter_getx_starter_template/firebase_options_staging.dart';

void main() async {
  final config = await AppConfig.create(
    appName: 'Local SLM Staging',
    environment: Environment.staging,
    envFile: '.env.staging',
  );
  await app.main(
    config: config,
    // firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
