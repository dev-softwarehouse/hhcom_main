import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/Routes/app_routes.dart';
import 'package:hhcom/controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? _preferences;
  var _loadCredentials = ValueNotifier(true);

  @override
  void initState() {
    NavigationController().notifierInitLoading.value = true;
    _loadCredentials.addListener(listener);
    _storedCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      child: Center(
        child: Container(
          child: customIcon(icon: title_img, size: 30.0),
        ),
      ),
    );
  }

  _storedCredentials() async {
    _preferences = await SharedPreferences.getInstance();
    Constants.preferences = _preferences!;
    print('CurrentUser: ${_preferences!.getString('CurrentUser')}');
    bool isLoggedIn = (_preferences!.getString('CurrentUser')?.isNotEmpty ?? false) && FirebaseAuth.instance.currentUser != null;
    if (!isLoggedIn) {
      await FirebaseAuth.instance.signOut();
    }
    _loadCredentials.value = false;
    await Future.delayed(Duration(seconds: 2));
    NavigationController().notifierInitLoading.value = false;
    isLoggedIn ? Get.toNamed(Routes.MAIN_SCREEN) : Get.toNamed(Routes.LOGIN_SCREEN); // Szymon
    //NavigationController().pushTo(context, child: isLoggedIn ? MainScreen() : LoginScreen());
  }

  void listener() {
    setState(() {});
  }
}
