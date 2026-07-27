import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xaosao/services/authe_service.dart';

class LanguageService extends GetxService {
  final AuthService _authService = Get.find<AuthService>();

  static const supportedLanguages = ['en', 'lo', 'th'];

  final _locale = const Locale('lo').obs;
  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLang = _authService.getLanguage();

    if (savedLang != null) {
      _locale.value = Locale(savedLang);
    } else {
      final deviceLocale = Get.deviceLocale;
      final deviceLangCode = deviceLocale?.languageCode ?? 'lo';

      final langCode = supportedLanguages.contains(deviceLangCode)
          ? deviceLangCode
          : 'lo';

      _locale.value = Locale(langCode);
    }

    Get.updateLocale(_locale.value);
  }

  Future<void> changeLanguage(String langCode) async {
    await _authService.saveLanguage(langCode);
    _locale.value = Locale(langCode);
    Get.updateLocale(Locale(langCode));
  }

  String get fontFamily {
    switch (_locale.value.languageCode) {
      case 'lo':
        return 'NotoSansLao';
      case 'th':
        return 'NotoSansThai';
      case 'en':
      default:
        return 'Poppins';
    }
  }

  String get languageName {
    switch (_locale.value.languageCode) {
      case 'lo':
        return 'ພາສາລາວ';
      case 'th':
        return 'ภาษาไทย';
      case 'en':
      default:
        return 'English';
    }
  }
}