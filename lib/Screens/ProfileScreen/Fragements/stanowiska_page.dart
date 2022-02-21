import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/position_model.dart';
import 'package:hhcom/Screens/ProfileScreen/Controllers/positions_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/Routes/app_routes.dart';
import 'package:sizer/sizer.dart';

/// Position list show in this screen and also user able to navigate to add position screen
class StanowiskaPage extends StatefulWidget {
  const StanowiskaPage({
    Key? key,
  });

  @override
  _StanowiskaPageState createState() => _StanowiskaPageState();
}

class _StanowiskaPageState extends State<StanowiskaPage> {
  var searchController = TextEditingController();

  var positionController = Get.find<PositionController>();

  String iconNameForJobType(int jobType) {
    String iconName = brush_icn;
    if (jobType == JobType.Hairdresser.index) {
      iconName = scissors_icn;
    }

    if (jobType == JobType.Manager.index) {
      iconName = book_icn;
    }

    if (jobType == JobType.Owner.index) {
      iconName = agent_icn;
    }

    return iconName;
  }

  @override
  Widget build(BuildContext context) {
    final cornerRadius = 35.0;
    final height = 40.h;
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          // height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(search_bg),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.only(
                //topRight: Radius.circular(40.0),
                bottomRight: Radius.circular(cornerRadius),
                //topLeft: Radius.circular(40.0),
                bottomLeft: Radius.circular(cornerRadius)),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15.h,
              ),
              Container(
                width: 40.0.w,
                child: Image.asset(stanowiska_title),
              ),
              SizedBox(height: 5.0.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60.0.w,
                    height: 50,
                    child: customTextField(
                        onSuffixTap: () {},
                        isSuffixIcon: true,
                        suffixIcon: customIcon(icon: search_icn, size: 1),
                        controller: searchController,
                        labelText: 'Stanowisko',
                        validator: (v) {
                          if (v!.isEmpty) {
                            return 'Please enter Stanowisko';
                          }
                        }),
                  ),
                  SizedBox(width: 3.0.w),
                  GestureDetector(
                      onTap: () => Get.toNamed(Routes.ADD_POSITION),
                      child: customIcon(icon: add_customer_icn, size: 5.5))
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(2.0.h),
            child: Obx(() {
              return ListView.separated(
                separatorBuilder: (ctx, i) => Divider(
                  height: 1,
                  thickness: 1,
                ),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  var itemList = positionController.positionList;
                  PositionModel model = itemList[i];
                  String position = model.maleJobTitle!;
                  if (model.femaleJobTitle != null && model.femaleJobTitle!.isNotEmpty) {
                    position = position + " / ${model.femaleJobTitle!}";
                  }
                  return Container(
                    padding: EdgeInsets.all(3.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        customIcon(icon: iconNameForJobType(itemList[i].jobType!), size: 3.5),
                        SizedBox(width: 2.0.h),
                        text(position, fontSize: 13.0),
                        Spacer(),
                        customIcon(icon: edit_icon, size: 3.0)
                      ],
                    ),
                  );
                },
                itemCount: positionController.positionList.length,
              );
            }),
          ),
        ),
      ],
    );
  }
}
