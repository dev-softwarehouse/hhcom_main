import 'package:get/get.dart';
import 'package:hhcom/Models/position_model.dart';

/// Used for manage the position list
class PositionController extends GetxController {
  /// Current selected item
  var selectedItem = PositionModel().obs;

  var positionList = <PositionModel>[].obs;
/*
  @override
  void onInit() async {
    super.onInit();
    positionList.value = [
      PositionModel(
          maleJobTitle: 'maleJobTitle',
          femaleJobTitle: 'femaleJobTitle',
          jobType: JobType.Hairdresser.index,
          //icon: scissors_icn,
          position: 'Fryzjer / Fryzjerka'),
      PositionModel(
          maleJobTitle: 'maleJobTitle',
          jobType: JobType.Manager.index,
          //icon: book_icn,
          femaleJobTitle: 'femaleJobTitle',
          position: 'Manager'),
      PositionModel(
        maleJobTitle: 'maleJobTitle',
        // icon: agent_icn,
        jobType: JobType.Owner.index,
        femaleJobTitle: 'femaleJobTitle',
        position: 'Właściciel / Właścicielka',
      ),
    ];
    selectedItem.value = positionList[0];
  }*/

  /// set current selected item, pass object of [PositionModel] as a parameter
  changeSelectedItem({PositionModel? item}) {
    selectedItem.value = item!;
  }
}
