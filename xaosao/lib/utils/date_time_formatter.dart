import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/utils/l10n.dart';

class DateTimeFormatter {
  /// Current UI locale code — used to pick localized month/day names.
  /// Falls back to `lo` (the app's default) when GetX hasn't resolved yet.
  static String _locale() => Get.locale?.languageCode ?? 'lo';

  /// "15 March 2026" / "15 ມີນາ 2026" / "15 มีนาคม 2026"
  static String laoDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('d MMMM y', _locale()).format(dt);
  }

  /// "15 Mar 2026" / "15 ມ.ນ 2026" / "15 มี.ค. 2026"
  static String laoDateShort(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('d MMM y', _locale()).format(dt);
  }

  /// "03:20"
  static String laoTime(DateTime? dt) {
    if (dt == null) return '-';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// "15 Mar 2026  ·  03:20"
  static String laoDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return '${laoDateShort(dt)}  ·  ${laoTime(dt)}';
  }

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
    if (day == today) return '${l10n.dateToday}, $time';
    if (day == today.subtract(const Duration(days: 1))) {
      return '${l10n.dateYesterday}, $time';
    }
    return DateFormat('MMM d, h:mm a', _locale()).format(t);
  }
}
