import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/shared/widgets/buttons/primary_button.dart';
import 'package:get/get.dart';

class StartChatButton extends GetView<HomeController> {
  const StartChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return PrimaryButton(
      label: TranslationKeys.homeStartChat.tr,
      isArabic: isArabic,
      onPressed: controller.openChat,
    );
  }
}
