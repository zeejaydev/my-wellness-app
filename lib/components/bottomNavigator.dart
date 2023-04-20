import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomBottomNavigator extends StatefulWidget {
  final int screenIndex;
  final Function onTap;
  const CustomBottomNavigator(
      {required this.screenIndex, required this.onTap, super.key});

  @override
  State<CustomBottomNavigator> createState() => _CustomBottomNavigatorState();
}

class _CustomBottomNavigatorState extends State<CustomBottomNavigator> {
  int get _screenIndex => widget.screenIndex;
  Function get _onTap => widget.onTap;

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.groups,
    Icons.food_bank_rounded,
    Icons.person_rounded,
  ];

  List<String> tabTitles = [
    'Home',
    ' Social',
    'Nutrition',
    'Account',
  ];

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        margin: !Platform.isIOS
            ? EdgeInsets.fromLTRB(
                displayWidth * .03, 0, displayWidth * .03, displayHeight * .03)
            : EdgeInsets.symmetric(horizontal: displayWidth * .03),
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xff192126),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              _onTap(index);
              HapticFeedback.lightImpact();
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == _screenIndex
                      ? displayWidth * .32
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == _screenIndex ? displayWidth * .12 : 0,
                    width: index == _screenIndex ? displayWidth * .32 : 0,
                    decoration: BoxDecoration(
                      color: index == _screenIndex
                          ? const Color(0xffbbf246)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == _screenIndex
                      ? displayWidth * .31
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == _screenIndex ? displayWidth * .12 : 0,
                          ),
                          if (index == _screenIndex)
                            AnimatedOpacity(
                              opacity: index == _screenIndex ? 1 : 0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                tabTitles[index],
                                style: const TextStyle(
                                  color: Color(0xff192126),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == _screenIndex ? displayWidth * .03 : 20,
                          ),
                          Icon(
                            listOfIcons[index],
                            size: displayWidth * .076,
                            color: index == _screenIndex
                                ? const Color(0xff192126)
                                : Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
