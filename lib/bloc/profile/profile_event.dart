import 'package:equatable/equatable.dart';
import 'package:hhcom/Models/position_model.dart';

abstract class ProfileEvent extends Equatable {
  ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfilePositionCreateEvent extends ProfileEvent {
  final PositionModel positionModel;
  ProfilePositionCreateEvent(this.positionModel);
}

class ProfilePositionUpdateEvent extends ProfileEvent {
  final PositionModel positionModel;
  ProfilePositionUpdateEvent(this.positionModel);
}
