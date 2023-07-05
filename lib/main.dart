import 'package:flutter/material.dart';
import 'package:pushup_presser/screens/connect.dart';

void main() {
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
