import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ordo_colors.dart';
import 'ordo_radius.dart';
import 'ordo_typography.dart';

/// Tema Material 3 do Ordo.
///
/// Não tenta replicar Material — usa só o esqueleto para que `Scaffold`,
/// `MaterialApp` e widgets nativos peguem as cores e fontes certas. A
/// maioria das telas é construída com widgets próprios usando direto os
/// tokens em `OrdoColors`, `OrdoTypography`, etc.
class OrdoTheme {
  const OrdoTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: OrdoColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: OrdoColors.lime,
        primary: OrdoColors.ink,
        onPrimary: OrdoColors.bone,
        secondary: OrdoColors.lime,
        onSecondary: OrdoColors.ink,
        surface: OrdoColors.paper,
        onSurface: OrdoColors.ink,
        error: OrdoColors.red,
        onError: OrdoColors.bone,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.dmSansTextTheme().apply(
        bodyColor: OrdoColors.fg1,
        displayColor: OrdoColors.fg1,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: OrdoColors.bone,
        foregroundColor: OrdoColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: OrdoColors.paper,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OrdoRadius.md),
          side: const BorderSide(color: OrdoColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: OrdoColors.border,
        thickness: 1,
        space: 0,
      ),
      iconTheme: const IconThemeData(color: OrdoColors.fg2, size: 20),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: OrdoColors.paper,
        surfaceTintColor: OrdoColors.paper,
        modalBackgroundColor: OrdoColors.paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(OrdoRadius.lg)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: OrdoColors.ink,
        contentTextStyle: OrdoTypography.body(color: OrdoColors.bone),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OrdoRadius.md),
        ),
      ),
    );
  }
}
