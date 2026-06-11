import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrFormatter {
  static final _fmt = NumberFormat('#,###', 'en_US');

  static String format(num amount) => _fmt.format(amount);

  static String kip(num amount) => '${_fmt.format(amount)} ກີບ';
}

/// Live-formats a numeric text field with thousands separators (e.g. 100,000).
/// Strip commas before parsing: `int.tryParse(ctrl.text.replaceAll(',', ''))`.
class ThousandsSeparatorFormatter extends TextInputFormatter {
  static final _fmt = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final number = int.tryParse(digits) ?? 0;
    final formatted = _fmt.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
