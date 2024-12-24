import 'package:appwrite/enums.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:chatapp/utils/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const SignInScreen(),
    );
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  dynamic _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      setState(() {
        _isButtonDisabled = true; // Disable the button
      });

      try {
        await AuthController.to.login(context, email, password);
        print('Email: $email');
        print('Password: $password');
      } catch (e) {
        print('Failed to submit form: $e');
      } finally {
        setState(() {
          _isButtonDisabled = false; // Re-enable the button in all cases
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset(
                      'assets/images/logo.webp',
                      color: Theme.of(context).colorScheme.primary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "Welcome back",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: const UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: const UnderlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _isButtonDisabled ? null : _submitForm,
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).colorScheme.primary,
                      ),

                      minimumSize: const WidgetStatePropertyAll(
                          Size(double.infinity, 50)), // Directly sets height
                    ),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()));
                    },
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                          Size(double.infinity, 50)), // Directly sets height
                    ),
                    child: const Text(
                      'Create account',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text('Or continue with',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                          onPressed: () => AuthController.to.signInWithProvider(
                              context,
                              provider: OAuthProvider.google),
                          icon: const FaIcon(FontAwesomeIcons.google)),
                      const SizedBox(width: 10),
                      IconButton.filledTonal(
                          onPressed: () {},
                          icon: FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
