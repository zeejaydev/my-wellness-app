import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simplii_fitness/screens/auth/authenticate.dart';
import 'package:simplii_fitness/screens/screensNavigator.dart';
import 'package:simplii_fitness/services/auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (kDebugMode) {
            print("waiting");
          }
          return const CircularProgressIndicator();
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: snapshot.hasData
                ? const ScreensNavigator()
                : const Authenticate(),
          );
        }
      },
    );
  }
}
