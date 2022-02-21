import 'package:equatable/equatable.dart';

class AuthState extends Equatable {

  final bool signing;

  AuthState({
    this.signing = false,
  });

  List<Object> get props => [
    this.signing,
  ];

  AuthState copyWith({
    bool? signing,
  }) {
    return AuthState(
      signing: signing ?? this.signing,
    );
  }
}

class LoginSuccessState extends AuthState {}