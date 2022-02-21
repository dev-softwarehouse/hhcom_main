import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/position_model.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/controller/fobject.dart';
import 'package:hhcom/controller/navigation_controller.dart';
import 'package:hhcom/widget/warning_dialog.dart';
import 'package:sizer/sizer.dart';

import 'Controllers/positions_controller.dart';

/// Addm position to position list
class AddPosition extends StatefulWidget {
  const AddPosition({Key? key}) : super(key: key);

  @override
  _AddPositionState createState() => _AddPositionState();
}

class _AddPositionState extends State<AddPosition> {
  var titleMalePositionController = TextEditingController();
  var titleFeMalePositionController = TextEditingController();
  var positionTextController = TextEditingController(text: "Manager");

  var isSeparateTitle = false.obs;
  var jobTitle = generalJobTitle.obs;
  var jobTitleHint = generalJobTitleHint.obs;

  /// Define the _formKey for the save and validate the form data
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Dispose the all textController when page is remove from stack
  @override
  void dispose() {
    titleFeMalePositionController.dispose();
    titleMalePositionController.dispose();
    positionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfffcfbfc),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 0.0.h),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0.h),
                  CustomBackArrow(
                    padding: 0.0,
                    alignment: Alignment.topLeft,
                  ),
                  // SizedBox(height: 3.0.h),
                  Container(
                    width: 50.0.w,
                    child: Image.asset(add_position_title),
                  ),
                  SizedBox(height: 3.0.h),
                  _basicInfoFormCard(),
                  SizedBox(height: 10.0.h),
                  customTextButton(onTap: _submit, btnText: savePositionBtnTitle, width: 10.w, height: 2.h),
                  SizedBox(height: 2.0.h),
                ],
              ),
            ),
          ),
        ));
  }

  GestureDetector separateTitleCheckBox() {
    return GestureDetector(
      onTap: () {
        isSeparateTitle.value = !isSeparateTitle.value;
        jobTitle.value = (isSeparateTitle.isTrue) ? maleJobTitle : generalJobTitle;
        jobTitleHint.value = (isSeparateTitle.isTrue) ? maleJobTitleHint : generalJobTitleHint;
      },
      child: Row(
        children: [
          Obx(() => Container(
                margin: EdgeInsets.only(left: 2.0.h),
                height: 3.0.h,
                width: 3.0.h,
                child: Image.asset(
                  checkbox_icn,
                  color: isSeparateTitle.value ? Colors.black : AppColors.lightGrey4,
                ),
              )),
          SizedBox(width: 2.0.w),
          text(differentGenderJobs, fontSize: 9.0, fontWeight: FontWeight.w500)
        ],
      ),
    );
  }

  _submit() async {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      //print(titleFeMalePositionController.text);
      //print(titleMalePositionController.text);
      //print(positionTextController.text);
      PositionModel model = PositionModel(
          sId: "1",
          femaleJobTitle: titleFeMalePositionController.text,
          maleJobTitle: titleMalePositionController.text,
          position: "Manager", //positionTextController.text,
          jobType: JobType.Manager.index);

      FObject position = FObject.objectWithPathDic(FPath.position, model.toJson());
      NavigationController().notifierInitLoading.value = true;
      await position.saveInBackground();
      var positionController = Get.find<PositionController>();
      positionController.positionList.refresh();
      NavigationController().notifierInitLoading.value = false;

      Get.back();
    }
  }

  Container _basicInfoFormCard() {
    return Container(
      width: 80.0.w,
      padding: EdgeInsets.all(3.0.h),
      decoration:
          BoxDecoration(color: AppColors.marron.withOpacity(0.2), borderRadius: BorderRadius.all(Radius.circular(20))),
      /*customBoxDecoration(
        color: AppColors.marron, //addCustomerCardBgColor.withOpacity(0.3),
        isBoxShadow: false,
        borderRadius: 14,
      ),*/
      child: Column(
        children: [
          FormTitleWidget(title: basicInformationTitle),
          SizedBox(height: 5.0.h),
          Obx(() {
            return customTextField(
              controller: titleMalePositionController,
              labelText: jobTitle.value,
              validator: (v) {
                if (v!.isEmpty) {
                  return jobTitleHint.value;
                }
              },
            );
          }),
          Obx(() {
            if (isSeparateTitle.isTrue) {
              return Column(
                children: [
                  SizedBox(height: 2.0.h),
                  customTextField(
                      controller: titleFeMalePositionController,
                      labelText: femaleJobTitle,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return femaleJobTitleHint;
                        }
                      }),
                ],
              );
            }

            return Container();
          }),
          SizedBox(height: 3.5.h),
          separateTitleCheckBox(),
          SizedBox(height: 3.5.h),
          InkWell(
            onTap: () {
              WarningMessageDialog.showDialog(context, jobPostOnlyManagerAvailable, type: MsgType.normal);
            },
            child: AbsorbPointer(
              absorbing: true,
              child: customTextField(
                  onSuffixTap: () {},
                  isReadOnly: true,
                  isSuffixIcon: true,
                  suffixIcon: customIcon(icon: iconTriangle, size: 1),
                  controller: positionTextController,
                  labelText: positionTitle,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return positionTitleHint;
                    }
                  }),
            ),
          ),
          SizedBox(height: 1.0.h),
        ],
      ),
    );
  }
}

class FormTitleWidget extends StatelessWidget {
  const FormTitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 8.h,
      //padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 15.0.w),
      decoration: BoxDecoration(
          color: AppColors.lightGrey3.withOpacity(0.15), borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Center(child: text(title!, textStyle: TextStyles.basicInformationTitle, fontSize: 13)),
    );
  }
}
