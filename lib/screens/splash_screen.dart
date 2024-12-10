import 'package:appwrite/models.dart';
import 'package:chatapp/screens/chatlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/signin_screen.dart';
import 'package:chatapp/utils/globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);

    try {
      final User isAuthenticated = await globals.account.get();
      if (!mounted) return;

      if (isAuthenticated != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Chatlistscreen()),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          SignInScreen.route(),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        SignInScreen.route(),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
