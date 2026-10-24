import 'package:intl/intl.dart';

/// Formats currency strictly from integer paise (1 INR = 100 paise)
/// using Indian numerical grouping conventions (lakhs, crores).
class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrDecimalFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Converts paise integer to formatted INR string (e.g., 240000 -> ₹2,400)
  static String formatPaise(int paise, {bool showDecimals = false}) {
    final double rupees = paise / 100.0;
    if (showDecimals || paise % 100 != 0) {
      return _inrDecimalFormatter.format(rupees);
    }
    return _inrFormatter.format(rupees);
  }

  /// Converts rupees to integer paise (e.g., 24.50 -> 2450)
  static int rupeesToPaise(num rupees) {
    return (rupees * 100).round();
  }

  /// Formats savings (e.g., "Save ₹1,200")
  static String formatSavings(int savedPaise) {
    return 'Save ${formatPaise(savedPaise)}';
  }
}
