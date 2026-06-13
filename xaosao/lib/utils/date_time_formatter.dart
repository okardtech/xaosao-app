import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String? dateFormatter(DateTime? date) {
    if (date == null) return null;
    return DateFormat("dd/MM/yyyy").format(date);
  }

  static String dobFormatter(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static String chatTimeLabel(DateTime? t) {
    if (t == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(t.year, t.month, t.day);
    final time = DateFormat('h:mm a').format(t);
    if (day == today) return 'ມື້ນີ້, $time';
    if (day == today.subtract(const Duration(days: 1))) return 'ມື້ວານ, $time';
    return DateFormat('MMM d, h:mm a').format(t);
  }
}
