import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    // TODO: create and add provider
    ChangeNotifierProvider(create: (context) => null), // food items provider
    ChangeNotifierProvider(create: (context) => null), // user provider
  ], child: const MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // taken from Exer 8 and 9
        // can be changed
        colorScheme: .fromSeed(seedColor: Colors.greenAccent),
      ),
      initialRoute: '/',
      routes: {
        // TODO: create routes (in screens folder)
      },
      home: null, // start screen
    );
  }
}