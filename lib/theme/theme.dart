import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color mainColor = Color(0xff000633);
  static Color bgColor = Color(0xff070706);
  static Color accentColor = Color(0xff0065ff);

  //card
  static List<Color> cardsColor = [
    Colors.white,
    Colors.red.shade100,
    Colors.blueGrey.shade300,
    Colors.pink.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
  ];

  //textStyle

  static TextStyle mainTitle =
      GoogleFonts.roboto(fontSize: 18.0, fontWeight: FontWeight.bold);
  static TextStyle mainContent =
      GoogleFonts.roboto(fontSize: 16.0, fontWeight: FontWeight.normal);
  static TextStyle dateTitle =
      GoogleFonts.roboto(fontSize: 13.0, fontWeight: FontWeight.w500);
}
