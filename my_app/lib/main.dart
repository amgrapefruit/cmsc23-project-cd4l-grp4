//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
// commented some import so i can check the auth ui

import 'package:flutter/material.dart';
import "package:provider/provider.dart";


import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';


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
      // TODO: create and add provider
      ChangeNotifierProvider(create: (context) => null), // food items provider
      ChangeNotifierProvider(create: (context) => null), // user provider
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
        // taken from Exer 8 and 9
        // can be changed
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      initialRoute: '/login', // Set to login so it doesn't start at a blank root
routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => SignupScreen(),
       
      },
    );
  }
}