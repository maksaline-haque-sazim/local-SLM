import 'package:flutter/material.dart';
import 'package:flutter_getx_starter_template/features/home/controllers/home_controller.dart';
import 'package:flutter_getx_starter_template/features/home/widgets/home_highlights.dart';
import 'package:flutter_getx_starter_template/features/home/widgets/home_intro.dart';
import 'package:flutter_getx_starter_template/features/home/widgets/start_chat_button.dart';
import 'package:flutter_getx_starter_template/utils/constants/sizes.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              HomeIntro(),
              SizedBox(height: Sizes.xl),
              HomeHighlights(),
              Spacer(),
              StartChatButton(),
            ],
          ),
        ),
      ),
    );
  }
}
