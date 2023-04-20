import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color translucentWhite(double amount) {
  return Color.fromARGB((255 * amount).round(), 255, 255, 255);
}

Color translucentBlack(double amount) {
  return Color.fromARGB((255 * amount).round(), 0, 0, 0);
}

const green = Color(0xffbbf246);
const background = Color(0xfff5f5f5);
String mDash = "\u2014";
String nDash = "\u2013";

const Color textColor = Color(0xff192126);

TextStyle subTitle = GoogleFonts.lato(
    fontSize: 16, fontWeight: FontWeight.w700, color: textColor);

TextStyle smallTitle = GoogleFonts.lato(
    fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black54);

TextStyle mediumRegularText = GoogleFonts.lato(
    fontSize: 14, fontWeight: FontWeight.w600, color: textColor);
