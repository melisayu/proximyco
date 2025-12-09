import 'package:flutter/material.dart';

import 'theme_extension.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF53734D)),
    useMaterial3: true,
    extensions: const [
      ProximycoTheme(
        primaryBrand: Color(0xFF53734D),
        primaryBrandLight: Color(0xFF5C7D5A),
        accentColor: Color(0xFF53734D),
        primaryTextColor: Colors.black87,
        secondaryTextColor: Colors.black54,
        cardColor: Colors.white,
        borderColor: Color(0xFFE4E4E4),
      ),
    ],
  );
}
