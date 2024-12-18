import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chatapp/screens/chatlist_screen.dart';
import 'package:chatapp/screens/signin_screen.dart';
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
      final user = await account.get(); // Try to get the current user
      currentUser.value = user; // Set the current user
    } catch (e) {
      currentUser.value = null; // If there's an error, set currentUser to null
      _handleError(e, 'Failed to check authentication');
    }
  }

  // Login method
  Future<void> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
          email: email, password: password); // Create session for the user
      await checkAuth(); // Update current user after login
      Get.snackbar('Success', 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColorLight);
    } catch (e) {
      _handleError(e, 'Login failed');
    }
  }

  // Sign-up method
  Future<void> signUp(String email, String password, String fullname) async {
    try {
      await account.create(
          userId: ID.unique(),
          email: email,
          password: password,
          name: fullname); // Create the user in Appwrite
      await login(email, password); // Automatically log in after sign-up
      Get.snackbar('Success', 'Account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColorLight);
    } catch (e) {
      _handleError(e, 'Sign-up failed');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await account.deleteSession(
          sessionId: 'current'); // Delete the current session
      currentUser.value = null; // Clear the current user
      Get.snackbar('Success', 'Logout successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColorLight);
    } catch (e) {
      _handleError(e, 'Logout failed');
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
  void _handleError(dynamic error, String defaultMessage) {
    String errorMessage = defaultMessage;

    // Handle specific Appwrite errors
    if (error is AppwriteException && error.message != null) {
      errorMessage = error.message!;
    }

    // Display the error to the user using a GetX snackbar
    Get.snackbar('Error', errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError);
  }
}
