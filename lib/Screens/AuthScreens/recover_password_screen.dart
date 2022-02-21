import 'package:flutter/material.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

/// Provide the textfield for email
/// 
class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({Key? key}) : super(key: key);

  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {


  /// Define the _formKey for the save and validate the form data
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();

  /// Dispose the all textController when page is remove from stack
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomBackground(),
            CustomBackArrow(),
            Center(
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
                              (recover_password_title),
                            )),
                        SizedBox(height: 6.0.h),
                        customTextField(
                            controller: emailController,
                            labelText: 'Adres email',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (!GetUtils.isEmail(v!)) {
                                return 'Email Not Valid';
                              }
                            }),
                        SizedBox(height: 4.0.h),
                        customTextButton(
                            onTap: _submit, btnText: 'Przypomnij hasło'),
                        Spacer(flex: 2)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submit() {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      print(emailController.text);
    }
  }
}
