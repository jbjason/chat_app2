import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<Color> colorsList = [
  const Color(0xffe91e63),
  const Color(0xFF8F90F3),
  const Color(0xFF9C27B0),
  const Color(0xFF795548),
  const Color(0xFF14162D),
  const Color(0xff4caf50),
  const Color(0xFF00BCD4),
  const Color(0xff000000),
  const Color(0xFF009688),
  const Color(0xff3f51b5),
  const Color(0xff2196f3),
  const Color(0xFFFFFFFF),
  const Color(0xFF9E9E9E),
];

TextStyle getTextStyle(int i, Color textColor, TextDecoration dec) {
  List<TextStyle> _style = [
    GoogleFonts.zenDots(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.dancingScript(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.nerkoOne(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.kenia(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.satisfy(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.lobster(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.kenia(color: textColor, fontSize: 24, decoration: dec),
    GoogleFonts.caveat(color: textColor, fontSize: 24, decoration: dec),
  ];
  return _style[i];
}

SnackBar getSnackBar(String title, Color color) {
  return SnackBar(
    backgroundColor: Colors.transparent,
    duration: const Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    shape: const StadiumBorder(),
    content: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(colors: [
            color,
            color.withOpacity(.6),
            color.withOpacity(.4),
            //Colors.grey[800]!,
            // Colors.grey,
            // Colors.grey[300]!,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        )),
  );
}
