import 'package:get/get.dart';
import 'package:hhcom/Models/drawer_item_model.dart';
import 'package:hhcom/Utils/Constant/constant.dart';

/// Define the enum for the Drawer item value for the select page on selected drawer item
enum DrawerItem {
  Profil,
  Stanowiska,
  Pracownicy,
  Firma,
  Umowy,
  Platnosci,
  Preferencje,
  Centrum_Pomocy,
}

/// [DrawerItemController] is used for manage all the drawer events
///
class DrawerItemController extends GetxController {
  /// Current selected item
  var selectedItem = DrawerItemModel().obs;

  /// Dummy Item List
  var draweritemModelDummyList = <DrawerItemModel>[].obs;

  /// this method call when [DrawerItemController] put first time
  @override
  void onInit() async {
    super.onInit();
    draweritemModelDummyList.value = [
      DrawerItemModel(
          sId: "Profil",
          icon: user_icn,
          title: 'Profil',
          value: DrawerItem.Profil),
      DrawerItemModel(
          sId: "Stanowiska",
          icon: stanowiska,
          title: 'Stanowiska',
          value: DrawerItem.Stanowiska),
      DrawerItemModel(
          sId: "Pracownicy",
          icon: users_icn,
          title: 'Pracownicy',
          value: DrawerItem.Pracownicy),
      DrawerItemModel(
          sId: "Firma", icon: firma, title: 'Firma', value: DrawerItem.Firma),
      DrawerItemModel(
          sId: "Umowy",
          icon: checkList,
          title: 'Umowy',
          value: DrawerItem.Umowy),
      DrawerItemModel(
          sId: "Płatności",
          icon: card,
          title: 'Płatności',
          value: DrawerItem.Platnosci),
      DrawerItemModel(
          sId: "Preferencje",
          icon: settings,
          title: 'Preferencje',
          value: DrawerItem.Preferencje),
      DrawerItemModel(
          sId: "Centrum Pomocy",
          icon: help,
          title: 'Centrum Pomocy',
          value: DrawerItem.Centrum_Pomocy),
    ];

    /// Set initial selected value for drawer
    selectedItem.value = draweritemModelDummyList[0];
  }

  /// set current selected item, pass object of [DrawerItemModel] as a parameter
  changeSelectedItem({DrawerItemModel? item}) {
    selectedItem.value = item!;
  }
}
