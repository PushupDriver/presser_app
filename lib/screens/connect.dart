import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/blocs/blocs.dart';
import 'package:pushup_presser/screens/wait_for_pushup.dart';
import 'package:pushup_presser/ws/handle_ws.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushupConnectPage extends StatefulWidget {
  const PushupConnectPage({super.key});

  @override
  State<PushupConnectPage> createState() => _PushupConnectPageState();
}

class _PushupConnectPageState extends State<PushupConnectPage> {
  TextEditingController controller = TextEditingController();

  bool connecting = false;
  late Blocs blocs;
  late HandleWebSocket handleWebSocket;
  late SharedPreferences prefs;

  @override
  void initState() {
    blocs = Blocs();
    handleWebSocket = HandleWebSocket();
    GetIt.instance.allowReassignment = true;
    GetIt.instance.registerSingleton(blocs);
    GetIt.instance.registerSingleton(handleWebSocket);
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      final serverAddr = prefs.getString('ServerAddr') ?? "";
      controller.text = serverAddr;
      handleConnect();
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? _errorText;

  set errorText(String? value) {
    _errorText = value;
  }

  String? get errorText {
    final text = controller.value.text;
    if (text.isEmpty) {
      _errorText = 'Can\'t be empty';
    }
    return _errorText;
  }

  void handleConnect() {
    if (controller.text.isEmpty || connecting) return;
    setState(() {
      connecting = true;
    });
    handleWebSocket.startConnection(controller.text).then((value) {
      setState(() {
        connecting = false;
      });
      prefs.setString('ServerAddr', controller.text);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const WaitForPushup()));
    }).onError((error, stackTrace) {
      setState(() {
        connecting = false;
        errorText = "Can not connect to this address";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "IP Addresses",
                errorText: errorText,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              height: 50,
              onPressed: handleConnect,
              color: Colors.blue,
              child: connecting
                  ? const CircularProgressIndicator()
                  : const Text("Connect"),
            )
          ],
        ),
      ),
    );
  }
}
