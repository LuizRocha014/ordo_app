import 'package:intl/intl.dart';

/// Formatadores PT-BR usados pela UI Ordo.
///
/// - `brl()` formata centavos como `R$ 1.250,00`.
/// - `relativeDay()` usa data curta (`14 mai`) ou relativa (`há 2h`).
/// - `dateTimeShort()` para timeline (`14 mai · 09:42`).
class OrdoFormatters {
  const OrdoFormatters._();

  static final NumberFormat _brl = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: r'R$',
    decimalDigits: 2,
  );

  static String brl(int cents) {
    return _brl.format(cents / 100);
  }

  /// `14 mai · 09:42` (PT-BR, sem ano).
  static String dateTimeShort(DateTime d) {
    return DateFormat("d MMM · HH:mm", 'pt_BR').format(d);
  }

  /// `14 mai`.
  static String dateShort(DateTime d) =>
      DateFormat("d MMM", 'pt_BR').format(d);

  /// Para feed: `há 2h`, `há 3 dias`, ou `14 mai` se mais antigo que 7d.
  static String relativeDay(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    if (diff.inDays < 7) return 'há ${diff.inDays}d';
    return dateShort(d);
  }
}
