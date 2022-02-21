import 'package:hhcom/Screens/MainScreen/Controllers/drawer_item_controller.dart';

/// Drawer model class used in the [DrawerItemController] for manage the drawer items
///
class DrawerItemModel {
  String? sId;
  String? title;
  String? icon;
  DrawerItem? value;

  DrawerItemModel({this.sId, this.title, this.icon, this.value});

  DrawerItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    icon = json['icon'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['value'] = this.value;
    return data;
  }
}
