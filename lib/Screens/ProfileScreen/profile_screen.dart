import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/drawer_item_controller.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/worker_controller.dart';
import 'package:hhcom/Screens/MainScreen/customer_screen.dart';
import 'package:hhcom/Screens/ProfileScreen/Controllers/positions_controller.dart';
import 'package:hhcom/Screens/base_scaffold.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/Routes/app_routes.dart';
import 'package:sizer/sizer.dart';

import 'Fragements/stanowiska_page.dart';

/// This screen contains the drawer
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var drawerItemController = Get.put(DrawerItemController());
  var positionController = Get.put(PositionController());
  var workerController = Get.find<WorkerController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      drawer: ListDrawer(),
      scaffoldKey: _scaffoldKey,
      hasMenu: true,
      child: Obx(
        () => _getScreen(drawerItemController.selectedItem.value.value!),
      ),
    );
  }

  Widget _buildWorkerPage() {
    return Column(
      children: [
        Container(
          height: 25.0.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100.0.w,
                height: 25.0.h,
                child: Image.asset(
                  search_bg,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50.0.w,
                    child: Image.asset(pracownicy_title),
                  ),
                  SizedBox(height: 2.0.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 65.0.w,
                        child: customTextField(
                            controller: searchController,
                            labelText: 'Pracownik',
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'Please enter Pracownik';
                              }
                            }),
                      ),
                      SizedBox(width: 3.0.w),
                      GestureDetector(
                          onTap: () => Get.toNamed(Routes.ADD_POSITION),
                          child: customIcon(icon: add_customer_icn, size: 7.0))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Obx(() {
          if (workerController.workerList.length > 0) {
            return ListView.builder(
                itemCount: workerController.workerList.length,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  WorkerModel worker = workerController.workerList[index];
                  return Padding(
                      padding: EdgeInsets.all(2.0.h),
                      child: Column(
                        children: [
                          text("${worker.firstName}, ${worker.lastName}", fontSize: 15.0),
                          IconValueWidget(
                              mainAxisAlignment: MainAxisAlignment.center, icon: phone_icn, value: "${worker.phone}"),
                          IconValueWidget(
                              mainAxisAlignment: MainAxisAlignment.center, icon: email_icn, value: "${worker.email}"),
                          IconValueWidget(
                              mainAxisAlignment: MainAxisAlignment.center,
                              icon: stanowiska,
                              value: "${worker.position}"),
                        ],
                      ));
                });
          } else {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.all(2.0.h),
                child: Column(
                  children: [
                    text('Sobolewska, Małgorzata', fontSize: 15.0),
                    IconValueWidget(
                        mainAxisAlignment: MainAxisAlignment.center, icon: phone_icn, value: '+48 702 011 883'),
                    IconValueWidget(
                        mainAxisAlignment: MainAxisAlignment.center, icon: email_icn, value: 'gocha9791@op.pl'),
                    IconValueWidget(mainAxisAlignment: MainAxisAlignment.center, icon: stanowiska, value: 'Fryzjerka'),
                  ],
                ),
              ),
            );
          }
        }),
        /*
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(2.0.h),
              child: Column(
                children: [
                  text('Sobolewska, Małgorzata', fontSize: 15.0),
                  IconValueWidget(mainAxisAlignment: MainAxisAlignment.center, icon: phone_icn, value: '+48 702 011 883'),
                  IconValueWidget(mainAxisAlignment: MainAxisAlignment.center, icon: email_icn, value: 'gocha9791@op.pl'),
                  IconValueWidget(mainAxisAlignment: MainAxisAlignment.center, icon: stanowiska, value: 'Fryzjerka'),
                ],
              )),
        ),*/
      ],
    );
  }

  Widget _buildProfilePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Center(child: Obx(() => text(drawerItemController.selectedItem.value.title!)))],
    );
  }

  _getScreen(DrawerItem drawerItem) {
    switch (drawerItem) {
      case DrawerItem.Profil:
        return _buildProfilePage();
      case DrawerItem.Stanowiska:
        return StanowiskaPage();
      case DrawerItem.Pracownicy:
        return _buildWorkerPage();
      default:
        return _buildProfilePage();
    }
  }
}

/// Specifies the list of [ItemModel]
class ListDrawer extends StatefulWidget {
  const ListDrawer({Key? key}) : super(key: key);

  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  var drawerItemController = Get.put(DrawerItemController());
  var searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text('Panel\nAdministracyjny', fontWeight: FontWeight.bold, fontSize: 15.0),
                  Padding(
                    padding: EdgeInsets.all(2.0.h),
                    child: GestureDetector(onTap: () => Get.back(), child: customIcon(icon: drawer_icn)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(
                () => drawerItemController.draweritemModelDummyList.length == 0
                    ? NoDataWidget()
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
                          var itemList = drawerItemController.draweritemModelDummyList;
                          return Obx(() => ListTile(
                                enabled: true,
                                selectedTileColor: primaryColor.withOpacity(0.3),
                                selected: itemList[i] == drawerItemController.selectedItem.value,
                                leading: customIcon(icon: itemList[i].icon ?? "", size: 3.0),
                                title: text('${itemList[i].title}',
                                    fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.8)),
                                onTap: () {
                                  drawerItemController.changeSelectedItem(item: itemList[i]);
                                  Get.back();
                                },
                              ));
                        },
                        itemCount: drawerItemController.draweritemModelDummyList.length,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
