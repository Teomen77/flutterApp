import 'package:applock/Pages/home_page.dart';
import 'package:applock/app_lock_list.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());

  await initAppLocking();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
