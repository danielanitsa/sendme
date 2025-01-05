import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:chatapp/models/user_document.dart';
import 'package:chatapp/screens/chatlist_screen.dart';
import 'package:chatapp/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late Account account;
  late Databases db;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Rx<User?> currentUser = Rx<User?>(null);

  void initAccount(Client client) {
    account = Account(client);
  }

  void initDb(Client client) {
    db = Databases(client);
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
          email: email,
          password: password); // Create session for the useruserId);
      await checkAuth(); // Update current user after login
      _showSnackBar(context, 'Success', 'Login successful', Colors.green);
    } catch (e) {
      _handleError(context, e, 'Login failed');
    }
  }

  Future<void> signUp(BuildContext context, String email, String password,
      String fullname) async {
    try {
      // Step 1: Create the user account
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullname,
      );

      // Step 2: Login the user
      await login(context, email, password);

      // Step 3: Create user document with proper error handling
      if (currentUser.value != null) {
        try {
          final userDoc = UserDocument.fromAuthUser(currentUser.value!);

          // Check if user document already exists
          final doesUserExist = await db.listDocuments(
            databaseId: dotenv.env['DATABASE_ID']!,
            collectionId: dotenv.env['COLLECTION_ID']!,
            queries: [
              Query.equal('id', userDoc.id),
            ], // Use the same ID as Auth user
          );

          if (doesUserExist.documents.isNotEmpty) {
            print('User document already exists, skipping creation.');
            return; // Exit if user document already exists
          }

          // Create document with the same ID as Auth user
          await db.createDocument(
            databaseId: dotenv.env['DATABASE_ID']!,
            collectionId: dotenv.env['COLLECTION_ID']!,
            documentId: userDoc.id, // Use the same ID as Auth user
            data: userDoc.toJson(),
          );
        } catch (dbError) {
          // Handle database error separately to not affect the sign-up process
          print('Error creating user document: $dbError');
          _showSnackBar(context, 'Warning',
              'Account created but profile setup incomplete', Colors.orange);
          return;
        }
      }

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
    if (context.mounted) {
      // Check if the context is still mounted
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            '$title: $message',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: color,
        ),
      );
    }
  }

  Future<void> signInWithProvider(
    BuildContext context, {
    required OAuthProvider provider,
  }) async {
    try {
      // Step 1: Create an OAuth session
      await account.createOAuth2Session(
        provider: provider,
        scopes: ['email', 'profile'],
      );

      // Step 2: Check current authentication status
      await checkAuth(); // Ensures `currentUser` is updated

      if (currentUser.value != null) {
        final userDoc = UserDocument.fromAuthUser(currentUser.value!);

        // Step 3: Check if the user document already exists
        final doesUserExist = await db.listDocuments(
          databaseId: dotenv.env['DATABASE_ID']!,
          collectionId: dotenv.env['COLLECTION_ID']!,
          queries: [
            Query.equal('id', userDoc.id),
          ],
        );

        if (doesUserExist.documents.isNotEmpty) {
          print('User document already exists, skipping creation.');
        } else {
          // Step 4: Create user document if it doesn't exist
          await db.createDocument(
            databaseId: dotenv.env['DATABASE_ID']!,
            collectionId: dotenv.env['COLLECTION_ID']!,
            documentId: userDoc.id,
            data: userDoc.toJson(),
          );
        }
      }

      // Step 5: Notify the user of success
      _showSnackBar(context, 'Success', 'Login successful', Colors.green);
    } on AppwriteException catch (e) {
      // Handle OAuth errors gracefully
      _handleError(
          context, e.message.toString(), "Failed to sign in with provider");
    } catch (e) {
      print('Unexpected error: $e');
      _showSnackBar(context, 'Error', 'Something went wrong', Colors.red);
    }
  }
}
