import 'package:hhcom/Utils/Constant/constant.dart';

import 'enum/enums.dart';

abstract class AppointmentItemModel {
  String? sId;
  String? icon;
  AppointmentItemModel({this.sId, this.icon});
}

class AppointmentLeftItemModel extends AppointmentItemModel {
  String? title;
  AppointmentLeftItemValue? value;

  AppointmentLeftItemModel({sId, this.title, icon, this.value}) : super(sId: sId, icon: icon);
}

class AppointmentRightItemModel extends AppointmentItemModel {
  AppointmentRightItemValue? value;
  AppointmentRightItemModel({sId, icon, this.value}) : super(sId: sId, icon: icon);
}

class AppointmentItems {
  static List<AppointmentLeftItemModel> get leftSideItems {
    List<AppointmentLeftItemModel> appointmentItemList = <AppointmentLeftItemModel>[];
    appointmentItemList.add(AppointmentLeftItemModel(sId: dateHeader, title: dateHeader, icon: calendar_appointment, value: AppointmentLeftItemValue.Date));
    appointmentItemList.add(AppointmentLeftItemModel(sId: timeHeader, title: timeHeader, icon: time_appointment, value: AppointmentLeftItemValue.Time));
    appointmentItemList.add(AppointmentLeftItemModel(sId: workerHeader, title: workerHeader, icon: worker_appointment, value: AppointmentLeftItemValue.Worker));
    appointmentItemList.add(AppointmentLeftItemModel(sId: locationHeader, title: locationHeader, icon: location_appointment, value: AppointmentLeftItemValue.Location));
    appointmentItemList.add(AppointmentLeftItemModel(sId: paymentHeader, title: paymentHeader, icon: payment_appointment, value: AppointmentLeftItemValue.Payment));

    return appointmentItemList;
  }

  static List<AppointmentRightItemModel> get rightSideItems {
    List<AppointmentRightItemModel> appointmentItemList = <AppointmentRightItemModel>[];
    appointmentItemList.add(AppointmentRightItemModel(sId: servicesHeader, icon: flag_appointment, value: AppointmentRightItemValue.Services));
    appointmentItemList.add(AppointmentRightItemModel(sId: productsHeader, icon: product_appointment, value: AppointmentRightItemValue.Products));
    appointmentItemList.add(AppointmentRightItemModel(sId: notesHeader, icon: note_appointment, value: AppointmentRightItemValue.Notes));
    appointmentItemList.add(AppointmentRightItemModel(sId: agreementsHeader, icon: agreement_appointment, value: AppointmentRightItemValue.Agreements));

    return appointmentItemList;
  }
}
