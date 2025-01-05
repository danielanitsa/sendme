import 'package:chatapp/utils/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  dynamic _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final fullname = _fullnameController.text.trim();

      setState(() {
        _isButtonDisabled = true; // Disable the button
      });

      try {
        await AuthController.to.signUp(context, email, password, fullname);
      } finally {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // iconTheme:
          //     IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          // backgroundColor: Theme.of(context).colorScheme.primary,
          // title: Text(
          //   'Signup',
          //   // style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          // ),
          ),
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
                    "Welcome to SendMe!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _fullnameController,
                    decoration: InputDecoration(
                      labelText: "Fullname",
                      filled: true,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      border: const UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your fullname';
                      }
                      return null;
                    },
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
                      'Sign up',
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
                      'Sign in',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text('Or continue with',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton.filledTonal(
                          onPressed: () {},
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
