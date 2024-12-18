import 'package:chatapp/utils/auth_controller.dart';
import 'package:flutter/material.dart';

class Chatlistscreen extends StatelessWidget {
  const Chatlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("List of Chats"),
          FilledButton(
              onPressed: () => AuthController.to.logout(),
              child: const Text("Sign out!"))
        ],
      ),
    ));
  }
}
