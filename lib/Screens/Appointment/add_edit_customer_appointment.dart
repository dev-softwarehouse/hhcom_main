import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:fialogs/fialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/appointment_item_model.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Models/selected_service_product_model.dart';
import 'package:hhcom/Models/service_item_model.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/customer_controller.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/worker_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:hhcom/bloc/bloc.dart';
import 'package:hhcom/controller/fuser.dart';
import 'package:hhcom/widget/appointment_list_view.dart';
import 'package:hhcom/widget/appointment_service_items.dart';
import 'package:hhcom/widget/date_time_selection.dart';
import 'package:hhcom/widget/warning_dialog.dart';
import 'package:hhcom/widget/worker_location.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../base_scaffold.dart';
import 'controllers/customer_appointment_controller.dart';

class AddEditCustomerAppointment extends StatefulWidget {
  const AddEditCustomerAppointment({Key? key}) : super(key: key);

  @override
  _AddEditCustomerAppointmentState createState() => _AddEditCustomerAppointmentState();
}

class _AddEditCustomerAppointmentState extends State<AddEditCustomerAppointment> {
  final currencyFormat = NumberFormat.currency(locale: 'eu', symbol: currencyHeader);

  var customerController = Get.find<CustomerController>();
  var workerController = Get.find<WorkerController>();
  var customerAppointmentController = Get.find<CustomerAppointmentController>();
  late List<Item> serviceListItems;

  var serviceDropdown = [AppointmentRightItemValue.Services, AppointmentRightItemValue.Products];

  late Timer timer;
  final undoTimerDurationInSec = 2;

  void setServiceMenu() {
    customerAppointmentController.selectedProductService =
        SelectedServiceProductModel(type: 0, count: 1, name: serviceListItems[0].name!, cost: serviceListItems[0].cost)
            .obs;

    customerAppointmentController.serviceItems.clear();
    customerAppointmentController.serviceItemsDropdownMenu.clear();
    for (Item item in serviceListItems) {
      customerAppointmentController.serviceItems.add(item);
      customerAppointmentController.serviceItemsDropdownMenu.add(item);
    }
    customerAppointmentController.serviceItemsDropdownMenu.removeAt(0);
  }

  @override
  void initState() {
    super.initState();

    serviceListItems =
        List<Item>.from(customerAppointmentController.serviceItemController.serviceItemList.first.items!);

    setServiceMenu();

    // var serviceNames = [serviceItem0, serviceItem1, serviceItem2].obs;
    // var serviceDropdownMenu = [serviceItem1, serviceItem2].obs;

    if (customerAppointmentController.customerAppointment.value.timestamp != null) {
      customerAppointmentController.isEditMode.value = true;
    }
    if (customerAppointmentController.customerAppointment.value.totalCost != null) {
      customerAppointmentController.totalCostOfServices.value =
          customerAppointmentController.customerAppointment.value.totalCost!;
    }
  }

  void deleteServiceItem() {
    timer = Timer(Duration(seconds: undoTimerDurationInSec), () {
      updateProductServices();
    });
  }

  void saveNotes(String notes) {
    customerAppointmentController.saveNotes(notes);

    if (customerAppointmentController.isEditMode.isTrue) {
      updateNotes();
    }
  }

  void updateNotes() {
    var model = customerController.selectedCustomer.value;
    model.visits[customerAppointmentController.editingIndex.value] =
        customerAppointmentController.customerAppointment.value.toMap();
    CustomerBloc _customerBloc = BlocProvider.of<CustomerBloc>(context);
    _customerBloc.add(AddRemoveAppointmentNotesEvent(customerModel: model));
  }

