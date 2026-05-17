import 'package:flutter/material.dart';

/// Sistema de elevação Ordo.
///
/// Sombras suaves em camadas, nunca difusas. Inner shadows usados apenas
/// em inputs no foco (recriado via decoration na widget).
class OrdoShadows {
  const OrdoShadows._();

  /// Cards estáticos.
  static List<BoxShadow> sm = const [
    BoxShadow(color: Color(0x0A0F1115), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// Cards interativos em hover / pressed.
  static List<BoxShadow> md = const [
    BoxShadow(color: Color(0x0F0F1115), offset: Offset(0, 4), blurRadius: 12),
    BoxShadow(color: Color(0x0A0F1115), offset: Offset(0, 1), blurRadius: 2),
  ];

  /// Modal, popover.
  static List<BoxShadow> lg = const [
    BoxShadow(color: Color(0x1A0F1115), offset: Offset(0, 12), blurRadius: 32),
    BoxShadow(color: Color(0x0F0F1115), offset: Offset(0, 2), blurRadius: 6),
  ];

  /// Bottom sheet, dialog crítico.
  static List<BoxShadow> xl = const [
    BoxShadow(color: Color(0x290F1115), offset: Offset(0, 24), blurRadius: 64),
  ];

  /// FAB lime.
  static List<BoxShadow> fab = [
    const BoxShadow(
      color: Color(0x380F1115),
      offset: Offset(0, 12),
      blurRadius: 24,
    ),
    const BoxShadow(
      color: Color(0x1A0F1115),
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];
}
