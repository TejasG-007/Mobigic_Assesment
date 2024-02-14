import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  navigateToHomeScreen() async =>
      await Future.delayed(const Duration(seconds: 2))
          .then((value) => Get.to(() => const HomeScreen()));

  @override
  void initState() {
    navigateToHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Text("Splash Screen",style: TextStyle(
            color: Colors.teal
          ),),
        ));
  }
}