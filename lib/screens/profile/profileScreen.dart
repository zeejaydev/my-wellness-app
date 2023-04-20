import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplii_fitness/styles.dart';

import '../../services/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();
  bool _admin = false;

  @override
  void initState() {
    super.initState();
    _isAdmin();
  }

  Future _isAdmin() async {
    IdTokenResult? result = await _auth.getCurrentUser()?.getIdTokenResult();

    if (result != null &&
        result.claims != null &&
        result.claims!.containsKey('admin')) {
      setState(() {
        _admin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(_admin ? 'Admin' : 'user'),
              ElevatedButton(
                  onPressed: _auth.signOut, child: const Text('logout')),
            ],
          ),
        ),
      ),
    );
  }
}
