import 'package:flutter/material.dart';
import 'package:pushup_presser/blocs/blocs.dart';
import 'package:pushup_presser/blocs/next_screen_bloc.dart';

export 'package:pushup_presser/blocs/connect_bloc.dart';
export 'package:pushup_presser/blocs/pressed_bloc.dart';

class Blocs {
  PressedBloc pressedBloc = PressedBloc(0);
  ConnectBloc connectBloc = ConnectBloc(ConnectionState.none);
  NextScreenBloc nextScreenBloc = NextScreenBloc('');
}
