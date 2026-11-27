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

  /// The name a service is shown under, in the app's language.
  ///
  /// Keyed by the service's stored name. Some services are stored under
  /// their old Lao names (e.g. ເປັນຄູ່ບຸນທາດຫຼວງ), so those map here too,
  /// as do the English keys they may be renamed to in admin.
  static String serviceOriginalName(String? name) {
    switch (name?.trim()) {
      case 'drinkingFriend':
        return l10n.serviceNameDrinking;
      case 'travelingFriend':
      case 'travellingFriend':
      case 'travelingPartner':
      case 'travellingPartner':
        return l10n.serviceNameTravel;
      case 'massage':
        return l10n.serviceNameMassage;
      case 'pimaiPartner':
      case 'ເພື່ອນປີໃຫ່ມລາວ':
      case 'ເພື່ອນປີໃໝ່ລາວ':
      case 'pimaiPatner':
        return l10n.serviceNamePimai;
      case 'thatLuangPartner':
      case 'ເປັນຄູ່ບຸນທາດຫຼວງ':
      case 'thatlungParter':
      case 'thatLuangParter':
        return l10n.serviceNameThatLuang;
      case 'hmongNewYearPartner':
      case 'ເປັນຄູ່ບຸນກີນຈຽງ':
      case 'ເປັນຄູ່ບຸນກິນຈຽງ':
      case 'hmongNewYear':
        return l10n.serviceNameHmongNewYear;
      case 'countdownFriend':
      case 'ຄູ່ເຄົ້າດາວປີໃໝ່':
      case 'ຄູ່ເຄົ້າດາວ':
      case 'countdownPartner':
        return l10n.serviceNameCountdown;
      case 'call':
        return l10n.serviceNameCall;
      default:
        return name ?? '';
    }
  }

}
