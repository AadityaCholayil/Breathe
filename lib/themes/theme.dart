import 'package:flutter/material.dart';

class CustomTheme {
  static Color get bg => const Color(0xFFFBFBFB);

  static Color get onBg => const Color(0xFFF6F6F6);

  static Color get bg2 => const Color(0xFFF3F3F3);

  static Color get card => const Color(0xFFFFFFFF);

  static Color get t1 => const Color(0xFF000000);

  static Color get t2 => const Color(0xFF818181);

  static Color get t3 => const Color(0xFFFFFFFF);

  static Color get accent => const Color(0xFFE50914);

  static Color get onAccent => const Color(0xFFFFFFFF);

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

  static ThemeData getTheme(BuildContext context) {
    return ThemeData.from(
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Montserrat',
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