  void updateProductServices() {
    var model = customerController.selectedCustomer.value;
    model.visits[customerAppointmentController.editingIndex.value] =
        customerAppointmentController.customerAppointment.value.toMap();
    CustomerBloc _customerBloc = BlocProvider.of<CustomerBloc>(context);
    _customerBloc.add(AddRemoveAppointmentProductsServicesEvent(customerModel: model));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBloc, CustomerState>(
      listener: (_, CustomerState state) {
        if (state is AddCustomerAppointmentSuccessState) {
          //WarningMessageDialog.showDialog(context, appointmentAddSuccessMsg, type: MsgType.success);
          Get.back();
        } else if (state is AddCustomerAppointmentErrorState) {
          WarningMessageDialog.showDialog(context, state.errorMessage, type: MsgType.error);
        } else if (state is AddEditCustomerAppointmentProductServiceSuccessState) {
          setState(() {});
        }
      },
      child: BaseScaffold(
          hasBack: false,
          hasCustomBackground: false,
          backgroundColor: Color(0xfffcfcfc),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0.h, vertical: 0.0.h),
            child: Stack(
              children: [
                Column(
                  children: [
                    Obx(() {
                      var backgroundImageName = top_background_appointment;
                      if (customerAppointmentController.addServiceActive.isTrue) {
                        backgroundImageName = appointment_background_full;
                      }

                      if (customerAppointmentController.isEditMode.isTrue) {
                        backgroundImageName = appointment_edit_background;
                        if (customerAppointmentController.editServiceActive.isTrue ||
                            customerAppointmentController.enableDeleteServiceView.isTrue) {
                          backgroundImageName = appointment_edit_full_background;
                        }
                      }

                      return Container(
                        height: 65.h,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(backgroundImageName),
                          fit: BoxFit.fill,
                        )),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.h, vertical: 0.0.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //  SizedBox(height: 5.0.h),
                              Padding(
                                padding: EdgeInsets.only(left: 1.w),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                        onTap: () {
                                          if (customerAppointmentController.editNotes.isTrue) {
                                            customerAppointmentController.editNotes.value = false;
                                            customerAppointmentController.enableDelete.value = false;
                                          } else {
                                            Get.back();
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 0, top: 60),
                                          child: customIcon(icon: back_icn),
                                        ))),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${customerController.selectedCustomer.value.firstName + " " + customerController.selectedCustomer.value.lastName}",
                                      style: TextStyles.customerName,
                                    ),
                                    Text(
                                      (customerAppointmentController.isEditMode.isTrue)
                                          ? appointmentEditStatus
                                          : appointmentStatus,
                                      style: TextStyles.customerVisitType,
                                    ),
                                  ],
                                ),
                              ),
                              Obx(
                                () => (customerAppointmentController.editNotes.value)
                                    ? Center(
                                        child: Padding(
                                          //padding: EdgeInsets.only(left: 10.w, right: 0.w, top: 1.h, bottom: 1.h),
                                          padding: EdgeInsets.all(0),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Obx(() {
                                                if (customerAppointmentController.customerAppointment.value.notes !=
                                                        null &&
                                                    customerAppointmentController
                                                            .customerAppointment.value.notes!.length >
                                                        0) {
                                                  return Container(
                                                    height: 36.h,
                                                    child: ListView.builder(
                                                        itemCount: customerAppointmentController
                                                            .customerAppointment.value.notes!.length,
                                                        shrinkWrap: true,
                                                        itemBuilder: (_, index) {
                                                          AppointmentNotesModel notesModel =
                                                              AppointmentNotesModel.fromMap(Map<String, dynamic>.from(
                                                                  customerAppointmentController
                                                                      .customerAppointment.value.notes![index]));
                                                          return Obx(() {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: customIcon(icon: notesIconBig),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 2.w,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      // setState(() {
                                                                      customerAppointmentController.deleteIndex.value =
                                                                          index;
                                                                      if (customerAppointmentController
                                                                              .deleteIndex.value !=
                                                                          customerAppointmentController
                                                                              .oldDeleteSelection.value) {
                                                                        customerAppointmentController
                                                                                .oldDeleteSelection =
                                                                            customerAppointmentController.deleteIndex;
                                                                        customerAppointmentController
                                                                            .enableDelete.value = true;
                                                                      } else {
                                                                        customerAppointmentController
                                                                                .enableDelete.value =
                                                                            !customerAppointmentController
                                                                                .enableDelete.value;
                                                                      }

                                                                      // });
                                                                    },
                                                                    child: Container(
                                                                      width: (customerAppointmentController
                                                                                  .enableDelete.isTrue &&
                                                                              index ==
                                                                                  customerAppointmentController
                                                                                      .deleteIndex.value)
                                                                          ? 59.w
                                                                          : 72.w,
                                                                      //52.w,
                                                                      height: 9.h,
                                                                      alignment: Alignment.centerLeft,

                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(16.0),
                                                                        child: Text(
                                                                          notesModel.note,
                                                                        ),
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(
                                                                        image: AssetImage(notesBackground),
                                                                        fit: BoxFit.fill,
                                                                      )),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: (customerAppointmentController
                                                                                .enableDelete.value &&
                                                                            index ==
                                                                                customerAppointmentController
                                                                                    .deleteIndex.value)
                                                                        ? 2.w
                                                                        : 0.w, //2.w,
                                                                  ),
                                                                  (customerAppointmentController.enableDelete.isTrue &&
                                                                          index ==
                                                                              customerAppointmentController
                                                                                  .deleteIndex.value)
                                                                      ? InkWell(
                                                                          onTap: () {
                                                                            customerAppointmentController
                                                                                .enableDelete.value = false;
                                                                            var tempOutput = List<dynamic>.from(
                                                                                customerAppointmentController
                                                                                    .customerAppointment.value.notes!);

                                                                            tempOutput.removeAt(
                                                                                customerAppointmentController
                                                                                    .deleteIndex.value);
                                                                            customerAppointmentController
                                                                                .customerAppointment
                                                                                .value
                                                                                .notes = List<dynamic>.from(tempOutput);
                                                                            customerAppointmentController
                                                                                .customerAppointment
                                                                                .refresh();

                                                                            if (customerAppointmentController
                                                                                .isEditMode.isTrue) {
                                                                              updateNotes();
                                                                            }
                                                                          },
                                                                          child: customIcon(
                                                                              icon: deleteNotesIcon, size: 7))
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        }),
                                                  );
                                                }

                                                return Text(
                                                  emptyNotes,
                                                  style: TextStyles.noNotesHeader,
                                                );
                                              }),
                                              Align(
                                                  alignment: Alignment.bottomRight,
                                                  widthFactor: 1.25.w,
                                                  heightFactor: 0.65.h,
                                                  child: InkWell(
                                                      onTap: () {
                                                        singleInputDialog(
                                                          context,
                                                          enterNotesHeader,
                                                          DialogTextField(
                                                            label: enterNotesHint,
                                                            // value: "some value",
                                                            // valueAutoSelected: true,
                                                            obscureText: false,
                                                            textInputType: TextInputType.multiline,
                                                            minLines: 1,
                                                            maxLines: 2,
                                                            validator: (value) {
                                                              return null;
                                                            },
                                                            onEditingComplete: (value) {
                                                              //  setState(() {
                                                              saveNotes(value);
                                                              // });
                                                            },
                                                          ),
                                                          positiveButtonText: notesSaveBtn,
                                                          positiveButtonAction: (value) {
                                                            //setState(() {
                                                            saveNotes(value);
                                                            //});
                                                          },
                                                          negativeButtonText: notesCancelBtn,
                                                          negativeButtonAction: () {},
                                                          hideNeutralButton: true,
                                                          closeOnBackPress: true,
                                                        );
                                                      },
                                                      child: customIcon(icon: addNotesIcon, size: 8))),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 8.w, top: 1.h, bottom: 1.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: ListView.builder(
                                                  itemBuilder: (_, index) {
                                                    AppointmentLeftItemModel appointmentLeftItemModel =
                                                        AppointmentItems.leftSideItems[index];
                                                    var hasValue = false.obs;
                                                    var title = "".obs;
                                                    String paymentMode = "";
                                                    bool hasPayment = false;
                                                    switch (appointmentLeftItemModel.value) {
                                                      case AppointmentLeftItemValue.Date:
                                                        {
                                                          if (customerAppointmentController
                                                              .selectedDate.value.isNotEmpty) {
                                                            title.value =
                                                                customerAppointmentController.selectedDate.value;
                                                            hasValue.value = true;
                                                          } else {
                                                            if (customerAppointmentController.isEditMode.isTrue) {
                                                              customerAppointmentController.selectedDate.value =
                                                                  DateFormat("d MMMM yyyy").format(
                                                                      DateTime.fromMillisecondsSinceEpoch(
                                                                          customerAppointmentController
                                                                              .customerAppointment.value.timestamp!));
                                                              title.value =
                                                                  customerAppointmentController.selectedDate.value;
                                                              hasValue.value = true;
                                                            }
                                                          }
                                                        }
                                                        break;

                                                      case AppointmentLeftItemValue.Time:
                                                        {
                                                          if (customerAppointmentController
                                                              .selectedTime.value.isNotEmpty) {
                                                            title.value =
                                                                customerAppointmentController.selectedTime.value;
                                                            hasValue.value = true;
                                                          } else {
                                                            if (customerAppointmentController.isEditMode.isTrue) {
                                                              customerAppointmentController.selectedTime.value =
                                                                  DateFormat.Hm().format(
                                                                      DateTime.fromMillisecondsSinceEpoch(
                                                                          customerAppointmentController
                                                                              .customerAppointment.value.timestamp!));
                                                              title.value =
                                                                  customerAppointmentController.selectedTime.value;
                                                              hasValue.value = true;
                                                            }
                                                          }
                                                        }
                                                        break;
                                                      case AppointmentLeftItemValue.Worker:
                                                        {
                                                          if (customerAppointmentController.worker.value.isNotEmpty) {
                                                            title.value = customerAppointmentController.worker.value;
                                                            hasValue.value = true;
                                                          } else {
                                                            if (customerAppointmentController
                                                                    .customerAppointment.value.employee !=
                                                                null) {
                                                              title.value = customerAppointmentController
                                                                  .customerAppointment.value.employee!;
                                                              hasValue.value = true;
                                                            }
                                                          }
                                                        }
                                                        break;
                                                      case AppointmentLeftItemValue.Location:
                                                        {
                                                          if (customerAppointmentController.location.value.isNotEmpty) {
                                                            title.value = customerAppointmentController.location.value;
                                                            hasValue.value = true;
                                                          } else {
                                                            if (customerAppointmentController
                                                                    .customerAppointment.value.location !=
                                                                null) {
                                                              title.value = customerAppointmentController
                                                                  .customerAppointment.value.location!;
                                                              hasValue.value = true;
                                                            }
                                                          }
                                                        }
                                                        break;
                                                      case AppointmentLeftItemValue.Payment:
                                                        {
                                                          if (customerAppointmentController.payment.value.isEmpty) {
                                                            title.value =
                                                                "${currencyFormat.format(customerAppointmentController.totalCostOfServices.value)}";
                                                          }
                                                          hasValue.value = true;
                                                          paymentMode = paymentModeHeader;

                                                          if (customerAppointmentController
                                                                      .customerAppointment.value.isPaymentDone !=
                                                                  null &&
                                                              customerAppointmentController
                                                                  .customerAppointment.value.isPaymentDone!) {
                                                            paymentMode = customerAppointmentController
                                                                .customerAppointment.value.paymentMode!;
                                                            title.value =
                                                                "${currencyFormat.format(customerAppointmentController.customerAppointment.value.totalCost!)}";
                                                            hasValue.value = true;
                                                            hasPayment = true;
                                                          }
                                                        }
                                                        break;

                                                      default:
                                                    }

                                                    return Obx(() {
                                                      return AppointmentListView(
                                                          hasPayment: hasPayment,
                                                          cartText: paymentMode,
                                                          isCart: (appointmentLeftItemModel.value ==
                                                              AppointmentLeftItemValue.Payment),
                                                          title: (title.value.isNotEmpty)
                                                              ? title.value
                                                              : appointmentLeftItemModel.title!,
                                                          icon: appointmentLeftItemModel.icon!,
                                                          hasValue: hasValue.value,
                                                          tapped: () {
                                                            if (customerAppointmentController.isEditMode.isFalse) {
                                                              if (appointmentLeftItemModel.value ==
                                                                      AppointmentLeftItemValue.Date ||
                                                                  appointmentLeftItemModel.value ==
                                                                      AppointmentLeftItemValue.Time) {
                                                                customerAppointmentController
                                                                    .showDateTimeSelectionWidget.value = true;
                                                              }

                                                              if (appointmentLeftItemModel.value ==
                                                                      AppointmentLeftItemValue.Worker ||
                                                                  appointmentLeftItemModel.value ==
                                                                      AppointmentLeftItemValue.Location) {
                                                                customerAppointmentController
                                                                    .showWorkerLocationFormWidget.value = true;
                                                              }
                                                            }
                                                          },
                                                          index: index);
                                                    });
                                                  },
                                                  itemCount: AppointmentItems.leftSideItems.length,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemBuilder: (_, index) {
                                                    AppointmentRightItemModel appointmentRightItemModel =
                                                        AppointmentItems.rightSideItems[index];
                                                    bool hasValue = true;
                                                    int count = 0;

                                                    if (appointmentRightItemModel.sId == servicesHeader) {
                                                      int addedServiceCount = 0;
                                                      if (customerAppointmentController
                                                              .customerAppointment.value.services !=
                                                          null) {
                                                        for (var services in customerAppointmentController
                                                            .customerAppointment.value.services!) {
                                                          SelectedServiceProductModel selectedService =
                                                              SelectedServiceProductModel.fromMap(
                                                                  Map<String, dynamic>.from(services));
                                                          addedServiceCount += selectedService.count;
                                                        }
                                                      }
                                                      count = addedServiceCount;
                                                    }

                                                    if (appointmentRightItemModel.sId == productsHeader) {
                                                      if (customerAppointmentController
                                                              .customerAppointment.value.products !=
                                                          null) {
                                                        customerAppointmentController.addedProductCount.value =
                                                            0; //customerAppointmentController.customerAppointment.value.products!.length;
                                                        for (var products in customerAppointmentController
                                                            .customerAppointment.value.products!) {
                                                          SelectedServiceProductModel selectedProduct =
                                                              SelectedServiceProductModel.fromMap(
                                                                  Map<String, dynamic>.from(products));
                                                          customerAppointmentController.addedProductCount.value +=
                                                              selectedProduct.count;
                                                        }
                                                      }
                                                      count = customerAppointmentController.addedProductCount.value;
                                                    }

                                                    if (appointmentRightItemModel.sId == notesHeader) {
                                                      if (customerAppointmentController
                                                              .customerAppointment.value.notes !=
                                                          null) {
                                                        customerAppointmentController.addedNotesCount.value =
                                                            customerAppointmentController
                                                                .customerAppointment.value.notes!.length;
                                                      }
                                                      count = customerAppointmentController.addedNotesCount.value;
                                                    }

                                                    if (appointmentRightItemModel.sId == agreementsHeader) {
                                                      if (customerAppointmentController
                                                              .customerAppointment.value.agreements !=
                                                          null) {
                                                        customerAppointmentController.addedAgreementCount.value =
                                                            customerAppointmentController
                                                                .customerAppointment.value.agreements!.length;
                                                      }
                                                      count = customerAppointmentController.addedAgreementCount.value;
                                                    }

                                                    return AppointmentListView(
                                                        isLeftItem: false,
                                                        title: count.toString(),
                                                        icon: appointmentRightItemModel.icon!,
                                                        hasValue: hasValue,
                                                        tapped: () {
                                                          //if (!isEditMode) {
                                                          if (appointmentRightItemModel.sId == notesHeader) {
                                                            customerAppointmentController.editNotes.value = true;
                                                          }
                                                          // }
                                                        },
                                                        index: index);
                                                  },
                                                  itemCount: AppointmentItems.rightSideItems.length,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    if (customerAppointmentController.isEditMode.isFalse)
                      Obx(() {
                        if (customerAppointmentController.addServiceActive.isTrue) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.0.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(appointment_background),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          customerAppointmentController.flagMenuActive.value =
                                              !customerAppointmentController.flagMenuActive.value;
                                          customerAppointmentController.dropdownActive.value = false;
                                        },
                                        child: Container(
                                          decoration: (customerAppointmentController.flagMenuActive.value)
                                              ? BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(dropdown_selected),
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : null,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              (customerAppointmentController.selectedProductService.value.type == 0)
                                                  ? customIcon(icon: add_service_flag)
                                                  : customIcon(icon: product_appointment),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              customIcon(icon: add_service_drop_down, size: 2.5),
                                              //customIcon(icon: add_service_vertical_separator, size: 7.5),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              VerticalDivider(
                                                width: 1.0,
                                                thickness: 1.0,
                                                endIndent: 4.h,
                                                indent: 4.h,
                                                color: AppColors.borderColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          customerAppointmentController.flagMenuActive.value = false;
                                          customerAppointmentController.dropdownActive.value =
                                              !customerAppointmentController.dropdownActive.value;
                                        },
                                        child: Container(
                                          decoration: (customerAppointmentController.dropdownActive.isTrue)
                                              ? BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(dropdown_selected),
                                                    fit: BoxFit.fill,
                                                  ),
                                                )
                                              : null,
                                          child: Container(
                                            //  height: 12.h,
                                            width: 40.w,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Container(
                                                  width: 22.w,
                                                  child: Text(
                                                    customerAppointmentController.selectedProductService.value.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyles.addServiceDropdownSelected,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                customIcon(icon: add_service_drop_down, size: 2.5),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                VerticalDivider(
                                                  width: 1.0,
                                                  thickness: 1.0,
                                                  endIndent: 4.h,
                                                  indent: 4.h,
                                                  color: AppColors.borderColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                singleInputDialog(
                                                  context,
                                                  enterQuantity,
                                                  DialogTextField(
                                                    label: enterQuantityHint,
                                                    obscureText: false,
                                                    textInputType: TextInputType.number,
                                                    value: customerAppointmentController
                                                        .selectedProductService.value.count
                                                        .toString(),
                                                    validator: (value) {
                                                      return null;
                                                    },
                                                    onEditingComplete: (value) {
                                                      customerAppointmentController.selectedProductService.value.count =
                                                          int.parse(value);
                                                    },
                                                  ),
                                                  positiveButtonText: notesSaveBtn,
                                                  positiveButtonAction: (value) {
                                                    customerAppointmentController.selectedProductService.value.count =
                                                        int.parse(value);
                                                  },
                                                  negativeButtonText: notesCancelBtn,
                                                  negativeButtonAction: () {},
                                                  hideNeutralButton: true,
                                                  closeOnBackPress: true,
                                                );
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.black, width: 0.0),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    customerAppointmentController.selectedProductService.value.count
                                                        .toString(),
                                                    style: TextStyles.addServiceDropdown,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                customerAppointmentController.addServiceActive.value = false;
                                                customerAppointmentController.hasAddedProduct.value = true;

                                                customerAppointmentController.addProductService(true,
                                                    customerAppointmentController.selectedProductService.value, 0);
                                                customerAppointmentController.updateTotalCost();
                                                setServiceMenu();
                                              },
                                              child: customIcon(icon: add_service_save),
                                            ),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                customerAppointmentController.addServiceActive.value = false;
                                                setServiceMenu();
                                              },
                                              child: customIcon(icon: add_service_return),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (customerAppointmentController.dropdownActive.isTrue)
                                Padding(
                                  padding: EdgeInsets.only(left: 23.w),
                                  child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      height: 23.h,
                                      width: 41.5.w,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(unselected_item),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              thickness: 0.5,
                                              height: 0.5,
                                              color: Colors.grey,
                                            );
                                          },
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (_, index) {
                                            return InkWell(
                                              onTap: () {
                                                Item itemPrevious = Item(
                                                    name:
                                                        customerAppointmentController.selectedProductService.value.name,
                                                    cost: customerAppointmentController
                                                        .selectedProductService.value.cost);
                                                Item itemCurrent =
                                                    customerAppointmentController.serviceItemsDropdownMenu[index];

                                                SelectedServiceProductModel model =
                                                    customerAppointmentController.selectedProductService.value;

                                                SelectedServiceProductModel newModel = SelectedServiceProductModel(
                                                    type: model.type,
                                                    count: model.count,
                                                    name: itemCurrent.name!,
                                                    cost: itemCurrent.cost * model.count);

                                                customerAppointmentController.selectedProductService.value = newModel;

                                                customerAppointmentController.serviceItemsDropdownMenu[index] =
                                                    itemPrevious;
                                                customerAppointmentController.serviceItemsDropdownMenu.refresh();

                                                customerAppointmentController.dropdownActive.value = false;
                                                //setState(() {});
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: (index == 0) ? 0.0 : 20.0, bottom: 15.0),
                                                  child: Text(
                                                    customerAppointmentController.serviceItemsDropdownMenu[index].name!,
                                                    style: TextStyles.addServiceDropdown,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          shrinkWrap: true,
                                          itemCount: customerAppointmentController.serviceItemsDropdownMenu.length,
                                        ),
                                      )),
                                ),
                              if (customerAppointmentController.flagMenuActive.isTrue)
                                InkWell(
                                  onTap: () {
                                    if (customerAppointmentController.selectedProductService.value.type == 0) {
                                      customerAppointmentController.selectedProductService.value.type = 1;
                                    } else {
                                      customerAppointmentController.selectedProductService.value.type = 0;
                                    }

                                    customerAppointmentController.flagMenuActive.value = false;
                                  },
                                  child: Container(
                                    height: 10.h,
                                    width: 25.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(dropdown_unselected),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Center(
                                      child: (customerAppointmentController.selectedProductService.value.type == 0)
                                          ? customIcon(icon: product_appointment)
                                          : customIcon(icon: add_service_flag),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        } else {
                          return Container(
                              height: (customerAppointmentController.hasAddedProduct.isTrue) ? 25.h : 12.54.h,
                              child: AppointmentServiceItems(
                                update: () {
                                  setState(() {});
                                },
                              ));
                        }
                      }),

                    Obx(() {
                      if (customerAppointmentController.isEditMode.isTrue) {
                        return Expanded(
                          child: Stack(
                            children: [
                              AppointmentServiceItems(),
                              Obx(() {
                                if (customerAppointmentController.enableDeleteServiceView.isTrue) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 12.5.h,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                            image: AssetImage(service_item_background_delete_view),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              customerAppointmentController.enableDeleteServiceView.value = false;
                                              customerAppointmentController.forceEditingServiceEnabled.value = false;
                                              customerAppointmentController.forceEditingServiceOldIndex.value =
                                                  99999999999;
                                            },
                                            child: Container(
                                              height: 12.5.h,
                                              width: 50.w,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print("service_item_background_delete");
                                              customerAppointmentController.enableDeleteServiceView.value = false;
                                              customerAppointmentController.forceEditingServiceEnabled.value = false;
                                              customerAppointmentController.forceEditingServiceOldIndex.value =
                                                  99999999999;
                                              double cost = 0.0;
                                              int deleteIndex =
                                                  customerAppointmentController.forceEditingServiceCurrentIndex.value;
                                              List<dynamic> services = List<dynamic>.from(
                                                  customerAppointmentController.customerAppointment.value.services!);

                                              if (deleteIndex < services.length) {
                                                AppointmentItemsModel itemsModel = AppointmentItemsModel.fromMap(
                                                    Map<String, dynamic>.from(services[deleteIndex]));
                                                cost = itemsModel.cost * itemsModel.quantity;
                                                services.removeAt(deleteIndex);

                                                customerAppointmentController.customerAppointment.value.services =
                                                    List<dynamic>.from(services);
                                              } else {
                                                deleteIndex -= services.length;

                                                List<dynamic> products = List<dynamic>.from(
                                                    customerAppointmentController.customerAppointment.value.products!);

                                                AppointmentItemsModel itemsModel = AppointmentItemsModel.fromMap(
                                                    Map<String, dynamic>.from(products[deleteIndex]));
                                                cost = itemsModel.cost * itemsModel.quantity;
                                                products.removeAt(deleteIndex);

                                                customerAppointmentController.customerAppointment.value.products =
                                                    List<dynamic>.from(products);
                                              }
                                              customerAppointmentController.totalCostOfServices.value -= cost;
                                              customerAppointmentController.customerAppointment.value.totalCost =
                                                  customerAppointmentController.customerAppointment.value.totalCost! -
                                                      cost;

                                              if (customerAppointmentController.customerAppointment.value.totalCost ==
                                                  0) {
                                                customerAppointmentController.customerAppointment.value.isPaymentDone =
                                                    false;
                                                customerAppointmentController.customerAppointment.value.paymentMode =
                                                    paymentModeHeader;
                                              }

                                              customerAppointmentController.customerAppointment.refresh();
                                              setState(() {});
                                              deleteServiceItem();
                                              Flushbar(
                                                isDismissible: false,
                                                margin: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                                                padding: EdgeInsets.zero,
                                                duration: Duration(seconds: undoTimerDurationInSec),
                                                borderRadius: BorderRadius.circular(12),
                                                backgroundColor: Colors.transparent,
                                                flushbarPosition: FlushbarPosition.BOTTOM,
                                                messageText: InkWell(
                                                  onTap: () {
                                                    customerAppointmentController.serviceItemDeleteUndo.value = true;
                                                    timer.cancel();
                                                    int deleteIndex = customerAppointmentController
                                                        .forceEditingServiceCurrentIndex.value;
                                                    List<dynamic> services = List<dynamic>.from(
                                                        customerAppointmentController
                                                            .customerAppointment.value.services!);

                                                    if (deleteIndex < services.length) {
                                                      services.insert(
                                                          deleteIndex, customerAppointmentController.itemBeingDeleted);

                                                      customerAppointmentController.customerAppointment.value.services =
                                                          List<dynamic>.from(services);
                                                    } else {
                                                      deleteIndex -= services.length;

                                                      List<dynamic> products = List<dynamic>.from(
                                                          customerAppointmentController
                                                              .customerAppointment.value.products!);

                                                      products.insert(
                                                          deleteIndex, customerAppointmentController.itemBeingDeleted);

                                                      customerAppointmentController.customerAppointment.value.products =
                                                          List<dynamic>.from(products);
                                                    }

                                                    customerAppointmentController.totalCostOfServices.value += cost;
                                                    customerAppointmentController.customerAppointment.value.totalCost =
                                                        customerAppointmentController
                                                                .customerAppointment.value.totalCost! +
                                                            cost;

                                                    customerAppointmentController.customerAppointment.refresh();
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height: 10.h,
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Center(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          image: DecorationImage(
                                                            image: AssetImage(service_item_background_undo),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ).show(context);
                                            },
                                            child: Container(
                                              height: 12.5.h,
                                              width: 50.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              }),
                              Obx(() {
                                if (customerAppointmentController.editServiceActive.isTrue) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 12.0.h,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(appointment_background),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  customerAppointmentController.flagMenuActive.value =
                                                      !customerAppointmentController.flagMenuActive.value;
                                                  customerAppointmentController.dropdownActive.value = false;
                                                },
                                                child: Container(
                                                  decoration: (customerAppointmentController.flagMenuActive.value)
                                                      ? BoxDecoration(
                                                          image: DecorationImage(
                                                            image: AssetImage(dropdown_selected),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : null,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      (customerAppointmentController
                                                                  .selectedProductService.value.type ==
                                                              0)
                                                          ? customIcon(icon: add_service_flag)
                                                          : customIcon(icon: product_appointment),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      customIcon(icon: add_service_drop_down, size: 2.5),
                                                      //customIcon(icon: add_service_vertical_separator, size: 7.5),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      VerticalDivider(
                                                        width: 1.0,
                                                        thickness: 1.0,
                                                        endIndent: 4.h,
                                                        indent: 4.h,
                                                        color: AppColors.borderColor,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  customerAppointmentController.flagMenuActive.value = false;
                                                  customerAppointmentController.dropdownActive.value =
                                                      !customerAppointmentController.dropdownActive.value;
                                                },
                                                child: Container(
                                                  decoration: (customerAppointmentController.dropdownActive.isTrue)
                                                      ? BoxDecoration(
                                                          image: DecorationImage(
                                                            image: AssetImage(dropdown_selected),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      : null,
                                                  child: Container(
                                                    //  height: 12.h,
                                                    width: 40.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        Container(
                                                          width: 22.w,
                                                          child: Text(
                                                            customerAppointmentController
                                                                .selectedProductService.value.name,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyles.addServiceDropdownSelected,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        customIcon(icon: add_service_drop_down, size: 2.5),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        VerticalDivider(
                                                          width: 1.0,
                                                          thickness: 1.0,
                                                          endIndent: 4.h,
                                                          indent: 4.h,
                                                          color: AppColors.borderColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        singleInputDialog(
                                                          context,
                                                          enterQuantity,
                                                          DialogTextField(
                                                            label: enterQuantityHint,
                                                            obscureText: false,
                                                            textInputType: TextInputType.number,
                                                            value: customerAppointmentController
                                                                .selectedProductService.value.count
                                                                .toString(),
                                                            validator: (value) {
                                                              return null;
                                                            },
                                                            onEditingComplete: (value) {
                                                              customerAppointmentController.selectedProductService.value
                                                                  .count = int.parse(value);
                                                            },
                                                          ),
                                                          positiveButtonText: notesSaveBtn,
                                                          positiveButtonAction: (value) {
                                                            customerAppointmentController
                                                                .selectedProductService.value.count = int.parse(value);
                                                            setState(() {});
                                                          },
                                                          negativeButtonText: notesCancelBtn,
                                                          negativeButtonAction: () {},
                                                          hideNeutralButton: true,
                                                          closeOnBackPress: true,
                                                        );
                                                      },
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: new BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(color: Colors.black, width: 0.0),
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            customerAppointmentController
                                                                .selectedProductService.value.count
                                                                .toString(),
                                                            style: TextStyles.addServiceDropdown,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        //background_service_edit
                                                        customerAppointmentController.addServiceActive.value = false;
                                                        customerAppointmentController.hasAddedProduct.value = true;
                                                        customerAppointmentController.editServiceActive.value = false;

                                                        SelectedServiceProductModel selectedServiceProduct =
                                                            customerAppointmentController.selectedProductService.value;

                                                        double cost =
                                                            selectedServiceProduct.cost * selectedServiceProduct.count;

                                                        int editingItemIndex =
                                                            customerAppointmentController.editingItemIndex.value;
                                                        List<dynamic> services = List<dynamic>.from(
                                                            customerAppointmentController
                                                                .customerAppointment.value.services!);

                                                        print(selectedServiceProduct.type);

                                                        if (editingItemIndex < services.length &&
                                                            selectedServiceProduct.type == 0) {
                                                          services[editingItemIndex] = selectedServiceProduct.toMap();

                                                          customerAppointmentController.customerAppointment.value
                                                              .services = List<dynamic>.from(services);
                                                        } else {
                                                          List<dynamic> products = List<dynamic>.from(
                                                              customerAppointmentController
                                                                  .customerAppointment.value.products!);
                                                          print(editingItemIndex);
                                                          print("products.length ${products.length}");
                                                          if (editingItemIndex >= products.length) {
                                                            products = <dynamic>[selectedServiceProduct.toMap()];

                                                            if (editingItemIndex < services.length) {
                                                              services.removeAt(editingItemIndex);
                                                              customerAppointmentController.customerAppointment.value
                                                                  .services = List<dynamic>.from(services);
                                                            }
                                                          } else {
                                                            editingItemIndex -= services.length;
                                                            products[editingItemIndex] = selectedServiceProduct.toMap();
                                                          }

                                                          customerAppointmentController.customerAppointment.value
                                                              .products = List<dynamic>.from(products);
                                                        }

                                                        SelectedServiceProductModel previousServiceProduct =
                                                            customerAppointmentController
                                                                .previousSelectedProductService.value;

                                                        customerAppointmentController.totalCostOfServices.value +=
                                                            (cost -
                                                                (previousServiceProduct.cost *
                                                                    previousServiceProduct.count));

                                                        customerAppointmentController
                                                                .customerAppointment.value.totalCost =
                                                            customerAppointmentController.totalCostOfServices.value;

                                                        customerAppointmentController.customerAppointment.refresh();
                                                        print(selectedServiceProduct.toMap());
                                                        updateProductServices();
                                                        setServiceMenu();
                                                        setState(() {});
                                                      },
                                                      child: customIcon(icon: add_service_save),
                                                    ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        customerAppointmentController.editServiceActive.value = false;
                                                        customerAppointmentController.addServiceActive.value = false;
                                                        setServiceMenu();
                                                      },
                                                      child: customIcon(icon: add_service_return),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (customerAppointmentController.dropdownActive.isTrue)
                                        Padding(
                                          padding: EdgeInsets.only(left: 23.w),
                                          child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              height: 23.h,
                                              width: 41.5.w,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(unselected_item),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ListView.separated(
                                                  separatorBuilder: (context, index) {
                                                    return Divider(
                                                      thickness: 0.5,
                                                      height: 0.5,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                                  physics: ClampingScrollPhysics(),
                                                  itemBuilder: (_, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Item itemPrevious = Item(
                                                            name: customerAppointmentController
                                                                .selectedProductService.value.name,
                                                            cost: customerAppointmentController
                                                                .selectedProductService.value.cost);
                                                        Item itemCurrent = customerAppointmentController
                                                            .serviceItemsDropdownMenu[index];

                                                        SelectedServiceProductModel model =
                                                            customerAppointmentController.selectedProductService.value;

                                                        SelectedServiceProductModel newModel =
                                                            SelectedServiceProductModel(
                                                                type: model.type,
                                                                count: model.count,
                                                                name: itemCurrent.name!,
                                                                cost: itemCurrent.cost * model.count);

                                                        customerAppointmentController.selectedProductService.value =
                                                            newModel;

                                                        customerAppointmentController.serviceItemsDropdownMenu[index] =
                                                            itemPrevious;
                                                        customerAppointmentController.serviceItemsDropdownMenu
                                                            .refresh();

                                                        customerAppointmentController.dropdownActive.value = false;
                                                        //setState(() {});
                                                      },
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              top: (index == 0) ? 0.0 : 20.0, bottom: 15.0),
                                                          child: Text(
                                                            customerAppointmentController
                                                                .serviceItemsDropdownMenu[index].name!,
                                                            style: TextStyles.addServiceDropdown,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      customerAppointmentController.serviceItemsDropdownMenu.length,
                                                ),
                                              )),
                                        ),
                                      if (customerAppointmentController.flagMenuActive.isTrue)
                                        InkWell(
                                          onTap: () {
                                            if (customerAppointmentController.selectedProductService.value.type == 0) {
                                              customerAppointmentController.selectedProductService.value.type = 1;
                                            } else {
                                              customerAppointmentController.selectedProductService.value.type = 0;
                                            }

                                            customerAppointmentController.flagMenuActive.value = false;
                                          },
                                          child: Container(
                                            height: 10.h,
                                            width: 25.w,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(dropdown_unselected),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            child: Center(
                                              child:
                                                  (customerAppointmentController.selectedProductService.value.type == 0)
                                                      ? customIcon(icon: product_appointment)
                                                      : customIcon(icon: add_service_flag),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                            ],
                          ),
                        );
                      }
                      return Container();
                    }),
                    //if (isEditMode) allAddedServicesItems(),
                  ],
                ),
                Obx(() => (customerAppointmentController.showDateTimeSelectionWidget.value ||
                        customerAppointmentController.showWorkerLocationFormWidget.value ||
                        customerAppointmentController.addServiceActive.value)
                    ? Container()
                    : (customerAppointmentController.isEditMode.isFalse &&
                            customerAppointmentController.editNotes.isFalse)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: customTextButton(
                                  cornerRadius: 15,
                                  height: 2.h,
                                  width: 8.w,
                                  btnText: saveVisitBtn,
                                  onTap: () {
                                    var model = customerController.selectedCustomer.value;
                                    if (customerAppointmentController.isEditMode.isFalse) {
                                      String name = model.firstName + " " + model.lastName;
                                      CustomerAppointment customerAppointment = CustomerAppointment(
                                          createdByUserId: FUser.currentId()!,
                                          createdByUsername: FUser.fullName(),
                                          timestamp:
                                              customerAppointmentController.selectedDateTime.millisecondsSinceEpoch,
                                          employee: customerAppointmentController.worker.value,
                                          employeeId: customerAppointmentController.workerId.value,
                                          location: customerAppointmentController.location.value,
                                          createdForUserId: model.objectId!,
                                          createdForUsername: name);

                                      double addedServiceCost = 0.0;
                                      if (customerAppointmentController.customerAppointment.value.services != null) {
                                        customerAppointment.services = List<dynamic>.from(
                                            customerAppointmentController.customerAppointment.value.services!.toList());

                                        for (var services
                                            in customerAppointmentController.customerAppointment.value.services!) {
                                          SelectedServiceProductModel selectedService =
                                              SelectedServiceProductModel.fromMap(Map<String, dynamic>.from(services));
                                          print(selectedService.toMap());
                                          addedServiceCost += selectedService.count * selectedService.cost;
                                        }
                                      }

                                      if (customerAppointmentController.customerAppointment.value.products != null) {
                                        customerAppointment.products = List<dynamic>.from(
                                            customerAppointmentController.customerAppointment.value.products!.toList());
                                        for (var products
                                            in customerAppointmentController.customerAppointment.value.products!) {
                                          SelectedServiceProductModel selectedProduct =
                                              SelectedServiceProductModel.fromMap(Map<String, dynamic>.from(products));
                                          print(selectedProduct.toMap());
                                          addedServiceCost += selectedProduct.count * selectedProduct.cost;
                                        }
                                      }

                                      customerAppointment.totalCost = addedServiceCost;
                                      if (addedServiceCost > 0) {
                                        customerAppointment.isPaymentDone = true;
                                        customerAppointment.paymentMode = paymentMode;
                                      }

                                      if (customerAppointmentController.customerAppointment.value.notes != null) {
                                        customerAppointment.notes = List<dynamic>.from(
                                            customerAppointmentController.customerAppointment.value.notes!);
                                      }

                                      model.visits.add(customerAppointment.toMap());
                                    } else {
                                      model.visits[customerAppointmentController.editingIndex.value] =
                                          customerAppointmentController.customerAppointment.value.toMap();
                                    }

                                    CustomerBloc _customerBloc = BlocProvider.of<CustomerBloc>(context);
                                    _customerBloc.add(AddCustomerAppointmentEvent(customerModel: model));
                                  }),
                            ),
                          )
                        : Container()),
                Obx(() => (customerAppointmentController.showDateTimeSelectionWidget.value)
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DateTimeSelection(
                            oldSelectedDateTime: customerAppointmentController.selectedDateTime,
                            doneButtonPressed: (DateTime? dateTime) {
                              customerAppointmentController.showDateTimeSelectionWidget.value = false;
                              if (dateTime != null) {
                                customerAppointmentController.updateDateTime(dateTime);
                                customerAppointmentController.selectedDate.value =
                                    DateFormat("d MMMM yyyy").format(dateTime);
                                customerAppointmentController.selectedTime.value = DateFormat.Hm().format(dateTime);
                                setState(() {});
                              }
                            },
                          ),
                        ),
                      )
                    : Container()),
                Obx(() => (customerAppointmentController.showWorkerLocationFormWidget.value)
                    ? Center(
                        child: WorkerLocation(
                          doneButtonPressed:
                              (String? selectedWorker, String? selectedWorkerId, String? selectedLocation) {
                            customerAppointmentController.showWorkerLocationFormWidget.value = false;
                            customerAppointmentController.workerId.value = selectedWorkerId!;
                            if (selectedWorker != null) {
                              customerAppointmentController.worker.value = selectedWorker;
                            }

                            if (selectedLocation != null) {
                              customerAppointmentController.location.value = selectedLocation;
                            }

                            setState(() {});
                          },
                        ),
                      )
                    : Container()),
              ],
            ),
          )),
    );
  }
}
