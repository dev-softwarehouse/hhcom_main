import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/bloc/customer/customer.dart';
import 'package:hhcom/controller/controller.dart';

import '../bloc.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final String tag = 'AutBloc:';
  final BaseBloc _baseBloc;
  CustomerBloc(this._baseBloc) : super(CustomerState());

  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
    if (event is UploadCustomerPictureEvent) {
      yield* _uploadImage(event.file, event.customerId);
    } else if (event is AddCustomerAppointmentEvent) {
      // Szymon
      yield* _addAppointment(event.customerModel); // Szymon
    } else if (event is AddRemoveAppointmentNotesEvent) {
      // Szymon
      yield* _addRemoveAppointmentNotes(event.customerModel); // Szymon
    } else if (event is AddRemoveAppointmentProductsServicesEvent) {
      // Szymon
      yield* _addRemoveAppointmentProductsServices(event.customerModel); // Szymon
    }
  }

  Stream<CustomerState> _uploadImage(File file, String customerId) async* {
    yield state.copyWith(loading: true);
    NavigationController().notifierInitLoading.value = true;
    String refPath = 'customer/$customerId/$customerId.png';
    try {
      UploadTask task = FirebaseStorage.instance.ref(refPath).putFile(file);
      TaskSnapshot taskSnapshot = await task.whenComplete(() {
        print('print complete');
      });
      String link = await taskSnapshot.ref.getDownloadURL();
      FObject object = FObject(path: FPath.customer);
      object.dictionary['objectId'] = customerId;
      await object.fetchInBackground();
      object.dictionary['picture'] = link;
      await object.saveInBackground();
      List<CustomerModel> list = [..._baseBloc.state.customers];
      list.firstWhere((e) => e.objectId == customerId).picture = link;
      _baseBloc.add(UpdateCustomerListEvent(list));
      await Future.delayed(Duration(milliseconds: 500));
      yield UpdateCustomerSuccessState();
      yield state.copyWith(loading: false);
      NavigationController().notifierInitLoading.value = false;
    } on FirebaseException catch (e) {
      print('$tag failed upload image: ${e.toString()}');
      NavigationController().notifierInitLoading.value = false;
    }
  }

  // Szymon
  Stream<CustomerState> _addAppointment(CustomerModel customerModel) async* {
    yield state.copyWith(loading: true);
    NavigationController().notifierInitLoading.value = true;

    try {
      FObject customer = FObject.objectWithPathDic(FPath.customer, customerModel.toJson());
      NavigationController().notifierInitLoading.value = true;
      await customer.updateInBackground();

      List<CustomerModel> list = [..._baseBloc.state.customers];
      list.firstWhere((e) => e.objectId == customerModel.objectId).visits = customerModel.visits;
      _baseBloc.add(UpdateCustomerListEvent(list));
      await Future.delayed(Duration(milliseconds: 500));
      yield AddCustomerAppointmentSuccessState();
      yield state.copyWith(loading: false);
      NavigationController().notifierInitLoading.value = false;
    } on FirebaseException catch (e) {
      print("Couldn't add appointment: ${e.toString()}");
      NavigationController().notifierInitLoading.value = false;
      yield AddCustomerAppointmentErrorState(errorMessage: e.message!);
    }
  }

  Stream<CustomerState> _addRemoveAppointmentNotes(CustomerModel customerModel) async* {
    NavigationController().notifierInitLoading.value = false;
    yield state.copyWith(loading: false);
    try {
      FObject customer = FObject.objectWithPathDic(FPath.customer, customerModel.toJson());
      await customer.updateInBackground();

      List<CustomerModel> list = [..._baseBloc.state.customers];
      list.firstWhere((e) => e.objectId == customerModel.objectId).visits = customerModel.visits;
      _baseBloc.add(UpdateCustomerListEvent(list));
      yield AddCustomerAppointmentNotesSuccessState();
      yield state.copyWith(loading: false);
    } on FirebaseException catch (e) {
      print("Couldn't add appointment: ${e.toString()}");
      NavigationController().notifierInitLoading.value = false;
      yield AddCustomerAppointmentErrorState(errorMessage: e.message!);
    }
  }

  Stream<CustomerState> _addRemoveAppointmentProductsServices(CustomerModel customerModel) async* {
    NavigationController().notifierInitLoading.value = false;
    yield state.copyWith(loading: false);
    try {
      FObject customer = FObject.objectWithPathDic(FPath.customer, customerModel.toJson());
      await customer.updateInBackground();

      List<CustomerModel> list = [..._baseBloc.state.customers];
      list.firstWhere((e) => e.objectId == customerModel.objectId).visits = customerModel.visits;
      _baseBloc.add(UpdateCustomerListEvent(list));
      yield AddEditCustomerAppointmentProductServiceSuccessState();
      yield state.copyWith(loading: false);
    } on FirebaseException catch (e) {
      print("Couldn't add appointment: ${e.toString()}");
      NavigationController().notifierInitLoading.value = false;
      yield AddCustomerAppointmentErrorState(errorMessage: e.message!);
    }
  }
}
