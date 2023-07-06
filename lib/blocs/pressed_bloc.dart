import 'package:flutter_bloc/flutter_bloc.dart';

class PressedBloc extends Cubit<int> {
  PressedBloc(super.initialState);
  void add(int state) => emit(state);
}
