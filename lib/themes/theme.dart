import 'package:flutter/material.dart';

class CustomTheme {
  static Color get bg => const Color(0xFFF3FBFF);

  static Color get card => const Color(0xFFFFFFFF);

  static Color get onAccent => const Color(0xFFFFFFFF);

  static Color get accent => const Color(0xFF0DAEFF);

  static Color get t1 => const Color(0xFF000000);

  static Color get t2 => const Color(0xFF979797);


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
