import 'dart:io';

class PushUpSocketClient {
  Socket? socket;
  static Future<PushUpSocketClient?> tryConnect(String address) async {
    try {
      Socket socket = await Socket.connect(address, 12635,
          timeout: const Duration(seconds: 3));
      PushUpSocketClient client = PushUpSocketClient();
      client.socket = socket;
      return client;
    } catch (e) {}

    return null;
  }
}
