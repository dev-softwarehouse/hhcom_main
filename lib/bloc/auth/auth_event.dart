import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hhcom/Models/model.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent();

  @override
  List<Object> get props => [];
}

class UpdateGroupEvent extends AuthEvent {
  final Map<String, dynamic>data;
  UpdateGroupEvent(this.data);
}


class EmailLoginEvent extends AuthEvent {
  final String email;
  final String password;

  EmailLoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final UserModel userModel;
  RegisterEvent(this.email, this.password, this.userModel);
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

class LoadUserEvent extends AuthEvent {
  final User user;
  final UserCredential credential;

  LoadUserEvent(this.user, {required this.credential});
}

class CreateUserEvent extends AuthEvent {
  final User user;
  final UserCredential credential;
  final UserModel userModel;
  CreateUserEvent(this.user, {required this.credential, required this.userModel});
}