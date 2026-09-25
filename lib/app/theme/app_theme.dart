import 'package:flutter/material.dart';

/// Palette : vert émeraude profond, or doux, fond crème (clair) ou
/// presque noir (sombre, pour la lecture de nuit).
abstract final class AppColors {
  static const emerald = Color(0xFF0E6B55);
  static const emeraldLight = Color(0xFF5CC9A7);
  static const gold = Color(0xFFB8893B);
  static const goldLight = Color(0xFFE0B866);
  static const cream = Color(0xFFFAF7F0);
  static const night = Color(0xFF0E1412);
  static const nightSurface = Color(0xFF16201D);
}

const uiFontFamily = 'IBMPlexSansArabic';
const quranFontFamily = 'AmiriQuran';

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.emerald, brightness: brightness)
      .copyWith(
        primary: isDark ? AppColors.emeraldLight : AppColors.emerald,
        tertiary: isDark ? AppColors.goldLight : AppColors.gold,
        surface: isDark ? AppColors.night : AppColors.cream,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: uiFontFamily,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      centerTitle: true,
      scrolledUnderElevation: 1,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: isDark ? AppColors.nightSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      margin: EdgeInsets.zero,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? AppColors.nightSurface : Colors.white,
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontFamily: uiFontFamily, fontSize: 12, color: scheme.onSurface),
      ),
    ),
    listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.symmetric(horizontal: 20)),
  );
}
