import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectBloc extends Cubit<ConnectionState> {
  ConnectBloc(super.initialState);

  void add(ConnectionState state) => emit(state);
}
