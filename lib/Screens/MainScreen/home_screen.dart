import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hhcom/Screens/AuthScreens/login_screen.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/utils.dart';
import 'package:hhcom/bloc/base/base.dart';
import 'package:hhcom/controller/controller.dart';
import 'package:sizer/sizer.dart';

/// Homescreen of app user can logout from this screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(right: 2.0.h, top: Utils().safePaddingTop(context)),
            child: GestureDetector(
                onTap: () async {
                  NavigationController().notifierInitLoading.value = true;
                  await FUser.signOut();
                  BlocProvider.of<BaseBloc>(context).add(ClearCustomerListEvent());
                  await Future.delayed(Duration(seconds: 1));
                  NavigationController().notifierInitLoading.value = false;
                  Get.to(() => LoginScreen()); //Szymon
                },
                child: customIcon(icon: signout_icn)),
          ),
        ),
        Center(
          child: Container(
            child: customIcon(icon: title_img, size: 30.0),
          ),
        ),
      ],
    );
  }
}
