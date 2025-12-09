import 'package:flutter/material.dart';

class ProximycoTheme extends ThemeExtension<ProximycoTheme> {
  final Color primaryBrand;
  final Color primaryBrandLight;

  final Color accentColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color cardColor;
  final Color borderColor;

  const ProximycoTheme({
    required this.primaryBrand,
    required this.primaryBrandLight,
    required this.accentColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  ProximycoTheme copyWith({
    Color? primaryBrand,
    Color? primaryBrandLight,
    Color? accentColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? cardColor,
    Color? borderColor,
  }) {
    return ProximycoTheme(
      primaryBrand: primaryBrand ?? this.primaryBrand,
      primaryBrandLight: primaryBrandLight ?? this.primaryBrandLight,
      accentColor: accentColor ?? this.accentColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      cardColor: cardColor ?? this.cardColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  ProximycoTheme lerp(ThemeExtension<ProximycoTheme>? other, double t) {
    if (other is! ProximycoTheme) return this;
    return ProximycoTheme(
      primaryBrand: Color.lerp(primaryBrand, other.primaryBrand, t)!,
      primaryBrandLight: Color.lerp(
        primaryBrandLight,
        other.primaryBrandLight,
        t,
      )!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      primaryTextColor: Color.lerp(
        primaryTextColor,
        other.primaryTextColor,
        t,
      )!,
      secondaryTextColor: Color.lerp(
        secondaryTextColor,
        other.secondaryTextColor,
        t,
      )!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}
