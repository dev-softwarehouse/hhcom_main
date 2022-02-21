import 'package:equatable/equatable.dart';

class CalendarState extends Equatable {

  final bool loading;

  CalendarState({
    this.loading = false,
  });

  List<Object> get props => [
    this.loading,
  ];

  CalendarState copyWith({
    bool? loading,
  }) {
    return CalendarState(
      loading: loading ?? this.loading,
    );
  }
}
