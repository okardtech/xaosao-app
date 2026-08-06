import 'package:xaosao/utils/l10n.dart';

class ServiceHelper {
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
        return '';
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
