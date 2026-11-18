import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogueBox {
  static void openDialogBox(String title, String body) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static removeDialogueBox() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
