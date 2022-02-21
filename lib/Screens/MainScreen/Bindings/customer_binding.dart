import 'package:get/get.dart';
import 'package:hhcom/Screens/Appointment/controllers/customer_appointment_controller.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/customer_controller.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerController>(() => CustomerController());
    Get.lazyPut<CustomerAppointmentController>(() => CustomerAppointmentController());
  }
}
