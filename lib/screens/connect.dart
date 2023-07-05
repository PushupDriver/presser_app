import 'package:flutter/material.dart';
import 'package:pushup_presser/screens/pushup.dart';
import 'package:pushup_presser/socket/socket_client.dart';

class PushupConnectPage extends StatefulWidget {
  const PushupConnectPage({super.key});

  @override
  State<PushupConnectPage> createState() => _PushupConnectPageState();
}

class _PushupConnectPageState extends State<PushupConnectPage> {
  TextEditingController controller = TextEditingController();

  bool connecting = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  set _errorText(String? value) {
    _errorText = value;
  }

  String? get _errorText {
    final text = controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
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
                errorText: _errorText,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              height: 50,
              onPressed: () {
                if (controller.text.isEmpty || connecting) return;
                setState(() {
                  connecting = true;
                });
                PushUpSocketClient.tryConnect(controller.text).then((value) {
                  setState(() {
                    connecting = false;
                  });
                  if (value == null) {
                    setState(() {
                      _errorText = "Can not connect to this address";
                    });
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PushupPressPage()));
                  }
                });
              },
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
