import 'package:flutter/foundation.dart';
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

  /// Returns the BARE unit noun for [billingType] — "hours", "days",
  /// "nights", "minutes", "times" — with no leading slash.
  ///
  /// Use this wherever a duration or rate needs a unit word, composed via
  /// `l10n.bookingCountUnit(unit)`, `l10n.bookingRatePerUnit(rate, unit)`
  /// or plain `'$n $unit'`. Never hard-code a unit: a single generic word
  /// reads wrong for four of the five billing types the API can send.
  static String unitName(String? billingType) {
    switch (billingType) {
      case 'per_hour':
        return l10n.meetupsUnitHours;
      case 'per_day':
        return l10n.meetupsUnitDays;
      case 'per_night':
        return l10n.bookingUnitNight;
      case 'per_minute':
        return l10n.bookingUnitMinute;
      case 'one_time':
        return l10n.bookingUnitTime;
      default:
        // Unknown/absent billingType (the "Local Tours" case where the
        // backend sends a type we don't know): hours is the most common
        // unit, and a wrong-but-present unit beats a bare number.
        //
        // Logged rather than swallowed — a silent fallback is how this went
        // unnoticed last time. If this line appears, the backend is sending
        // a billingType the app doesn't map, and THAT is the real fix.
        if (billingType != null && billingType.isNotEmpty) {
          debugPrint('[service] unmapped billingType "$billingType" '
              '- falling back to the hour unit');
        }
        return l10n.meetupsUnitHours;
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
