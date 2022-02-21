import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Models/selected_service_product_model.dart';
import 'package:hhcom/Screens/Appointment/controllers/customer_appointment_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AppointmentServiceItems extends StatelessWidget {
  final Function? update;
  const AppointmentServiceItems({Key? key, this.update}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerAppointmentController = Get.find<CustomerAppointmentController>();
    final currencyFormat = NumberFormat.currency(locale: 'eu', symbol: currencyHeader);

    if (customerAppointmentController.isEditMode.isFalse && customerAppointmentController.editNotes.isTrue) {
      return Container();
    }
    List<dynamic> items = [].obs;
    if (customerAppointmentController.customerAppointment.value.services != null) {
      items.addAll(customerAppointmentController.customerAppointment.value.services!);
    }
    if (customerAppointmentController.customerAppointment.value.products != null) {
      items.addAll(customerAppointmentController.customerAppointment.value.products!);
    }
    int len = items.length;

    if (customerAppointmentController.isEditMode.isFalse) {
      len += 1;
    }

    return Obx(() {
      if (items.isNotEmpty) {
        return ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: len,
            itemBuilder: (_, index) {
              if (customerAppointmentController.isEditMode.isFalse && len == index + 1) {
                return InkWell(
                  onTap: () {
                    customerAppointmentController.addServiceActive.value = true;
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customIcon(icon: cart_appointment),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          addServiceBtnHeader,
                          style: TextStyles.customerAddService,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (index >= items.length) {
                return Container();
              }

              AppointmentItemsModel itemsModel = AppointmentItemsModel.fromMap(Map<String, dynamic>.from(items[index]));

              return AbsorbPointer(
                absorbing: customerAppointmentController.enableDeleteServiceView.value,
                child: InkWell(
                  onTap: () {
                    if (customerAppointmentController.enableDeleteServiceView.isFalse) {
                      customerAppointmentController.forceEditingServiceCurrentIndex.value = index;

                      if (customerAppointmentController.forceEditingServiceOldIndex.value !=
                          customerAppointmentController.forceEditingServiceCurrentIndex.value) {
                        customerAppointmentController.forceEditingServiceEnabled.value = true;
                        customerAppointmentController.forceEditingServiceOldIndex.value =
                            customerAppointmentController.forceEditingServiceCurrentIndex.value;
                      } else {
                        customerAppointmentController.forceEditingServiceEnabled.value =
                            !customerAppointmentController.forceEditingServiceEnabled.value;
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 8.w),
                    child: Container(
                      height: (customerAppointmentController.isEditMode.isTrue) ? 10.h : 12.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            if (customerAppointmentController.isEditMode.isFalse ||
                                (customerAppointmentController.forceEditingServiceEnabled.isTrue &&
                                    index == customerAppointmentController.forceEditingServiceCurrentIndex.value)) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (customerAppointmentController.isEditMode.isTrue) {
                                          if (customerAppointmentController.enableDeleteServiceView.isFalse) {
                                            customerAppointmentController.enableDeleteServiceView.value = true;
                                            customerAppointmentController.itemBeingEdited = items[index];
                                            customerAppointmentController.enableDeleteServiceView.value = false;
                                            customerAppointmentController.editServiceActive.value = true;
                                            customerAppointmentController.editingItemIndex.value = index;
                                            customerAppointmentController.selectedProductService =
                                                SelectedServiceProductModel(
                                                        type: itemsModel.type,
                                                        count: itemsModel.quantity,
                                                        name: itemsModel.name,
                                                        cost: itemsModel.cost)
                                                    .obs;

                                            customerAppointmentController.previousSelectedProductService =
                                                SelectedServiceProductModel(
                                                        type: itemsModel.type,
                                                        count: itemsModel.quantity,
                                                        name: itemsModel.name,
                                                        cost: itemsModel.cost)
                                                    .obs;
                                          }
                                        } else {
                                          if (itemsModel.type == AppointmentRightItemValue.Services.index) {
                                            customerAppointmentController.editingServiceIndex.value = index;
                                          } else {
                                            customerAppointmentController.editingProductIndex.value = 0;
                                            if (customerAppointmentController.customerAppointment.value.services !=
                                                null) {
                                              customerAppointmentController.editingProductIndex.value = index -
                                                  customerAppointmentController
                                                      .customerAppointment.value.services!.length;
                                            }
                                          }
                                          customerAppointmentController.editingItemIndex.value = index;
                                          customerAppointmentController.isEditingProductService.value = true;
                                          customerAppointmentController.selectedProductService =
                                              SelectedServiceProductModel.fromMap(
                                                      Map<String, dynamic>.from(items[index]))
                                                  .obs;
                                          customerAppointmentController.addServiceActive.value = true;
                                        }
                                      },
                                      child: customIcon(icon: addService, size: 2.5)),
                                  SizedBox(
                                    width: 2.h,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (customerAppointmentController.isEditMode.isTrue) {
                                          customerAppointmentController.editServiceActive.value = false;
                                          customerAppointmentController.enableDeleteServiceView.value = true;
                                          customerAppointmentController.itemBeingDeleted = items[index];
                                        } else {
                                          if (itemsModel.type == AppointmentRightItemValue.Services.index) {
                                            customerAppointmentController.customerAppointment.value.services!
                                                .remove(items[index]);
                                          } else {
                                            int idx = index -
                                                customerAppointmentController
                                                    .customerAppointment.value.services!.length;
                                            customerAppointmentController.customerAppointment.value.products!
                                                .remove(items[idx]);
                                          }

                                          customerAppointmentController.totalCostOfServices.value -=
                                              itemsModel.quantity * itemsModel.cost;
                                          customerAppointmentController.customerAppointment.value.totalCost =
                                              customerAppointmentController.totalCostOfServices.value;

                                          items.removeAt(index);

                                          if (customerAppointmentController.totalCostOfServices.value > 0) {
                                          } else {
                                            customerAppointmentController.hasAddedProduct.value = false;
                                          }
                                          customerAppointmentController.hasAddedProduct.value = items.isNotEmpty;
                                          if (update != null) {
                                            update!();
                                          }
                                        }
                                      },
                                      child: customIcon(icon: deleteService, size: 2.5)),
                                ],
                              );
                            }

                            return Container();
                          }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 1.w,
                              ),
                              customIcon(
                                  icon: (itemsModel.type == AppointmentRightItemValue.Services.index)
                                      ? add_service_flag
                                      : product_appointment,
                                  size: 3),
                              SizedBox(
                                width: 8.w,
                              ),
                              Text(
                                "${itemsModel.quantity}x",
                                style: TextStyles.addServiceName,
                              ),
                              SizedBox(
                                width: 3.w,
                              ),
                              Text(
                                itemsModel.name,
                                style: TextStyles.addServiceName,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${currencyFormat.format(itemsModel.quantity * itemsModel.cost.toDouble())}",
                                style: TextStyles.addServiceCost,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      } else {
        return (customerAppointmentController.isEditMode.isTrue)
            ? Container()
            : InkWell(
                onTap: () {
                  customerAppointmentController.addServiceActive.value = true;
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customIcon(icon: cart_appointment),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        addServiceBtnHeader,
                        style: TextStyles.customerAddService,
                      ),
                    ],
                  ),
                ),
              );
      }
    });
  }
}
