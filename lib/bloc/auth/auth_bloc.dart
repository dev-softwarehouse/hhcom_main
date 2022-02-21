import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hhcom/Models/enum/enums.dart';
import 'package:hhcom/Models/model.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/controller/controller.dart';
import 'package:hhcom/controller/fuser.dart';
import 'package:hhcom/widget/warning_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final String tag = 'AutBloc:';
  BuildContext _context;

  AuthBloc(this._context) : super(AuthState()) {
    SharedPreferences.getInstance()
        .then((value) => Constants.preferences = value);
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is EmailLoginEvent) {
      yield* _loginEmail(event.email, event.password);
    } else if (event is RegisterEvent) {
      yield* _registerEmail(event.email, event.password, event.userModel);
    } else if (event is ForgotPasswordEvent) {
      yield* _forgotPassword(event.email);
    } else if (event is LoadUserEvent) {
      yield* _load(event.user, event.credential);
    } else if (event is CreateUserEvent) {
      yield* _create(
          event.user.uid, event.user.email!, event.credential, event.userModel);
    }
  }

  Stream<AuthState> _loginEmail(String email, String password) async* {
    print('$tag login with email...');
    NavigationController().notifierInitLoading.value = true;
    String? error;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      add(LoadUserEvent(userCredential.user!, credential: userCredential));
      NavigationController().notifierInitLoading.value = false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
        // add(RegisterEvent(email, password));
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      }
      NavigationController().notifierInitLoading.value = false;
    } catch (e) {
      print(e);
      error = e.toString();
      NavigationController().notifierInitLoading.value = false;
    }
    if (error != null) {
      _handleError(error);
    }
  }

  Stream<AuthState> _registerEmail(
      String email, String password, UserModel userModel) async* {
    print('$tag Register with email...');
    NavigationController().notifierInitLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print('$tag userCredential: $userCredential');
      add(CreateUserEvent(userCredential.user!,
          credential: userCredential, userModel: userModel));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _handleError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _handleError('The account already exists for that email.');
      }
      NavigationController().notifierInitLoading.value = false;
    } catch (e) {
      print(e);
      _handleError(e.toString());
      NavigationController().notifierInitLoading.value = false;
    }
  }

  Stream<AuthState> _forgotPassword(String email) async* {
    NavigationController().notifierInitLoading.value = true;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    NavigationController().notifierInitLoading.value = false;
  }

  Stream<AuthState> _load(User fUser, UserCredential credential) async* {
    print('$tag load user...');
    FUser user = FUser.userWithId(fUser.uid);
    try {
      await user.fetchInBackground();
      yield LoginSuccessState();
      WarningMessageDialog.showDialog(_context, 'Logged in successfully.',
          type: MsgType.success);
      NavigationController().notifierInitLoading.value = false;
    } catch (e) {
      print('$tag fetch error ${e.toString()}');
      // add(CreateUserEvent(fUser, credential: credential));
    }
  }

  Stream<AuthState> _create(String uid, String email, UserCredential credential,
      UserModel userModel) async* {
    print('$tag creating user...');
    FUser user = FUser.userWithId(uid);
    userModel.objectId = uid;
    userModel.email = email;
    userModel.online = true;
    user.dictionary = {...user.dictionary, ...userModel.toJson()};
    await user.saveInBackground();
    print('$tag created user!');
    WarningMessageDialog.showDialog(_context, 'Registered successfully.',
        type: MsgType.success);
    yield LoginSuccessState();
    NavigationController().notifierInitLoading.value = false;
  }

  _handleError(String message) {
    WarningMessageDialog.showDialog(_context, message, type: MsgType.error);
  }
}
