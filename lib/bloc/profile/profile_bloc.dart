import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:hhcom/Models/position_model.dart';
import 'package:hhcom/Screens/ProfileScreen/Controllers/positions_controller.dart';
import 'package:hhcom/Utils/Constant/constant.dart';
import 'package:hhcom/controller/fobject.dart';
import 'package:hhcom/controller/navigation_controller.dart';

import '../bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final String tag = 'ProfileBloc:';
  final BaseBloc _baseBloc;

  ProfileBloc(this._baseBloc) : super(ProfileState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfilePositionCreateEvent) {
      yield* _createPosition(event.positionModel);
    }
  }

  Stream<ProfileState> _createPosition(PositionModel positionModel) async* {
    var positionController = Get.find<PositionController>();
    yield state.copyWith(loading: true);
    NavigationController().notifierInitLoading.value = true;

    try {
      FObject position = FObject.objectWithPathDic(FPath.position, positionModel.toJson());
      NavigationController().notifierInitLoading.value = true;
      await position.saveInBackground();

      List<PositionModel> list = [..._baseBloc.state.positions];
      list.add(positionModel);

      _baseBloc.add(UpdatePositionListEvent(list));
      positionController.positionList.addAll(list);
      positionController.positionList.refresh();
      await Future.delayed(Duration(milliseconds: 500));
      yield ProfilePositionSuccessState();
      yield state.copyWith(loading: false);
      NavigationController().notifierInitLoading.value = false;
    } on FirebaseException catch (e) {
      print("Couldn't add appointment: ${e.toString()}");
      NavigationController().notifierInitLoading.value = false;
      yield ProfilePositionErrorState(errorMessage: e.message!);
    }
  }
}
