import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ordo_colors.dart';

/// Famílias e escala tipográfica do Ordo.
///
/// - Display: Space Grotesk — H1/H2, números grandes, label de marca.
/// - Body: DM Sans — copy corrida, botões, labels.
/// - Mono: JetBrains Mono — número de OS, valores, IMEI, placa.
///
/// Fallback nativo aceitável caso offline (`system-ui, sans-serif`).
class OrdoTypography {
  const OrdoTypography._();

  // ────────── Type scale (mobile-first) ──────────
  static const double xxs = 10;
  static const double xs = 11;
  static const double sm = 13;
  static const double base = 15;
  static const double md = 17;
  static const double lg = 20;
  static const double xl = 24;
  static const double xl2 = 32;
  static const double xl3 = 40;
  static const double xl4 = 56;

  // ────────── Famílias ──────────
  static TextStyle display({
    double size = lg,
    FontWeight weight = FontWeight.w700,
    Color color = OrdoColors.fg1,
    double letterSpacing = -0.015,
    double height = 1.15,
  }) {
    return GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: size * letterSpacing,
      height: height,
    );
  }

  static TextStyle body({
    double size = base,
    FontWeight weight = FontWeight.w400,
    Color color = OrdoColors.fg1,
    double height = 1.5,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.dmSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle mono({
    double size = sm,
    FontWeight weight = FontWeight.w500,
    Color color = OrdoColors.fg1,
    double letterSpacing = -0.01,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: size * letterSpacing,
    );
  }

  // ────────── Classes semânticas ──────────
  static TextStyle hDisplay = display(size: xl3, weight: FontWeight.w700);
  static TextStyle h1 = display(size: xl2, weight: FontWeight.w700);
  static TextStyle h2 = display(size: xl, weight: FontWeight.w600, height: 1.3);
  static TextStyle h3 = display(size: lg, weight: FontWeight.w600, height: 1.3);

  static TextStyle p = body();
  static TextStyle pSm =
      body(size: sm, color: OrdoColors.fg2);
  static TextStyle label = body(
    size: sm,
    weight: FontWeight.w500,
    color: OrdoColors.fg2,
  );
  static TextStyle eyebrow = body(
    size: xxs,
    weight: FontWeight.w600,
    color: OrdoColors.fg3,
    letterSpacing: 0.08 * xxs,
  ).copyWith(
    fontFeatures: const [],
  );

  static TextStyle monoBase = mono();
}
