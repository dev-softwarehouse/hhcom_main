import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'constant.dart';

/// Custom Text widget with predefine text style
Text text(
  String content, {
  TextStyle? textStyle,
  Color? color = Colors.black,
  double? fontSize = 11,
  int? maxLines,
  FontWeight? fontWeight = FontWeight.normal,
  double? letterSpacing = 0.0,
}) {
  return Text(content,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
          color: color, fontSize: fontSize!.sp, fontWeight: fontWeight, letterSpacing: letterSpacing!));
}

/// Method used for show textfield in allover the app
TextFormField customTextField(
    {required TextEditingController? controller,
    required String? labelText,
    required Function(String?)? validator,
    bool obscureText = false,
    bool isSuffixIcon = false,
    bool isReadOnly = false,
    Function(String?)? onChanged,
    Function? onSuffixTap,
    Widget? suffixIcon,
    TextInputType? keyboardType = TextInputType.name,
    bool autofocus = false}) {
  return TextFormField(
    readOnly: isReadOnly,
    autofocus: autofocus,
    controller: controller,
    keyboardType: keyboardType,
    cursorColor: Colors.black,
    style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, fontSize: 11.sp)),
    decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
        filled: true,
        fillColor: whiteColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        suffixIcon: (suffixIcon != null || isSuffixIcon)
            ? Padding(
                padding: const EdgeInsetsDirectional.only(end: 14.0),
                child: GestureDetector(
                    onTap: () => onSuffixTap!(), child: suffixIcon ?? customIcon(icon: eye_icn, size: 1.0)),
              )
            : Text(''),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
    textInputAction: TextInputAction.done,
    validator: (v) => validator!(v),
    obscureText: obscureText,
    onChanged: onChanged,
  );
}

/// Custom textButton
customTextButton(
    {required Function onTap,
    required String btnText,
    double width = 70.0,
    double fontSize = 10.0,
    double height = 12.0,
    double cornerRadius = 10.0,
    Color color = primaryColor}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 0.2.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornerRadius),
          color: color,
          border: Border.all(color: color == whiteColor ? primaryColor : color, width: 2)),
      height: height.w,
      width: width.h,
      child: text(
        btnText,
        color: color == primaryColor ? whiteColor : primaryColor,
        letterSpacing: 1.0,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// Container custom box decoration with some default style and also customizable
BoxDecoration customBoxDecoration(
    {Color color = whiteColor, bool isBoxShadow = true, bool isBorderEnable = false, double borderRadius = 20}) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: isBorderEnable ? Border.all(color: primaryColor.withOpacity(0.9)) : null,
      boxShadow: isBoxShadow
          ? [BoxShadow(spreadRadius: 0, offset: Offset(2, 4), blurRadius: 5, color: Colors.grey.withOpacity(1))]
          : []);
}

/// Custom error ErrorSnackBar design for show error
///
/// Call `Get.showSnackbar(ErrorSnackBar(title: 'Oops!', message: response.body.toString()));` for show ErrorSnackBar
GetBar errorSnackBar({String title = 'Error', String? message}) {
  Get.log("[$title] $message", isError: true);
  return GetBar(
    titleText: text(title.tr, color: whiteColor, fontSize: 5.0),
    messageText: text(message!, color: whiteColor, fontSize: 5.0),
    snackPosition: SnackPosition.BOTTOM,
    margin: EdgeInsets.all(20),
    backgroundColor: Colors.redAccent,
    icon: Icon(Icons.remove_circle_outline, size: 10.0.sp, color: whiteColor),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    borderRadius: 8,
    duration: Duration(seconds: 3),
  );
}

Widget customIcon({required String? icon, double size = 4.0}) {
  return Container(
    height: size.h,
    width: size.h,
    child: Image.asset(
      icon!,
    ),
  );
}

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: text('No Data', color: Colors.black, fontSize: 9.0),
      ),
    );
  }
}

/// Customerbackground
class CustomBackground extends StatelessWidget {
  final double height;
  const CustomBackground({
    Key? key,
    this.height = 45.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: 50.0.w, child: Image.asset(bg_img));
  }
}

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({
    Key? key,
    this.alignment = Alignment.topRight,
    this.padding = 2.0,
  }) : super(key: key);

  final Alignment? alignment;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment!,
        child: GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.only(right: padding!.h, top: 60),
              child: customIcon(icon: back_icn),
            )));
  }
}
