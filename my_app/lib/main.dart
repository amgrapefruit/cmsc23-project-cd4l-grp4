import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
import 'package:flutter/material.dart';

// screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/interest_selection_page.dart';
import 'screens/landing_page.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'package:my_app/screens/verification_screen.dart';

// providers
import 'package:my_app/provider/auth_provider.dart';
import 'package:my_app/provider/food_provider.dart';
import "package:provider/provider.dart";

class DummyFoodItemsProvider extends ChangeNotifier {}
class DummyUserProvider extends ChangeNotifier {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MultiProvider(
    providers: [
      // TODO: create and add provider
      ChangeNotifierProvider(create: (context) => FoodProvider()), // food items provider
      ChangeNotifierProvider(create: (context) => AuthProvider()), // user provider
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
      initialRoute: '/home',   // Start in mainscreen
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/interests': (context) => const InterestSelectionScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
        '/home': (context) => const HomeScreen(),
        '/verification': (context) => const VerificationScreen(),
      },
    );
  }
}