import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:day32/firebase_options.dart';
import 'package:day32/screens/home_screen.dart';
import 'package:day32/screens/login_screen.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before Firebase init
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Use StreamBuilder with authStateChanges for route protection
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If user is authenticated, show HomeScreen
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
          }

          // If user is not authenticated, show LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}

