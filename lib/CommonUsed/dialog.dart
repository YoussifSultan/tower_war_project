import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tower_war/CommonUsed/button_tile.dart';

class DialogTile {
  static void showDialogWidget(BuildContext context,
      {required String title,
      required String content,
      String buttonText = 'Ok',
      Function? onEnd,
      Function? onTap}) {
    onTap = onTap ??
        () {
          Get.back();
        };
    onEnd = onEnd ?? () {};
    Get.dialog(AlertDialog(
      actions: [ButtonTile(text: buttonText, onTap: () => onTap!())],
      title: Text(title,
          style: const TextStyle(fontSize: 18, color: Colors.black)),
      content: Text(content,
          style: TextStyle(fontSize: 16, color: Colors.grey[600])),
    )).then((value) => onEnd!());
  }
}
