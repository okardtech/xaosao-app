import 'package:intl/intl.dart';

class CurrFormatter {
  static String format(num amount) {
    return NumberFormat.currency(symbol: '', decimalDigits: 0).format(amount);
  }
}
