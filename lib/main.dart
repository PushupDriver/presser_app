import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pushup_presser/screens/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.instance.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());

  runApp(const PushupPresser());
}

class PushupPresser extends StatelessWidget {
  const PushupPresser({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const PushupConnectPage(),
    );
  }
}
