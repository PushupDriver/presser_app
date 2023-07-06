import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/blocs/blocs.dart';

Blocs blocs = GetIt.instance.get<Blocs>();

class PushUpSocketClient {
  Socket? socket;
  StreamSubscription? streamSubscription;

  void onDone() {
    blocs.connectBloc.add(ConnectionState.done);
  }

  void onError(e) {
    onDone();
  }

  void startListen() {
    if (socket == null) {
      return;
    }
    streamSubscription = socket!.listen((Uint8List event) {
      final incoming = String.fromCharCodes(event);
      int toPushup = int.tryParse(incoming) ?? 0;
      blocs.pressedBloc.add(toPushup);
    }, onDone: onDone, onError: onError);
  }

  void start() {
    if (socket == null) {
      return;
    }
    socket!.write("Start!");
    socket!.flush();
  }

  void pressed() {
    if (socket == null) {
      return;
    }
    socket!.write("Pressed!");
    socket!.flush();
  }

  static Future<PushUpSocketClient?> tryConnect(String address) async {
    try {
      Socket socket = await Socket.connect(address, 12635,
          timeout: const Duration(seconds: 3));
      PushUpSocketClient client = PushUpSocketClient();
      client.socket = socket;
      blocs.connectBloc.add(ConnectionState.active);
      return client;
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }
}
