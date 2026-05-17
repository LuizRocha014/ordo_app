import 'package:flutter/animation.dart';

/// Tokens de animação Ordo.
///
/// Curva padrão `cubic-bezier(0.2, 0, 0, 1)` (Material standard easing).
/// Sem bounces, sem spring, sem confetti. Lime é a única "diversão".
class OrdoMotion {
  const OrdoMotion._();

  static const Curve easeStandard = Cubic(0.2, 0, 0, 1);

  static const Duration micro = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);
}
