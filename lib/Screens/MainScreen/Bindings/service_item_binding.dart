import 'package:get/get.dart';
import 'package:hhcom/Screens/Appointment/controllers/service_item_controller.dart';

class ServiceItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceItemController>(() => ServiceItemController());
  }
}
