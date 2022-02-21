import 'package:equatable/equatable.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Models/position_model.dart';
import 'package:hhcom/Models/service_item_model.dart';

class BaseState extends Equatable {
  final bool loading;
  final List<CustomerModel> customers;
  final List<WorkerModel> workers;
  final List<PositionModel> positions;
  final List<ServiceItemModel> serviceItems;
  BaseState({
    this.loading = false,
    this.customers = const [],
    this.workers = const [],
    this.positions = const [],
    this.serviceItems = const [],
  });

  @override
  List<Object> get props => [
        this.loading,
        this.customers,
        this.workers,
        this.positions,
        this.serviceItems,
      ];

  BaseState copyWith({
    bool? loading,
    List<CustomerModel>? customers,
    List<WorkerModel>? workers,
    List<PositionModel>? positions,
    List<ServiceItemModel>? serviceItems,
  }) {
    return BaseState(
      loading: loading ?? this.loading,
      customers: customers ?? this.customers,
      positions: positions ?? this.positions,
      serviceItems: serviceItems ?? this.serviceItems,
    );
  }
}
