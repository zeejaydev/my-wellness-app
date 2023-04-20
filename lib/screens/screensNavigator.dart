import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simplii_fitness/components/BottomNavigator.dart';
import 'package:simplii_fitness/screens/Home/homeScreen.dart';
import 'package:simplii_fitness/screens/food/foodScreen.dart';
import 'package:simplii_fitness/screens/profile/profileScreen.dart';
import 'package:simplii_fitness/screens/social/socialScreen.dart';
import 'package:simplii_fitness/styles.dart';

class ScreensNavigator extends StatefulWidget {
  const ScreensNavigator({super.key});
  @override
  State<ScreensNavigator> createState() => _ScreensNavigatorState();
}

class _ScreensNavigatorState extends State<ScreensNavigator> {
  int _selectedScreen = 0;

  static const List<Widget> _routes = <Widget>[
    HomeScreen(),
    SocialScreen(),
    FoodScreen(),
    ProfileScreen(),
  ];

  ontap(int screenChoice) {
    setState(() {
      _selectedScreen = screenChoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: _routes.elementAt(_selectedScreen),
          // extendBodyBehindAppBar: true,
          extendBody: true,
          bottomNavigationBar: CustomBottomNavigator(
            screenIndex: _selectedScreen,
            onTap: ontap,
          )),
    );
  }
}
