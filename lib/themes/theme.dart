import 'package:flutter/material.dart';

class CustomTheme {
  static Color get cream => const Color(0xFFFFE6B7);

  static Color get cream70 => const Color(0xFFFFEEC8).withOpacity(0.7);

  static Color get cream15 => const Color(0xFFFFF7E2).withOpacity(0.15);

  static Color get brown => const Color(0xFF3A0E1D);

  static Color get maroon => const Color(0xFF6D270B);

  static Color get red => const Color(0xFFEC1F27);

  static Color get black => const Color(0xFF000000);

  static Color get white => const Color(0xFFFFFFFF);

  static Color get blue => const Color(0xFF30C9C8);

  static Color get yellow => const Color(0xFFFFDE83);

  static Color get greyBlue => const Color(0xFF23292E);
  
  static Color get green => const Color(0xFF00FF0A);

  // static Color get t3 => const Color(0xFFFFFFFF);
  //
  // static Color get accent => const Color(0xFFE50914);
  //
  // static Color get onAccent => const Color(0xFFFFFFFF);

  static ThemeData getTheme(BuildContext context) {
    return ThemeData.from(
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: 'Poppins',
      ),
      colorScheme: const ColorScheme.light().copyWith(
        // primary: accent,
        // onPrimary: t1,
        // background: bg,
        // surface: card,
      ),
    );
  }
}
