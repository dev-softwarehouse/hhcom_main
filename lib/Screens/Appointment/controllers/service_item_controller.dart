import 'package:get/get.dart';
import 'package:hhcom/Models/service_item_model.dart';

class ServiceItemController extends GetxController {
  /// Current selected item
  var selectedItem = ServiceItemModel().obs;

  var serviceItemList = <ServiceItemModel>[].obs;

  changeSelectedItem({ServiceItemModel? item}) {
    selectedItem.value = item!;
  }
}
