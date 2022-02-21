import 'dart:ui';
import 'package:hhcom/Models/enum/enums.dart';
import '../app_theme.dart';

extension MsgTypeEx on MsgType {
  Color get bgColor {
    switch (this) {
      case MsgType.success:
        return AppColors.green_1;
      case MsgType.error:
        return AppColors.red_1;
      case MsgType.normal:
        return AppColors.dark_3;
    }
  }
}