import 'package:chatapp/utils/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    // Trigger a delay to simulate a loading state
    Future.delayed(const Duration(seconds: 2), () {
      // Check and fire the initial route
      authController.fireRoute(authController.currentUser.value != null);
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Spinner widget
      ),
    );
  }
}
