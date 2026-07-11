import 'package:flutter/services.dart';

/// Laos mobile number rules:
///   • Must start with 20
///   • 3rd digit must be one of: 202, 205, 206, 207, 209
///   • Total length: exactly 10 digits
class LaoPhoneValidator {
  LaoPhoneValidator._();

  static const int length = 10;
  static const List<String> validPrefixes = [
    '202',
    '205',
    '206',
    '207',
    '209',
  ];

  /// Returns a Lao error string, or null when the number is valid.
  static String? error(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'ກະລຸນາໃສ່ເບີໂທ';
    if (v.length < 2 || !v.startsWith('20')) {
      return 'ເບີໂທຕ້ອງເລີ່ມດ້ວຍ 20';
    }
    if (v.length >= 3 && !validPrefixes.any((p) => v.startsWith(p))) {
      return 'ຕ້ອງເປັນ: 202, 205, 206, 207 ຫຼື 209';
    }
    if (v.length != length) return 'ເບີໂທຕ້ອງມີ $length ຕົວເລກ';
    return null;
  }

  /// Returns true only when the number is fully valid and complete.
  static bool isValid(String? value) => error(value) == null;
}

/// [TextInputFormatter] that enforces Lao phone rules in real time.
///
/// Rules enforced as the user types:
///   1. Digits only (strips anything else).
///   2. Maximum [LaoPhoneValidator.length] digits.
///   3. Must begin with 20.
///   4. Third digit must lead to one of the valid prefixes.
class LaoPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Strip non-digits
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Enforce max length
    if (digits.length > LaoPhoneValidator.length) return oldValue;

    // First character must be 2
    if (digits.isNotEmpty && digits[0] != '2') return oldValue;

    // Second character must be 0
    if (digits.length >= 2 && digits[1] != '0') return oldValue;

    // Third character must start a valid prefix (2, 5, 6, 7, 9)
    if (digits.length >= 3) {
      const validThird = {'2', '5', '6', '7', '9'};
      if (!validThird.contains(digits[2])) return oldValue;
    }

    return newValue.copyWith(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}
