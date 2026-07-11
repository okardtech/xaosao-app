/// Parses the API's custom datetime format "dd-MM-yyyy HH:mm:ss"
/// (e.g. "11-05-2026 09:04:39") into a [DateTime].
///
/// Falls back to [DateTime.tryParse] for ISO-8601 strings so existing
/// data already in standard format continues to work.
/// Returns null for null, empty, or unparseable input.
DateTime? parseApiDateTime(dynamic value) {
  if (value == null) return null;
  final s = value.toString().trim();
  if (s.isEmpty) return null;

  // Primary: "dd-MM-yyyy HH:mm:ss"
  final spaceIdx = s.indexOf(' ');
  if (spaceIdx > 0) {
    final d = s.substring(0, spaceIdx).split('-');
    final t = s.substring(spaceIdx + 1).split(':');
    if (d.length == 3 && t.length >= 2) {
      final day   = int.tryParse(d[0]);
      final month = int.tryParse(d[1]);
      final year  = int.tryParse(d[2]);
      final hour  = int.tryParse(t[0]);
      final min   = int.tryParse(t[1]);
      final sec   = t.length > 2 ? int.tryParse(t[2]) ?? 0 : 0;
      if (day != null && month != null && year != null &&
          hour != null && min != null) {
        return DateTime(year, month, day, hour, min, sec);
      }
    }
  }

  // Fallback: ISO-8601 / any format Dart can handle natively
  return DateTime.tryParse(s);
}
