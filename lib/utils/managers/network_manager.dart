import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_starter_template/localization/translation_keys.dart';
import 'package:flutter_getx_starter_template/utils/theme/snackbar.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;
  final DateTime _initTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Future<void> onReady() async {
    await isConnected(withSnackbar: false);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final newStatus = result.firstWhere(
      (connection) => connection != ConnectivityResult.none,
      orElse: () => ConnectivityResult.none,
    );


    if (_connectionStatus.value == newStatus) return;
    _connectionStatus.value = newStatus;

    final bool isStartup = DateTime.now().difference(_initTime).inSeconds < 2;

    if (newStatus == ConnectivityResult.none && !isStartup) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_connectionStatus.value == ConnectivityResult.none) {
          AppSnackbar.errorSnackBar(
            title: TranslationKeys.noInternetTitle.tr,
            message: TranslationKeys.noInternetMessage.tr,
          );
        }
      });
    }
  }

  Future<bool> isConnected({bool withSnackbar = false}) async {
    try {
      final result = await _connectivity.checkConnectivity();

      bool hasConnection = result
          .where((connection) => connection != ConnectivityResult.none)
          .isNotEmpty;

      if (!hasConnection) {
        if (withSnackbar) {
          AppSnackbar.errorSnackBar(
            title: TranslationKeys.noInternetTitle.tr,
            message: TranslationKeys.noInternetMessage.tr,
          );
        }
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
