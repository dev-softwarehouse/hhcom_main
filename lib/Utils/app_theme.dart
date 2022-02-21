import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const Color dark_1 = Color(0xFF515761);
  static const Color dark_2 = Color(0xFF3A3E45);
  static Color dark_3 = const Color(0xFF23252A);
  static const Color dark_4 = const Color(0xFF444444);
  static const Color dark_7 = const Color(0xFF777777);
  static Color dark_4_half = Color(0xFF444444).withOpacity(0.5);
  static Color lightGrey = Color(0xFFAAAAAA99);
  static Color lightGrey_2 = Color(0xFFAAAAAA);
  static Color medium_1 = const Color(0xFF9EA3AE);
  static Color medium_2 = const Color(0xFF828997);
  static Color medium_3 = const Color(0xFF686F7D);
  static Color light_1 = const Color(0xFFF1F2F4);
  static Color light_2 = const Color(0xFFD6D8DC);
  static Color light_3 = const Color(0xFFBABDC5);
  static const Color light_4 = Color(0xFFE2E2E3);
  static Color lightest = const Color(0xFFFFFFFF);
  static Color darkest = const Color(0xFF0B0C0E);
  static Color icon = const Color(0xFF323232);
  static Color black = Colors.black;
  static const Color red_1 = Color(0xFFEC5252);
  static const Color green_1 = Color(0xFF2CDE2C);
  static Color green_2 = Color(0xFF58AC3B).withOpacity(0.6);
  static Color marron = Color(0xFFC9C2F4);
  //static Color lightGrey3 = Color(0xFFE9E8F0);
  static Color lightGrey3 = Color(0xFFA09CB0);
  static Color lightGrey4 = Color(0xFFDDDDDD);

  static Color yellow_light = Color(0xFFf4aa3a).withOpacity(0.6);
  static Color borderColor = const Color(0xFFBBBBBB);
}

abstract class TextStyles {
  static const TextStyle text10 = TextStyle(color: AppColors.dark_2, fontSize: 10, fontWeight: FontWeight.w400);

  static const TextStyle text16 = TextStyle(color: AppColors.dark_1, fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle title24Normal = TextStyle(color: AppColors.dark_4, fontSize: 24, fontWeight: FontWeight.w400);

  static TextStyle text14 =
      TextStyle(color: AppColors.dark_4_half.withOpacity(0.5), fontSize: 14, fontWeight: FontWeight.w400);

  static const TextStyle title24 = TextStyle(color: AppColors.dark_2, fontSize: 24, fontWeight: FontWeight.bold);

  static const TextStyle nav20 = TextStyle(color: AppColors.dark_1, fontSize: 20, fontWeight: FontWeight.w500);

  static TextStyle customerName = GoogleFonts.poppins(textStyle: title24Normal);
  static TextStyle customerVisitType = GoogleFonts.poppins(textStyle: text14);
  static TextStyle customerAddService = GoogleFonts.poppins(
    textStyle: TextStyle(color: AppColors.dark_4.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w400),
  );

  static TextStyle paymentMode(bool hasPayment) {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: (hasPayment) ? AppColors.green_2 : AppColors.yellow_light,
            fontSize: 12,
            fontWeight: FontWeight.w400));
  }

  static TextStyle get addServiceDropdown {
    return GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400));
  }

  static TextStyle get addServiceDropdownSelected {
    return GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400));
  }

  static TextStyle get noNotesHeader {
    return GoogleFonts.poppins(
        textStyle: TextStyle(color: AppColors.dark_4, fontSize: 18, fontWeight: FontWeight.w400));
  }

  static TextStyle get addServiceName {
    return GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400));
  }

  static TextStyle get addServiceCost {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: Colors.black.withOpacity(0.2),
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400));
  }

  static TextStyle customerAppointmentDetails(bool hasValue, {bool isLeft = true}) {
    if (!isLeft) {
      return GoogleFonts.notoSans(
          textStyle: TextStyle(color: AppColors.dark_4.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w400));
    }

    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: (hasValue)
                ? (isLeft)
                    ? AppColors.dark_4.withOpacity(0.6)
                    : AppColors.dark_4.withOpacity(0.8)
                : AppColors.lightGrey.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400));
  }

  static TextStyle calendarMonthHeader = GoogleFonts.roboto(
    textStyle: TextStyle(color: AppColors.dark_4, fontSize: 18, fontWeight: FontWeight.w400),
  );

  static TextStyle calendarDateHeader = GoogleFonts.roboto(
    textStyle: TextStyle(color: AppColors.dark_7, fontSize: 8, fontWeight: FontWeight.w400),
  );

  static TextStyle pickerItems = GoogleFonts.roboto(
    textStyle: TextStyle(color: AppColors.dark_7, fontSize: 18, fontWeight: FontWeight.w400),
  );

  static TextStyle calendarWeekHeader = GoogleFonts.roboto(
    textStyle: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w400),
  );

  static TextStyle timeHeader = GoogleFonts.roboto(
    textStyle: TextStyle(color: AppColors.dark_4, fontSize: 22, fontWeight: FontWeight.w400),
  );

  static TextStyle workerLocationPickerText = GoogleFonts.roboto(
    textStyle: TextStyle(color: AppColors.dark_4.withOpacity(0.4), fontSize: 14, fontWeight: FontWeight.w400),
  );
  static TextStyle workerLocationPickerValue = GoogleFonts.roboto(
    textStyle: TextStyle(color: AppColors.dark_4, fontSize: 14, fontWeight: FontWeight.w400),
  );

  static TextStyle customerListingName = GoogleFonts.poppins(
    textStyle: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
  );

  static TextStyle customerListingInfo = GoogleFonts.poppins(
    textStyle: TextStyle(color: AppColors.dark_7, fontSize: 10, fontWeight: FontWeight.w400),
  );

  static TextStyle addVisitBtn = GoogleFonts.poppins(
    textStyle: TextStyle(color: AppColors.lightGrey_2, fontSize: 14, fontWeight: FontWeight.w500),
  );

  static TextStyle basicInformationTitle = GoogleFonts.poppins(
    textStyle: TextStyle(color: AppColors.dark_4, fontSize: 16, fontWeight: FontWeight.w400),
  );
  static TextStyle addPositionBtn = GoogleFonts.poppins(
    textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
  );
}
