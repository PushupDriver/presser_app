import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/blocs/blocs.dart';
import 'package:pushup_presser/socket/socket_client.dart';

class PushupPressPage extends StatefulWidget {
  const PushupPressPage({super.key});

  @override
  State<PushupPressPage> createState() => _PushupPressPageState();
}

class _PushupPressPageState extends State<PushupPressPage> {
  GetIt getIt = GetIt.instance;

  late PushUpSocketClient socketClient;
  int _toPushUp = 0;
  set toPushUp(int value) {
    _toPushUp = value;
    if (_toPushUp == 0) {
      // Done!!
      confettiController.play();
      donePlayer.seek(Duration.zero);
      donePlayer.resume();
      Future.delayed(const Duration(seconds: 10))
          .then((value) => confettiController.stop());
    } else if (_toPushUp < 0) {
      _toPushUp = 0;
    }
  }

  final pushupPlayer = AudioPlayer();
  final donePlayer = AudioPlayer();

  int get toPushUp => _toPushUp;
  late ConfettiController confettiController;

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void initState() {
    super.initState();
    socketClient = getIt.get<PushUpSocketClient>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    pushupPlayer.setVolume(1);
    donePlayer.setVolume(1);
    pushupPlayer.setSource(AssetSource('sound_effects/pushup.opus'));
    donePlayer.setSource(AssetSource('sound_effects/done.opus'));
    getIt.get<PushUpSocketClient>().start();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    confettiController.dispose();
    pushupPlayer.dispose();
    donePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: getIt.get<Blocs>().connectBloc,
          listener: (context, state) {
            if (state == ConnectionState.done &&
                Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<PressedBloc, int>(
          bloc: getIt.get<Blocs>().pressedBloc,
          listener: (context, state) {
            setState(() {
              toPushUp = state;
            });
          },
        )
      ],
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            socketClient.pressed();
            pushupPlayer.seek(Duration.zero);
            pushupPlayer.resume();
          },
          child: Stack(
            children: [
              Center(
                child: Text(
                  toPushUp.toString(),
                  style: const TextStyle(
                    fontFamily: 'Rajdhiani',
                    fontSize: 350,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
