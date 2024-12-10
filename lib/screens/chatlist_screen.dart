import 'package:chatapp/utils/globals.dart' as globals;
import 'package:flutter/material.dart';

class Chatlistscreen extends StatelessWidget {
  const Chatlistscreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => const Chatlistscreen());
  }

  Future<void> _signout() async {
    await globals.account.deleteSession(sessionId: 'current');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("List of Chats"),
          FilledButton(onPressed: _signout, child: const Text("Sign out!"))
        ],
      ),
    ));
  }
}
