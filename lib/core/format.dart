import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/gen/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get arabic => Localizations.localeOf(this).languageCode == 'ar';
}

/// Money, dates and ids in the conventions Saudi users expect. Digits stay
/// Western in both languages, as most Saudi banking apps do.
class Fmt {
  Fmt._();

  static final _grouped = NumberFormat('#,##0', 'en');

  static String number(num v) => _grouped.format(v);

  static String sar(BuildContext context, num v) =>
      context.arabic ? '${number(v)} ر.س' : 'SAR ${number(v)}';

  /// 418,000 -> "418K" / "418 ألف".
  static String compact(BuildContext context, num v) {
    if (v.abs() >= 1000000) {
      final m = (v / 1000000).toStringAsFixed(v % 1000000 == 0 ? 0 : 1);
      return context.arabic ? '$m مليون' : '${m}M';
    }
    if (v.abs() >= 1000) {
      final k = (v / 1000).round();
      return context.arabic ? '$k ألف' : '${k}K';
    }
    return number(v);
  }

  static String _loc(BuildContext c) => c.arabic ? 'ar' : 'en';

  static DateFormat _df(BuildContext c, String pattern) =>
      DateFormat(pattern, _loc(c))..useNativeDigits = false;

  static String date(BuildContext c, DateTime d) =>
      _df(c, 'd MMMM y').format(d);

  static String shortDate(BuildContext c, DateTime d) =>
      _df(c, 'd MMM').format(d);

  static String month(BuildContext c, DateTime d) =>
      _df(c, 'MMMM y').format(d);

  static String monthShort(BuildContext c, DateTime d) =>
      _df(c, 'MMM').format(d);

  static String time(BuildContext c, DateTime d) =>
      _df(c, 'h:mm a').format(d);

  static String dateTime(BuildContext c, DateTime d) =>
      '${shortDate(c, d)} · ${time(c, d)}';

  /// 20250010283 -> "2025 001 0283", the way Ejar prints contract numbers.
  static String ejar(String n) => n.length < 8
      ? n
      : '${n.substring(0, 4)} ${n.substring(4, 7)} ${n.substring(7)}';

  /// +966551234567 -> "+966 55 123 4567".
  static String phone(String p) {
    if (!p.startsWith('+966') || p.length != 13) return p;
    return '+966 ${p.substring(4, 6)} ${p.substring(6, 9)} ${p.substring(9)}';
  }
}
