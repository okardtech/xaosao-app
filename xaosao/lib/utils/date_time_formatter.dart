import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String? dateFormatter(DateTime? date) {
    if (date == null) return null;
    return DateFormat("dd/MM/yyyy").format(date);
  }

  static String dobFormatter(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }
}
