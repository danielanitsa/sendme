import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:chatapp/screens/chatlist_screen.dart';
import 'package:chatapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late Account account;

  Rx<User?> currentUser = Rx<User?>(null);

  void initAccount(Client client) {
    account = Account(client);
  }

  static AuthController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
    // Check initial authentication state
    checkAuth();
    // Listen to changes in authentication state
    ever(currentUser, (user) => fireRoute(user != null));
  }

  // Check if user is logged in and update the state
  Future<void> checkAuth() async {
    try {
      final user = await account.get();
      print(
          "User fetched successfully: ${user.name}"); // Try to get the current user
      currentUser.value = user; // Set the current user
    } catch (e) {
      currentUser.value = null; // If there's an error, set currentUser to null
    }
  }

  // Login method
  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      await account.createEmailPasswordSession(
          email: email, password: password); // Create session for the user
      await checkAuth(); // Update current user after login
      _showSnackBar(context, 'Success', 'Login successful', Colors.green);
    } catch (e) {
      _handleError(context, e, 'Login failed');
    }
  }

  // Sign-up method
  Future<void> signUp(BuildContext context, String email, String password,
      String fullname) async {
    try {
      await account.create(
          userId: ID.unique(),
          email: email,
          password: password,
          name: fullname); // Create the user in Appwrite
      await login(
          context, email, password); // Automatically log in after sign-up
      _showSnackBar(
          context, 'Success', 'Account created successfully', Colors.green);
    } catch (e) {
      _handleError(context, e, 'Sign-up failed');
    }
  }

  // Logout method
  Future<void> logout(BuildContext context) async {
    try {
      await account.deleteSession(
          sessionId: 'current'); // Delete the current session
      currentUser.value = null; // Clear the current user
      _showSnackBar(context, 'Success', 'Logout successful', Colors.green);
    } catch (e) {
      _handleError(context, e, 'Logout failed');
    }
  }

  // Fire route based on authentication status
  void fireRoute(bool logged) {
    if (logged) {
      Get.offAll(() => const Chatlistscreen()); // Redirect to ChatListScreen
    } else {
      Get.offAll(() => const SignInScreen()); // Redirect to SignInScreen
    }
  }

  // Error handling helper method
  void _handleError(
      BuildContext context, dynamic error, String defaultMessage) {
    String errorMessage = defaultMessage;

    // Handle specific Appwrite errors
    if (error is AppwriteException) {
      // Use a fallback if error.message is null
      errorMessage = error.message ?? defaultMessage;
    }

    _showSnackBar(context, 'Error', errorMessage, Colors.red);
  }

  // Standard Flutter SnackBar display
  void _showSnackBar(
      BuildContext context, String title, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title: $message',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
  }

  Future<void> signInWithProvider(BuildContext context,
      {required OAuthProvider provider}) async {
    try {
      final response = await account.createOAuth2Session(
          provider: provider, scopes: ['email', 'profile']);

      print(response); // Sign in with the selected provider
      await checkAuth(); // Update current user after login
      _showSnackBar(context, 'Success', 'Login successful', Colors.green);
    } on AppwriteException catch (e) {
      _handleError(
          context, e.message.toString(), "Failed to sign in with provider");
    }
  }
}
