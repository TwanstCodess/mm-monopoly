import 'package:flutter/widgets.dart';

class CurrencyUtils {
  static String symbolForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
      case 'zh':
        return '¥';
      case 'fr':
      case 'es':
        return '€';
      default:
        return r'$';
    }
  }

  static String format(BuildContext context, num amount) {
    final symbol = symbolForLocale(Localizations.localeOf(context));
    return '$symbol$amount';
  }
}
