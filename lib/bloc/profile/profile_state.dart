import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final bool loading;

  ProfileState({
    this.loading = false,
  });

  List<Object> get props => [
        this.loading,
      ];

  ProfileState copyWith({
    bool? loading,
  }) {
    return ProfileState(
      loading: loading ?? this.loading,
    );
  }
}

class ProfilePositionSuccessState extends ProfileState {}

class ProfilePositionErrorState extends ProfileState {
  final String errorMessage;
  ProfilePositionErrorState({required this.errorMessage});
}
