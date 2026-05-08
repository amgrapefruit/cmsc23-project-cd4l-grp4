//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
// commented some import so i can check the ui

import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/landing_page.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';



// Dummy providers (no Firebase yet)
class DummyFoodItemsProvider extends ChangeNotifier {}
class DummyUserProvider extends ChangeNotifier {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase is commented out for UI testing
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DummyFoodItemsProvider()),
      ChangeNotifierProvider(create: (context) => DummyUserProvider()),
    ], 
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      initialRoute: '/main',   // Start in mainscreen
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
       
      },
    );
  }
}