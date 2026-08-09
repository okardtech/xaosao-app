import 'package:xaosao/utils/l10n.dart';

class ServiceHelper {
  /// Returns a localized billing-unit suffix (e.g. "/session", "/day")
  /// for the given [billingType]. Falls back to [l10n.serviceUnitHour]
  /// (now "/session") for unknown or null values so the UI never shows
  /// a bare price with no unit — this was the "Local Tours" bug where
  /// backend sent a billingType we didn't recognize and the unit
  /// disappeared entirely.
  static String serviceName(String? billingType) {
    switch (billingType) {
      case 'per_hour':
        return l10n.serviceUnitHour;
      case 'per_day':
        return l10n.serviceUnitDay;
      case 'per_night':
        return l10n.serviceUnitNight;
      case 'one_time':
        return l10n.serviceUnitOnce;
      case 'per_minute':
        return l10n.serviceUnitMinute;
      default:
        // Safe fallback — "/session" reads correctly for any service
        // type (activities, tours, massage). Better than an empty
        // string that hides pricing context from the user.
        return l10n.serviceUnitHour;
    }
  }

  static String serviceOriginalName(String? name) {
    switch (name) {
      case 'drinkingFriend':
        return l10n.serviceTypeSocial;
      case 'travelingFriend':
        return l10n.serviceTypeTravel;
      case 'massage':
        return l10n.serviceTypeMassage;
      default:
        return name ?? '';
    }
  }
}
