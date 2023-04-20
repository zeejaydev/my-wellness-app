import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simplii_fitness/components/imageCarousel.dart';
import 'package:simplii_fitness/components/weekPlan.dart';
import 'package:simplii_fitness/services/auth.dart';

import '../../styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  String displayName = '';

  @override
  void initState() {
    super.initState();
    String? name = _auth.getCurrentUser()?.displayName;
    setState(() {
      displayName = name != null && name != ''
          ? name
          : "🤨 Stranger (update your name in profile)";
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String greeting = date.hour >= 0 && date.hour <= 12
        ? "Good Morning 🏃🏻‍♂️"
        : date.hour >= 12 && date.hour <= 17
            ? "Good afternoon 🔥"
            : "Good Evning 🌙";
    return SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    greeting,
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text(
                      displayName,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.black)),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3, top: 5, left: 8),
              child: Text(
                'Workout Videos',
                style:
                    GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            const ImageCarousel(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'This Week Plan',
                style:
                    GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const WeekPlan()
          ],
        ));
  }
}
