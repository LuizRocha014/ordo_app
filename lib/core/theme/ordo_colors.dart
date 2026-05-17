import 'package:flutter/material.dart';

/// Cores do design system Ordo.
///
/// Espelha os tokens definidos em `colors_and_type.css` do design system.
/// Regra principal: lime (`#D6F24E`) é o acento e aparece **uma vez por
/// tela**, sempre pareado com Ink. Nunca usar lime em gradiente ou área
/// extensa.
class OrdoColors {
  const OrdoColors._();

  // ────────── Foundation ──────────
  static const Color bone = Color(0xFFF6F4EE);
  static const Color paper = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF0F1115);

  // ────────── Slate (neutral scale) ──────────
  static const Color slate950 = Color(0xFF0F1115);
  static const Color slate900 = Color(0xFF1C1F26);
  static const Color slate800 = Color(0xFF2A2F3D);
  static const Color slate700 = Color(0xFF3A3F4B);
  static const Color slate500 = Color(0xFF6B7280);
  static const Color slate400 = Color(0xFF9CA3AF);
  static const Color slate300 = Color(0xFFD1D5DB);
  static const Color slate200 = Color(0xFFE5E7EB);
  static const Color slate100 = Color(0xFFF1F0EB);

  // ────────── Brand accent ──────────
  static const Color lime = Color(0xFFD6F24E);
  static const Color limeSoft = Color(0xFFECF7B6);

  // ────────── Funcionais ──────────
  static const Color blue = Color(0xFF2A6FDB);
  static const Color blueSoft = Color(0xFFE2ECFA);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberSoft = Color(0xFFFCEBC9);
  static const Color violet = Color(0xFF7C5CFC);
  static const Color violetSoft = Color(0xFFE6DEFE);
  static const Color green = Color(0xFF16A34A);
  static const Color greenSoft = Color(0xFFD4EFDC);
  static const Color red = Color(0xFFDC2626);
  static const Color redSoft = Color(0xFFF8D7D7);

  // ────────── Semantic ──────────
  static const Color bg = bone;
  static const Color surface = paper;
  static const Color fg1 = ink;
  static const Color fg2 = slate700;
  static const Color fg3 = slate500;
  static const Color fgOnInk = bone;
  static const Color fgOnLime = ink;
  static const Color border = slate200;
  static const Color borderStrong = slate300;
  static const Color accent = lime;
}
