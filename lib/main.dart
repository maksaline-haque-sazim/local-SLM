import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/app_config.dart';
import 'package:flutter_getx_starter_template/bindings/global_bindings.dart';
import 'package:flutter_getx_starter_template/localization/app_translations.dart';
import 'package:flutter_getx_starter_template/localization/locale_service.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/shared/services/env_config.service.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme.dart';
import 'package:flutter_getx_starter_template/utils/theme/theme_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main({
  AppConfig? config,
  FirebaseOptions? firebaseOptions,
}) async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  final localeService = await LocaleService().init();
  Get.put(localeService);

  final themeService = await ThemeService().init();
  Get.put(themeService);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final appConfig = config ??
      await AppConfig.create(
        appName: 'Flutter Template Dev',
        environment: Environment.development,
        envFile: '.env.development',
      );
  Get.put(appConfig);

  if (firebaseOptions != null) {
    await Firebase.initializeApp(options: firebaseOptions);
  }

  await Get.putAsync<EnvConfigService>(
    () async => EnvConfigService(appConfig).init(),
  );

  runApp(App(config: appConfig));
}

class App extends StatelessWidget {
  const App({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    final localeService = LocaleService.instance;
    final themeService = ThemeService.instance;

    return GetMaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: localeService.locale,
      fallbackLocale: AppTranslations.fallbackLocale,
      supportedLocales: AppTranslations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialBinding: GlobalBindings(
        enableApiGlobalLogging: true,
      ),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.themeMode,
      initialRoute: Routes.login,
      getPages: AppPages.pages,
    );
  }
}
