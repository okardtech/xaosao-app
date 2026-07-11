import 'package:intl/intl.dart';

class DateTimeFormatter {
  static const _fullMonths = [
    'ມັງກອນ', 'ກຸມພາ', 'ມີນາ', 'ເມສາ', 'ພຶດສະພາ', 'ມິຖຸນາ',
    'ກໍລະກົດ', 'ສິງຫາ', 'ກັນຍາ', 'ຕຸລາ', 'ພະຈິກ', 'ທັນວາ',
  ];

  static const _shortMonths = [
    'ມ.ກ', 'ກ.ພ', 'ມ.ນ', 'ມ.ສ', 'ພ.ຈ', 'ມິ.ຖ',
    'ກ.ລ', 'ສ.ຫ', 'ກ.ຍ', 'ຕ.ລ', 'ພ.ສ', 'ທ.ວ',
  ];

  /// "15 ມີນາ 2026"
  static String laoDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day} ${_fullMonths[dt.month - 1]} ${dt.year}';
  }

  /// "15 ມ.ນ 2026"
  static String laoDateShort(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day} ${_shortMonths[dt.month - 1]} ${dt.year}';
  }

  /// "03:20"
  static String laoTime(DateTime? dt) {
    if (dt == null) return '-';
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// "15 ມ.ນ 2026  ·  03:20"
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
    if (day == today) return 'ມື້ນີ້, $time';
    if (day == today.subtract(const Duration(days: 1))) return 'ມື້ວານ, $time';
    return DateFormat('MMM d, h:mm a').format(t);
  }
}
