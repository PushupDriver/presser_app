import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/blocs/blocs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class HandleWebSocket {
  late WebSocketChannel channel;
  void onError(e) {}

  void onDone() {
    GetIt.instance.get<Blocs>().connectBloc.add(ConnectionState.done);
  }

  Future<void> startConnection(String ipAddress) async {
    GetIt getIt = GetIt.instance;
    Blocs blocs = getIt.get<Blocs>();

    final url = "ws://$ipAddress:8000/presser";

    channel = WebSocketChannel.connect(Uri.parse(url));
    await channel.ready;
    channel.stream.listen((event) {
      if (event is! String) {
        return;
      }

      try {
        Map<String, dynamic> jsonParsed = jsonDecode(event);
        if (jsonParsed.keys.contains('nextScreen')) {
          blocs.nextScreenBloc.add(jsonParsed['nextScreen']);
        } else if (jsonParsed.keys.contains('remain')) {
          blocs.pressedBloc.add(jsonParsed['remain']);
        }
      } on Exception {
        debugPrint("Failed to parse json");
      }
    }, onError: onError, onDone: onDone);
  }

  void send(String data) {
    channel.sink.add(data);
  }

  void close() {
    channel.sink.close(status.goingAway);
  }
}
