import 'package:get/get.dart';
import 'package:hhcom/Screens/ProfileScreen/Controllers/positions_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PositionController>(() => PositionController());
  }
}
