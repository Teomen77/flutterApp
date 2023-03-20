import 'package:flutter/material.dart';

class LockApp extends StatelessWidget {
  const LockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LockScreen(),
    );
  }
}

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Lock Screen"),
    ));
  }
}
