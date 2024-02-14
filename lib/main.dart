import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/spalsh_screen.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}



