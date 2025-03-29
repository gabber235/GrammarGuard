import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Catppuccin Latte Colors
  static const Color latteRosewater = Color(0xFFDC8A78);
  static const Color latteFlamingo = Color(0xFFDD7878);
  static const Color lattePink = Color(0xFFEA76CB);
  static const Color latteMauve = Color(0xFF8839EF);
  static const Color latteRed = Color(0xFFD20F39);
  static const Color latteMaroon = Color(0xFFE64553);
  static const Color lattePeach = Color(0xFFFE640B);
  static const Color latteYellow = Color(0xFFDF8E1D);
  static const Color latteGreen = Color(0xFF40A02B);
  static const Color latteTeal = Color(0xFF179299);
  static const Color latteSky = Color(0xFF04A5E5);
  static const Color latteSapphire = Color(0xFF209FB5);
  static const Color latteBlue = Color(0xFF1E66F5);
  static const Color latteLavender = Color(0xFF7287FD);
  static const Color latteText = Color(0xFF4C4F69);
  static const Color latteSubtext1 = Color(0xFF5C5F77);
  static const Color latteSubtext0 = Color(0xFF6C6F85);
  static const Color latteOverlay2 = Color(0xFF7C7F93);
  static const Color latteOverlay1 = Color(0xFF8C8FA1);
  static const Color latteOverlay0 = Color(0xFF9CA0B0);
  static const Color latteSurface2 = Color(0xFFACB0BE);
  static const Color latteSurface1 = Color(0xFFBCC0CC);
  static const Color latteSurface0 = Color(0xFFCCD0DA);
  static const Color latteBase = Color(0xFFEFF1F5);
  static const Color latteMantle = Color(0xFFE6E9EF);
  static const Color latteCrust = Color(0xFFDCE0E8);

  // Catppuccin Mocha Colors
  static const Color mochaRosewater = Color(0xFFF5E0DC);
  static const Color mochaFlamingo = Color(0xFFF2CDCD);
  static const Color mochaPink = Color(0xFFF5C2E7);
  static const Color mochaMauve = Color(0xFFCBA6F7);
  static const Color mochaRed = Color(0xFFF38BA8);
  static const Color mochaMaroon = Color(0xFFEBA0AC);
  static const Color mochaPeach = Color(0xFFFAB387);
  static const Color mochaYellow = Color(0xFFF9E2AF);
  static const Color mochaGreen = Color(0xFFA6E3A1);
  static const Color mochaTeal = Color(0xFF94E2D5);
  static const Color mochaSky = Color(0xFF89DCEB);
  static const Color mochaSapphire = Color(0xFF74C7EC);
  static const Color mochaBlue = Color(0xFF89B4FA);
  static const Color mochaLavender = Color(0xFFB4BEFE);
  static const Color mochaText = Color(0xFFCDD6F4);
  static const Color mochaSubtext1 = Color(0xFFBAC2DE);
  static const Color mochaSubtext0 = Color(0xFFA6ADC8);
  static const Color mochaOverlay2 = Color(0xFF9399B2);
  static const Color mochaOverlay1 = Color(0xFF7F849C);
  static const Color mochaOverlay0 = Color(0xFF6C7086);
  static const Color mochaSurface2 = Color(0xFF585B70);
  static const Color mochaSurface1 = Color(0xFF45475A);
  static const Color mochaSurface0 = Color(0xFF313244);
  static const Color mochaBase = Color(0xFF1E1E2E);
  static const Color mochaMantle = Color(0xFF181825);
  static const Color mochaCrust = Color(0xFF11111B);

  // Light theme (Catppuccin Latte)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: latteBlue,
      secondary: latteLavender,
      tertiary: latteGreen,
      error: latteRed,
      surface: latteBase,
      onPrimary: latteBase,
      onSecondary: latteBase,
      onError: latteBase,
      onSurface: latteText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: latteBase,
      foregroundColor: latteText,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: latteBase,
        backgroundColor: latteBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: latteSurface0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: latteBlue, width: 2),
      ),
      filled: true,
      fillColor: latteSurface0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: latteSurface0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: ListTileThemeData(
      textColor: latteText,
      selectedColor: latteBlue,
      selectedTileColor: latteSurface0,
      tileColor: latteSurface0,
    ),
  );

  // Dark theme (Catppuccin Mocha)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: mochaBlue,
      secondary: mochaLavender,
      tertiary: mochaGreen,
      error: mochaRed,
      surface: mochaBase,
      onPrimary: mochaBase,
      onSecondary: mochaBase,
      onError: mochaBase,
      onSurface: mochaText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: mochaBase,
      foregroundColor: mochaText,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: mochaBase,
        backgroundColor: mochaBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: mochaSurface0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: mochaBlue, width: 2),
      ),
      filled: true,
      fillColor: mochaSurface0,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: mochaSurface0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    listTileTheme: ListTileThemeData(
      textColor: mochaText,
      selectedColor: mochaBlue,
      selectedTileColor: mochaSurface0,
      tileColor: mochaSurface0,
    ),
  );
}
