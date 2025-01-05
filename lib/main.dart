import 'package:appwrite/appwrite.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:chatapp/util.dart';
import 'package:chatapp/utils/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Appwrite Client
  GlobalKey<ScaffoldMessengerState>();

  await dotenv.load(fileName: ".env");

  Client client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject(dotenv.env['PROJECT_ID']);
  // .setProject("67506d50000ed831ccff");

  // Initialize AuthController
  final authController = Get.put(AuthController());
  authController.initAccount(client);
  authController.initDb(client);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto Flex", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return GetMaterialApp(
      scaffoldMessengerKey: AuthController.to.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.dark,
      home: SplashScreen(),
    );
  }
}
