import 'package:flutter_bloc/flutter_bloc.dart';

class NextScreenBloc extends Cubit<String> {
  NextScreenBloc(super.initialState);
  void add(String state) => emit(state);
}
