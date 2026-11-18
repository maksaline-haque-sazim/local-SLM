import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_starter_template/features/home/widgets/create_product_card.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/routes.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationKeys.homePage.tr),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    TranslationKeys.appName.tr,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add_box_outlined),
                title: Text(TranslationKeys.drawerCreateProduct.tr),
                onTap: () {
                  Get.back();
                  controller.openCreateProduct();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(TranslationKeys.drawerSettings.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.settings);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(TranslationKeys.drawerLogout.tr),
                onTap: () {
                  Get.back();
                  controller.logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(Sizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CreateProductCard(),
          ],
        ),
      ),
    );
  }
}
