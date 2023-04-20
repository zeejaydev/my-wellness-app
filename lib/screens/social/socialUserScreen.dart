import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplii_fitness/screens/social/workoutBuilderView.dart';
import 'package:simplii_fitness/screens/social/workoutsView.dart';
import 'package:simplii_fitness/services/auth.dart';
import 'package:simplii_fitness/services/database.dart';
import 'package:simplii_fitness/styles.dart';

class SocialUserScreen extends StatefulWidget {
  final DatabaseService database;
  final String uuid;
  final String userName;
  final String userPic;
  final User? currentUser;
  const SocialUserScreen(
      {required this.database,
      required this.uuid,
      required this.userName,
      required this.userPic,
      required this.currentUser,
      super.key});

  @override
  State<SocialUserScreen> createState() => _SocialUserScreenState();
}

class _SocialUserScreenState extends State<SocialUserScreen>
    with TickerProviderStateMixin {
  DatabaseService get _database => widget.database;
  String get _uuid => widget.uuid;
  String get _userName => widget.userName;
  String get _userPic => widget.userPic;
  User? get _currentUser => widget.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _userName,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: textColor,
        foregroundColor: green,
      ),
      floatingActionButton: _uuid == _currentUser!.uid
          ? FloatingActionButton(
              backgroundColor: green,
              child: const Icon(
                Icons.add,
                color: textColor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkoutBuilderView(
                              database: _database,
                            )));
              },
            )
          : null,
      body: _currentUser == null
          ? Container()
          : WorkoutsView(
              database: _database,
              currentUser: _currentUser!,
              userPic: _userPic,
              uuid: _uuid),
    );
  }
}
