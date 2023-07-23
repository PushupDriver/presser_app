import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/blocs/blocs.dart';
import 'package:pushup_presser/screens/pushup.dart';

class WaitForPushup extends StatelessWidget {
  const WaitForPushup({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: GetIt.instance.get<Blocs>().nextScreenBloc,
          listener: (context, state) {
            if (state == 'pushUp') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PushupPressPage()));
            }
          },
        )
      ],
      child: const Scaffold(
        body: Center(
          child: Text("Please wait for counter to enter pushup screen"),
        ),
      ),
    );
  }
}
