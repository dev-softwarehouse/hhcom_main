import 'package:equatable/equatable.dart';

class CustomerState extends Equatable {
  final bool loading;

  CustomerState({
    this.loading = false,
  });

  List<Object> get props => [
        this.loading,
      ];

  CustomerState copyWith({
    bool? loading,
  }) {
    return CustomerState(
      loading: loading ?? this.loading,
    );
  }
}

class UpdateCustomerSuccessState extends CustomerState {}

class AddCustomerState extends CustomerState {}

class AddCustomerSuccessState extends CustomerState {}

// Szymon
class AddCustomerAppointmentSuccessState extends CustomerState {}

class AddCustomerAppointmentNotesSuccessState extends CustomerState {}

// Szymon
class AddCustomerAppointmentErrorState extends CustomerState {
  final String errorMessage;
  AddCustomerAppointmentErrorState({required this.errorMessage});
}

class AddEditCustomerAppointmentProductServiceSuccessState extends CustomerState {}
