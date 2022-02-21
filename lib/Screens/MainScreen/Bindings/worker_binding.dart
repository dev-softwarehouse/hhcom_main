import 'package:get/get.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/worker_controller.dart';

class WorkerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkerController>(() => WorkerController());
  }
}
