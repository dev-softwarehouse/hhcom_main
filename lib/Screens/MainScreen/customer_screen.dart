import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Screens/Appointment/controllers/customer_appointment_controller.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/customer_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/Routes/app_routes.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/Utils/utils.dart';
import 'package:hhcom/bloc/base/base.dart';
import 'package:hhcom/bloc/customer/customer.dart';
import 'package:hhcom/widget/user_avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import 'Controllers/drawer_item_controller.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late CustomerBloc _screenBloc;
  var searchController = TextEditingController();

  var drawerItemController = Get.put(DrawerItemController());
  List<CustomerModel> _customerList = [];
  CustomerModel? _selectedItem;

  @override
  void initState() {
    _screenBloc = BlocProvider.of<CustomerBloc>(context);
    _initCustomerList();
    super.initState();
  }

  _initCustomerList() {
    _customerList = BlocProvider.of<BaseBloc>(context).state.customers;
    _customerList = _customerList.toSet().toList();
    Get.find<CustomerController>().customerList.addAll(_customerList);
  }

  bool _listenBaseStateWhen(BaseState pre, BaseState state) => pre.customers != state.customers;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BaseBloc, BaseState>(
          listenWhen: _listenBaseStateWhen,
          listener: (_, BaseState state) {
            _initCustomerList();
            setState(() {});
          },
        ),
        BlocListener<CustomerBloc, CustomerState>(
          listener: (_, CustomerState state) {
            if (state is UpdateCustomerSuccessState ||
                state is AddCustomerAppointmentSuccessState ||
                state is AddCustomerAppointmentNotesSuccessState) {
              _initCustomerList();
              setState(() {});
            }
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            height: 23.0.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100.0.w,
                  child: Image.asset(search_bg),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 65.0.w,
                      child: customTextField(
                          controller: searchController,
                          labelText: 'Dane klienta',
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Please enter Dane klienta';
                            }
                          }),
                    ),
                    SizedBox(width: 3.0.w),
                    GestureDetector(
                        onTap: () => Get.toNamed(Routes.ADD_CUSTOMER_SCREEN),
                        child: customIcon(icon: add_customer_icn, size: 7.0))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (ctx, i) {
                var itemList = _customerList;
                double height = 1;
                double thickness = 1;
                Color color = Color(0xffbbbbbb);

                if (itemList[i].objectId == _selectedItem?.objectId) {
                  height = 0;
                  thickness = 0;
                  color = Colors.white;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Divider(
                    color: color,
                    height: height,
                    thickness: thickness,
                  ),
                );
              },
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                var itemList = _customerList;
                return itemList[i].objectId == _selectedItem?.objectId
                    ? _expandedTile(itemList[i])
                    : InkWell(
                        onTap: () {
                          _selectedItem = itemList[i];
                          setState(() {});
                        },
                        child: Center(
                          child: Container(
                            width: 80.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                UserAvatar(itemList[i].picture, size: 15.w),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itemList[i].firstName,
                                      style: TextStyles.customerListingName,
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Row(
                                      children: [
                                        customIcon(size: 1.5, icon: phone_icn),
                                        SizedBox(
                                          width: 1.w,
                                        ),
                                        Text(
                                          itemList[i].phone,
                                          style: TextStyles.customerListingInfo,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.5.w,
                                    ),
                                    Row(
                                      children: [
                                        customIcon(size: 1.5, icon: email_icn),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          itemList[i].email,
                                          style: TextStyles.customerListingInfo,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
              itemCount: _customerList.length,
            ),
          ),
        ],
      ),
    );
  }

  /// Called on user tap on any customer and user can able to show the customer details
  ///
  Column _expandedTile(CustomerModel customer) {
    Get.find<CustomerController>().setSelectedCustomer(customer);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 2.0.h,
            bottom: 5.0.h,
            right: 1.h,
            top: 2.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  UserAvatar(customer.picture, size: 24.0.h),
                  Positioned(
                    bottom: -10,
                    left: -10,
                    child: CupertinoButton(
                      onPressed: _showBottomSheet,
                      child: Icon(Icons.camera_alt, color: AppColors.dark_1, size: 40),
                    ),
                  )
                ],
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.0.w),
                        child: Text('${customer.firstName}', style: TextStyles.customerListingName),
                      ),
                      SizedBox(height: 1.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 3.0.w),
                        child: IconValueWidget(
                            mainAxisAlignment: MainAxisAlignment.start,
                            icon: selected_phone_customer,
                            value: customer.phone),
                      ),
                      SizedBox(height: 1.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w),
                        child: IconValueWidget(
                            mainAxisAlignment: MainAxisAlignment.start,
                            icon: selected_email_customer,
                            value: customer.email),
                      ),
                      SizedBox(height: 1.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0.w),
                        child: IconValueWidget(
                            mainAxisAlignment: MainAxisAlignment.start,
                            icon: selected_home_customer,
                            value: customer.street),
                      ),
                      SizedBox(height: 1.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: IconValueWidget(
                            mainAxisAlignment: MainAxisAlignment.start, icon: hash_icn, value: customer.objectId!),
                      ),
                      SizedBox(height: 1.0.h),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0.w),
                        child: IconValueWidget(
                            mainAxisAlignment: MainAxisAlignment.start,
                            icon: selected_building_customer,
                            value: customer.city),
                      ),
                      SizedBox(height: 2.5.h),
                    ],
                  ),
                  Positioned(
                    bottom: -40,
                    right: -20,
                    child: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          _selectedItem = null;
                        });
                      },
                      child: customIcon(icon: customer_edit, size: 7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 100.w,
          height: 20.0.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(appointment_background),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: customer.visits.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return Container(
                          padding: EdgeInsets.all(2.5.h),
                          margin: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 2.0.h),
                          child: InkWell(
                            onTap: () {
                              Get.delete<CustomerAppointmentController>();
                              Get.put(CustomerAppointmentController());
                              Get.toNamed(Routes.ADD_APPOINTMENT);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customIcon(icon: add_icn),
                                SizedBox(height: 1.0.h),
                                text(addVisitHeader, textStyle: TextStyles.addVisitBtn),
                              ],
                            ),
                          ),
                        );
                      }

                      CustomerAppointment customerAppointment = CustomerAppointment.fromMap(customer.visits[i - 1]);
                      return InkWell(
                        onTap: () {
                          Get.delete<CustomerAppointmentController>();
                          Get.put(CustomerAppointmentController());
                          var customerAppointmentController = Get.find<CustomerAppointmentController>();
                          customerAppointmentController.customerAppointment.value = customerAppointment;
                          customerAppointmentController.editingIndex.value = i - 1;
                          Get.toNamed(Routes.ADD_APPOINTMENT, arguments: [customerAppointment, i - 1]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.5.h),
                          margin: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 2.0.h),
                          decoration: customBoxDecoration(color: i != 1 ? Color(0xffBBBBBB) : Color(0xffC8D3DB)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              text(
                                  DateFormat("dd MMM yyyy").format(
                                      customer.visitDateTime(customerAppointment.timestamp!)
                                      /*DateTime.parse(
                                                customer.visits[i - 1].date!)*/
                                      ),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12),
                              text(DateFormat.Hm().format(customer.visitDateTime(customerAppointment.timestamp!)),
                                  fontWeight: FontWeight.w500, letterSpacing: 1, fontSize: 12)
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                bottomSheetItem('Take a photo', Icons.camera_alt_outlined, ImageSource.camera),
                SizedBox(height: 25),
                bottomSheetItem('Choose from gallery', Icons.folder_open, ImageSource.gallery),
                SizedBox(height: Utils().safePaddingBottom(context)),
              ],
            ),
          );
        },
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  bottomSheetItem(String text, IconData data, ImageSource source) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        bool isGranted = false;
        String? permissionDes;
        if (source == ImageSource.camera) {
          PermissionStatus state = await Permission.camera.request();
          isGranted = state.isGranted;
          permissionDes = PermissionDes.Camera;
        } else {
          PermissionStatus state = await Permission.photos.request();
          isGranted = state.isGranted;
          permissionDes = PermissionDes.Gallery;
        }
        if (isGranted)
          _openPicker(source);
        else {
          Get.defaultDialog(
              title: 'Warning!',
              middleText: permissionDes,
              confirm: CupertinoButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('OK')));
        }
      },
      child: Row(
        children: [
          Icon(data, color: AppColors.icon, size: 20),
          SizedBox(width: 20),
          Text(text, style: TextStyle(color: AppColors.icon, fontSize: 17, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }

  _openPicker(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    _screenBloc.add(UploadCustomerPictureEvent(File(pickedFile!.path), _selectedItem!.objectId!));
  }
}

/// This custom widget used for the show customer details with icon
class IconValueWidget extends StatelessWidget {
  const IconValueWidget(
      {Key? key,
      required this.icon,
      required this.value,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.textColor = textGreyColor})
      : super(key: key);

  final String icon, value;
  final Color textColor;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        customIcon(icon: icon, size: 1.5),
        SizedBox(width: 1.5.w),
        Container(
          width: 30.0.w,
          child: Text(
            value,
            style: TextStyles.customerListingInfo,
          ),
        ),
        //Container(width: 40.0.w, child: text(value, fontWeight: FontWeight.w400, color: textGreyColor, maxLines: 2)),
      ],
    );
  }
}
