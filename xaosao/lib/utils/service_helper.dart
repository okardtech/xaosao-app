class ServiceHelper {
  static String serviceName(String? billingType) {
    switch (billingType) {
      case 'per_hour':
        return '/ຊົ່ວໂມງ';
      case 'per_day':
        return '/ວັນ';
      case 'per_night':
        return '/ຄືນ';
      case 'one_time':
        return 'ຄັ້ງດຽວ';
      case 'per_minute':
        return '/ນາທີ';
      default:
        return '';
    }
  }

  static String serviceOriginalName(String? name) {
    switch (name) {
      case 'drinkingFriend':
        return 'ເພື່ອນສັງຄົມ';
      case 'travelingFriend':
        return 'ເພື່ອນທ່ອງທ່ຽວ';
      case 'massage':
        return 'ບໍລິການນວດ';
      default:
        return name ?? '';
    }
  }
}
