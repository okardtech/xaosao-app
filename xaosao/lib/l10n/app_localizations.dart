import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_lo.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('lo'),
    Locale('th'),
  ];

  /// No description provided for @english.
  ///
  /// In lo, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @lao.
  ///
  /// In lo, this message translates to:
  /// **'ພາສາລາວ'**
  String get lao;

  /// No description provided for @thai.
  ///
  /// In lo, this message translates to:
  /// **'ภาษาไทย'**
  String get thai;

  /// Title of the language selector sheet
  ///
  /// In lo, this message translates to:
  /// **'ພາສາ'**
  String get languageTitle;

  /// Subtitle explaining what to do in the language selector
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກພາສາທີ່ທ່ານຕ້ອງການໃຊ້'**
  String get languageSubtitle;

  /// No description provided for @commonCancel.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກ'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In lo, this message translates to:
  /// **'ຕົກລົງ'**
  String get commonOk;

  /// No description provided for @commonSave.
  ///
  /// In lo, this message translates to:
  /// **'ບັນທຶກ'**
  String get commonSave;

  /// No description provided for @commonClose.
  ///
  /// In lo, this message translates to:
  /// **'ປິດ'**
  String get commonClose;

  /// No description provided for @commonLater.
  ///
  /// In lo, this message translates to:
  /// **'ພາຍຫຼັງ'**
  String get commonLater;

  /// No description provided for @commonSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດ'**
  String get commonSuccess;

  /// No description provided for @commonError.
  ///
  /// In lo, this message translates to:
  /// **'ເກີດຂໍ້ຜິດພາດ, ກະລຸນາລອງໃໝ່'**
  String get commonError;

  /// No description provided for @commonDelete.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບ'**
  String get commonDelete;

  /// No description provided for @commonBack.
  ///
  /// In lo, this message translates to:
  /// **'ກັບຄືນ'**
  String get commonBack;

  /// No description provided for @commonYes.
  ///
  /// In lo, this message translates to:
  /// **'ແມ່ນ'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່'**
  String get commonNo;

  /// No description provided for @profileInfoSection.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນ'**
  String get profileInfoSection;

  /// No description provided for @profileSecuritySection.
  ///
  /// In lo, this message translates to:
  /// **'ຄວາມປອດໄພ'**
  String get profileSecuritySection;

  /// No description provided for @profileSettingsSection.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງຄ່າ'**
  String get profileSettingsSection;

  /// No description provided for @profileHelpSection.
  ///
  /// In lo, this message translates to:
  /// **'ຊ່ວຍເຫຼືອ'**
  String get profileHelpSection;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນສ່ວນຕົວ'**
  String get profilePersonalInfo;

  /// No description provided for @profilePersonalInfoSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຊື່, ນາມສະກຸນ, ວັນເດືອນປີເກີດ'**
  String get profilePersonalInfoSubtitle;

  /// No description provided for @profileFinance.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນທາງການເງິນ'**
  String get profileFinance;

  /// No description provided for @profileFinanceSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ບັນຊີເງິນ, ບັດເຄຣດິດ, ການໂອນເງິນ'**
  String get profileFinanceSubtitle;

  /// No description provided for @profileChangePassword.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນລະຫັດຜ່ານ'**
  String get profileChangePassword;

  /// No description provided for @profileVerifyPhone.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນເບີໂທ'**
  String get profileVerifyPhone;

  /// No description provided for @profileVerifiedBadge.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນແລ້ວ'**
  String get profileVerifiedBadge;

  /// No description provided for @profileVerifiedIdentity.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນຕົວຕົນແລ້ວ'**
  String get profileVerifiedIdentity;

  /// No description provided for @profileLanguage.
  ///
  /// In lo, this message translates to:
  /// **'ພາສາ'**
  String get profileLanguage;

  /// No description provided for @profileNotifications.
  ///
  /// In lo, this message translates to:
  /// **'ການແຈ້ງເຕືອນ'**
  String get profileNotifications;

  /// No description provided for @profileNotificationsSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'Push, ອີເມລ, SMS, WhatsApp'**
  String get profileNotificationsSubtitle;

  /// No description provided for @profileHelpFaq.
  ///
  /// In lo, this message translates to:
  /// **'ຊ່ວຍເຫຼືອ / FAQ'**
  String get profileHelpFaq;

  /// No description provided for @profileFeedback.
  ///
  /// In lo, this message translates to:
  /// **'ຄຳຕິຊົມ'**
  String get profileFeedback;

  /// No description provided for @profileFeedbackSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍງານບັນຫາ ຫຼື ສົ່ງຄຳຄິດເຫັນ'**
  String get profileFeedbackSubtitle;

  /// No description provided for @profileTerms.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ກຳນົດ ແລະ ນະໂຍບາຍ'**
  String get profileTerms;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບບັນຊີ'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteAccountSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ການດຳເນີນການນີ້ບໍ່ສາມາດຍ້ອນໄດ້'**
  String get profileDeleteAccountSubtitle;

  /// No description provided for @profileDeleteAccountShortSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດຍ້ອນໄດ້'**
  String get profileDeleteAccountShortSubtitle;

  /// No description provided for @profileLogout.
  ///
  /// In lo, this message translates to:
  /// **'ອອກຈາກລະບົບ'**
  String get profileLogout;

  /// No description provided for @profileAppVersion.
  ///
  /// In lo, this message translates to:
  /// **'XAOSAO v{version}'**
  String profileAppVersion(String version);

  /// No description provided for @profilePhotos.
  ///
  /// In lo, this message translates to:
  /// **'ຮູບພາບ'**
  String get profilePhotos;

  /// No description provided for @profilePhotosCount.
  ///
  /// In lo, this message translates to:
  /// **'ຮູບພາບ ({count}/{max})'**
  String profilePhotosCount(int count, int max);

  /// No description provided for @profilePhotosMissingWarning.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງເພີ່ມຄົບ {max} ຮູບ — ຍັງຂາດ {missing} ຮູບ'**
  String profilePhotosMissingWarning(int max, int missing);

  /// No description provided for @profileMyServices.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການຂອງຂ້ອຍ'**
  String get profileMyServices;

  /// No description provided for @profileMyQr.
  ///
  /// In lo, this message translates to:
  /// **'QR ຂອງຂ້ອຍ'**
  String get profileMyQr;

  /// No description provided for @profileStatLikes.
  ///
  /// In lo, this message translates to:
  /// **'ຖືກໃຈ'**
  String get profileStatLikes;

  /// No description provided for @profileStatFriends.
  ///
  /// In lo, this message translates to:
  /// **'ໝູ່'**
  String get profileStatFriends;

  /// No description provided for @profileStatReferrals.
  ///
  /// In lo, this message translates to:
  /// **'ຄໍາລິຊົມ'**
  String get profileStatReferrals;

  /// No description provided for @profileStatBookings.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງ'**
  String get profileStatBookings;

  /// No description provided for @profileHiddenEnabled.
  ///
  /// In lo, this message translates to:
  /// **'ໂປຣໄຟຂອງທ່ານຖືກຊ່ອນຢູ່ — ລູກຄ້າບໍ່ສາມາດເຫັນທ່ານໄດ້'**
  String get profileHiddenEnabled;

  /// No description provided for @profileHiddenDisabled.
  ///
  /// In lo, this message translates to:
  /// **'ເຊື່ອງໂປຣໄຟຂອງທ່ານບໍ່ໃຫ້ລູກຄ້າເຫັນ. ທ່ານສາມາດເປີດ-ປິດໄດ້ຕະຫຼອດເວລາ.'**
  String get profileHiddenDisabled;

  /// No description provided for @customerProfileBuyPackage.
  ///
  /// In lo, this message translates to:
  /// **'ການຊື້ແພັກເກດ'**
  String get customerProfileBuyPackage;

  /// No description provided for @customerProfileBuyPackageSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຊ່ວງໂມງ, ຊ່ວງວັນ ແລະ ຊ່ວງເດືອນ'**
  String get customerProfileBuyPackageSubtitle;

  /// No description provided for @customerProfileTopupHistory.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດເຕີມເງິນ'**
  String get customerProfileTopupHistory;

  /// No description provided for @walletBalanceTitle.
  ///
  /// In lo, this message translates to:
  /// **'ກະເປົ໋າເງິນ ຍອດຄົງເຫຼືອ'**
  String get walletBalanceTitle;

  /// No description provided for @walletTopup.
  ///
  /// In lo, this message translates to:
  /// **'ເຕີມເງິນ'**
  String get walletTopup;

  /// No description provided for @walletHistory.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດ'**
  String get walletHistory;

  /// No description provided for @confirmLogoutTitle.
  ///
  /// In lo, this message translates to:
  /// **'ອອກຈາກລະບົບ'**
  String get confirmLogoutTitle;

  /// No description provided for @confirmLogoutMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຕ້ອງການອອກຈາກລະບົບແທ້ບໍ່?'**
  String get confirmLogoutMessage;

  /// No description provided for @confirmLogoutConfirm.
  ///
  /// In lo, this message translates to:
  /// **'ອອກ'**
  String get confirmLogoutConfirm;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບບັນຊີ'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານແນ່ໃຈບໍ່ທີ່ຕ້ອງການລຶບບັນຊີ?\nຂໍ້ມູນທັງໝົດຈະຖືກລຶບຖາວອນ ແລະ ບໍ່ສາມາດຍ້ອນໄດ້.'**
  String get confirmDeleteMessage;

  /// No description provided for @commonGenericError.
  ///
  /// In lo, this message translates to:
  /// **'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ'**
  String get commonGenericError;

  /// No description provided for @commonActionFailed.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດດຳເນີນການໄດ້'**
  String get commonActionFailed;

  /// No description provided for @commonLoadDataFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ'**
  String get commonLoadDataFailed;

  /// No description provided for @commonAddFailed.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມບໍ່ສຳເລັດ'**
  String get commonAddFailed;

  /// No description provided for @commonUpdateFailed.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດບໍ່ສຳເລັດ'**
  String get commonUpdateFailed;

  /// No description provided for @commonDeleteFailed.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບບໍ່ສຳເລັດ'**
  String get commonDeleteFailed;

  /// No description provided for @loginFailed.
  ///
  /// In lo, this message translates to:
  /// **'ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ'**
  String get loginFailed;

  /// No description provided for @registerLoadServicesFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດບໍລິການບໍ່ສຳເລັດ'**
  String get registerLoadServicesFailed;

  /// No description provided for @registerSelectProfilePhoto.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາເລືອກຮູບໂປຮໄຟລ໌'**
  String get registerSelectProfilePhoto;

  /// No description provided for @registerFailed.
  ///
  /// In lo, this message translates to:
  /// **'ລົງທະບຽນບໍ່ສຳເລັດ'**
  String get registerFailed;

  /// No description provided for @registerInvalidOtp.
  ///
  /// In lo, this message translates to:
  /// **'OTP ບໍ່ຖືກຕ້ອງ'**
  String get registerInvalidOtp;

  /// No description provided for @registerSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ການລົງທະບຽນສຳເລັດເເລ້ວ'**
  String get registerSuccess;

  /// No description provided for @registerVerifyOtpFailed.
  ///
  /// In lo, this message translates to:
  /// **'ກວດສອບ OTP ບໍ່ສຳເລັດ'**
  String get registerVerifyOtpFailed;

  /// No description provided for @registerResendOtpFailed.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງ OTP ໃໝ່ບໍ່ສຳເລັດ'**
  String get registerResendOtpFailed;

  /// No description provided for @registerResendOtpSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງລະຫັດ OTP ໃໝ່ແລ້ວ'**
  String get registerResendOtpSuccess;

  /// No description provided for @meetUpsCancelSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກການຈອງສຳເລັດ'**
  String get meetUpsCancelSuccess;

  /// No description provided for @meetUpsReleasePaymentSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ອຍເງີນສຳເລັດ'**
  String get meetUpsReleasePaymentSuccess;

  /// No description provided for @meetUpsDisputeSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຄຳຮ້ອງຂໍສຳເລັດ'**
  String get meetUpsDisputeSuccess;

  /// No description provided for @meetUpsConfirmSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນການຈອງສຳເລັດ'**
  String get meetUpsConfirmSuccess;

  /// No description provided for @meetUpsRejectSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ປະຕິເສດການຈອງສຳເລັດ'**
  String get meetUpsRejectSuccess;

  /// No description provided for @meetUpsReceiveMoneySuccess.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບເງີນສຳເລັດ'**
  String get meetUpsReceiveMoneySuccess;

  /// No description provided for @meetUpsDeleteSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບລາຍການສຳເລັດ'**
  String get meetUpsDeleteSuccess;

  /// No description provided for @postsFeedLoadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດຟີດບໍ່ສຳເລັດ'**
  String get postsFeedLoadFailed;

  /// No description provided for @postsMyLoadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດໂພສຂ້ອຍບໍ່ສຳເລັດ'**
  String get postsMyLoadFailed;

  /// No description provided for @postsCreateSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງໂພສສຳເລັດ'**
  String get postsCreateSuccess;

  /// No description provided for @postsCreateFailed.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງໂພສບໍ່ສຳເລັດ'**
  String get postsCreateFailed;

  /// No description provided for @postsDisableSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ປິດໃຊ້ງານໂພສສຳເລັດ'**
  String get postsDisableSuccess;

  /// No description provided for @postsDisableFailed.
  ///
  /// In lo, this message translates to:
  /// **'ປິດໃຊ້ງານໂພສບໍ່ສຳເລັດ'**
  String get postsDisableFailed;

  /// No description provided for @postsDeleteSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບໂພສສຳເລັດ'**
  String get postsDeleteSuccess;

  /// No description provided for @postsDeleteFailed.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບໂພສບໍ່ສຳເລັດ'**
  String get postsDeleteFailed;

  /// No description provided for @authWelcome.
  ///
  /// In lo, this message translates to:
  /// **'ຍິນດີຕ້ອນຮັບ 👋'**
  String get authWelcome;

  /// No description provided for @authRolePrompt.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານເຂົ້າໃນຖານະໃດ?'**
  String get authRolePrompt;

  /// No description provided for @authTagline.
  ///
  /// In lo, this message translates to:
  /// **'ເພື່ອນຄູ່ໃຈ ທຸກທີ່ ທຸກເວລາ'**
  String get authTagline;

  /// No description provided for @authRoleCustomer.
  ///
  /// In lo, this message translates to:
  /// **'ລູກຄ້າ'**
  String get authRoleCustomer;

  /// No description provided for @authRoleCompanion.
  ///
  /// In lo, this message translates to:
  /// **'Companion'**
  String get authRoleCompanion;

  /// No description provided for @authFieldPhone.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທລະສັບ'**
  String get authFieldPhone;

  /// No description provided for @authFieldPassword.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານ'**
  String get authFieldPassword;

  /// No description provided for @authHintPassword.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານ'**
  String get authHintPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In lo, this message translates to:
  /// **'ລືມລະຫັດຜ່ານ?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccount.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີບັນຊີ?'**
  String get authNoAccount;

  /// No description provided for @authLoginButton.
  ///
  /// In lo, this message translates to:
  /// **'ເຂົ້າສູ່ລະບົບ'**
  String get authLoginButton;

  /// No description provided for @authCreateCustomerAccount.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງບັນຊີ ລູກຄ້າ'**
  String get authCreateCustomerAccount;

  /// No description provided for @authCreateCompanionAccount.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງບັນຊີ ຜູ້ຮັບຈອງ'**
  String get authCreateCompanionAccount;

  /// No description provided for @authValidPhoneRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ເບີໂທລະສັບໃຫ້ຖືກຕ້ອງ'**
  String get authValidPhoneRequired;

  /// No description provided for @authPasswordRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ລະຫັດຜ່ານ'**
  String get authPasswordRequired;

  /// No description provided for @commonCurrencyKip.
  ///
  /// In lo, this message translates to:
  /// **'ກີບ'**
  String get commonCurrencyKip;

  /// No description provided for @monthShortJan.
  ///
  /// In lo, this message translates to:
  /// **'ມ.ກ'**
  String get monthShortJan;

  /// No description provided for @monthShortFeb.
  ///
  /// In lo, this message translates to:
  /// **'ກ.ພ'**
  String get monthShortFeb;

  /// No description provided for @monthShortMar.
  ///
  /// In lo, this message translates to:
  /// **'ມ.ນ'**
  String get monthShortMar;

  /// No description provided for @monthShortApr.
  ///
  /// In lo, this message translates to:
  /// **'ມ.ສ'**
  String get monthShortApr;

  /// No description provided for @monthShortMay.
  ///
  /// In lo, this message translates to:
  /// **'ພ.ພ'**
  String get monthShortMay;

  /// No description provided for @monthShortJun.
  ///
  /// In lo, this message translates to:
  /// **'ມ.ຖ'**
  String get monthShortJun;

  /// No description provided for @monthShortJul.
  ///
  /// In lo, this message translates to:
  /// **'ກ.ລ'**
  String get monthShortJul;

  /// No description provided for @monthShortAug.
  ///
  /// In lo, this message translates to:
  /// **'ສ.ຫ'**
  String get monthShortAug;

  /// No description provided for @monthShortSep.
  ///
  /// In lo, this message translates to:
  /// **'ກ.ຍ'**
  String get monthShortSep;

  /// No description provided for @monthShortOct.
  ///
  /// In lo, this message translates to:
  /// **'ຕ.ລ'**
  String get monthShortOct;

  /// No description provided for @monthShortNov.
  ///
  /// In lo, this message translates to:
  /// **'ພ.ຈ'**
  String get monthShortNov;

  /// No description provided for @monthShortDec.
  ///
  /// In lo, this message translates to:
  /// **'ທ.ວ'**
  String get monthShortDec;

  /// No description provided for @walletTitle.
  ///
  /// In lo, this message translates to:
  /// **'ກະເປົ໋າເງິນ'**
  String get walletTitle;

  /// No description provided for @walletSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດ ແລະ ປະຫວັດ'**
  String get walletSubtitle;

  /// No description provided for @walletFilterAll.
  ///
  /// In lo, this message translates to:
  /// **'ທັງໝົດ'**
  String get walletFilterAll;

  /// No description provided for @walletFilterPending.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າອະນຸມດ'**
  String get walletFilterPending;

  /// No description provided for @walletFilterApproved.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດເເລ້ວ'**
  String get walletFilterApproved;

  /// No description provided for @walletFilterRejected.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກເເລ້ວ'**
  String get walletFilterRejected;

  /// No description provided for @walletRechargeHistory.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດການເຕີມ'**
  String get walletRechargeHistory;

  /// No description provided for @walletEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີລາຍການ'**
  String get walletEmptyTitle;

  /// No description provided for @walletEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການເຕີມເງິນຂອງທ່ານ\nຈະສະແດງຢູ່ທີ່ນີ້'**
  String get walletEmptySubtitle;

  /// No description provided for @walletTxStatusCompleted.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດ'**
  String get walletTxStatusCompleted;

  /// No description provided for @walletTxStatusPending.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າ'**
  String get walletTxStatusPending;

  /// No description provided for @walletTxStatusProcessing.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງດຳເນີນ'**
  String get walletTxStatusProcessing;

  /// No description provided for @walletTxStatusCancelled.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກ'**
  String get walletTxStatusCancelled;

  /// No description provided for @walletBalanceUpdated.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດຄົງເຫຼືອ, ອັບເດດ {time}'**
  String walletBalanceUpdated(String time);

  /// No description provided for @walletUsed.
  ///
  /// In lo, this message translates to:
  /// **'ໃຊ້ໄປແລ້ວ'**
  String get walletUsed;

  /// No description provided for @walletTxTypeRecharge.
  ///
  /// In lo, this message translates to:
  /// **'ເຕີມເງິນ'**
  String get walletTxTypeRecharge;

  /// No description provided for @walletTxTypeSubscription.
  ///
  /// In lo, this message translates to:
  /// **'ຊື້ Package'**
  String get walletTxTypeSubscription;

  /// No description provided for @walletTxTypeGift.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຂອງຂວັນ'**
  String get walletTxTypeGift;

  /// No description provided for @walletTxTypeBookingHold.
  ///
  /// In lo, this message translates to:
  /// **'ຝາກຊຳລະການຈອງ'**
  String get walletTxTypeBookingHold;

  /// No description provided for @walletTxTypeBookingRefund.
  ///
  /// In lo, this message translates to:
  /// **'ຄືນເງິນການຈອງ'**
  String get walletTxTypeBookingRefund;

  /// No description provided for @walletTxTypeGiftEarning.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບຂອງຂວັນ'**
  String get walletTxTypeGiftEarning;

  /// No description provided for @walletTxTypeBookingEarning.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບເງິນການຈອງ'**
  String get walletTxTypeBookingEarning;

  /// No description provided for @walletTxTypeWithdrawal.
  ///
  /// In lo, this message translates to:
  /// **'ຖອນເງິນ'**
  String get walletTxTypeWithdrawal;

  /// No description provided for @walletTxTypeReferral.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່ານາຍໜ້າ'**
  String get walletTxTypeReferral;

  /// No description provided for @walletTxTypeBookingReferral.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່ານາຍໜ້າ (ການຈອງ)'**
  String get walletTxTypeBookingReferral;

  /// No description provided for @walletTxTypeSubscriptionReferral.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່ານາຍໜ້າ (Package)'**
  String get walletTxTypeSubscriptionReferral;

  /// No description provided for @walletTxTypeGeneric.
  ///
  /// In lo, this message translates to:
  /// **'ທຸລະກຳ'**
  String get walletTxTypeGeneric;

  /// No description provided for @commonNext.
  ///
  /// In lo, this message translates to:
  /// **'ຕໍ່ໄປ'**
  String get commonNext;

  /// No description provided for @commonAmount.
  ///
  /// In lo, this message translates to:
  /// **'ຈຳນວນ'**
  String get commonAmount;

  /// No description provided for @commonDate.
  ///
  /// In lo, this message translates to:
  /// **'ວັນທີ'**
  String get commonDate;

  /// No description provided for @commonErrorDetail.
  ///
  /// In lo, this message translates to:
  /// **'ເກີດຂໍ້ຜິດພາດ: {error}'**
  String commonErrorDetail(String error);

  /// No description provided for @topupAmountSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກ ຫຼື ປ້ອນຈຳນວນ'**
  String get topupAmountSubtitle;

  /// No description provided for @topupOther.
  ///
  /// In lo, this message translates to:
  /// **'ອື່ນໆ'**
  String get topupOther;

  /// No description provided for @topupCustomAmount.
  ///
  /// In lo, this message translates to:
  /// **'ກຳນົດເອງ'**
  String get topupCustomAmount;

  /// No description provided for @topupOrEnterYourself.
  ///
  /// In lo, this message translates to:
  /// **'ຫຼື ປ້ອນເອງ'**
  String get topupOrEnterYourself;

  /// No description provided for @topupEnterAmount.
  ///
  /// In lo, this message translates to:
  /// **'ປ້ອນຈຳນວນ'**
  String get topupEnterAmount;

  /// No description provided for @topupQrLoadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດໂຫຼດ QR ໄດ້'**
  String get topupQrLoadFailed;

  /// No description provided for @topupPackageFailed.
  ///
  /// In lo, this message translates to:
  /// **'ການຊື້ Package ບໍ່ສຳເລັດ'**
  String get topupPackageFailed;

  /// No description provided for @topupSlipUploadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດສົ່ງໃບຈ່າຍໄດ້'**
  String get topupSlipUploadFailed;

  /// No description provided for @topupUploadTitle.
  ///
  /// In lo, this message translates to:
  /// **'ອັບໂຫຼດ Slip'**
  String get topupUploadTitle;

  /// No description provided for @topupUploadSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນການຊຳລະ'**
  String get topupUploadSubtitle;

  /// No description provided for @topupUploadFileTypes.
  ///
  /// In lo, this message translates to:
  /// **'ຮອງຮັບຮູບແບບ: JPG, PNG, PDF (ຂຸງສຸດ 10MB)'**
  String get topupUploadFileTypes;

  /// No description provided for @topupUploadSubmit.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງ ແລະ ຢືນຢັນ'**
  String get topupUploadSubmit;

  /// No description provided for @topupUploadReceipt.
  ///
  /// In lo, this message translates to:
  /// **'ອັບໂຫຼດໃບບິນການຊຳລະ'**
  String get topupUploadReceipt;

  /// No description provided for @topupUploadReceiptSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ສາມາດອັບໃບຍືນຢັນໄດ້ທີ່ນີ້'**
  String get topupUploadReceiptSubtitle;

  /// No description provided for @topupSelectFile.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກໄຟລ໌'**
  String get topupSelectFile;

  /// No description provided for @topupAddMoreSlip.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມ slip ອີກ'**
  String get topupAddMoreSlip;

  /// No description provided for @topupExampleReceipt.
  ///
  /// In lo, this message translates to:
  /// **'ຕົວຢ່າງໃບບິນການຊຳລະ'**
  String get topupExampleReceipt;

  /// No description provided for @topupThankYouMessage.
  ///
  /// In lo, this message translates to:
  /// **'ຂອບໃຈສຳລັບຄວາມໄວ້ວາງໃຈ: ທີມງານຈະກວດສອບ ແລະ ດຳເນີນການ ພາຍໃນ 1–2 ຊົ່ວໂມງ. ຫຼັງຈາກໄດ້ຮັບໃບຍືນຢັນແລ້ວ.'**
  String get topupThankYouMessage;

  /// No description provided for @topupBackToWallet.
  ///
  /// In lo, this message translates to:
  /// **'ກັບໜ້າກະເປົ໋າ'**
  String get topupBackToWallet;

  /// No description provided for @topupSuccessTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເຕີມສຳເລັດ!'**
  String get topupSuccessTitle;

  /// No description provided for @topupSuccessSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງລໍຖ້າການກວດສອບຈາກ Admin'**
  String get topupSuccessSubtitle;

  /// No description provided for @topupWaitingReview.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າການກວດສອບ'**
  String get topupWaitingReview;

  /// No description provided for @topupQrTitle.
  ///
  /// In lo, this message translates to:
  /// **'ສະແກນ QR'**
  String get topupQrTitle;

  /// No description provided for @topupQrSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຊຳລະຜ່ານ app ທະນາຄານ'**
  String get topupQrSubtitle;

  /// No description provided for @topupQrPaidUploadSlip.
  ///
  /// In lo, this message translates to:
  /// **'ຊຳລະແລ້ວ — ອັບ slip'**
  String get topupQrPaidUploadSlip;

  /// No description provided for @topupQrAmountToPay.
  ///
  /// In lo, this message translates to:
  /// **'ຈຳນວນທີ່ຕ້ອງຊຳລະ'**
  String get topupQrAmountToPay;

  /// No description provided for @topupQrInstructions.
  ///
  /// In lo, this message translates to:
  /// **'ສະແກນ QR ດ້ວຍ app ທະນາຄານ\nຈາກນັ້ນກົດ \"ຊຳລະແລ້ວ\" ເພື່ອອັບ slip'**
  String get topupQrInstructions;

  /// No description provided for @topupQrSaving.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງບັນທຶກ...'**
  String get topupQrSaving;

  /// No description provided for @topupQrDownload.
  ///
  /// In lo, this message translates to:
  /// **'ດາວໂຫຼດ QR'**
  String get topupQrDownload;

  /// No description provided for @commonAll.
  ///
  /// In lo, this message translates to:
  /// **'ທັງໝົດ'**
  String get commonAll;

  /// No description provided for @commonRetry.
  ///
  /// In lo, this message translates to:
  /// **'ລອງໃໝ່'**
  String get commonRetry;

  /// No description provided for @commonPleaseRetry.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ'**
  String get commonPleaseRetry;

  /// No description provided for @serviceTypeSocial.
  ///
  /// In lo, this message translates to:
  /// **'ສັງຄົມ'**
  String get serviceTypeSocial;

  /// No description provided for @serviceTypeMassage.
  ///
  /// In lo, this message translates to:
  /// **'ນວດ'**
  String get serviceTypeMassage;

  /// No description provided for @serviceTypeTravel.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ຽວ'**
  String get serviceTypeTravel;

  /// No description provided for @viewCompanionPageTitle.
  ///
  /// In lo, this message translates to:
  /// **'ທັງໝົດ'**
  String get viewCompanionPageTitle;

  /// No description provided for @viewCompanionFilterLikedByMe.
  ///
  /// In lo, this message translates to:
  /// **'ຂ້ອຍ Like'**
  String get viewCompanionFilterLikedByMe;

  /// No description provided for @viewCompanionFilterWhoLikedMe.
  ///
  /// In lo, this message translates to:
  /// **'Like ຂ້ອຍ'**
  String get viewCompanionFilterWhoLikedMe;

  /// No description provided for @viewCompanionFilterNearby.
  ///
  /// In lo, this message translates to:
  /// **'ໃກ້ຂ້ອຍ'**
  String get viewCompanionFilterNearby;

  /// No description provided for @viewCompanionFilterNew.
  ///
  /// In lo, this message translates to:
  /// **'ໃໝ່'**
  String get viewCompanionFilterNew;

  /// No description provided for @viewCompanionFilterPopular.
  ///
  /// In lo, this message translates to:
  /// **'ນິຍົມ'**
  String get viewCompanionFilterPopular;

  /// No description provided for @viewCompanionEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ພົບຂໍ້ມູນ'**
  String get viewCompanionEmptyTitle;

  /// No description provided for @viewCompanionEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລອງປ່ຽນ filter ຫຼືຄົ້ນຫາໃໝ່'**
  String get viewCompanionEmptySubtitle;

  /// No description provided for @viewCompanionSearchHint.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາຊື່...'**
  String get viewCompanionSearchHint;

  /// No description provided for @genderMale.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ຊາຍ'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ຍິງ'**
  String get genderFemale;

  /// No description provided for @homeSearch.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາ'**
  String get homeSearch;

  /// No description provided for @homeFindCompanion.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນພົບຜູ້ຮ່ວມທາງຂອງທ່ານ'**
  String get homeFindCompanion;

  /// No description provided for @homeSearchHint.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາດ້ວຍຊື່...'**
  String get homeSearchHint;

  /// No description provided for @homeOnlineNow.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງອອນລາຍ'**
  String get homeOnlineNow;

  /// No description provided for @homeRecommended.
  ///
  /// In lo, this message translates to:
  /// **'ແນະນຳສຳລັບທ່ານ'**
  String get homeRecommended;

  /// No description provided for @homeSeeAll.
  ///
  /// In lo, this message translates to:
  /// **'ເບິ່ງທັງໝົດ'**
  String get homeSeeAll;

  /// No description provided for @homeNoResults.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ພົບຜົນໄດ້ຮັບ'**
  String get homeNoResults;

  /// No description provided for @homeTryFilter.
  ///
  /// In lo, this message translates to:
  /// **'ລອງປ່ຽນ filter ໃໝ່'**
  String get homeTryFilter;

  /// No description provided for @homeFilters.
  ///
  /// In lo, this message translates to:
  /// **'ຕົວກອງ'**
  String get homeFilters;

  /// No description provided for @homeMaxDistance.
  ///
  /// In lo, this message translates to:
  /// **'ໄລຍະທາງສູງສຸດ'**
  String get homeMaxDistance;

  /// No description provided for @homeApplyFilter.
  ///
  /// In lo, this message translates to:
  /// **'ນຳໃຊ້ Filter'**
  String get homeApplyFilter;

  /// No description provided for @homeFilterNearby.
  ///
  /// In lo, this message translates to:
  /// **'ໃກ້ຄຽງ'**
  String get homeFilterNearby;

  /// No description provided for @homeServiceSocial.
  ///
  /// In lo, this message translates to:
  /// **'ເພື່ອນສັງຄົມ'**
  String get homeServiceSocial;

  /// No description provided for @homeServiceTravel.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ອງທ່ຽວ'**
  String get homeServiceTravel;

  /// No description provided for @homeCardSubtitleSocial.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ຽວ, ງານລ້ຽງ, ທຸກໂອກາດ'**
  String get homeCardSubtitleSocial;

  /// No description provided for @homeCardSubtitleMassage.
  ///
  /// In lo, this message translates to:
  /// **'ນວດສຸຂະພາບໂດຍມືອາຊີບ'**
  String get homeCardSubtitleMassage;

  /// No description provided for @homeCardSubtitleTravel.
  ///
  /// In lo, this message translates to:
  /// **'Guide ໃນ ແລະ ຕ່າງປະເທດ'**
  String get homeCardSubtitleTravel;

  /// No description provided for @homeLoadRecommendationsFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດຂໍ້ມູນແນະນຳບໍ່ສຳເລັດ'**
  String get homeLoadRecommendationsFailed;

  /// No description provided for @homeLoadOnlineFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດຂໍ້ມູນອອນລາຍບໍ່ສຳເລັດ'**
  String get homeLoadOnlineFailed;

  /// No description provided for @commonAgeYears.
  ///
  /// In lo, this message translates to:
  /// **'{years} ປີ'**
  String commonAgeYears(int years);

  /// No description provided for @commonHours.
  ///
  /// In lo, this message translates to:
  /// **'{hours} ຊົ່ວໂມງ'**
  String commonHours(int hours);

  /// No description provided for @commonDays.
  ///
  /// In lo, this message translates to:
  /// **'{days} ວັນ'**
  String commonDays(int days);

  /// No description provided for @commonConfirm.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນ'**
  String get commonConfirm;

  /// No description provided for @commonPleaseTitle.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາ'**
  String get commonPleaseTitle;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນ'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusConfirmedShort.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບເເລ້ວ'**
  String get bookingStatusConfirmedShort;

  /// No description provided for @bookingStatusInProgress.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງດຳເນີນ'**
  String get bookingStatusInProgress;

  /// No description provided for @bookingStatusAwaitingConfirmation.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຢືນຢັນ'**
  String get bookingStatusAwaitingConfirmation;

  /// No description provided for @bookingStatusAwaitingConfirmationShort.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຮັບຢືນຢັນ'**
  String get bookingStatusAwaitingConfirmationShort;

  /// No description provided for @bookingStatusCompletedFull.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດເເລ້ວ'**
  String get bookingStatusCompletedFull;

  /// No description provided for @bookingStatusCancelledFull.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກເເລ້ວ'**
  String get bookingStatusCancelledFull;

  /// No description provided for @bookingStatusRejected.
  ///
  /// In lo, this message translates to:
  /// **'ຖືກປະຕິເສດ'**
  String get bookingStatusRejected;

  /// No description provided for @bookingStatusDisputed.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ຂັດແຍ້ງ'**
  String get bookingStatusDisputed;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In lo, this message translates to:
  /// **'ຊຳລະແລ້ວ'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusPending.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າຊຳລະ'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusReleased.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ອຍເງີນແລ້ວ'**
  String get paymentStatusReleased;

  /// No description provided for @paymentStatusRefunded.
  ///
  /// In lo, this message translates to:
  /// **'ຄືນເງີນແລ້ວ'**
  String get paymentStatusRefunded;

  /// No description provided for @meetUpsTitle.
  ///
  /// In lo, this message translates to:
  /// **'ນັດພົບ'**
  String get meetUpsTitle;

  /// No description provided for @meetUpsAllHistory.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດການຈອງທັງໝົດ'**
  String get meetUpsAllHistory;

  /// No description provided for @meetUpsItemsWithStatus.
  ///
  /// In lo, this message translates to:
  /// **'{count} ລາຍການ · {status}'**
  String meetUpsItemsWithStatus(int count, String status);

  /// No description provided for @meetUpsEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີລາຍການ'**
  String get meetUpsEmptyTitle;

  /// No description provided for @meetUpsEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການຈອງຈະສະແດງທີ່ນີ້'**
  String get meetUpsEmptySubtitle;

  /// No description provided for @meetUpsLoadMore.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດເພີ່ມ'**
  String get meetUpsLoadMore;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍລະອຽດການຈອງ'**
  String get bookingDetailTitle;

  /// No description provided for @bookingLocation.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖານທີ່'**
  String get bookingLocation;

  /// No description provided for @bookingPhone.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທລະສັບ'**
  String get bookingPhone;

  /// No description provided for @bookingTip.
  ///
  /// In lo, this message translates to:
  /// **'ທິບ'**
  String get bookingTip;

  /// No description provided for @bookingTipReady.
  ///
  /// In lo, this message translates to:
  /// **'ມີທິບໃຫ້ພ້ອມ'**
  String get bookingTipReady;

  /// No description provided for @bookingAttire.
  ///
  /// In lo, this message translates to:
  /// **'ການເເຕ່ງກາຍ'**
  String get bookingAttire;

  /// No description provided for @bookingId.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດການຈອງ'**
  String get bookingId;

  /// No description provided for @bookingCreatedAt.
  ///
  /// In lo, this message translates to:
  /// **'ເວລາຈອງ'**
  String get bookingCreatedAt;

  /// No description provided for @bookingNoName.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີຊື່'**
  String get bookingNoName;

  /// No description provided for @bookingTotalPrice.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາທັງໝົດ'**
  String get bookingTotalPrice;

  /// No description provided for @bookingActionChat.
  ///
  /// In lo, this message translates to:
  /// **'ເເຊັດ'**
  String get bookingActionChat;

  /// No description provided for @bookingActionReleasePayment.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ອຍເງີນ'**
  String get bookingActionReleasePayment;

  /// No description provided for @bookingActionRefund.
  ///
  /// In lo, this message translates to:
  /// **'ເງິນຄືນ'**
  String get bookingActionRefund;

  /// No description provided for @bookingActionReject.
  ///
  /// In lo, this message translates to:
  /// **'ປະຕິເສດ'**
  String get bookingActionReject;

  /// No description provided for @bookingActionReceiveMoney.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບເງີນ'**
  String get bookingActionReceiveMoney;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກການຈອງ'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຕ້ອງການຍົກເລີກການຈອງນີ້ແທ້ບໍ່?\nການຍົກເລີກນີ້ບໍ່ສາມາດຖືກຄືນໄດ້.'**
  String get cancelBookingMessage;

  /// No description provided for @cancelBookingMessageShort.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຕ້ອງການຍົກເລີກການຈອງນີ້ແທ້ບໍ່?'**
  String get cancelBookingMessageShort;

  /// No description provided for @deleteItemTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບລາຍການ'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຕ້ອງການລຶບລາຍການນີ້ແທ້ບໍ່?'**
  String get deleteItemMessage;

  /// No description provided for @refundReasonTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເຫດຜົນການຮ້ອງຂໍເງິນຄືນ'**
  String get refundReasonTitle;

  /// No description provided for @rejectReasonTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເຫດຜົນການປະຕິເສດ'**
  String get rejectReasonTitle;

  /// No description provided for @reasonMinLength.
  ///
  /// In lo, this message translates to:
  /// **'ເຫດຜົນຕ້ອງມີຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ'**
  String get reasonMinLength;

  /// No description provided for @reasonHint.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາລະບຸເຫດຜົນ (ຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ)'**
  String get reasonHint;

  /// No description provided for @cancellationPolicyCanCancel.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກໄດ້'**
  String get cancellationPolicyCanCancel;

  /// No description provided for @cancellationPolicyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ນະໂຍບາຍຍົກເລີກ & ຄືນເງິນ'**
  String get cancellationPolicyTitle;

  /// No description provided for @cancellationPolicyExpand.
  ///
  /// In lo, this message translates to:
  /// **'ດູເພີ່ມ'**
  String get cancellationPolicyExpand;

  /// No description provided for @cancellationPolicyCollapse.
  ///
  /// In lo, this message translates to:
  /// **'ຫຍໍ້'**
  String get cancellationPolicyCollapse;

  /// No description provided for @cancellationTier1Title.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກກ່ອນ 30 ນາທີ'**
  String get cancellationTier1Title;

  /// No description provided for @cancellationTier1Subtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄືນເງິນທັນທີ ພາຍໃນ 24 ຊົ່ວໂມງ'**
  String get cancellationTier1Subtitle;

  /// No description provided for @cancellationTier2Title.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກຫຼັງ 30 ນາທີ'**
  String get cancellationTier2Title;

  /// No description provided for @cancellationTier2Subtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄືນເງິນພາຍໃນ 24 ຊົ່ວໂມງ'**
  String get cancellationTier2Subtitle;

  /// No description provided for @cancellationTier3Title.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກຫຼັງເລີ່ມນັດ'**
  String get cancellationTier3Title;

  /// No description provided for @cancellationTier3Subtitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດຄືນເງິນໄດ້'**
  String get cancellationTier3Subtitle;

  /// No description provided for @cancellationRefundInfo.
  ///
  /// In lo, this message translates to:
  /// **'ເງິນຈະຖືກໂອນຄືນໄປຍັງຊ່ອງທາງທີ່ທ່ານຊຳລະ ພາຍໃນ 24 ຊົ່ວໂມງ'**
  String get cancellationRefundInfo;

  /// No description provided for @bookingSummaryActive.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງມາ'**
  String get bookingSummaryActive;

  /// No description provided for @commonAdd.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມ'**
  String get commonAdd;

  /// No description provided for @commonUpdate.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດ'**
  String get commonUpdate;

  /// No description provided for @commonEnable.
  ///
  /// In lo, this message translates to:
  /// **'ເປີດໃຊ້'**
  String get commonEnable;

  /// No description provided for @billingPerHourShort.
  ///
  /// In lo, this message translates to:
  /// **'/ຊ.ມ'**
  String get billingPerHourShort;

  /// No description provided for @billingPerDayShort.
  ///
  /// In lo, this message translates to:
  /// **'/ມື້'**
  String get billingPerDayShort;

  /// No description provided for @billingPerNightShort.
  ///
  /// In lo, this message translates to:
  /// **'/ຄືນ'**
  String get billingPerNightShort;

  /// No description provided for @billingPerSession.
  ///
  /// In lo, this message translates to:
  /// **'/ຄັ້ງ'**
  String get billingPerSession;

  /// No description provided for @billingPerMinute.
  ///
  /// In lo, this message translates to:
  /// **'/ນາທີ'**
  String get billingPerMinute;

  /// No description provided for @servicesManageSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຈັດການ ແລະ ຕັ້ງລາຄາບໍລິການ'**
  String get servicesManageSubtitle;

  /// No description provided for @servicesManageDeleteTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບ {name}'**
  String servicesManageDeleteTitle(String name);

  /// No description provided for @servicesManageDeleteMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຕ້ອງການລຶບບໍລິການນີ້ອອກຈາກໂປຣໄຟຂອງທ່ານແທ້ບໍ່?'**
  String get servicesManageDeleteMessage;

  /// No description provided for @servicesManageYourRate.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາທ່ານກຳນົດ'**
  String get servicesManageYourRate;

  /// No description provided for @servicesManageFeePerSession.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່າບໍລິການ/ຄັ້ງ'**
  String get servicesManageFeePerSession;

  /// No description provided for @servicesManageActualEarnings.
  ///
  /// In lo, this message translates to:
  /// **'ເງິນທີ່ໄດ້ຮັບຕົວຈິງ'**
  String get servicesManageActualEarnings;

  /// No description provided for @servicesManagePriceList.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການລາຄາ'**
  String get servicesManagePriceList;

  /// No description provided for @servicesManageCommissionPerSession.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່ານາຍໜ້າ/ຄັ້ງ'**
  String get servicesManageCommissionPerSession;

  /// No description provided for @servicesManageCommission.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່ານາຍໜ້າ'**
  String get servicesManageCommission;

  /// No description provided for @servicesManageBaseRate.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາພື້ນຖານ'**
  String get servicesManageBaseRate;

  /// No description provided for @servicesManageAddThis.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມບໍລິການນີ້'**
  String get servicesManageAddThis;

  /// No description provided for @servicesManageLocationRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ທີ່ຢູ່/ສະຖານທີ່'**
  String get servicesManageLocationRequired;

  /// No description provided for @servicesManageUpdateMassageRate.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດລາຄານວດ'**
  String get servicesManageUpdateMassageRate;

  /// No description provided for @servicesManageAddMassageRate.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມລາຄານວດ'**
  String get servicesManageAddMassageRate;

  /// No description provided for @servicesManageVariantName.
  ///
  /// In lo, this message translates to:
  /// **'ຊື່ປະເພດ'**
  String get servicesManageVariantName;

  /// No description provided for @servicesManagePriceKipPerHour.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາ (ກີບ/ຊມ)'**
  String get servicesManagePriceKipPerHour;

  /// No description provided for @servicesManagePriceKipPerHourShort.
  ///
  /// In lo, this message translates to:
  /// **'{amount} ກີບ/ຊມ'**
  String servicesManagePriceKipPerHourShort(String amount);

  /// No description provided for @servicesManageMinimum.
  ///
  /// In lo, this message translates to:
  /// **'ຕ່ຳສຸດ {amount}'**
  String servicesManageMinimum(String amount);

  /// No description provided for @servicesManageAddVariant.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມປະເພດ'**
  String get servicesManageAddVariant;

  /// No description provided for @servicesManageAddressLabel.
  ///
  /// In lo, this message translates to:
  /// **'ທີ່ຢູ່/ສະຖານທີ່'**
  String get servicesManageAddressLabel;

  /// No description provided for @servicesManageAddressHint.
  ///
  /// In lo, this message translates to:
  /// **'ເຊັ່ນ: ນະຄອນຫຼວງວຽງຈັນ, ສີສັດຕະນາກ'**
  String get servicesManageAddressHint;

  /// No description provided for @servicesManageInstructions.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກເພີ່ມບໍລິການທີ່ທ່ານສາມາດໃຫ້ໄດ້ ແລະ ຕັ້ງລາຄາຂອງທ່ານເອງ. ລູກຄ້າຈະເຫັນລາຍການທີ່ທ່ານເປີດໃຊ້ເທົ່ານັ້ນ.'**
  String get servicesManageInstructions;

  /// No description provided for @servicesManageNoData.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີຂໍ້ມູນບໍລິການ'**
  String get servicesManageNoData;

  /// No description provided for @servicesManageValidRateRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ລາຄາທີ່ຖືກຕ້ອງ'**
  String get servicesManageValidRateRequired;

  /// No description provided for @servicesManageMinRate.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາຕ່ຳສຸດ: {amount} ກີບ'**
  String servicesManageMinRate(String amount);

  /// No description provided for @servicesManageUpdatePrice.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດລາຄາ'**
  String get servicesManageUpdatePrice;

  /// No description provided for @servicesManageAddService.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມບໍລິການ'**
  String get servicesManageAddService;

  /// No description provided for @servicesManagePriceWithBilling.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາ{billing} (ກີບ)'**
  String servicesManagePriceWithBilling(String billing);

  /// No description provided for @registerCompanionTitle.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງບັນຊີ ສຳລັບຜູ້ໃຫ້ບໍລິການ'**
  String get registerCompanionTitle;

  /// No description provided for @registerCustomerTitle.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງບັນຊີ ສຳລັບລູກຄ້າ'**
  String get registerCustomerTitle;

  /// No description provided for @registerFillInfo.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບ'**
  String get registerFillInfo;

  /// No description provided for @registerFirstName.
  ///
  /// In lo, this message translates to:
  /// **'ຊື່'**
  String get registerFirstName;

  /// No description provided for @registerLastName.
  ///
  /// In lo, this message translates to:
  /// **'ນາມສະກຸນ'**
  String get registerLastName;

  /// No description provided for @registerFirstNameHint.
  ///
  /// In lo, this message translates to:
  /// **'ປ້ອນຊື່'**
  String get registerFirstNameHint;

  /// No description provided for @registerLastNameHint.
  ///
  /// In lo, this message translates to:
  /// **'ປ້ອນນາມສະກຸນ'**
  String get registerLastNameHint;

  /// No description provided for @registerPhone.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທລະສັບ'**
  String get registerPhone;

  /// No description provided for @registerSelectGender.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກເພດ'**
  String get registerSelectGender;

  /// No description provided for @registerDob.
  ///
  /// In lo, this message translates to:
  /// **'ວັນເດືອນປີເກີດ'**
  String get registerDob;

  /// No description provided for @registerPassword.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານ'**
  String get registerPassword;

  /// No description provided for @registerPasswordHint.
  ///
  /// In lo, this message translates to:
  /// **'ປ້ອນລະຫັດຜ່ານ'**
  String get registerPasswordHint;

  /// No description provided for @registerAddress.
  ///
  /// In lo, this message translates to:
  /// **'ທີ່ຢູ່'**
  String get registerAddress;

  /// No description provided for @registerAddressHint.
  ///
  /// In lo, this message translates to:
  /// **'ນາທົ່ມ,ໜອງວຽງຄຳ,ວຽງຈັນ...'**
  String get registerAddressHint;

  /// No description provided for @registerReferredBy.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານໄດ້ຮັບການແນະນຳຈາກ'**
  String get registerReferredBy;

  /// No description provided for @registerCta.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງບັນຊື'**
  String get registerCta;

  /// No description provided for @registerTermsPrefix.
  ///
  /// In lo, this message translates to:
  /// **'ຂ້ອຍໄດ້ອ່ານ ແລະ ຍອມຮັບ '**
  String get registerTermsPrefix;

  /// No description provided for @registerTermsOfUse.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ກຳນົດການໃຊ້ງານ'**
  String get registerTermsOfUse;

  /// No description provided for @registerTermsAnd.
  ///
  /// In lo, this message translates to:
  /// **' ແລະ '**
  String get registerTermsAnd;

  /// No description provided for @registerPrivacyPolicy.
  ///
  /// In lo, this message translates to:
  /// **'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ'**
  String get registerPrivacyPolicy;

  /// No description provided for @registerTermsSuffix.
  ///
  /// In lo, this message translates to:
  /// **' ຂອງ XAOSAO'**
  String get registerTermsSuffix;

  /// No description provided for @registerAvatarChange.
  ///
  /// In lo, this message translates to:
  /// **'ກົດເພື່ອປ່ຽນຮູບ'**
  String get registerAvatarChange;

  /// No description provided for @registerAvatarPick.
  ///
  /// In lo, this message translates to:
  /// **'ກົດເພື່ອເລືອກຮູບ'**
  String get registerAvatarPick;

  /// No description provided for @registerStepInfo.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນ'**
  String get registerStepInfo;

  /// No description provided for @registerStepServices.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການ'**
  String get registerStepServices;

  /// No description provided for @registerStepOtp.
  ///
  /// In lo, this message translates to:
  /// **'OTP'**
  String get registerStepOtp;

  /// No description provided for @registerServicesTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກບໍລິການ'**
  String get registerServicesTitle;

  /// No description provided for @registerServicesSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ກຳນົດປະເພດ ແລະ ລາຄາບໍລິການຂອງທ່ານ'**
  String get registerServicesSubtitle;

  /// No description provided for @registerNoServices.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີບໍລິການ'**
  String get registerNoServices;

  /// No description provided for @registerServicesInfoPrefix.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາດຳເນີນການ'**
  String get registerServicesInfoPrefix;

  /// No description provided for @registerServicesInfoSelect.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກບໍລິການ'**
  String get registerServicesInfoSelect;

  /// No description provided for @registerServicesInfoMid.
  ///
  /// In lo, this message translates to:
  /// **' ທີ່ທ່ານຕ້ອງການ ແລະ '**
  String get registerServicesInfoMid;

  /// No description provided for @registerServicesInfoSetPrice.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງລາຄາ'**
  String get registerServicesInfoSetPrice;

  /// No description provided for @registerServicesInfoDot.
  ///
  /// In lo, this message translates to:
  /// **'.'**
  String get registerServicesInfoDot;

  /// No description provided for @registerPriceRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ລາຄາ'**
  String get registerPriceRequired;

  /// No description provided for @registerMinPrice.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາຕ່ຳສຸດ {amount} ກີບ'**
  String registerMinPrice(String amount);

  /// No description provided for @registerPricePerHourLabel.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາ (ກີບ/ຊົ່ວໂມງ) *'**
  String get registerPricePerHourLabel;

  /// No description provided for @registerMinPriceKip.
  ///
  /// In lo, this message translates to:
  /// **'ຕ່ຳສຸດ {amount} ກີບ'**
  String registerMinPriceKip(String amount);

  /// No description provided for @registerAllVariants.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມໄດ້ທຸກປະເພດ'**
  String get registerAllVariants;

  /// No description provided for @registerServiceLocation.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖານທີ່ໃຫ້ບໍລິການ *'**
  String get registerServiceLocation;

  /// No description provided for @registerServiceLocationHint.
  ///
  /// In lo, this message translates to:
  /// **'ເຊັ່ນ: ເຮືອນ, ໂຮງແຮມ, ສະຖານທີ່ລູກຄ້າ'**
  String get registerServiceLocationHint;

  /// No description provided for @registerVariantsPriceLabel.
  ///
  /// In lo, this message translates to:
  /// **'ປະເພດ ແລະ ລາຄາ (ກີບ/ຊົ່ວໂມງ) *'**
  String get registerVariantsPriceLabel;

  /// No description provided for @registerContinueCta.
  ///
  /// In lo, this message translates to:
  /// **'ດຳເນີນການຕໍ່'**
  String get registerContinueCta;

  /// No description provided for @registerCurrencyPerHour.
  ///
  /// In lo, this message translates to:
  /// **'ກີບ/ຊມ'**
  String get registerCurrencyPerHour;

  /// No description provided for @registerOtpSmsInfo.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາກວດເບິ່ງ SMS ຂອງທ່ານ\nລະຫັດໃຊ້ໄດ້ 5 ນາທີ ເທົ່ານັ້ນ'**
  String get registerOtpSmsInfo;

  /// No description provided for @registerOtpInvalid.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ — ລອງໃໝ່'**
  String get registerOtpInvalid;

  /// No description provided for @registerOtpInvalidRetry.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ ກະລຸນາລອງໃໝ່'**
  String get registerOtpInvalidRetry;

  /// No description provided for @registerOtpExpiresIn.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດໝົດອາຍຸໃນ '**
  String get registerOtpExpiresIn;

  /// No description provided for @registerOtpExpired.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດໝົດອາຍຸແລ້ວ'**
  String get registerOtpExpired;

  /// No description provided for @registerOtpNotReceived.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ໄດ້ຮັບລະຫັດ? '**
  String get registerOtpNotReceived;

  /// No description provided for @registerOtpResend.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງໃໝ່'**
  String get registerOtpResend;

  /// No description provided for @registerOtpChangePhone.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນເບີໂທລະສັບ'**
  String get registerOtpChangePhone;

  /// No description provided for @registerOtpConfirmPhone.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນເບີໂທ'**
  String get registerOtpConfirmPhone;

  /// No description provided for @registerOtpEnter6Digits.
  ///
  /// In lo, this message translates to:
  /// **'ໃສ່ລະຫັດ 6 ໂຕທີ່ສົ່ງໄປຫາ'**
  String get registerOtpEnter6Digits;

  /// No description provided for @registerOtpVerify.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນ OTP'**
  String get registerOtpVerify;

  /// No description provided for @commonEdit.
  ///
  /// In lo, this message translates to:
  /// **'ແກ້ໄຂ'**
  String get commonEdit;

  /// No description provided for @commonConnectionRetry.
  ///
  /// In lo, this message translates to:
  /// **'ກວດສອບການເຊື່ອມຕໍ່ແລ້ວລອງໃໝ່'**
  String get commonConnectionRetry;

  /// No description provided for @commonBank.
  ///
  /// In lo, this message translates to:
  /// **'ທະນາຄານ'**
  String get commonBank;

  /// No description provided for @qrTitle.
  ///
  /// In lo, this message translates to:
  /// **'QR ໂອນເງິນ'**
  String get qrTitle;

  /// No description provided for @qrSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຈັດການ QR Code ຂອງຂ້ອຍ'**
  String get qrSubtitle;

  /// No description provided for @qrDeleteTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບ QR Code'**
  String get qrDeleteTitle;

  /// No description provided for @qrDeleteMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບ QR Code ນີ້?'**
  String get qrDeleteMessage;

  /// No description provided for @qrDefaultLabel.
  ///
  /// In lo, this message translates to:
  /// **'ບັນຊີຫຼັກ'**
  String get qrDefaultLabel;

  /// No description provided for @qrScanHint.
  ///
  /// In lo, this message translates to:
  /// **'ໃຫ້ລູກຄ້າສະແກນ QR ນີ້ເພື່ອໂອນເງິນ'**
  String get qrScanHint;

  /// No description provided for @qrEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີ QR Code'**
  String get qrEmptyTitle;

  /// No description provided for @qrEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມ QR Code ທະນາຄານຂອງທ່ານ\nເພື່ອຮັບເງິນຈາກລູກຄ້າ'**
  String get qrEmptySubtitle;

  /// No description provided for @qrEmptyAddFirst.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມ QR Code ທຳອິດ'**
  String get qrEmptyAddFirst;

  /// No description provided for @qrSetPrimary.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງເປັນ QR ຫຼັກ'**
  String get qrSetPrimary;

  /// No description provided for @qrAddNew.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມ QR ໃໝ່'**
  String get qrAddNew;

  /// No description provided for @qrInfoBanner.
  ///
  /// In lo, this message translates to:
  /// **'QR ທີ່ຕັ້ງເປັນ ຫຼັກ ຈະໂຊໃນໜ້າ Profile ຂອງທ່ານ ເພື່ອໃຫ້ລູກຄ້າສາມາດສະແກນໂອນເງິນໄດ້ທັນທີ.'**
  String get qrInfoBanner;

  /// No description provided for @qrAddFailed.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມ QR ບໍ່ສຳເລັດ'**
  String get qrAddFailed;

  /// No description provided for @qrUpdateFailed.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດ QR ບໍ່ສຳເລັດ'**
  String get qrUpdateFailed;

  /// No description provided for @qrDeleteFailed.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບ QR ບໍ່ສຳເລັດ'**
  String get qrDeleteFailed;

  /// No description provided for @qrSetDefaultFailed.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງ QR ຫຼັກບໍ່ສຳເລັດ'**
  String get qrSetDefaultFailed;

  /// No description provided for @genderMaleShort.
  ///
  /// In lo, this message translates to:
  /// **'ຊາຍ'**
  String get genderMaleShort;

  /// No description provided for @genderFemaleShort.
  ///
  /// In lo, this message translates to:
  /// **'ຍິງ'**
  String get genderFemaleShort;

  /// No description provided for @genderOther.
  ///
  /// In lo, this message translates to:
  /// **'ອື່ນໆ'**
  String get genderOther;

  /// No description provided for @monthLongJan.
  ///
  /// In lo, this message translates to:
  /// **'ມັງກອນ'**
  String get monthLongJan;

  /// No description provided for @monthLongFeb.
  ///
  /// In lo, this message translates to:
  /// **'ກຸມພາ'**
  String get monthLongFeb;

  /// No description provided for @monthLongMar.
  ///
  /// In lo, this message translates to:
  /// **'ມີນາ'**
  String get monthLongMar;

  /// No description provided for @monthLongApr.
  ///
  /// In lo, this message translates to:
  /// **'ເມສາ'**
  String get monthLongApr;

  /// No description provided for @monthLongMay.
  ///
  /// In lo, this message translates to:
  /// **'ພຶດສະພາ'**
  String get monthLongMay;

  /// No description provided for @monthLongJun.
  ///
  /// In lo, this message translates to:
  /// **'ມິຖຸນາ'**
  String get monthLongJun;

  /// No description provided for @monthLongJul.
  ///
  /// In lo, this message translates to:
  /// **'ກໍລະກົດ'**
  String get monthLongJul;

  /// No description provided for @monthLongAug.
  ///
  /// In lo, this message translates to:
  /// **'ສິງຫາ'**
  String get monthLongAug;

  /// No description provided for @monthLongSep.
  ///
  /// In lo, this message translates to:
  /// **'ກັນຍາ'**
  String get monthLongSep;

  /// No description provided for @monthLongOct.
  ///
  /// In lo, this message translates to:
  /// **'ຕຸລາ'**
  String get monthLongOct;

  /// No description provided for @monthLongNov.
  ///
  /// In lo, this message translates to:
  /// **'ພະຈິກ'**
  String get monthLongNov;

  /// No description provided for @monthLongDec.
  ///
  /// In lo, this message translates to:
  /// **'ທັນວາ'**
  String get monthLongDec;

  /// No description provided for @profileTitle.
  ///
  /// In lo, this message translates to:
  /// **'ໂປຣໄຟລ໌'**
  String get profileTitle;

  /// No description provided for @profileSectionGeneralInfo.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນທົ່ວໄປ'**
  String get profileSectionGeneralInfo;

  /// No description provided for @profileSectionAccountInfo.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນບັນຊີ'**
  String get profileSectionAccountInfo;

  /// No description provided for @profileSectionServices.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການ'**
  String get profileSectionServices;

  /// No description provided for @profileFullName.
  ///
  /// In lo, this message translates to:
  /// **'ຊື່-ນາມສະກຸນ'**
  String get profileFullName;

  /// No description provided for @profilePhone.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທ'**
  String get profilePhone;

  /// No description provided for @profileGender.
  ///
  /// In lo, this message translates to:
  /// **'ເພດ'**
  String get profileGender;

  /// No description provided for @profileAccountCreated.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງບັນຊີ'**
  String get profileAccountCreated;

  /// No description provided for @profileNoServices.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີບໍລິການ'**
  String get profileNoServices;

  /// No description provided for @profileVerifiedCustomer.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັງແລ້ວ'**
  String get profileVerifiedCustomer;

  /// No description provided for @profileVerifiedCompanion.
  ///
  /// In lo, this message translates to:
  /// **'Companion ຢືນຢັງ'**
  String get profileVerifiedCompanion;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດຂໍ້ມູນສຳເລັດ'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດຂໍ້ມູນບໍ່ສຳເລັດ'**
  String get profileUpdateFailed;

  /// No description provided for @profileEditTitle.
  ///
  /// In lo, this message translates to:
  /// **'ແກ້ໄຂຂໍ້ມູນ'**
  String get profileEditTitle;

  /// No description provided for @profilePhoneReadonlyLabel.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທ (ບໍ່ສາມາດປ່ຽນ)'**
  String get profilePhoneReadonlyLabel;

  /// No description provided for @profileAddressHint.
  ///
  /// In lo, this message translates to:
  /// **'ເຊັ່ນ: ໂຊນ 1, ວຽງຈັນ'**
  String get profileAddressHint;

  /// No description provided for @profileEditNote.
  ///
  /// In lo, this message translates to:
  /// **'ການປ່ຽນລະຫັດຜ່ານ ແລະ ເລກໂທ, ຕ້ອງໄປທີ່ ໜ້າຕັ້ງຄ່າ'**
  String get profileEditNote;

  /// No description provided for @profileSave.
  ///
  /// In lo, this message translates to:
  /// **'ບັນທຶກ'**
  String get profileSave;

  /// No description provided for @commonErrorTryAgain.
  ///
  /// In lo, this message translates to:
  /// **'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ'**
  String get commonErrorTryAgain;

  /// No description provided for @commonUploadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ອັບໂຫຼດບໍ່ສຳເລັດ'**
  String get commonUploadFailed;

  /// No description provided for @changePasswordTitle.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນລະຫັດຜ່ານ'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງໃສ່ລະຫັດທຳກ່ອນ'**
  String get changePasswordSubtitle;

  /// No description provided for @changePasswordSectionCurrent.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານ'**
  String get changePasswordSectionCurrent;

  /// No description provided for @changePasswordCurrentLabel.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານປັດຈຸບັນ'**
  String get changePasswordCurrentLabel;

  /// No description provided for @changePasswordMin6.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານຕ້ອງຢ່າງໜ້ອຍ 6 ໂຕ'**
  String get changePasswordMin6;

  /// No description provided for @changePasswordSectionNew.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດໃໝ່'**
  String get changePasswordSectionNew;

  /// No description provided for @changePasswordNewLabel.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານໃໝ່'**
  String get changePasswordNewLabel;

  /// No description provided for @changePasswordNewHint.
  ///
  /// In lo, this message translates to:
  /// **'ໃສ່ລະຫັດໃໝ່'**
  String get changePasswordNewHint;

  /// No description provided for @changePasswordConfirmLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນລະຫັດໃໝ່'**
  String get changePasswordConfirmLabel;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານບໍ່ກົງກັນ'**
  String get changePasswordMismatch;

  /// No description provided for @changePasswordSave.
  ///
  /// In lo, this message translates to:
  /// **'ບັນທຶກລະຫັດໃໝ່'**
  String get changePasswordSave;

  /// No description provided for @changePasswordSecurityTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄວາມປອດໄພ'**
  String get changePasswordSecurityTitle;

  /// No description provided for @changePasswordSecurityRule.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານຕ້ອງຢ່າງໜ້ອຍ 8 ໂຕ, ລວມທັງຕົວໃຫຍ່, ຕົວເລກ ແລະ ສັນຍາລັກ'**
  String get changePasswordSecurityRule;

  /// No description provided for @changePasswordStrengthWeak.
  ///
  /// In lo, this message translates to:
  /// **'ອ່ອນ'**
  String get changePasswordStrengthWeak;

  /// No description provided for @changePasswordStrengthFair.
  ///
  /// In lo, this message translates to:
  /// **'ປານກາງ'**
  String get changePasswordStrengthFair;

  /// No description provided for @changePasswordStrengthStrong.
  ///
  /// In lo, this message translates to:
  /// **'ແຂງແຮງ'**
  String get changePasswordStrengthStrong;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນລະຫັດຜ່ານສຳເລັດ'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordFailed.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນລະຫັດຜ່ານບໍ່ສຳເລັດ'**
  String get changePasswordFailed;

  /// No description provided for @profileToggleStatusFailed.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນສະຖານະບໍ່ສຳເລັດ'**
  String get profileToggleStatusFailed;

  /// No description provided for @profileUploadPhotoFailed.
  ///
  /// In lo, this message translates to:
  /// **'ອັບໂຫຼດຮູບໂປຣໄຟບໍ່ສຳເລັດ'**
  String get profileUploadPhotoFailed;

  /// No description provided for @profileNoPhotos.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຮູບ'**
  String get profileNoPhotos;

  /// No description provided for @profileGalleryTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຮູບພາບທັງໝົດ'**
  String get profileGalleryTitle;

  /// No description provided for @profileGalleryCount.
  ///
  /// In lo, this message translates to:
  /// **'{count} / {max} ຮູບ'**
  String profileGalleryCount(int count, int max);

  /// No description provided for @profileDeletePhotoTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບຮູບ'**
  String get profileDeletePhotoTitle;

  /// No description provided for @profileDeletePhotoMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຕ້ອງການລຶບຮູບນີ້ແທ້ບໍ່?'**
  String get profileDeletePhotoMessage;

  /// No description provided for @profileAddPhoto.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມຮູບ'**
  String get profileAddPhoto;

  /// No description provided for @profileHiddenShowSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສະແດງໂປຣໄຟສຳເລັດ'**
  String get profileHiddenShowSuccess;

  /// No description provided for @profileHiddenBannerBody.
  ///
  /// In lo, this message translates to:
  /// **'ລູກຄ້າບໍ່ສາມາດເຫັນໂປຣໄຟຂອງທ່ານໃນຕອນນີ້. ເມື່ອທ່ານພ້ອມຮັບການຈອງອີກຄັ້ງ, ກົດສະແດງໂປຣໄຟຂອງທ່ານ.'**
  String get profileHiddenBannerBody;

  /// No description provided for @profileHiddenClose.
  ///
  /// In lo, this message translates to:
  /// **'ປິດ'**
  String get profileHiddenClose;

  /// No description provided for @profileHiddenShow.
  ///
  /// In lo, this message translates to:
  /// **'ສະແດງໂປຣໄຟ'**
  String get profileHiddenShow;

  /// No description provided for @profileHiddenHeaderTitle.
  ///
  /// In lo, this message translates to:
  /// **'ໂປຣໄຟຂອງທ່ານຖືກຊ່ອນຢູ່'**
  String get profileHiddenHeaderTitle;

  /// No description provided for @profileHiddenHeaderSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຈະບໍ່ສະແດງໃນຜົນຄົ້ນຫາ'**
  String get profileHiddenHeaderSubtitle;

  /// No description provided for @profileShareLink.
  ///
  /// In lo, this message translates to:
  /// **'ແຊຣ໌ Profile Link'**
  String get profileShareLink;

  /// No description provided for @profileHideYourProfile.
  ///
  /// In lo, this message translates to:
  /// **'ເຊື່ອງໂປຣໄຟຂອງທ່ານ'**
  String get profileHideYourProfile;

  /// No description provided for @qrRowScanToTransfer.
  ///
  /// In lo, this message translates to:
  /// **'ສະແກນເພື່ອໂອນເງິນ'**
  String get qrRowScanToTransfer;

  /// No description provided for @servicesEditAddLabel.
  ///
  /// In lo, this message translates to:
  /// **'ແກ້ໄຂ / ເພີ່ມ ບໍລິການ'**
  String get servicesEditAddLabel;

  /// No description provided for @servicesEditAddSub.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງລາຄາ ແລະ ຄຳອະທິບາຍ'**
  String get servicesEditAddSub;

  /// No description provided for @timeJustNow.
  ///
  /// In lo, this message translates to:
  /// **'ໃໝ່ໆ'**
  String get timeJustNow;

  /// No description provided for @timeJustNowShort.
  ///
  /// In lo, this message translates to:
  /// **'ຫາກໍ່'**
  String get timeJustNowShort;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ນາທີກ່ອນ'**
  String timeMinutesAgo(int n);

  /// No description provided for @timeHoursAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ຊົ່ວໂມງກ່ອນ'**
  String timeHoursAgo(int n);

  /// No description provided for @timeDaysAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ວັນກ່ອນ'**
  String timeDaysAgo(int n);

  /// No description provided for @timeWeeksAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ອາທິດກ່ອນ'**
  String timeWeeksAgo(int n);

  /// No description provided for @timeMinutesShort.
  ///
  /// In lo, this message translates to:
  /// **'{n}ນາທີ'**
  String timeMinutesShort(int n);

  /// No description provided for @timeHoursShort.
  ///
  /// In lo, this message translates to:
  /// **'{n}ຊົ່ວໂມງ'**
  String timeHoursShort(int n);

  /// No description provided for @timeDaysShort.
  ///
  /// In lo, this message translates to:
  /// **'{n}ວັນ'**
  String timeDaysShort(int n);

  /// No description provided for @timeWeeksShort.
  ///
  /// In lo, this message translates to:
  /// **'{n}ອາທິດ'**
  String timeWeeksShort(int n);

  /// No description provided for @timeDaysShortSpaced.
  ///
  /// In lo, this message translates to:
  /// **'{n} ວັນ'**
  String timeDaysShortSpaced(int n);

  /// No description provided for @timeWeeksShortSpaced.
  ///
  /// In lo, this message translates to:
  /// **'{n} ອາທິດ'**
  String timeWeeksShortSpaced(int n);

  /// No description provided for @commonUser.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ໃຊ້'**
  String get commonUser;

  /// No description provided for @commonYou.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານ'**
  String get commonYou;

  /// No description provided for @commonLoadMore.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດເພີ່ມ'**
  String get commonLoadMore;

  /// No description provided for @commonAmountKip.
  ///
  /// In lo, this message translates to:
  /// **'{amount} ກີບ'**
  String commonAmountKip(String amount);

  /// No description provided for @postsTitle.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສ'**
  String get postsTitle;

  /// No description provided for @postsSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາຜູ້ໃຫ້ບໍລິການທີ່ໃຊ້ຂອງທ່ານ'**
  String get postsSubtitle;

  /// No description provided for @postsCantLoad.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ'**
  String get postsCantLoad;

  /// No description provided for @postsPleaseRetry.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ'**
  String get postsPleaseRetry;

  /// No description provided for @postsEmpty.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີໂພສ'**
  String get postsEmpty;

  /// No description provided for @postsEmptyFeedSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສຈາກ Companion ຈະສະແດງທີ່ນີ້'**
  String get postsEmptyFeedSubtitle;

  /// No description provided for @postsEmptyMySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ກົດ \"ສ້າງໂພສ\" ເພື່ອເລີ່ມໂພສ'**
  String get postsEmptyMySubtitle;

  /// No description provided for @postsShare.
  ///
  /// In lo, this message translates to:
  /// **'ແຊຣ໌ໂພສ'**
  String get postsShare;

  /// No description provided for @postsReport.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍງານ'**
  String get postsReport;

  /// No description provided for @postsDeleteTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບໂພສ'**
  String get postsDeleteTitle;

  /// No description provided for @postsDeleteMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານແນ່ໃຈທີ່ຈະລຶບໂພສນີ້ບໍ?\nການດຳເນີນການນີ້ບໍ່ສາມາດຍ້ອນຄືນໄດ້'**
  String get postsDeleteMessage;

  /// No description provided for @postsDisableTitle.
  ///
  /// In lo, this message translates to:
  /// **'ປິດໂພສ'**
  String get postsDisableTitle;

  /// No description provided for @postsDisableMessage.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານແນ່ໃຈທີ່ຈະປິດໂພສນີ້ບໍ?\nລູກຄ້າຈະບໍ່ສາມາດເຫັນໂພສນີ້ໄດ້'**
  String get postsDisableMessage;

  /// No description provided for @postsDisableConfirm.
  ///
  /// In lo, this message translates to:
  /// **'ປິດໂພສ'**
  String get postsDisableConfirm;

  /// No description provided for @postsCreate.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງໂພສ'**
  String get postsCreate;

  /// No description provided for @postsTabAll.
  ///
  /// In lo, this message translates to:
  /// **'ທັງໝົດ'**
  String get postsTabAll;

  /// No description provided for @postsTabMine.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂ້ອຍ'**
  String get postsTabMine;

  /// No description provided for @postsPublicPost.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສສາທາລະນະ'**
  String get postsPublicPost;

  /// No description provided for @postsWhatLookingFor.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານກຳລັງຊອກຫາຄູ່ເເບບໃດ?'**
  String get postsWhatLookingFor;

  /// No description provided for @postsHintCustomer.
  ///
  /// In lo, this message translates to:
  /// **'ຕົວຢ່າງ: ຂ້ອຍກຳລັງຊ່ວຍລູກຄ້າທີ່ໂພສນີ້ ເພື່ອຫາຄູ່ດື່ມ'**
  String get postsHintCustomer;

  /// No description provided for @postsHintModel.
  ///
  /// In lo, this message translates to:
  /// **'ຕົວຢ່າງ: ຂ້ອຍຕ້ອງການ 2 ຄົນເປັນຄູ່ດື່ມຄືນນີ້'**
  String get postsHintModel;

  /// No description provided for @postsAddPhotos.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມຮູບພາບ'**
  String get postsAddPhotos;

  /// No description provided for @postsChangePhoto.
  ///
  /// In lo, this message translates to:
  /// **'ປ່ຽນຮູບ'**
  String get postsChangePhoto;

  /// No description provided for @postsSelectGender.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກເພດ'**
  String get postsSelectGender;

  /// No description provided for @postsSelectService.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກບໍລິການ'**
  String get postsSelectService;

  /// No description provided for @postsLocation.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖານທີ'**
  String get postsLocation;

  /// No description provided for @postsLocationHint.
  ///
  /// In lo, this message translates to:
  /// **'ຕົວຢ່າງ: ຮ້ານອາຫານ,ດາວອັງຄານ...'**
  String get postsLocationHint;

  /// No description provided for @postsWillTip.
  ///
  /// In lo, this message translates to:
  /// **'ຂ້ອຍຈະໃຫ້ທິບ'**
  String get postsWillTip;

  /// No description provided for @postsWillTipHelp.
  ///
  /// In lo, this message translates to:
  /// **'ເພື່ອໃຫ້ຮູ້ວ່າຈະໃຫ້ທິບ, ຈຶ່ງມີຄົນສົນໃຈຫຼາຍຂຶ້ນ'**
  String get postsWillTipHelp;

  /// No description provided for @postsSubmitAndNotify.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສ ແລະ ແຈ້ງເຕື່ອນ'**
  String get postsSubmitAndNotify;

  /// No description provided for @postsGenderAny.
  ///
  /// In lo, this message translates to:
  /// **'ທຸກເພດ'**
  String get postsGenderAny;

  /// No description provided for @postsGiftHistory.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດຂອງຂວັນ'**
  String get postsGiftHistory;

  /// No description provided for @postsGiftHistorySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ດູລາຍການຂອງຂວັນທີ່ທ່ານສົ່ງໃຫ້ໂມເດວ'**
  String get postsGiftHistorySubtitle;

  /// No description provided for @postsAuthorFallback.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ໂພສ'**
  String get postsAuthorFallback;

  /// No description provided for @postStatusActive.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງໃຊ້'**
  String get postStatusActive;

  /// No description provided for @postStatusExpired.
  ///
  /// In lo, this message translates to:
  /// **'ໝົດອາຍຸ'**
  String get postStatusExpired;

  /// No description provided for @postStatusHidden.
  ///
  /// In lo, this message translates to:
  /// **'ຊ່ອນ'**
  String get postStatusHidden;

  /// No description provided for @postStatusFulfilled.
  ///
  /// In lo, this message translates to:
  /// **'ປິດໃຊ້ງານເເລ້ວ'**
  String get postStatusFulfilled;

  /// No description provided for @postActionBook.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງ'**
  String get postActionBook;

  /// No description provided for @postActionChat.
  ///
  /// In lo, this message translates to:
  /// **'ແຊັດ'**
  String get postActionChat;

  /// No description provided for @commentsTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄໍາເຫັນ'**
  String get commentsTitle;

  /// No description provided for @commentsEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຄໍາເຫັນ'**
  String get commentsEmptyTitle;

  /// No description provided for @commentsEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ເປັນຄົນທໍາອິດທີ່ຄອມເມັນ!'**
  String get commentsEmptySubtitle;

  /// No description provided for @commentReply.
  ///
  /// In lo, this message translates to:
  /// **'ຕອບກັບ'**
  String get commentReply;

  /// No description provided for @commentCollapseReplies.
  ///
  /// In lo, this message translates to:
  /// **'ຫຍໍ້ຄໍາຕອບ'**
  String get commentCollapseReplies;

  /// No description provided for @commentViewReplies.
  ///
  /// In lo, this message translates to:
  /// **'ເບິ່ງ {count} ຄໍາຕອບ'**
  String commentViewReplies(int count);

  /// No description provided for @commentReplyToHint.
  ///
  /// In lo, this message translates to:
  /// **'ຕອບ {name}...'**
  String commentReplyToHint(String name);

  /// No description provided for @commentWriteHint.
  ///
  /// In lo, this message translates to:
  /// **'ຂຽນຄໍາເຫັນ...'**
  String get commentWriteHint;

  /// No description provided for @postDetailTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍລະອຽດໂພສ'**
  String get postDetailTitle;

  /// No description provided for @postDetailActive.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງເປີດ'**
  String get postDetailActive;

  /// No description provided for @postDetailClosed.
  ///
  /// In lo, this message translates to:
  /// **'ປິດເເລ້ວ'**
  String get postDetailClosed;

  /// No description provided for @postDetailCollapse.
  ///
  /// In lo, this message translates to:
  /// **'ຫຍໍ້ລົງ'**
  String get postDetailCollapse;

  /// No description provided for @postDetailReadMore.
  ///
  /// In lo, this message translates to:
  /// **'ອ່ານເພີ່ມ'**
  String get postDetailReadMore;

  /// No description provided for @postDetailInterested.
  ///
  /// In lo, this message translates to:
  /// **'ສົນໃຈ'**
  String get postDetailInterested;

  /// No description provided for @postDetailGift.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນ'**
  String get postDetailGift;

  /// No description provided for @postDetailComment.
  ///
  /// In lo, this message translates to:
  /// **'ຄຳເຫັນ'**
  String get postDetailComment;

  /// No description provided for @interestTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ສົນໃຈ'**
  String get interestTitle;

  /// No description provided for @interestSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍຊື່ຜູ້ທີ່ສົນໃຈໂພສຂອງທ່ານ'**
  String get interestSubtitle;

  /// No description provided for @interestEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຜູ້ສົນໃຈ'**
  String get interestEmptyTitle;

  /// No description provided for @interestEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ເມື່ອມີຜູ້ກົດໃຈໂພສນີ້,\nຊື່ຂອງພວກເຂົາຈະສະແດງຢູ່ນີ້'**
  String get interestEmptySubtitle;

  /// No description provided for @giftReceivedTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນ'**
  String get giftReceivedTitle;

  /// No description provided for @giftReceivedSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນທີ່ທ່ານໄດ້ຮັບ'**
  String get giftReceivedSubtitle;

  /// No description provided for @giftEmptyReceivedTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຂອງຂວັນ'**
  String get giftEmptyReceivedTitle;

  /// No description provided for @giftEmptyReceivedSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນທີ່ຄົນສົ່ງໃຫ້ຈະສະແດງທີ່ນີ້'**
  String get giftEmptyReceivedSubtitle;

  /// No description provided for @giftSenderLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ສົ່ງຂອງຂວັນ'**
  String get giftSenderLabel;

  /// No description provided for @giftReceivedTotal.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນທີ່ໄດ້ຮັບທັງໝົດ'**
  String get giftReceivedTotal;

  /// No description provided for @giftFallback.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນ'**
  String get giftFallback;

  /// No description provided for @giftHistoryTitle.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດຂອງຂວັນ'**
  String get giftHistoryTitle;

  /// No description provided for @giftHistorySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການຂອງຂວັນທີ່ທ່ານໄດ້ສົ່ງ'**
  String get giftHistorySubtitle;

  /// No description provided for @giftHistoryEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີປະຫວັດຂອງຂວັນ'**
  String get giftHistoryEmptyTitle;

  /// No description provided for @giftHistoryEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ເມື່ອທ່ານສົ່ງຂອງຂວັນໃຫ້ໂມເດວ,\nລາຍການຈະສະແດງຢູ່ນີ້'**
  String get giftHistoryEmptySubtitle;

  /// No description provided for @giftDetailsTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍລະອຽດຂອງຂວັນ'**
  String get giftDetailsTitle;

  /// No description provided for @giftHistorySentTimes.
  ///
  /// In lo, this message translates to:
  /// **'ຄັ້ງທີ່ທ່ານສົ່ງຂອງຂວັນ'**
  String get giftHistorySentTimes;

  /// No description provided for @giftHistorySpent.
  ///
  /// In lo, this message translates to:
  /// **'ໃຊ້ຈ່າຍ {amount} ກີບ'**
  String giftHistorySpent(String amount);

  /// No description provided for @commonErrorOccurred.
  ///
  /// In lo, this message translates to:
  /// **'ມີຂໍ້ຜິດພາດເກີດຂຶ້ນ'**
  String get commonErrorOccurred;

  /// No description provided for @commonCantLoadData.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນໄດ້'**
  String get commonCantLoadData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'lo', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'lo':
      return AppLocalizationsLo();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
