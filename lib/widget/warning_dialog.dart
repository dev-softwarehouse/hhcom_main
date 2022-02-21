import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/Utils/extension/extensions.dart';

class WarningMessageDialog {
  static showDialog(BuildContext context, String message, {int duration = 2, MsgType type = MsgType.normal}) {
    Flushbar(
      isDismissible: false,
      margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      padding: EdgeInsets.zero,
      duration: Duration(seconds: duration),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: type.bgColor,
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.lightest,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ),
      ),
    ).show(context);
  }
}