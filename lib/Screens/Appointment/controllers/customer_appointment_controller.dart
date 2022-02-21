import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hhcom/Models/appointment_item_model.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Models/selected_service_product_model.dart';
import 'package:hhcom/Models/service_item_model.dart';
import 'package:hhcom/Screens/Appointment/controllers/service_item_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';

class CustomerAppointmentController extends GetxController {
  var showDateTimeSelectionWidget = false.obs;
  var showWorkerLocationFormWidget = false.obs;
  var addServiceActive = false.obs;
  var editServiceActive = false.obs;
  var selectedDate = "".obs;
  var selectedTime = "".obs;
  var worker = "".obs;
  var workerId = "".obs;
  var location = "".obs;
  var payment = "".obs;
  var selectedDateTime;
  var selectedKey = "".obs;
  var hasAddedProduct = false.obs;
  var addedProductCount = 0.obs;
  var addedNotesCount = 0.obs;
  var addedAgreementCount = 0.obs;
  var flagMenuActive = false.obs;
  var dropdownActive = false.obs;
  var editNotes = false.obs;
  var enableDelete = false.obs;
  var deleteIndex = 0.obs;
  var oldDeleteSelection = 0.obs;
  var selectedServiceTypeDropdown = 0.obs;
  var totalCostOfServices = 0.0.obs;
  var isEditMode = false.obs;
  var isEditingProductService = false.obs;
  var editingProductIndex = 0.obs;
  var editingServiceIndex = 0.obs;
  var editingItemIndex = 0.obs;
  var editingIndex = 0.obs;
  var forceEditingServiceEnabled = false.obs;
  var forceEditingServiceCurrentIndex = 0.obs;
  var forceEditingServiceOldIndex = 99999999999.obs;
  var enableDeleteServiceView = false.obs;
  var serviceItemDeleteUndo = false.obs;
  var selectedProductService =
      SelectedServiceProductModel(type: 0, count: 1, name: serviceItem0, cost: double.parse(defaultCost)).obs;
  var previousSelectedProductService =
      SelectedServiceProductModel(type: 0, count: 1, name: serviceItem0, cost: double.parse(defaultCost)).obs;

  var customerAppointment = CustomerAppointment().obs;

  var serviceItemController = Get.find<ServiceItemController>();

  var selectedServiceItem = Item().obs;

  var serviceItems = [Item()].obs;
  var serviceItemsDropdownMenu = [Item()].obs;

  var appointmentLeftItemModel = AppointmentItems.leftSideItems.obs;

  var itemBeingDeleted;
  var itemBeingEdited;

  void saveNotes(String notes) {
    AppointmentNotesModel notesModel =
        AppointmentNotesModel(timestamp: DateTime.now().millisecondsSinceEpoch, note: notes);
    if (customerAppointment.value.notes != null) {
      customerAppointment.value.notes = customerAppointment.value.notes!.toList();
      customerAppointment.value.notes!.add(notesModel.toMap());
    } else {
      customerAppointment.value.notes = List<dynamic>.from([notesModel.toMap()]);
    }
    customerAppointment.refresh();
  }

  void updateDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    update();
  }

  void updateTotalCost() {
    double cost = 0;
    if (customerAppointment.value.services != null) {
      for (var services in customerAppointment.value.services!) {
        SelectedServiceProductModel selectedService =
            SelectedServiceProductModel.fromMap(Map<String, dynamic>.from(services));
        cost += (selectedService.count * selectedService.cost);
      }
    }

    if (customerAppointment.value.products != null) {
      for (var products in customerAppointment.value.products!) {
        SelectedServiceProductModel selectedProduct =
            SelectedServiceProductModel.fromMap(Map<String, dynamic>.from(products));
        cost += (selectedProduct.count * selectedProduct.cost);
      }
    }

    totalCostOfServices.value = cost;
  }

  void addProductService(bool isAdd, SelectedServiceProductModel productService, int index) {
    if (isAdd) {
      if (productService.type == AppointmentRightItemValue.Services.index) {
        if (customerAppointment.value.services != null) {
          if (isEditingProductService.isTrue) {
            customerAppointment.value.services![editingServiceIndex.value] = productService.toMap();
          } else {
            customerAppointment.value.services!.add(productService.toMap());
          }
        } else {
          customerAppointment.value.services = List<dynamic>.from([productService.toMap()]);
        }
      } else {
        if (customerAppointment.value.products != null) {
          if (isEditingProductService.isTrue) {
            customerAppointment.value.products![editingProductIndex.value] = productService.toMap();
          } else {
            customerAppointment.value.products!.add(productService.toMap());
          }
        } else {
          customerAppointment.value.products = List<dynamic>.from([productService.toMap()]);
        }
      }
    } else {
      if (productService.type == AppointmentRightItemValue.Services.index) {
        if (customerAppointment.value.services != null) {
          customerAppointment.value.services!.removeAt(index);
        }
      } else {
        if (customerAppointment.value.products != null) {
          customerAppointment.value.products!.removeAt(index);
        }
      }
    }

    isEditingProductService.value = false;
    /*
    selectedProductService =
        SelectedServiceProductModel(type: 0, count: 1, name: selectedService.value, cost: double.parse(defaultCost))
            .obs;
    serviceDropdownMenu = [serviceItem1, serviceItem2].obs;*/

    customerAppointment.refresh();
  }
}
