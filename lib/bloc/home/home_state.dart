import 'package:equatable/equatable.dart';

class HomeState extends Equatable {

  final bool loading;

  HomeState({
    this.loading = false,
  });

  List<Object> get props => [
    this.loading,
  ];

  HomeState copyWith({
    bool? loading,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
    );
  }
}
