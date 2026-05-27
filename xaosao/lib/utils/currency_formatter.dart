import 'package:intl/intl.dart';

class CurrFormatter {
  static final _fmt = NumberFormat('#,###', 'en_US');

  static String format(num amount) => _fmt.format(amount);

  static String kip(num amount) => '${_fmt.format(amount)} ກີບ';
}
