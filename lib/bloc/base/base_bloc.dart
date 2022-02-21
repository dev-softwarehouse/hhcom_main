import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Models/position_model.dart';
import 'package:hhcom/Models/service_item_model.dart';
import 'package:hhcom/Screens/Appointment/controllers/service_item_controller.dart';
import 'package:hhcom/Screens/MainScreen/Controllers/worker_controller.dart';
import 'package:hhcom/Screens/ProfileScreen/Controllers/positions_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/controller/fuser.dart';

import '../bloc.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  final String tag = 'AutBloc:';

  BaseBloc() : super(BaseState());
  DatabaseReference _refCustomer = FirebaseDatabase.instance.reference().child(FPath.customer);
  DatabaseReference _refWorker = FirebaseDatabase.instance.reference().child(FPath.worker);
  DatabaseReference _refPosition = FirebaseDatabase.instance.reference().child(FPath.position);
  DatabaseReference _refService = FirebaseDatabase.instance.reference().child(FPath.service);

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is AppInitEvent) {
      _listenWorkerRef();
      _listenCustomerRef();
      _listenPositionRef();
      _listenServiceItemRef();
    } else if (event is UpdateCustomerListEvent) {
      yield state.copyWith(customers: event.list);
    } else if (event is ClearCustomerListEvent) {
      yield state.copyWith(customers: []);
    } else if (event is UpdatePositionListEvent) {
      yield state.copyWith(positions: event.list);
    }
  }

  _listenCustomerRef() {
    var query = _refCustomer.orderByChild('userId').equalTo(FUser.currentId());
    query.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<CustomerModel> list = [...state.customers];
      CustomerModel model = CustomerModel.fromJson(Map<String, dynamic>.from(snapshot.value));
      int index = list.indexWhere((element) => element.email == model.email);
      if (index == -1) {
        list.add(model);
        add(UpdateCustomerListEvent(list));
      }
    });

    query.onChildChanged.listen((event) {});
  }

  _listenWorkerRef() {
    var workerController = Get.find<WorkerController>();
    var query = _refWorker;
    query.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<WorkerModel> list = [...state.workers];
      WorkerModel model = WorkerModel.fromJson(Map<String, dynamic>.from(snapshot.value));
      list.add(model);
      workerController.workerList.addAll(list);
    });
  }

  _listenPositionRef() {
    var positionController = Get.find<PositionController>();
    var query = _refPosition;
    query.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<PositionModel> list = [...state.positions];
      PositionModel model = PositionModel.fromJson(Map<String, dynamic>.from(snapshot.value));
      list.add(model);
      positionController.positionList.addAll(list);
    });

    positionController.positionList.refresh();
    add(UpdatePositionListEvent(positionController.positionList.toList()));
  }

  _listenServiceItemRef() {
    var serviceItemController = Get.find<ServiceItemController>();
    var query = _refService;
    query.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      List<ServiceItemModel> list = [...state.serviceItems];
      ServiceItemModel model = ServiceItemModel.fromMap(Map<String, dynamic>.from(snapshot.value));
      list.add(model);
      serviceItemController.serviceItemList.addAll(list);
    });

    serviceItemController.serviceItemList.refresh();
  }
}
