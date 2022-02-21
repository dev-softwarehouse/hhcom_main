import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final String tag = 'AutBloc:';

  CalendarBloc() : super(CalendarState()) ;

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {

  }
}