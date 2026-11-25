import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_starter_template/features/home/widgets/home_intro.dart';
import 'package:flutter_getx_starter_template/features/home/widgets/model_card.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:flutter_getx_starter_template/utils/theme/app_typography.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Sizes.lg),
          children: [
            const SizedBox(height: Sizes.lg),
            const HomeIntro(),
            const SizedBox(height: Sizes.xl),
            Text(
              TranslationKeys.homeModelsTitle.tr,
              style: AppTypography.getHeading4(isArabic),
            ),
            const SizedBox(height: Sizes.md),
            for (final model in controller.models)
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.md),
                child: ModelCard(model: model),
              ),
          ],
        ),
      ),
    );
  }
}
