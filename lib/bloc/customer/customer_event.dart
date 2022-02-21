import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hhcom/Models/model.dart';

abstract class CustomerEvent extends Equatable {
  CustomerEvent();

  @override
  List<Object> get props => [];
}

class UploadCustomerPictureEvent extends CustomerEvent {
  final File file;
  final String customerId;

  UploadCustomerPictureEvent(this.file, this.customerId);
}

class AddCustomerEvent extends CustomerEvent {
  final CustomerModel customerModel;
  final String customerId;
  AddCustomerEvent({required this.customerModel, required this.customerId});

  @override
  List<Object> get props => [customerModel, customerId];
}

// Szymon
class AddCustomerAppointmentEvent extends CustomerEvent {
  final CustomerModel customerModel;
  AddCustomerAppointmentEvent({required this.customerModel});
}

class AddRemoveAppointmentNotesEvent extends CustomerEvent {
  final CustomerModel customerModel;
  AddRemoveAppointmentNotesEvent({required this.customerModel});
}

class AddRemoveAppointmentProductsServicesEvent extends CustomerEvent {
  final CustomerModel customerModel;
  AddRemoveAppointmentProductsServicesEvent({required this.customerModel});
}
