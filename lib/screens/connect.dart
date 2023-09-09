import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/blocs/blocs.dart';
import 'package:pushup_presser/screens/pushup.dart';
import 'package:pushup_presser/socket/socket_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushupConnectPage extends StatefulWidget {
  const PushupConnectPage({super.key});

  @override
  State<PushupConnectPage> createState() => _PushupConnectPageState();
}

class _PushupConnectPageState extends State<PushupConnectPage> {
  TextEditingController controller = TextEditingController();
  SharedPreferences sharedPreferences = GetIt.instance.get<SharedPreferences>();

  bool connecting = false;

  @override
  void initState() {
    GetIt.instance.allowReassignment = true;
    GetIt.instance.registerSingleton(Blocs());
    controller.text = sharedPreferences.getString("addr") ?? "";

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (controller.text.isNotEmpty) {
        handleOnPress();
      }
    });

    super.initState();
  }

  void handleOnPress() {
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
          errorText = "Can not connect to this address";
        });
      } else {
        GetIt.instance.registerSingleton<PushUpSocketClient>(
          value,
        );
        value.startListen();
        sharedPreferences.setString("addr", controller.text);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const PushupPressPage()));
      }
    });
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
              onPressed: handleOnPress,
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
