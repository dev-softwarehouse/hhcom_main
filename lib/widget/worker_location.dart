import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/worker_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/Utils/Constant/constant_widget.dart';
import 'package:hhcom/Utils/app_theme.dart';
import 'package:sizer/sizer.dart';

class WorkerLocation extends StatefulWidget {
  Function doneButtonPressed;
  String? worker;
  String? location;
  WorkerLocation({required this.doneButtonPressed, this.worker, this.location});

  @override
  _WorkerLocationState createState() => _WorkerLocationState();
}

class _WorkerLocationState extends State<WorkerLocation> {
  String _selectedWorker = "";
  String _selectedWorkerId = "";
  String _selectedLocation = "";
  var workerController = Get.find<WorkerController>();

  List<String> workerName = [];

  List<Text> workerList = [];

  final locationList = [
    Text(
      "Kraków",
      style: TextStyles.pickerItems,
    ),
    Text(
      "Warsaw",
      style: TextStyles.pickerItems,
    ),
    Text(
      "Gdańsk",
      style: TextStyles.pickerItems,
    ),
  ];

  final location = [
    "Kraków",
    "Warsaw",
    "Gdańsk",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.worker != null) {
      _selectedWorker = widget.worker!;
    }
    if (widget.location != null) {
      _selectedLocation = widget.location!;
    }
    initWorkerInfo();
  }

  void initWorkerInfo() {
    workerController.workerList.forEach((element) {
      workerList.add(Text(
        "${element.firstName} ${element.lastName}",
        style: TextStyles.pickerItems,
      ));
      workerName.add("${element.firstName} ${element.lastName}");
    });
  }

  Widget entryField(String entry) {
    return Container(
      width: 50.w,
      height: 50,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: Color(0xFF999999))),
      ),
      child: Center(
        child: Text(
          entry,
          textAlign: TextAlign.center,
          style: (entry == locationHintText || entry == workerHintText) ? TextStyles.workerLocationPickerText : TextStyles.workerLocationPickerValue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.doneButtonPressed(null, null);
        return false;
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 5.0,
        color: Colors.white,
        child: Container(
          constraints: BoxConstraints(maxWidth: 86.w, maxHeight: 90.h),
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40, top: 50, bottom: 50),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customIcon(icon: worker_appointment),
                    InkWell(
                        onTap: () {
                          BottomPicker(
                            onSubmit: (idx) {
                              setState(() {
                                _selectedWorker = workerName[idx];
                                _selectedWorkerId = workerController.workerList[idx].objectId!;
                              });
                            },
                            buttonSingleColor: primaryColor,
                            items: workerList,
                            title: workerHintText,
                          ).show(context);
                        },
                        child: entryField((_selectedWorker.isEmpty) ? workerHintText : _selectedWorker)),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customIcon(icon: location_appointment),
                    InkWell(
                        onTap: () {
                          BottomPicker(
                            buttonSingleColor: primaryColor,
                            items: locationList,
                            title: locationHintText,
                            onSubmit: (idx) {
                              setState(() {
                                _selectedLocation = location[idx];
                              });
                            },
                          ).show(context);
                        },
                        child: entryField((_selectedLocation.isEmpty) ? locationHintText : _selectedLocation)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10, top: 20),
                  child: customTextButton(
                      cornerRadius: 15,
                      height: 15,
                      width: 29,
                      btnText: saveDateTimeBtnHeader,
                      onTap: () {
                        widget.doneButtonPressed(_selectedWorker, _selectedWorkerId, _selectedLocation);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
