import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Screens/MainScreen/main_screen.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/bloc/auth/auth.dart';
import 'package:hhcom/controller/controller.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

class RegistrationScreen extends StatefulWidget {
  final AuthBloc authBloc;
  const RegistrationScreen(this.authBloc, {Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var companyNameController = TextEditingController();
  var emailController = TextEditingController();
  var nipController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var isPasswordHide = true.obs;
  var isConfirmPasswordHide = true.obs;

  @override
  void dispose() {
    emailController.dispose();
    companyNameController.dispose();
    nipController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: widget.authBloc,
      listener: (_, AuthState state) {
        if (state is LoginSuccessState) {
          NavigationController().pushTo(context, child: const MainScreen());
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
          bloc: widget.authBloc,
          builder: (_, AuthState state) {
            return BaseScaffold(
              hasBack: true,
              child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: 70.0.w,
                    height: 100.0.h,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Container(
                              width: 90.0.w,
                              // color: Colors.indigo,
                              child: Image.asset(
                                (registration_title),
                              )),
                          SizedBox(height: 6.0.h),
                          customTextField(
                              controller: companyNameController,
                              labelText: 'Nazwa firmy',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter valid Nazwa firmy';
                                }
                              }),
                          SizedBox(height: 2.0.h),
                          customTextField(
                              controller: nipController,
                              labelText: 'NIP',
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter valid NIP';
                                }
                              }),
                          SizedBox(height: 2.0.h),
                          customTextField(
                              controller: userNameController,
                              labelText: 'Nazwa użytkownika',
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter valid Nazwa użytkownika';
                                }
                              }),
                          SizedBox(height: 2.0.h),
                          customTextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              labelText: 'Adres email',
                              validator: (v) {
                                if (!GetUtils.isEmail(v!)) {
                                  return 'Please enter valid Adres email';
                                }
                              }),
                          SizedBox(height: 2.0.h),
                          Obx(() => customTextField(
                              controller: passwordController,
                              labelText: 'Hasło',
                              obscureText: isPasswordHide.value,
                              isSuffixIcon: true,
                              onSuffixTap: () => isPasswordHide.value =
                                  !isPasswordHide.value,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter Hasło';
                                } else if (v.length < 8) {
                                  return 'Please enter minimum 8 character';
                                }
                              })),
                          SizedBox(height: 2.0.h),
                          Obx(() => customTextField(
                              controller: confirmPasswordController,
                              labelText: 'Powtórz hasło',
                              obscureText: isConfirmPasswordHide.value,
                              isSuffixIcon: true,
                              onSuffixTap: () => isConfirmPasswordHide
                                  .value = !isConfirmPasswordHide.value,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Please enter Powtórz hasło';
                                } else if (v != passwordController.text) {
                                  return 'Password not matched';
                                }
                              })),
                          SizedBox(height: 4.0.h),
                          customTextButton(
                              onTap: _submit, btnText: 'Zarejestruj się'),
                          Spacer(flex: 2)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _submit() {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      UserModel userModel = UserModel();
      userModel.username = userNameController.text;
      userModel.email = emailController.text;
      userModel.taxId = nipController.text;
      userModel.companyName = companyNameController.text;

      widget.authBloc.add(RegisterEvent(emailController.text, passwordController.text, userModel));
    }
  }
}
