import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final String tag = 'AutBloc:';
  HomeBloc() : super(HomeState()) ;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {

  }
}