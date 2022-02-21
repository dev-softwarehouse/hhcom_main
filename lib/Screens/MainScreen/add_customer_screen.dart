import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/controller/fobject.dart';
import 'package:hhcom/controller/fuser.dart';
import 'package:hhcom/controller/navigation_controller.dart';
import 'package:hhcom/widget/warning_dialog.dart';
import 'package:sizer/sizer.dart';

/// It's contained the name, Lastname, mobilenumber, email, address details FormFields
///
/// After the successfull submit form need to call API for addcustomer
///
class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  var lastNameController = TextEditingController();
  var nameController = TextEditingController();

  var _phoneController = TextEditingController();
  var emailController = TextEditingController();

  var streetNameController = TextEditingController();
  var streetNumberController = TextEditingController();
  var apartmentNumberController = TextEditingController();
  var zipCodeController = TextEditingController();
  var cityController = TextEditingController();

  /// Define the _formKey for the save and validate the form data
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _selectedContryCode = "+91".obs;

  /// Dispose the all textController when page is remove from stack
  @override
  void dispose() {
    lastNameController.dispose();
    nameController.dispose();
    _phoneController.dispose();
    emailController.dispose();
    streetNumberController.dispose();
    streetNameController.dispose();
    apartmentNumberController.dispose();
    zipCodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        backgroundColor: Color(0xfffcfbfc),
        child: Padding(
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
                    child: Image.asset(add_customer),
                  ),
                  SizedBox(height: 3.0.h),
                  _basicInfoFormCard(),
                  SizedBox(height: 2.0.h),
                  _contactDetailsFormCard(),
                  SizedBox(height: 2.0.h),
                  _addressDetailsFormCard(),
                  SizedBox(height: 2.0.h),
                  customTextButton(onTap: _submit, btnText: 'Dodaj klienta'),
                  SizedBox(height: 2.0.h),
                ],
              ),
            ),
          ),
        ));
  }

  /// Final Submit button after fill form here check for validation if any value is wroung
  ///
  /// After the validation call the API here
  ///
  _submit() async {
    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        print(lastNameController.text);
        print(nameController.text);
        print(_phoneController.text);
        print(emailController.text);
        print(streetNameController.text);
        print(streetNumberController.text);
        print(apartmentNumberController.text);
        print(zipCodeController.text);
        print(cityController.text);
        var model = CustomerModel();
        model.userId = FUser.currentId()!;
        model.firstName = nameController.text;
        model.lastName = lastNameController.text;
        model.phone = _phoneController.text;
        model.email = emailController.text;

        model.street = streetNameController.text;
        model.streetNumber = streetNumberController.text;
        model.city = cityController.text;
        model.apartmentNumber = int.parse(apartmentNumberController.text);
        model.zipCode = int.parse(zipCodeController.text);

        //print(model.toJson());
        FObject customer = FObject.objectWithPathDic(FPath.customer, model.toJson());
        NavigationController().notifierInitLoading.value = true;
        await customer.saveInBackground();
        NavigationController().notifierInitLoading.value = false;
        Get.back();
      } on FormatException catch (e) {
        String msg = "Only numbers are allowed" + e.message;
        WarningMessageDialog.showDialog(context, msg, type: MsgType.error);
      } catch (e) {
        WarningMessageDialog.showDialog(context, e.toString(), type: MsgType.error);
      }
    }
  }

  /// Contact Information block
  Container _contactDetailsFormCard() {
    return Container(
      width: 70.0.w,
      padding: EdgeInsets.all(3.0.h),
      decoration: customBoxDecoration(
        color: addCustomerCardBgColor.withOpacity(0.3),
        isBoxShadow: false,
        borderRadius: 14,
      ),
      child: Column(
        children: [
          FormTitleWidget(title: 'Dane kontaktowe'),
          SizedBox(height: 2.0.h),
          Row(
            children: [
              Container(
                width: 25.0.w,
                decoration: customBoxDecoration(
                  color: whiteColor,
                  isBoxShadow: false,
                  borderRadius: 14,
                  isBorderEnable: true,
                ),
                child: CountryCodePicker(
                  onChanged: (contryCode) => _selectedContryCode.value = contryCode.dialCode!,
                  initialSelection: 'PL',
                  favorite: ['+48', 'PL'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
              ),
              SizedBox(width: 1.0.w),
              Expanded(
                child: customTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  labelText: 'Numer telefonu',
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Please enter Numer telefonu';
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: emailController,
              labelText: 'Adres email',
              validator: (v) {
                if (!GetUtils.isEmail(v!)) {
                  return 'Please enter valid Adres email';
                }
              }),
        ],
      ),
    );
  }

  /// Address Information block
  Container _addressDetailsFormCard() {
    return Container(
      width: 70.0.w,
      padding: EdgeInsets.all(3.0.h),
      decoration: customBoxDecoration(
        color: addCustomerCardBgColor.withOpacity(0.3),
        isBoxShadow: false,
        borderRadius: 14,
      ),
      child: Column(
        children: [
          FormTitleWidget(title: 'Dane adresowe'),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: streetNameController,
              labelText: 'Nazwa ulicy',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please enter Nazwa ulicy';
                }
              }),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: streetNumberController,
              labelText: 'Numer ulicy',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please enter Numer ulicy';
                }
              }),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: apartmentNumberController,
              labelText: 'Numer mieszkania',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please enter Numer mieszkania';
                }
              }),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: zipCodeController,
              keyboardType: TextInputType.number,
              labelText: 'Kod pocztowy',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please enter Kod pocztowy';
                }
              }),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: cityController,
              labelText: 'Miasto',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please enter Miasto';
                }
              }),
        ],
      ),
    );
  }

  /// Basic Information block
  Container _basicInfoFormCard() {
    return Container(
      width: 70.0.w,
      padding: EdgeInsets.all(3.0.h),
      decoration: customBoxDecoration(
        color: addCustomerCardBgColor.withOpacity(0.3),
        isBoxShadow: false,
        borderRadius: 14,
      ),
      child: Column(
        children: [
          FormTitleWidget(title: 'Dane podstawowe'),
          SizedBox(height: 2.0.h),
          customTextField(
            controller: nameController,
            labelText: 'Imię',
            validator: (v) {
              if (v!.isEmpty) {
                return 'Please enter Imię';
              }
            },
          ),
          SizedBox(height: 2.0.h),
          customTextField(
              controller: lastNameController,
              labelText: 'Nazwisko',
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please enter Nazwisko';
                }
              }),
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
      padding: EdgeInsets.all(2.0.h),
      decoration: customBoxDecoration(
        color: addCustomerCardTitlebgColor,
        isBoxShadow: false,
        borderRadius: 14,
      ),
      child: text(title!, fontSize: 12.0),
    );
  }
}
