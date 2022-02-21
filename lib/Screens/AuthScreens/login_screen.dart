import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hhcom/Screens/AuthScreens/registration_screen.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/Routes/app_routes.dart';
import 'package:hhcom/bloc/auth/auth.dart';
import 'package:hhcom/controller/controller.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  var _isRememberMeChecked = false.obs;
  var _isPasswordHide = true.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = AuthBloc(context);
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => _authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (_, AuthState state) {
          if (state is LoginSuccessState) {
            //NavigationController().pushTo(context, child: const MainScreen());
            Get.toNamed(Routes.MAIN_SCREEN); //Szymon
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (_, AuthState state) {
            return BaseScaffold(
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: 70.0.w,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: customIcon(icon: title_img, size: 30.0),
                          ),
                          customTextField(
                              controller: _usernameController,
                              labelText: 'Nazwa użytkownika',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter Nazwa użytkownika';
                                }
                              }),
                          SizedBox(height: 2.0.h),
                          Obx(() => customTextField(
                              controller: _passwordController,
                              labelText: 'Hasło',
                              obscureText: _isPasswordHide.value,
                              isSuffixIcon: true,
                              onSuffixTap: () => _isPasswordHide.value = !_isPasswordHide.value,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter Hasło';
                                } else if (v.length < 8) {
                                  return 'Please enter minimum 8 character';
                                }
                              })),
                          SizedBox(height: 2.0.h),
                          _rememberMeCheckboxWidget(),
                          SizedBox(height: 2.0.h),
                          customTextButton(onTap: _submit, btnText: 'Zaloguj się'),
                          SizedBox(height: 1.0.h),
                          customTextButton(onTap: () => NavigationController().pushTo(context, child: RegistrationScreen(_authBloc)), btnText: 'Zaloguj się', color: whiteColor),
                          SizedBox(height: 1.0.h),
                          GestureDetector(onTap: () => Get.toNamed(Routes.RECOVER_PASSWORDE), child: text('Nie pamiętam hasła', color: Colors.grey))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  GestureDetector _rememberMeCheckboxWidget() {
    return GestureDetector(
      onTap: () => _isRememberMeChecked.value = !_isRememberMeChecked.value,
      child: Row(
        children: [
          Obx(() => Container(
                margin: EdgeInsets.only(left: 2.0.h),
                height: 3.0.h,
                width: 3.0.h,
                child: Image.asset(
                  checkbox_icn,
                  color: _isRememberMeChecked.value ? Colors.black : Colors.grey,
                ),
              )),
          SizedBox(width: 2.0.w),
          text('zapamiętaj na tym urządzeniu', fontSize: 9.0, fontWeight: FontWeight.w500)
        ],
      ),
    );
  }

  _submit() {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    //_authBloc.add(EmailLoginEvent(Constants.testUserEmail, Constants.password));
    _authBloc.add(EmailLoginEvent(_usernameController.text, _passwordController.text));
  }
}
