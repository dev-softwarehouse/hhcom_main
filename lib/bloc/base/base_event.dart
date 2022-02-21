import 'package:equatable/equatable.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Models/position_model.dart';

abstract class BaseEvent extends Equatable {
  BaseEvent();

  @override
  List<Object> get props => [];
}

class AppInitEvent extends BaseEvent {}

class UpdateCustomerListEvent extends BaseEvent {
  final List<CustomerModel> list;
  UpdateCustomerListEvent(this.list);
}

class ClearCustomerListEvent extends BaseEvent {}

class UpdatePositionListEvent extends BaseEvent {
  final List<PositionModel> list;
  UpdatePositionListEvent(this.list);
}
