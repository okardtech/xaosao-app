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
  /// **'ກິດຈະກຳທ້ອງຖິ່ນ'**
  String get serviceTypeSocial;

  /// No description provided for @serviceTypeMassage.
  ///
  /// In lo, this message translates to:
  /// **'ນວດ'**
  String get serviceTypeMassage;

  /// No description provided for @serviceTypeTravel.
  ///
  /// In lo, this message translates to:
  /// **'ປະສົບການທ້ອງຖິ່ນ'**
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
  /// **'{hours} ຮອບ'**
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
  /// **'ແຊຣ໌ລິ້ງແນະນຳຂອງທ່ານ'**
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

  /// No description provided for @packageHistoryTitle.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດ Package'**
  String get packageHistoryTitle;

  /// No description provided for @packageHistorySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການຊື້ທັງໝົດ'**
  String get packageHistorySubtitle;

  /// No description provided for @packageHistoryEmpty.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີລາຍການ'**
  String get packageHistoryEmpty;

  /// No description provided for @packageStatusActive.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງໃຊ້'**
  String get packageStatusActive;

  /// No description provided for @packageStatusCompleted.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດ'**
  String get packageStatusCompleted;

  /// No description provided for @packageStatusPending.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າ'**
  String get packageStatusPending;

  /// No description provided for @packageStatusPendingRelease.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າໂອນ'**
  String get packageStatusPendingRelease;

  /// No description provided for @packageStatusCanceled.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກ'**
  String get packageStatusCanceled;

  /// No description provided for @packageStatusRefunded.
  ///
  /// In lo, this message translates to:
  /// **'ຄືນເງິນ'**
  String get packageStatusRefunded;

  /// No description provided for @packageStatusExpired.
  ///
  /// In lo, this message translates to:
  /// **'ໝົດອາຍຸ'**
  String get packageStatusExpired;

  /// No description provided for @packageStatusUpgraded.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເກຣດ'**
  String get packageStatusUpgraded;

  /// No description provided for @packageStatusHeld.
  ///
  /// In lo, this message translates to:
  /// **'ຄ້ຳປະກັນ'**
  String get packageStatusHeld;

  /// No description provided for @packageStatusSuperseded.
  ///
  /// In lo, this message translates to:
  /// **'ຖືກແທນທີ່'**
  String get packageStatusSuperseded;

  /// No description provided for @packageAmount.
  ///
  /// In lo, this message translates to:
  /// **'ຈຳນວນ'**
  String get packageAmount;

  /// No description provided for @packageDaysRemaining.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງເຫຼືອ {days} ວັນ'**
  String packageDaysRemaining(int days);

  /// No description provided for @packageExpiresShort.
  ///
  /// In lo, this message translates to:
  /// **'ໝົດ {date}'**
  String packageExpiresShort(String date);

  /// No description provided for @subscriptionPrice.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາ'**
  String get subscriptionPrice;

  /// No description provided for @subscriptionDuration.
  ///
  /// In lo, this message translates to:
  /// **'ໄລຍະເວລາ'**
  String get subscriptionDuration;

  /// No description provided for @subscriptionBenefits.
  ///
  /// In lo, this message translates to:
  /// **'ສິ່ງທີ່ທ່ານຈະໄດ້ຮັບ:'**
  String get subscriptionBenefits;

  /// No description provided for @subscriptionViewAll.
  ///
  /// In lo, this message translates to:
  /// **'ເບິ່ງແພັກທັງໝົດ'**
  String get subscriptionViewAll;

  /// No description provided for @subscriptionClose.
  ///
  /// In lo, this message translates to:
  /// **'ປິດ'**
  String get subscriptionClose;

  /// No description provided for @subscriptionBuyNow.
  ///
  /// In lo, this message translates to:
  /// **'ຊື້ເລີຍ'**
  String get subscriptionBuyNow;

  /// No description provided for @subscriptionTopUp.
  ///
  /// In lo, this message translates to:
  /// **'ຕື່ມເງິນ'**
  String get subscriptionTopUp;

  /// No description provided for @subscriptionDurationHours.
  ///
  /// In lo, this message translates to:
  /// **'{hours} ຊ.ມ'**
  String subscriptionDurationHours(int hours);

  /// No description provided for @subscriptionDuration1Day.
  ///
  /// In lo, this message translates to:
  /// **'1 ວັນ'**
  String get subscriptionDuration1Day;

  /// No description provided for @subscriptionDuration1Week.
  ///
  /// In lo, this message translates to:
  /// **'1 ອາທິດ'**
  String get subscriptionDuration1Week;

  /// No description provided for @subscriptionDuration1Month.
  ///
  /// In lo, this message translates to:
  /// **'1 ເດືອນ'**
  String get subscriptionDuration1Month;

  /// No description provided for @subscriptionDuration3Months.
  ///
  /// In lo, this message translates to:
  /// **'3 ເດືອນ'**
  String get subscriptionDuration3Months;

  /// No description provided for @subscriptionDuration1Year.
  ///
  /// In lo, this message translates to:
  /// **'1 ປີ'**
  String get subscriptionDuration1Year;

  /// No description provided for @subscriptionDurationDays.
  ///
  /// In lo, this message translates to:
  /// **'{days} ວັນ'**
  String subscriptionDurationDays(int days);

  /// No description provided for @subscriptionSpecialPack.
  ///
  /// In lo, this message translates to:
  /// **'ແພັກພິເສດ'**
  String get subscriptionSpecialPack;

  /// No description provided for @subscriptionYourBalance.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດເງິນຂອງທ່ານ'**
  String get subscriptionYourBalance;

  /// No description provided for @subscriptionNeedMore.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງການ +{amount} KIP'**
  String subscriptionNeedMore(String amount);

  /// No description provided for @subscriptionCanPay.
  ///
  /// In lo, this message translates to:
  /// **'ຊຳລະໄດ້ເລີຍ'**
  String get subscriptionCanPay;

  /// No description provided for @subscriptionNeedPackageBody.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາຊື້ Package ກ່ອນ ຈຶ່ງສາມາດຈອງບໍລິການໄດ້. Package ຈະໃຫ້ທ່ານສິດໃນການຈອງ ແລະ ໃຊ້ງານຕ່າງໆ.'**
  String get subscriptionNeedPackageBody;

  /// No description provided for @subscriptionViewPackage.
  ///
  /// In lo, this message translates to:
  /// **'ເບິ່ງ Package'**
  String get subscriptionViewPackage;

  /// No description provided for @subscriptionNeedPackage.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງການ Wallet Package'**
  String get subscriptionNeedPackage;

  /// No description provided for @subscriptionNoActive.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີ Wallet Package ໃຊ້ງານ'**
  String get subscriptionNoActive;

  /// No description provided for @subscriptionServicePrice.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາບໍລິການ'**
  String get subscriptionServicePrice;

  /// No description provided for @subscriptionShortfall.
  ///
  /// In lo, this message translates to:
  /// **'ຂາດຢູ່'**
  String get subscriptionShortfall;

  /// No description provided for @subscriptionTopUpAmount.
  ///
  /// In lo, this message translates to:
  /// **'ຕື່ມ {amount} KIP'**
  String subscriptionTopUpAmount(String amount);

  /// No description provided for @subscriptionInsufficient.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດເງິນບໍ່ພຽງພໍ'**
  String get subscriptionInsufficient;

  /// No description provided for @subscriptionPleaseTopup.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາຕື່ມເງິນກ່ອນຈອງ'**
  String get subscriptionPleaseTopup;

  /// No description provided for @subscriptionPendingVerification.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າການຢືນຢັນ'**
  String get subscriptionPendingVerification;

  /// No description provided for @subscriptionAlreadySubscribed.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານມີ Wallet Package ໃຊ້ງານຢູ່ແລ້ວ'**
  String get subscriptionAlreadySubscribed;

  /// No description provided for @subscriptionPendingBadge.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າ'**
  String get subscriptionPendingBadge;

  /// No description provided for @subscriptionPendingBody.
  ///
  /// In lo, this message translates to:
  /// **'Package ຂອງທ່ານກຳລັງລໍຖ້າການຢືນຢັນຈາກ Admin. ກະລຸນາລໍຖ້າ ຫຼື ຕິດຕໍ່ Admin ເພື່ອຢືນຢັນໂດຍໄວ.'**
  String get subscriptionPendingBody;

  /// No description provided for @subscriptionAdminPhone.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທ Admin'**
  String get subscriptionAdminPhone;

  /// No description provided for @subscriptionCallAdmin.
  ///
  /// In lo, this message translates to:
  /// **'ໂທຫາ Admin'**
  String get subscriptionCallAdmin;

  /// No description provided for @subscriptionWaitingVerification.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງລໍຖ້າການຢືນຢັນ'**
  String get subscriptionWaitingVerification;

  /// No description provided for @subscriptionAdminChecking.
  ///
  /// In lo, this message translates to:
  /// **'Package ຂອງທ່ານລໍຖ້າ Admin ກວດສອບ'**
  String get subscriptionAdminChecking;

  /// No description provided for @packagePurchaseFailed.
  ///
  /// In lo, this message translates to:
  /// **'ການຊື້ບໍ່ສຳເລັດ'**
  String get packagePurchaseFailed;

  /// No description provided for @packageFeature1.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງບໍລິການຈາກຜູ້ໃຫ້ບໍລິການໃນທ້ອງຖິ່ນໄດ້ບໍ່ຈຳກັດຕໍ່ວັນ'**
  String get packageFeature1;

  /// No description provided for @packageFeature2.
  ///
  /// In lo, this message translates to:
  /// **'ຕິດຕໍ່ຜູ້ໃຫ້ບໍລິການເພື່ອປະສານງານການຈອງ ແລະ ກິດຈະກຳ'**
  String get packageFeature2;

  /// No description provided for @packageFeature3.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງກິດຈະກຳ ແລະ ບໍລິການໃນຊີວິດຈິງໄດ້ບໍ່ຈຳກັດຕໍ່ວັນ'**
  String get packageFeature3;

  /// No description provided for @packageFeature4.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນພົບຜູ້ໃຫ້ບໍລິການທີ່ໄດ້ຮັບຄະແນນສູງໃນເຂດຂອງທ່ານ'**
  String get packageFeature4;

  /// No description provided for @packageFeature5.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາຜູ້ໃຫ້ບໍລິການຕາມປະເພດ, ສະຖານທີ່ ແລະ ຄວາມພ້ອມ'**
  String get packageFeature5;

  /// No description provided for @packageFeature6.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການຊ່ວຍເຫຼືອລູກຄ້າ 24/7'**
  String get packageFeature6;

  /// No description provided for @packageFeature7.
  ///
  /// In lo, this message translates to:
  /// **'ໂປຣໄຟລ໌ຜູ້ໃຫ້ບໍລິການເຫັນເດັ່ນຊັດຂຶ້ນ'**
  String get packageFeature7;

  /// No description provided for @packagePlanShort1.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງບໍລິການ ແລະ ເຊື່ອມຕໍ່ກັບຜູ້ໃຫ້ບໍລິການໃນທ້ອງຖິ່ນ'**
  String get packagePlanShort1;

  /// No description provided for @packagePlanShort2.
  ///
  /// In lo, this message translates to:
  /// **'ທົດລອງໃຊ້ 24 ຊົ່ວໂມງ ສຳລັບການຈອງ ແລະ ຕິດຕໍ່ຜູ້ໃຫ້ບໍລິການ'**
  String get packagePlanShort2;

  /// No description provided for @packagePlanShort3.
  ///
  /// In lo, this message translates to:
  /// **'ຄຸ້ມທີ່ສຸດສຳລັບການຈອງໄລຍະຍາວ ແລະ ວາງແຜນກິດຈະກຳ'**
  String get packagePlanShort3;

  /// No description provided for @packageChooseTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກແຜນ'**
  String get packageChooseTitle;

  /// No description provided for @packageChooseSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກ Wallet Package'**
  String get packageChooseSubtitle;

  /// No description provided for @packageHistoryButton.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດ'**
  String get packageHistoryButton;

  /// No description provided for @packageCancelAnytime.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກໄດ້ທຸກເວລາ · ໂອນຄືນຕາມນະໂຍບາຍ'**
  String get packageCancelAnytime;

  /// No description provided for @packageWaitingVerification.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າການຢືນຢັນ'**
  String get packageWaitingVerification;

  /// No description provided for @packageExpiredLabel.
  ///
  /// In lo, this message translates to:
  /// **'ໝົດອາຍຸແລ້ວ'**
  String get packageExpiredLabel;

  /// No description provided for @packageNearExpiry.
  ///
  /// In lo, this message translates to:
  /// **'ໃກ້ໝົດອາຍຸ'**
  String get packageNearExpiry;

  /// No description provided for @packageActive.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງໃຊ້ງານ'**
  String get packageActive;

  /// No description provided for @packageProcessingVerification.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງດຳເນີນການຢືນຢັນ...'**
  String get packageProcessingVerification;

  /// No description provided for @packageExpiresOn.
  ///
  /// In lo, this message translates to:
  /// **'ໝົດອາຍຸ {date}'**
  String packageExpiresOn(String date);

  /// No description provided for @packageDays.
  ///
  /// In lo, this message translates to:
  /// **'ວັນ'**
  String get packageDays;

  /// No description provided for @packageRemainingLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຄົງເຫຼືອ'**
  String get packageRemainingLabel;

  /// No description provided for @packageChooseYourPlan.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກແຜນຂອງທ່ານ'**
  String get packageChooseYourPlan;

  /// No description provided for @packageUpgradeExperience.
  ///
  /// In lo, this message translates to:
  /// **'ຂະຫຍາຍການເຂົ້າເຖິງການຈອງ'**
  String get packageUpgradeExperience;

  /// No description provided for @packageChooseFitPlan.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກແຜນທີ່ເໝາະສົມກັບຄວາມຕ້ອງການຈອງ'**
  String get packageChooseFitPlan;

  /// No description provided for @packageLoadFailedShort.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດບໍ່ສຳເລັດ'**
  String get packageLoadFailedShort;

  /// No description provided for @packageNoPackage.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີ Package'**
  String get packageNoPackage;

  /// No description provided for @packageRequestProcessing.
  ///
  /// In lo, this message translates to:
  /// **'ຄຳຮ້ອງຂໍຂອງທ່ານກຳລັງຖືກດຳເນີນການ · ກະລຸນາລໍຖ້າ'**
  String get packageRequestProcessing;

  /// No description provided for @packageCurrent.
  ///
  /// In lo, this message translates to:
  /// **'ແພັກເກດປັດຈຸບັນ'**
  String get packageCurrent;

  /// No description provided for @packageSelectPlan.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກແຜນນີ້'**
  String get packageSelectPlan;

  /// No description provided for @checkoutPurchaseSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ຊື້ Package ສຳເລັດ'**
  String get checkoutPurchaseSuccess;

  /// No description provided for @checkoutUpgradeTitle.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເກຣດ Package'**
  String get checkoutUpgradeTitle;

  /// No description provided for @checkoutUpgradeSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ກວດສອບ ແລະ ຢືນຢັນການຊຳລະ'**
  String get checkoutUpgradeSubtitle;

  /// No description provided for @checkoutProcessPayment.
  ///
  /// In lo, this message translates to:
  /// **'ດຳເນີນການຊຳລະ'**
  String get checkoutProcessPayment;

  /// No description provided for @checkoutAlreadySubscribed.
  ///
  /// In lo, this message translates to:
  /// **'Wallet Package ໃຊ້ງານຢູ່ແລ້ວ'**
  String get checkoutAlreadySubscribed;

  /// No description provided for @checkoutPillPlan.
  ///
  /// In lo, this message translates to:
  /// **'ແຜນ {name}'**
  String checkoutPillPlan(String name);

  /// No description provided for @checkoutPillRemainingDays.
  ///
  /// In lo, this message translates to:
  /// **'ເຫຼືອ {days} ວັນ'**
  String checkoutPillRemainingDays(int days);

  /// No description provided for @checkoutUpgradeInfo.
  ///
  /// In lo, this message translates to:
  /// **'ການຊຳລະໃໝ່ຈະເລີ່ມຕໍ່ຈາກ Package ປັດຈຸບັນ ແລະ ວັນທີ່ຍັງເຫຼືອຈະຖືກນຳໃສ່ Package ໃໝ່.'**
  String get checkoutUpgradeInfo;

  /// No description provided for @checkoutPackageDuration.
  ///
  /// In lo, this message translates to:
  /// **'ໄລຍະ Package'**
  String get checkoutPackageDuration;

  /// No description provided for @checkoutNewPackageDuration.
  ///
  /// In lo, this message translates to:
  /// **'ໄລຍະ Package ໃໝ່'**
  String get checkoutNewPackageDuration;

  /// No description provided for @checkoutBonusFromOld.
  ///
  /// In lo, this message translates to:
  /// **'+ ໂບນັດ (Package ເດີມ)'**
  String get checkoutBonusFromOld;

  /// No description provided for @checkoutTotalDuration.
  ///
  /// In lo, this message translates to:
  /// **'ໄລຍະທັງໝົດ'**
  String get checkoutTotalDuration;

  /// No description provided for @checkoutPaymentSummary.
  ///
  /// In lo, this message translates to:
  /// **'ສະຫຼຸບການຊຳລະ'**
  String get checkoutPaymentSummary;

  /// No description provided for @checkoutWalletBalance.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດ Wallet'**
  String get checkoutWalletBalance;

  /// No description provided for @checkoutPackagePrice.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາ Package'**
  String get checkoutPackagePrice;

  /// No description provided for @checkoutRemaining.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດຄົງເຫຼືອ'**
  String get checkoutRemaining;

  /// No description provided for @checkoutShortfallSuffix.
  ///
  /// In lo, this message translates to:
  /// **' (ຂາດ)'**
  String get checkoutShortfallSuffix;

  /// No description provided for @checkoutWalletDeductInfo.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດ Wallet ຈະຖືກຕັດທັນທີ. Package ຈະເປີດໃຊ້ງານຫຼັງຈາກການຊຳລະສຳເລັດ.'**
  String get checkoutWalletDeductInfo;

  /// No description provided for @onboardingTopCompanions.
  ///
  /// In lo, this message translates to:
  /// **'ເພື່ອນແນະນຳຍອດນິຍົມ'**
  String get onboardingTopCompanions;

  /// No description provided for @onboardingTopCompanionsSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນພົບຜູ້ໃຫ້ບໍລິການທີ່ໄດ້ຮັບຄະແນນສູງ'**
  String get onboardingTopCompanionsSubtitle;

  /// No description provided for @onboardingWelcome.
  ///
  /// In lo, this message translates to:
  /// **'ຍິນດີຕ້ອນຮັບ 👋'**
  String get onboardingWelcome;

  /// No description provided for @onboardingFindYourCompanion.
  ///
  /// In lo, this message translates to:
  /// **'ຊອກຫາເພື່ອນຂອງທ່ານ'**
  String get onboardingFindYourCompanion;

  /// No description provided for @onboardingLoginOrSignup.
  ///
  /// In lo, this message translates to:
  /// **'ເຂົ້າສູ່ລະບົບ / ສ້າງບັນຊີ'**
  String get onboardingLoginOrSignup;

  /// No description provided for @onboardingActionsHint.
  ///
  /// In lo, this message translates to:
  /// **'ເບິ່ງໂປຣໄຟລ໌ · ສົ່ງຂໍ້ຄວາມ · ຈອງໄດ້ທັນທີ'**
  String get onboardingActionsHint;

  /// No description provided for @onboardingLogin.
  ///
  /// In lo, this message translates to:
  /// **'ເຂົ້າສູ່ລະບົບ'**
  String get onboardingLogin;

  /// No description provided for @onboardingOurServices.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການຂອງພວກເຮົາ'**
  String get onboardingOurServices;

  /// No description provided for @onboardingMassageTitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການນວດ'**
  String get onboardingMassageTitle;

  /// No description provided for @onboardingMassageSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການນວດສຸຂະພາບໂດຍຜູ້ໃຫ້ບໍລິການມືອາຊີບ ສະດວກຮອດບ້ານ'**
  String get onboardingMassageSubtitle;

  /// No description provided for @onboardingSocialSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄູ່ຮ່ວມງານສຳລັບງານສັງຄົມ ເພື່ອເພີ່ມຄວາມມ່ວນຊື່ນ ແລະ ຄວາມປະທັບໃຈ'**
  String get onboardingSocialSubtitle;

  /// No description provided for @onboardingTravelTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເພື່ອນທ່ອງທ່ຽວ'**
  String get onboardingTravelTitle;

  /// No description provided for @onboardingTravelSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄູ່ຮ່ວມທ່ອງທ່ຽວທີ່ພ້ອມພາເຈົ້າຄົ້ນພົບປະສົບການໃໝ່ ທັງໃນ ແລະ ຕ່າງປະເທດ'**
  String get onboardingTravelSubtitle;

  /// No description provided for @onboardingLevelGeneral.
  ///
  /// In lo, this message translates to:
  /// **'ທົ່ວໄປ'**
  String get onboardingLevelGeneral;

  /// No description provided for @onboardingLevelSpecial.
  ///
  /// In lo, this message translates to:
  /// **'ພິເສດ'**
  String get onboardingLevelSpecial;

  /// No description provided for @onboardingLevelPartner.
  ///
  /// In lo, this message translates to:
  /// **'ພາກຮ່ວມ'**
  String get onboardingLevelPartner;

  /// No description provided for @onboardingPartnerBenefits.
  ///
  /// In lo, this message translates to:
  /// **'ສິດປະໂຫຍດພາກຮ່ວມ'**
  String get onboardingPartnerBenefits;

  /// No description provided for @onboardingIncreaseIncome.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມລາຍຮັບຂອງທ່ານ'**
  String get onboardingIncreaseIncome;

  /// No description provided for @onboardingJoinNow.
  ///
  /// In lo, this message translates to:
  /// **'ເຂົ້າຮ່ວມເລີຍ'**
  String get onboardingJoinNow;

  /// No description provided for @onboardingConditionRegister.
  ///
  /// In lo, this message translates to:
  /// **'ລົງທະບຽນເປັນຄູ່ຮ່ວມ'**
  String get onboardingConditionRegister;

  /// No description provided for @onboardingEarnPer20.
  ///
  /// In lo, this message translates to:
  /// **'ຕໍ່ 1 ຄົນທີ່ແນະນຳ · ສູງສຸດ 20 ຄົນ'**
  String get onboardingEarnPer20;

  /// No description provided for @onboardingCondition20People.
  ///
  /// In lo, this message translates to:
  /// **'ແນະນຳຄູ່ຮ່ວມ 20 ຄົນ'**
  String get onboardingCondition20People;

  /// No description provided for @onboardingEarnCommission.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່າຄອມມິຊັນ ແລະ ຈຳນວນແນະນຳ'**
  String get onboardingEarnCommission;

  /// No description provided for @onboardingEarnVipSummary.
  ///
  /// In lo, this message translates to:
  /// **'ສະຫຼຸບ VIP ແລະ ຄ່າຄອມມິຊັນໃນເວລາ'**
  String get onboardingEarnVipSummary;

  /// No description provided for @onboardingReadyToEarn.
  ///
  /// In lo, this message translates to:
  /// **'ພ້ອມເລີ່ມຫາລາຍຮັບບໍ?'**
  String get onboardingReadyToEarn;

  /// No description provided for @onboardingRegisterUnlock.
  ///
  /// In lo, this message translates to:
  /// **'ລົງທະບຽນຕອນນີ້ ແລະ ເພີ່ມລາງວັນຂອງທ່ານ ໂດຍການແນະນຳຜູ້ອື່ນ'**
  String get onboardingRegisterUnlock;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In lo, this message translates to:
  /// **'ເລີ່ມຕົ້ນ'**
  String get onboardingGetStarted;

  /// No description provided for @notifSettingTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງຄ່າລະບົບ'**
  String get notifSettingTitle;

  /// No description provided for @notifSettingSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຈັດການການແຈ້ງເຕືອນຂອງທ່ານ'**
  String get notifSettingSubtitle;

  /// No description provided for @notifSettingChannelsSection.
  ///
  /// In lo, this message translates to:
  /// **'ຊ່ອງທາງການແຈ້ງເຕືອນ'**
  String get notifSettingChannelsSection;

  /// No description provided for @notifSettingPushSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ແຈ້ງເຕືອນໂດຍກົງໃສ່ໂທລະສັບ'**
  String get notifSettingPushSubtitle;

  /// No description provided for @notifSettingSmsSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບຂໍ້ຄວາມສັ້ນໃສ່ເບີໂທ'**
  String get notifSettingSmsSubtitle;

  /// No description provided for @notifSettingBannerTitle.
  ///
  /// In lo, this message translates to:
  /// **'ການຕັ້ງຄ່າການແຈ້ງເຕືອນ'**
  String get notifSettingBannerTitle;

  /// No description provided for @notifSettingBannerBody.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກຊ່ອງທາງທີ່ທ່ານຕ້ອງການຮັບຂໍ້ຄວາມ\nການປ່ຽນແປງຈະຖືກບັນທຶກໂດຍອັດຕະໂນມັດ'**
  String get notifSettingBannerBody;

  /// No description provided for @notifSettingFooterNote.
  ///
  /// In lo, this message translates to:
  /// **'ການປ່ຽນແປງຈະຖືກບັນທຶກທັນທີ. ທ່ານສາມາດປ່ຽນການຕັ້ງຄ່າໄດ້ຕະຫຼອດເວລາ.'**
  String get notifSettingFooterNote;

  /// No description provided for @notifSettingUpdateFailed.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດບໍ່ສຳເລັດ'**
  String get notifSettingUpdateFailed;

  /// No description provided for @notifListTitle.
  ///
  /// In lo, this message translates to:
  /// **'ການແຈ້ງເຕືອນ'**
  String get notifListTitle;

  /// No description provided for @notifListSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການແຈ້ງເຕືອນທັງໝົດຂອງທ່ານ'**
  String get notifListSubtitle;

  /// No description provided for @notifListMarkAllRead.
  ///
  /// In lo, this message translates to:
  /// **'ອ່ານທັງໝົດ'**
  String get notifListMarkAllRead;

  /// No description provided for @notifListEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີການແຈ້ງເຕືອນ'**
  String get notifListEmptyTitle;

  /// No description provided for @notifListEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ການແຈ້ງເຕືອນຈະສະແດງທີ່ນີ້'**
  String get notifListEmptySubtitle;

  /// No description provided for @notifTimeJustNow.
  ///
  /// In lo, this message translates to:
  /// **'ຫາກໍ່ນີ້'**
  String get notifTimeJustNow;

  /// No description provided for @notifTimeMinutes.
  ///
  /// In lo, this message translates to:
  /// **'{n} ນາທີ'**
  String notifTimeMinutes(int n);

  /// No description provided for @notifTimeHours.
  ///
  /// In lo, this message translates to:
  /// **'{n} ຊົ່ວໂມງ'**
  String notifTimeHours(int n);

  /// No description provided for @notifTimeYesterday.
  ///
  /// In lo, this message translates to:
  /// **'ມື້ວານ'**
  String get notifTimeYesterday;

  /// No description provided for @notifTimeDaysAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ມື້ກ່ອນ'**
  String notifTimeDaysAgo(int n);

  /// No description provided for @notifTimeWeeksAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ອາທິດຜ່ານມາ'**
  String notifTimeWeeksAgo(int n);

  /// No description provided for @notifTimeMonthsAgo.
  ///
  /// In lo, this message translates to:
  /// **'{n} ເດືອນກ່ອນ'**
  String notifTimeMonthsAgo(int n);

  /// No description provided for @welcomeTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍິນດີຕ້ອນຮັບ!'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In lo, this message translates to:
  /// **'ບັນຊີຂອງທ່ານສ້າງສຳເລັດແລ້ວ.\nຂໍໃຫ້ທ່ານມີຄວາມສຸກໃນການໃຊ້ງານ!'**
  String get welcomeBody;

  /// No description provided for @welcomeCanDoTitle.
  ///
  /// In lo, this message translates to:
  /// **'ສິ່ງທີ່ທ່ານສາມາດເຮັດໄດ້'**
  String get welcomeCanDoTitle;

  /// No description provided for @welcomeChat.
  ///
  /// In lo, this message translates to:
  /// **'ສົນທະນາ'**
  String get welcomeChat;

  /// No description provided for @welcomeBook.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງ'**
  String get welcomeBook;

  /// No description provided for @welcomeExplore.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາ'**
  String get welcomeExplore;

  /// No description provided for @welcomeGetStartedCta.
  ///
  /// In lo, this message translates to:
  /// **'ເລີ່ມໃຊ້ງານເລີຍ'**
  String get welcomeGetStartedCta;

  /// No description provided for @modelWalletAvailableBalance.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດເງິນສາມາດຖອນໄດ້'**
  String get modelWalletAvailableBalance;

  /// No description provided for @modelWalletStatPending.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າ'**
  String get modelWalletStatPending;

  /// No description provided for @modelWalletStatWithdrawn.
  ///
  /// In lo, this message translates to:
  /// **'ຖອນແລ້ວ'**
  String get modelWalletStatWithdrawn;

  /// No description provided for @modelWalletStatTotalIncome.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍຮັບທັງໝົດ'**
  String get modelWalletStatTotalIncome;

  /// No description provided for @modelWalletWithdrawBtn.
  ///
  /// In lo, this message translates to:
  /// **'ຖອນເງິນ'**
  String get modelWalletWithdrawBtn;

  /// No description provided for @modelWalletIncomeHistory.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດລາຍຮັບ'**
  String get modelWalletIncomeHistory;

  /// No description provided for @modelWalletEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີລາຍການ'**
  String get modelWalletEmptyTitle;

  /// No description provided for @modelWalletEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍການລາຍຮັບຂອງທ່ານ\nຈະສະແດງຢູ່ທີ່ນີ້'**
  String get modelWalletEmptySubtitle;

  /// No description provided for @modelWalletWithdrawFailed.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດຖອນເງິນໄດ້'**
  String get modelWalletWithdrawFailed;

  /// No description provided for @withdrawTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຖອນເງິນ'**
  String get withdrawTitle;

  /// No description provided for @withdrawSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຈ່າຍໃຫ້ບັນຊີທະນາຄານ'**
  String get withdrawSubtitle;

  /// No description provided for @withdrawSelectBank.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກບັນຊີທະນາຄານ'**
  String get withdrawSelectBank;

  /// No description provided for @withdrawAmountLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຈໍານວນເງິນ'**
  String get withdrawAmountLabel;

  /// No description provided for @withdrawAmountHint.
  ///
  /// In lo, this message translates to:
  /// **'ປ້ອນຈໍານວນ'**
  String get withdrawAmountHint;

  /// No description provided for @withdrawHintMin.
  ///
  /// In lo, this message translates to:
  /// **'ຕ່ຳສຸດ'**
  String get withdrawHintMin;

  /// No description provided for @withdrawHintMax.
  ///
  /// In lo, this message translates to:
  /// **'ສູງສຸດ'**
  String get withdrawHintMax;

  /// No description provided for @withdrawBelowMin.
  ///
  /// In lo, this message translates to:
  /// **'ຈໍານວນຕ່ຳກວ່າຂີດຈໍາກັດ ({amount})'**
  String withdrawBelowMin(String amount);

  /// No description provided for @withdrawAboveMax.
  ///
  /// In lo, this message translates to:
  /// **'ເກີນຍອດທີ່ສາມາດຖອນໄດ້ ({amount})'**
  String withdrawAboveMax(String amount);

  /// No description provided for @withdrawConfirmBtn.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນການຖອນ'**
  String get withdrawConfirmBtn;

  /// No description provided for @withdrawableBalance.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດທີ່ຖອນໄດ້'**
  String get withdrawableBalance;

  /// No description provided for @withdrawAll.
  ///
  /// In lo, this message translates to:
  /// **'ຖອນທັງໝົດ'**
  String get withdrawAll;

  /// No description provided for @withdrawUnavailable.
  ///
  /// In lo, this message translates to:
  /// **'ຖອນບໍ່ໄດ້'**
  String get withdrawUnavailable;

  /// No description provided for @withdrawNoBankTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີບັນຊີທະນາຄານ'**
  String get withdrawNoBankTitle;

  /// No description provided for @withdrawNoBankSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາເພີ່ມບັນຊີກ່ອນທີ່ຈະຖອນເງິນ'**
  String get withdrawNoBankSubtitle;

  /// No description provided for @withdrawAddBank.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມບັນຊີທະນາຄານ'**
  String get withdrawAddBank;

  /// No description provided for @discoverTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນພົບ'**
  String get discoverTitle;

  /// No description provided for @discoverSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາຜູ້ໃຊ້ທີ່ທ່ານໃຈ'**
  String get discoverSubtitle;

  /// No description provided for @discoverSearchHint.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາດ້ວຍຊື່...'**
  String get discoverSearchHint;

  /// No description provided for @discoverTabForYou.
  ///
  /// In lo, this message translates to:
  /// **'ສຳລັບທ່ານ'**
  String get discoverTabForYou;

  /// No description provided for @discoverTabWhoLikedMe.
  ///
  /// In lo, this message translates to:
  /// **'ຖືກໃຈຂ້ອຍ'**
  String get discoverTabWhoLikedMe;

  /// No description provided for @discoverTabILiked.
  ///
  /// In lo, this message translates to:
  /// **'ຂ້ອຍຖືກໃຈ'**
  String get discoverTabILiked;

  /// No description provided for @discoverEmptyAllTitle.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ພົບຜູ້ໃຊ້'**
  String get discoverEmptyAllTitle;

  /// No description provided for @discoverEmptyAllSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລອງປ່ຽນຕົວກອງ ຫຼື ຄົ້ນຫາໃໝ່ອີກຄັ້ງ'**
  String get discoverEmptyAllSubtitle;

  /// No description provided for @discoverEmptyForYouTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຄຳແນະນຳ'**
  String get discoverEmptyForYouTitle;

  /// No description provided for @discoverEmptyForYouSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ລະບົບຈະຊອກຫາຜູ້ທີ່ເໝາະສົມໃຫ້ທ່ານ'**
  String get discoverEmptyForYouSubtitle;

  /// No description provided for @discoverEmptyWhoLikedMeTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີໃຜຖືກໃຈທ່ານ'**
  String get discoverEmptyWhoLikedMeTitle;

  /// No description provided for @discoverEmptyWhoLikedMeSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງໂປຣໄຟລ໌ທີ່ດີເພື່ອດຶງດູດ'**
  String get discoverEmptyWhoLikedMeSubtitle;

  /// No description provided for @discoverEmptyILikedTitle.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານຍັງບໍ່ໄດ້ຖືກໃຈໃຜ'**
  String get discoverEmptyILikedTitle;

  /// No description provided for @discoverEmptyILikedSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາແລ້ວກົດ ♥ ເພື່ອສະແດງຄວາມສົນໃຈ'**
  String get discoverEmptyILikedSubtitle;

  /// No description provided for @detailPersonalInfo.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນສ່ວນຕົວ'**
  String get detailPersonalInfo;

  /// No description provided for @detailStatAge.
  ///
  /// In lo, this message translates to:
  /// **'ອາຍຸ'**
  String get detailStatAge;

  /// No description provided for @detailStatMemberSince.
  ///
  /// In lo, this message translates to:
  /// **'ສະມາຊິກຕັ້ງແຕ່'**
  String get detailStatMemberSince;

  /// No description provided for @detailStatTier.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບ'**
  String get detailStatTier;

  /// No description provided for @detailViewPhotos.
  ///
  /// In lo, this message translates to:
  /// **'ດູຮູບ'**
  String get detailViewPhotos;

  /// No description provided for @detailTapPhotoToExpand.
  ///
  /// In lo, this message translates to:
  /// **'ກົດທີ່ຮູບເພື່ອຂະຫຍາຍ'**
  String get detailTapPhotoToExpand;

  /// No description provided for @detailStatRating.
  ///
  /// In lo, this message translates to:
  /// **'ຄະເເນນ'**
  String get detailStatRating;

  /// No description provided for @detailStatPosts.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສ'**
  String get detailStatPosts;

  /// No description provided for @detailStatGifts.
  ///
  /// In lo, this message translates to:
  /// **'ຂອງຂວັນ'**
  String get detailStatGifts;

  /// No description provided for @detailStatCount.
  ///
  /// In lo, this message translates to:
  /// **'ຈໍານວນ'**
  String get detailStatCount;

  /// No description provided for @meetupsEntryFromMeetUps.
  ///
  /// In lo, this message translates to:
  /// **'ຈາກໜ້ານັດພົບ'**
  String get meetupsEntryFromMeetUps;

  /// No description provided for @meetupsEntryFromChat.
  ///
  /// In lo, this message translates to:
  /// **'ຈາກ Chat'**
  String get meetupsEntryFromChat;

  /// No description provided for @meetupsDayShortSun.
  ///
  /// In lo, this message translates to:
  /// **'ອາ'**
  String get meetupsDayShortSun;

  /// No description provided for @meetupsDayShortMon.
  ///
  /// In lo, this message translates to:
  /// **'ຈ'**
  String get meetupsDayShortMon;

  /// No description provided for @meetupsDayShortTue.
  ///
  /// In lo, this message translates to:
  /// **'ອ'**
  String get meetupsDayShortTue;

  /// No description provided for @meetupsDayShortWed.
  ///
  /// In lo, this message translates to:
  /// **'ພ'**
  String get meetupsDayShortWed;

  /// No description provided for @meetupsDayShortThu.
  ///
  /// In lo, this message translates to:
  /// **'ພຫ'**
  String get meetupsDayShortThu;

  /// No description provided for @meetupsDayShortFri.
  ///
  /// In lo, this message translates to:
  /// **'ສຸ'**
  String get meetupsDayShortFri;

  /// No description provided for @meetupsDayShortSat.
  ///
  /// In lo, this message translates to:
  /// **'ສ'**
  String get meetupsDayShortSat;

  /// No description provided for @meetupsClockSuffix.
  ///
  /// In lo, this message translates to:
  /// **'ໂມງ'**
  String get meetupsClockSuffix;

  /// No description provided for @meetupsCountdownDays.
  ///
  /// In lo, this message translates to:
  /// **'ເຫຼືອອີກ {days} ວັນ {hours} ຊ.ມ.'**
  String meetupsCountdownDays(int days, int hours);

  /// No description provided for @meetupsCountdownHours.
  ///
  /// In lo, this message translates to:
  /// **'ເຫຼືອອີກ {hours} ຊ.ມ.'**
  String meetupsCountdownHours(int hours);

  /// No description provided for @meetupsCountdownMinutes.
  ///
  /// In lo, this message translates to:
  /// **'ເຫຼືອ {minutes} ນາທີ'**
  String meetupsCountdownMinutes(int minutes);

  /// No description provided for @meetupsServiceMultiplier.
  ///
  /// In lo, this message translates to:
  /// **'{name} × {n} {unit}'**
  String meetupsServiceMultiplier(String name, int n, String unit);

  /// No description provided for @meetupsUnitDays.
  ///
  /// In lo, this message translates to:
  /// **'ວັນ'**
  String get meetupsUnitDays;

  /// No description provided for @meetupsUnitHours.
  ///
  /// In lo, this message translates to:
  /// **'ຊົ່ວໂມງ'**
  String get meetupsUnitHours;

  /// No description provided for @meetupsServiceFallback.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການ'**
  String get meetupsServiceFallback;

  /// No description provided for @meetupsStepCreateBooking.
  ///
  /// In lo, this message translates to:
  /// **'ສ້າງການຈອງ'**
  String get meetupsStepCreateBooking;

  /// No description provided for @meetupsStepWaitCompanionConfirm.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າ Companion ຢືນຢັນ'**
  String get meetupsStepWaitCompanionConfirm;

  /// No description provided for @meetupsStepCompanionConfirmed.
  ///
  /// In lo, this message translates to:
  /// **'Companion ຢືນຢັນ'**
  String get meetupsStepCompanionConfirmed;

  /// No description provided for @meetupsStepWaitingMeetup.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້ານັດພົບ'**
  String get meetupsStepWaitingMeetup;

  /// No description provided for @meetupsStepInProgress.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງດຳເນີນ'**
  String get meetupsStepInProgress;

  /// No description provided for @meetupsStepWaitingConfirmation.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຢືນຢັນ'**
  String get meetupsStepWaitingConfirmation;

  /// No description provided for @meetupsStepMeetingUp.
  ///
  /// In lo, this message translates to:
  /// **'ດຳເນີນນັດພົບ'**
  String get meetupsStepMeetingUp;

  /// No description provided for @meetupsStepCompleted.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດ'**
  String get meetupsStepCompleted;

  /// No description provided for @meetupsStepCancelled.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກ'**
  String get meetupsStepCancelled;

  /// No description provided for @meetupsStepRejected.
  ///
  /// In lo, this message translates to:
  /// **'ຖືກປະຕິເສດ'**
  String get meetupsStepRejected;

  /// No description provided for @meetupsStepDisputed.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ຂັດແຍ້ງ'**
  String get meetupsStepDisputed;

  /// No description provided for @meetupsCantLoadData.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ'**
  String get meetupsCantLoadData;

  /// No description provided for @meetupsCantPerform.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດດຳເນີນການໄດ້'**
  String get meetupsCantPerform;

  /// No description provided for @meetupsSectionDateTime.
  ///
  /// In lo, this message translates to:
  /// **'ວັນທີ ແລະ ເວລາ'**
  String get meetupsSectionDateTime;

  /// No description provided for @meetupsSectionLocation.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖານທີ່ນັດພົບ'**
  String get meetupsSectionLocation;

  /// No description provided for @meetupsSectionServices.
  ///
  /// In lo, this message translates to:
  /// **'ບໍລິການ'**
  String get meetupsSectionServices;

  /// No description provided for @meetupsMapLink.
  ///
  /// In lo, this message translates to:
  /// **'ແຜນທີ່ ›'**
  String get meetupsMapLink;

  /// No description provided for @meetupsPriceSummary.
  ///
  /// In lo, this message translates to:
  /// **'ສະຫຼຸບລາຄາ'**
  String get meetupsPriceSummary;

  /// No description provided for @meetupsPriceTotal.
  ///
  /// In lo, this message translates to:
  /// **'ລວມທັງໝົດ'**
  String get meetupsPriceTotal;

  /// No description provided for @meetupsYourReview.
  ///
  /// In lo, this message translates to:
  /// **'ຄຳຕິຊົມຂອງທ່ານ'**
  String get meetupsYourReview;

  /// No description provided for @meetupsYouRated.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານໃຫ້ຄະແນນ {name}'**
  String meetupsYouRated(String name);

  /// No description provided for @meetupsProgress.
  ///
  /// In lo, this message translates to:
  /// **'ຄວາມຄືບໜ້າ'**
  String get meetupsProgress;

  /// No description provided for @meetupsCancellationPolicy.
  ///
  /// In lo, this message translates to:
  /// **'ນະໂຍບາຍຍົກເລີກ'**
  String get meetupsCancellationPolicy;

  /// No description provided for @meetupsCancelBefore.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກກ່ອນ '**
  String get meetupsCancelBefore;

  /// No description provided for @meetupsWillRefund.
  ///
  /// In lo, this message translates to:
  /// **' ຈະໄດ້ຄືນ '**
  String get meetupsWillRefund;

  /// No description provided for @meetupsWithin24h.
  ///
  /// In lo, this message translates to:
  /// **' ພາຍໃນ 24 ຊ.ມ.'**
  String get meetupsWithin24h;

  /// No description provided for @meetupsActionMessage.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ຄວາມ'**
  String get meetupsActionMessage;

  /// No description provided for @meetupsActionCall.
  ///
  /// In lo, this message translates to:
  /// **'ໂທ'**
  String get meetupsActionCall;

  /// No description provided for @meetupsActionCancel.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກ'**
  String get meetupsActionCancel;

  /// No description provided for @meetupsActionShare.
  ///
  /// In lo, this message translates to:
  /// **'ແຊຣ໌'**
  String get meetupsActionShare;

  /// No description provided for @meetupsActionReport.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍງານ'**
  String get meetupsActionReport;

  /// No description provided for @meetupsActionConfirmShort.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນ'**
  String get meetupsActionConfirmShort;

  /// No description provided for @meetupsSnackPleaseTitle.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາ'**
  String get meetupsSnackPleaseTitle;

  /// No description provided for @loginRoleCustomerLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ຈອງ'**
  String get loginRoleCustomerLabel;

  /// No description provided for @loginRoleCustomerSub.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາ ແລະ ຈອງບໍລິການ'**
  String get loginRoleCustomerSub;

  /// No description provided for @loginRoleCompanionLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຜູ້ໃຫ້ບໍລິການ'**
  String get loginRoleCompanionLabel;

  /// No description provided for @loginRoleCompanionSub.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສບໍລິການ ແລະ ຮັບການຈອງ'**
  String get loginRoleCompanionSub;

  /// No description provided for @forgotTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລືມລະຫັດຜ່ານ'**
  String get forgotTitle;

  /// No description provided for @forgotEnterRegistered.
  ///
  /// In lo, this message translates to:
  /// **'ໃສ່ເບີໂທທີ່ລົງທະບຽນ'**
  String get forgotEnterRegistered;

  /// No description provided for @forgotOtpWillSendHere.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດ OTP ຈະຖືກສົ່ງໄປຫາເບີນີ້'**
  String get forgotOtpWillSendHere;

  /// No description provided for @forgotSendOtp.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງລະຫັດ OTP'**
  String get forgotSendOtp;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In lo, this message translates to:
  /// **'ກັບຄືນໜ້າເຂົ້າສູ່ລະບົບ'**
  String get forgotBackToLogin;

  /// No description provided for @forgotIdentityVerifyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນຕົວຕົນ'**
  String get forgotIdentityVerifyTitle;

  /// No description provided for @forgotSetNewPasswordTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງລະຫັດຜ່ານໃໝ່'**
  String get forgotSetNewPasswordTitle;

  /// No description provided for @forgotSetNewPasswordSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຕັ້ງລະຫັດຜ່ານໃໝ່ທີ່ປອດໄພ'**
  String get forgotSetNewPasswordSubtitle;

  /// No description provided for @forgotSavePassword.
  ///
  /// In lo, this message translates to:
  /// **'ບັນທຶກລະຫັດຜ່ານ'**
  String get forgotSavePassword;

  /// No description provided for @forgotStepPhone.
  ///
  /// In lo, this message translates to:
  /// **'ໂທລະສັບ'**
  String get forgotStepPhone;

  /// No description provided for @forgotConfirmPassword.
  ///
  /// In lo, this message translates to:
  /// **'ຢືນຢັນລະຫັດຜ່ານ'**
  String get forgotConfirmPassword;

  /// No description provided for @feedbackTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຄຳຕິຊົມ'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຄຳຄິດເຫັນ ຫຼື ລາຍງານບັນຫາ'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackSendNew.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຄຳຕິຊົມໃໝ່'**
  String get feedbackSendNew;

  /// No description provided for @feedbackMine.
  ///
  /// In lo, this message translates to:
  /// **'ຄຳຕິຊົມຂອງຂ້ອຍ'**
  String get feedbackMine;

  /// No description provided for @feedbackTypeLabel.
  ///
  /// In lo, this message translates to:
  /// **'ປະເພດ'**
  String get feedbackTypeLabel;

  /// No description provided for @feedbackTypeHint.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກປະເພດຄຳຕິຊົມ'**
  String get feedbackTypeHint;

  /// No description provided for @feedbackSubjectLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຫົວຂໍ້'**
  String get feedbackSubjectLabel;

  /// No description provided for @feedbackSubjectHint.
  ///
  /// In lo, this message translates to:
  /// **'ໃສ່ຫົວຂໍ້ຄຳຕິຊົມ...'**
  String get feedbackSubjectHint;

  /// No description provided for @feedbackDescLabel.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍລະອຽດ'**
  String get feedbackDescLabel;

  /// No description provided for @feedbackDescHint.
  ///
  /// In lo, this message translates to:
  /// **'ອະທິບາຍລາຍລະອຽດເພີ່ມເຕີມ...'**
  String get feedbackDescHint;

  /// No description provided for @feedbackDescMinLength.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ລາຍລະອຽດຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ'**
  String get feedbackDescMinLength;

  /// No description provided for @feedbackSubmit.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຄຳຕິຊົມ'**
  String get feedbackSubmit;

  /// No description provided for @feedbackSubmitFailed.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຄຳຕິຊົມບໍ່ສຳເລັດ'**
  String get feedbackSubmitFailed;

  /// No description provided for @feedbackEmptyTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຄຳຕິຊົມ'**
  String get feedbackEmptyTitle;

  /// No description provided for @feedbackEmptySubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງຄຳຕິຊົມຂອງທ່ານດ້ານເທິງ'**
  String get feedbackEmptySubtitle;

  /// No description provided for @feedbackStatusResolved.
  ///
  /// In lo, this message translates to:
  /// **'ແກ້ໄຂແລ້ວ'**
  String get feedbackStatusResolved;

  /// No description provided for @feedbackTypeBug.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ຜິດພາດ (Bug)'**
  String get feedbackTypeBug;

  /// No description provided for @feedbackTypeFeature.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ສະເໜີ (Feature)'**
  String get feedbackTypeFeature;

  /// No description provided for @feedbackTypeGeneral.
  ///
  /// In lo, this message translates to:
  /// **'ທົ່ວໄປ (General)'**
  String get feedbackTypeGeneral;

  /// No description provided for @feedbackTypePayment.
  ///
  /// In lo, this message translates to:
  /// **'ບັນຫາການຊຳລະ (Payment)'**
  String get feedbackTypePayment;

  /// No description provided for @feedbackTypePerformance.
  ///
  /// In lo, this message translates to:
  /// **'ປະສິດທິພາບ (Performance)'**
  String get feedbackTypePerformance;

  /// No description provided for @feedbackTypeOther.
  ///
  /// In lo, this message translates to:
  /// **'ອື່ນໆ (Other)'**
  String get feedbackTypeOther;

  /// No description provided for @dashboardTabChat.
  ///
  /// In lo, this message translates to:
  /// **'ຄູ່ເເຊັດ'**
  String get dashboardTabChat;

  /// No description provided for @dashboardTabPosts.
  ///
  /// In lo, this message translates to:
  /// **'ໂພສຫາຄູ່'**
  String get dashboardTabPosts;

  /// No description provided for @reviewRatingRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃຫ້ຄະແນນ'**
  String get reviewRatingRequired;

  /// No description provided for @reviewTextRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາຂຽນລີວິວ'**
  String get reviewTextRequired;

  /// No description provided for @reviewSubmitSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງລີວິວສຳເລັດ'**
  String get reviewSubmitSuccess;

  /// No description provided for @reviewSubmitFailed.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງລີວິວບໍ່ສຳເລັດ'**
  String get reviewSubmitFailed;

  /// No description provided for @reviewWriteTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຂຽນລີວິວ'**
  String get reviewWriteTitle;

  /// No description provided for @reviewForCompanion.
  ///
  /// In lo, this message translates to:
  /// **'ສຳລັບ {name}'**
  String reviewForCompanion(String name);

  /// No description provided for @reviewGiveRating.
  ///
  /// In lo, this message translates to:
  /// **'ໃຫ້ຄະແນນ'**
  String get reviewGiveRating;

  /// No description provided for @reviewSubjectLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຫົວຂໍ້ (ທາງເລືອກ)'**
  String get reviewSubjectLabel;

  /// No description provided for @reviewSubjectHint.
  ///
  /// In lo, this message translates to:
  /// **'ໃສ່ຫົວຂໍ້ລີວິວ...'**
  String get reviewSubjectHint;

  /// No description provided for @reviewYourReview.
  ///
  /// In lo, this message translates to:
  /// **'ລີວິວຂອງທ່ານ'**
  String get reviewYourReview;

  /// No description provided for @reviewShareHint.
  ///
  /// In lo, this message translates to:
  /// **'ແບ່ງປັນປະສົບການຂອງທ່ານ...'**
  String get reviewShareHint;

  /// No description provided for @reviewSubmit.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງລີວິວ'**
  String get reviewSubmit;

  /// No description provided for @reviewRatingBad.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ດີ'**
  String get reviewRatingBad;

  /// No description provided for @reviewRatingOk.
  ///
  /// In lo, this message translates to:
  /// **'ພໍໃຊ້ໄດ້'**
  String get reviewRatingOk;

  /// No description provided for @reviewRatingGood.
  ///
  /// In lo, this message translates to:
  /// **'ດີ'**
  String get reviewRatingGood;

  /// No description provided for @reviewRatingVeryGood.
  ///
  /// In lo, this message translates to:
  /// **'ດີຫຼາຍ'**
  String get reviewRatingVeryGood;

  /// No description provided for @reviewRatingExcellent.
  ///
  /// In lo, this message translates to:
  /// **'ດີເລີດ!'**
  String get reviewRatingExcellent;

  /// No description provided for @reviewRatingPick.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກຄະແນນ'**
  String get reviewRatingPick;

  /// No description provided for @cpRatingsSection.
  ///
  /// In lo, this message translates to:
  /// **'ຄະແນນ ແລະ ລີວິວ'**
  String get cpRatingsSection;

  /// No description provided for @cpStatusAvailable.
  ///
  /// In lo, this message translates to:
  /// **'ໃຊ້ງານຢູ່'**
  String get cpStatusAvailable;

  /// No description provided for @cpStatusUnavailable.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ໄດ້ໃຊ້ງານ'**
  String get cpStatusUnavailable;

  /// No description provided for @cpStatusLabel.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖານະ'**
  String get cpStatusLabel;

  /// No description provided for @cpNoServicesNow.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີບໍລິການໃນຂະນະນີ້'**
  String get cpNoServicesNow;

  /// No description provided for @cpNoReviewsBeFirst.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີລີວິວ ເປັນຄົນທຳອິດ!'**
  String get cpNoReviewsBeFirst;

  /// No description provided for @cpLoadMoreReviews.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດລີວິວເພີ່ມ'**
  String get cpLoadMoreReviews;

  /// No description provided for @cpReviewsCount.
  ///
  /// In lo, this message translates to:
  /// **'{count} ລີວິວ'**
  String cpReviewsCount(int count);

  /// No description provided for @cpOnline.
  ///
  /// In lo, this message translates to:
  /// **'ອອນລາຍ'**
  String get cpOnline;

  /// No description provided for @cpStatReviews.
  ///
  /// In lo, this message translates to:
  /// **'ລີວິວ'**
  String get cpStatReviews;

  /// No description provided for @cpStatFollowers.
  ///
  /// In lo, this message translates to:
  /// **'ຕິດຕາມ'**
  String get cpStatFollowers;

  /// No description provided for @cpAnonymous.
  ///
  /// In lo, this message translates to:
  /// **'ນິລະນາມ'**
  String get cpAnonymous;

  /// No description provided for @cpBookNow.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງດຽວນີ້'**
  String get cpBookNow;

  /// No description provided for @chatTitle.
  ///
  /// In lo, this message translates to:
  /// **'ສົນທະນາ'**
  String get chatTitle;

  /// No description provided for @chatNewMessages.
  ///
  /// In lo, this message translates to:
  /// **'{count} ຂໍ້ຄວາມໃໝ່'**
  String chatNewMessages(int count);

  /// No description provided for @chatSearchHint.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາ...'**
  String get chatSearchHint;

  /// No description provided for @chatFallbackName.
  ///
  /// In lo, this message translates to:
  /// **'ການສົນທະນານີ້'**
  String get chatFallbackName;

  /// No description provided for @chatDeleteConvTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບການສົນທະນາ'**
  String get chatDeleteConvTitle;

  /// No description provided for @chatDeleteConvMessage.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບການສົນທະນາກັບ {name}?\nຂໍ້ຄວາມຍັງສາມາດເຫັນໄດ້ຈາກອີກຝ່າຍ'**
  String chatDeleteConvMessage(String name);

  /// No description provided for @chatCantEnter.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດເຂົ້າໄດ້'**
  String get chatCantEnter;

  /// No description provided for @chatBlockedByYou.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານໄດ້ບລັອກການສົນທະນານີ້'**
  String get chatBlockedByYou;

  /// No description provided for @chatBlockedByOther.
  ///
  /// In lo, this message translates to:
  /// **'ການສົນທະນານີ້ຖືກບລັອກ'**
  String get chatBlockedByOther;

  /// No description provided for @chatUnblockName.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກການບລັອກ {name}'**
  String chatUnblockName(String name);

  /// No description provided for @chatBlockName.
  ///
  /// In lo, this message translates to:
  /// **'ບລັອກ {name}'**
  String chatBlockName(String name);

  /// No description provided for @chatUnblockConfirmMsg.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກການບລັອກ ແລະ ສືບຕໍ່ສົນທະນາ?'**
  String get chatUnblockConfirmMsg;

  /// No description provided for @chatBlockConfirmMsg.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານ ແລະ {name} ຈະບໍ່ສາມາດສົ່ງຂໍ້ຄວາມຫາກັນໄດ້'**
  String chatBlockConfirmMsg(String name);

  /// No description provided for @chatUnblock.
  ///
  /// In lo, this message translates to:
  /// **'ຍົກເລີກການບລັອກ'**
  String get chatUnblock;

  /// No description provided for @chatBlock.
  ///
  /// In lo, this message translates to:
  /// **'ບລັອກ'**
  String get chatBlock;

  /// No description provided for @chatEmpty.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ພົບການສົນທະນາ'**
  String get chatEmpty;

  /// No description provided for @chatConversationBlocked.
  ///
  /// In lo, this message translates to:
  /// **'ການສົນທະນາຖືກບລັອກ'**
  String get chatConversationBlocked;

  /// No description provided for @chatTyping.
  ///
  /// In lo, this message translates to:
  /// **'ກຳລັງພິມ...'**
  String get chatTyping;

  /// No description provided for @chatOffline.
  ///
  /// In lo, this message translates to:
  /// **'ອອຟລາຍ'**
  String get chatOffline;

  /// No description provided for @chatSelectedImage.
  ///
  /// In lo, this message translates to:
  /// **'ຮູບພາບທີ່ເລືອກ'**
  String get chatSelectedImage;

  /// No description provided for @chatInputHint.
  ///
  /// In lo, this message translates to:
  /// **'ພິມຂໍ້ຄວາມ...'**
  String get chatInputHint;

  /// No description provided for @chatSendFailed.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງບໍ່ສຳເລັດ'**
  String get chatSendFailed;

  /// No description provided for @chatSendPleaseRetry.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາລອງໃໝ່'**
  String get chatSendPleaseRetry;

  /// No description provided for @chatDateToday.
  ///
  /// In lo, this message translates to:
  /// **'ມື້ນີ້'**
  String get chatDateToday;

  /// No description provided for @chatDeleteMsgTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລຶບຂໍ້ຄວາມ'**
  String get chatDeleteMsgTitle;

  /// No description provided for @chatDeleteMsgBody.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ຄວາມຈະຖືກລຶບອອກຈາກຝ່າຍຂອງທ່ານເທົ່ານັ້ນ\nອີກຝ່າຍຍັງສາມາດເຫັນຂໍ້ຄວາມໄດ້'**
  String get chatDeleteMsgBody;

  /// No description provided for @chatImagePrefix.
  ///
  /// In lo, this message translates to:
  /// **'📷 ຮູບພາບ'**
  String get chatImagePrefix;

  /// No description provided for @bookingLabelDate.
  ///
  /// In lo, this message translates to:
  /// **'ວັນທີ'**
  String get bookingLabelDate;

  /// No description provided for @bookingHoursCount.
  ///
  /// In lo, this message translates to:
  /// **'ຈຳນວນຮອບ'**
  String get bookingHoursCount;

  /// No description provided for @bookingHoursValue.
  ///
  /// In lo, this message translates to:
  /// **'{hours} ຮອບ'**
  String bookingHoursValue(int hours);

  /// No description provided for @bookingHoursShortValue.
  ///
  /// In lo, this message translates to:
  /// **'{hours} ຮ.'**
  String bookingHoursShortValue(int hours);

  /// No description provided for @bookingTotalPriceShort.
  ///
  /// In lo, this message translates to:
  /// **'ລາຄາລວມ'**
  String get bookingTotalPriceShort;

  /// No description provided for @bookingGoToMeetups.
  ///
  /// In lo, this message translates to:
  /// **'ໄປໜ້າການນັດພົບ'**
  String get bookingGoToMeetups;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງສຳເລັດ!'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessBody.
  ///
  /// In lo, this message translates to:
  /// **'ການຈອງຂອງທ່ານໄດ້ຖືກຮັບແລ້ວ'**
  String get bookingSuccessBody;

  /// No description provided for @bookingUnitNight.
  ///
  /// In lo, this message translates to:
  /// **'ຄືນ'**
  String get bookingUnitNight;

  /// No description provided for @bookingDateDeparture.
  ///
  /// In lo, this message translates to:
  /// **'ວັນທີອອກເດີນທາງ'**
  String get bookingDateDeparture;

  /// No description provided for @bookingDateReturn.
  ///
  /// In lo, this message translates to:
  /// **'ວັນທີກັບມາ'**
  String get bookingDateReturn;

  /// No description provided for @bookingDatePlaceholder.
  ///
  /// In lo, this message translates to:
  /// **'ວັນ/ເດືອນ/ປີ'**
  String get bookingDatePlaceholder;

  /// No description provided for @bookingLocationHint.
  ///
  /// In lo, this message translates to:
  /// **'ໃສ່ທີ່ຢູ່ ຫຼື ສະຖານທີ່...'**
  String get bookingLocationHint;

  /// No description provided for @bookingAttireLabel.
  ///
  /// In lo, this message translates to:
  /// **'ການແຕ່ງກາຍທີ່ຕ້ອງການ'**
  String get bookingAttireLabel;

  /// No description provided for @bookingAttireHint.
  ///
  /// In lo, this message translates to:
  /// **'ຕົວຢ່າງ: ແຕ່ງຕົວເຊັກຊີ(ທາງເລືອກ)'**
  String get bookingAttireHint;

  /// No description provided for @bookingTipService.
  ///
  /// In lo, this message translates to:
  /// **'ທິບ / ບໍລິການ'**
  String get bookingTipService;

  /// No description provided for @bookingAddTipTo.
  ///
  /// In lo, this message translates to:
  /// **'ເພີ່ມທິບໃຫ້ {name}'**
  String bookingAddTipTo(String name);

  /// No description provided for @bookingRatePerUnit.
  ///
  /// In lo, this message translates to:
  /// **'{rate} ກີບ / {unit}'**
  String bookingRatePerUnit(String rate, String unit);

  /// No description provided for @bookingRatePerHour.
  ///
  /// In lo, this message translates to:
  /// **'{rate} ກີບ / ຮອບ'**
  String bookingRatePerHour(String rate);

  /// No description provided for @bookingRatePerHourShort.
  ///
  /// In lo, this message translates to:
  /// **'{rate} ກີບ / ຮ.'**
  String bookingRatePerHourShort(String rate);

  /// No description provided for @bookingCountUnit.
  ///
  /// In lo, this message translates to:
  /// **'ຈຳນວນ{unit}'**
  String bookingCountUnit(String unit);

  /// No description provided for @bookingSelectTime.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກເວລາ'**
  String get bookingSelectTime;

  /// No description provided for @bookingSlotBooked.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງແລ້ວ'**
  String get bookingSlotBooked;

  /// No description provided for @bookingSelectMassageType.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກປະເພດນວດ'**
  String get bookingSelectMassageType;

  /// No description provided for @bookingVariantsCount.
  ///
  /// In lo, this message translates to:
  /// **'{count} ປະເພດ'**
  String bookingVariantsCount(int count);

  /// No description provided for @bookingDateAppointment.
  ///
  /// In lo, this message translates to:
  /// **'ວັນທີນັດໝາຍ'**
  String get bookingDateAppointment;

  /// No description provided for @bookingTimeMeeting.
  ///
  /// In lo, this message translates to:
  /// **'ເວລາພົບກັນ'**
  String get bookingTimeMeeting;

  /// No description provided for @bookingTimeFormat.
  ///
  /// In lo, this message translates to:
  /// **'ຊົ່ວໂມງ:ນາທີ'**
  String get bookingTimeFormat;

  /// No description provided for @bookingSelectPlaceholder.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກ'**
  String get bookingSelectPlaceholder;

  /// No description provided for @bookingMassageTypeLabel.
  ///
  /// In lo, this message translates to:
  /// **'ປະເພດນວດ'**
  String get bookingMassageTypeLabel;

  /// No description provided for @bookingSelectVariant.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກປະເພດ'**
  String get bookingSelectVariant;

  /// No description provided for @bookingCreationFailed.
  ///
  /// In lo, this message translates to:
  /// **'ການຈອງລົ້ມເຫຼວ'**
  String get bookingCreationFailed;

  /// No description provided for @shareTitle.
  ///
  /// In lo, this message translates to:
  /// **'ແນະນຳໝູ່'**
  String get shareTitle;

  /// No description provided for @shareAppbarSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ແບ່ງປັນລິ້ງ ແລະ ເພີ່ມລາຍຮັບຂອງທ່ານ'**
  String get shareAppbarSubtitle;

  /// No description provided for @shareSubtitleGeneral.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບ 10,000 ກີບ ຕໍ່ການແນະນຳ'**
  String get shareSubtitleGeneral;

  /// No description provided for @shareSubtitleCommission.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບຄ່າຄອມມິສຊັນຈາກການແນະນຳ'**
  String get shareSubtitleCommission;

  /// No description provided for @shareTierGeneral.
  ///
  /// In lo, this message translates to:
  /// **'ທົ່ວໄປ'**
  String get shareTierGeneral;

  /// No description provided for @shareTierSpecial.
  ///
  /// In lo, this message translates to:
  /// **'ພິເສດ'**
  String get shareTierSpecial;

  /// No description provided for @shareTierPartner.
  ///
  /// In lo, this message translates to:
  /// **'ພາກຮ່ວມ'**
  String get shareTierPartner;

  /// No description provided for @shareTierBadge.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບ {tier}'**
  String shareTierBadge(String tier);

  /// No description provided for @shareTabModel.
  ///
  /// In lo, this message translates to:
  /// **'ລິ້ງແນະນຳໂມເດວ'**
  String get shareTabModel;

  /// No description provided for @shareTabCustomer.
  ///
  /// In lo, this message translates to:
  /// **'ລິ້ງແນະນຳລູກຄ້າ'**
  String get shareTabCustomer;

  /// No description provided for @shareLinkModelDesc.
  ///
  /// In lo, this message translates to:
  /// **'ແບ່ງປັນລິ້ງນີ້ໃຫ້ໝູ່ທີ່ຢາກເປັນໂມເດວ'**
  String get shareLinkModelDesc;

  /// No description provided for @shareLinkCustomerDesc.
  ///
  /// In lo, this message translates to:
  /// **'ແບ່ງປັນລິ້ງນີ້ໃຫ້ລູກຄ້າສະໝັກ'**
  String get shareLinkCustomerDesc;

  /// No description provided for @shareCopy.
  ///
  /// In lo, this message translates to:
  /// **'ຄັດລອກ'**
  String get shareCopy;

  /// No description provided for @shareCopied.
  ///
  /// In lo, this message translates to:
  /// **'ຄັດລອກແລ້ວ'**
  String get shareCopied;

  /// No description provided for @shareShareLink.
  ///
  /// In lo, this message translates to:
  /// **'ແບ່ງປັນ'**
  String get shareShareLink;

  /// No description provided for @shareViewQr.
  ///
  /// In lo, this message translates to:
  /// **'QR'**
  String get shareViewQr;

  /// No description provided for @shareStatsModels.
  ///
  /// In lo, this message translates to:
  /// **'ໂມເດວທີ່ແນະນຳ'**
  String get shareStatsModels;

  /// No description provided for @shareStatsCustomers.
  ///
  /// In lo, this message translates to:
  /// **'ລູກຄ້າທີ່ແນະນຳ'**
  String get shareStatsCustomers;

  /// No description provided for @shareStatsCommission.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່າຄອມມິສຊັນ'**
  String get shareStatsCommission;

  /// No description provided for @shareStatsTotal.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍໄດ້ລວມ'**
  String get shareStatsTotal;

  /// No description provided for @shareCommissionsTitle.
  ///
  /// In lo, this message translates to:
  /// **'ປະຫວັດຄ່າຄອມມິສຊັນ'**
  String get shareCommissionsTitle;

  /// No description provided for @shareCommissionsEmpty.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ມີຄ່າຄອມມິສຊັນ'**
  String get shareCommissionsEmpty;

  /// No description provided for @shareCommissionsEmptySub.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່າຄອມມິສຊັນຈາກລູກຄ້າ ຫຼື ໂມເດວທີ່ທ່ານແນະນຳ ຈະສະແດງທີ່ນີ້'**
  String get shareCommissionsEmptySub;

  /// No description provided for @shareLearnMore.
  ///
  /// In lo, this message translates to:
  /// **'ຮຽນຮູ້ເພີ່ມກ່ຽວກັບລະດັບ'**
  String get shareLearnMore;

  /// No description provided for @shareProgressToNext.
  ///
  /// In lo, this message translates to:
  /// **'ຄວາມຄືບໜ້າສູ່ລະດັບຕໍ່ໄປ'**
  String get shareProgressToNext;

  /// No description provided for @shareUpgradeToSpecialRemaining.
  ///
  /// In lo, this message translates to:
  /// **'ອີກ {n} ຄົນ ຈຶ່ງໄດ້ລະດັບພິເສດ'**
  String shareUpgradeToSpecialRemaining(int n);

  /// No description provided for @shareUpgradeToPartnerRemainingModels.
  ///
  /// In lo, this message translates to:
  /// **'ອີກ {n} ຄົນ ຈຶ່ງໄດ້ລະດັບພາກຮ່ວມ'**
  String shareUpgradeToPartnerRemainingModels(int n);

  /// No description provided for @shareUpgradeToPartnerRemainingEarnings.
  ///
  /// In lo, this message translates to:
  /// **'ອີກ {amount} ກີບ ຈຶ່ງໄດ້ລະດັບພາກຮ່ວມ'**
  String shareUpgradeToPartnerRemainingEarnings(String amount);

  /// No description provided for @shareTierMaxed.
  ///
  /// In lo, this message translates to:
  /// **'ທ່ານໄດ້ຮັບລະດັບສູງສຸດແລ້ວ'**
  String get shareTierMaxed;

  /// No description provided for @shareCurrentTier.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບປັດຈຸບັນ'**
  String get shareCurrentTier;

  /// No description provided for @shareEarnPerReferral.
  ///
  /// In lo, this message translates to:
  /// **'ຮັບ {amount} ກີບ/ຄົນ'**
  String shareEarnPerReferral(String amount);

  /// No description provided for @shareInviteMessage.
  ///
  /// In lo, this message translates to:
  /// **'ສະໝັກກັບ Xaosao ຜ່ານລິ້ງຂອງຂ້ອຍ!'**
  String get shareInviteMessage;

  /// No description provided for @shareInviteSubject.
  ///
  /// In lo, this message translates to:
  /// **'ເຂົ້າຮ່ວມ Xaosao'**
  String get shareInviteSubject;

  /// No description provided for @appName.
  ///
  /// In lo, this message translates to:
  /// **'Xaosao'**
  String get appName;

  /// No description provided for @bookingThankYouFor.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍຂອບໃຈທີ່ໃຊ້ບໍລິການຜ່ານ {appName}'**
  String bookingThankYouFor(String appName);

  /// No description provided for @bookingSupportContact.
  ///
  /// In lo, this message translates to:
  /// **'ສອບຖາມເພີ່ມເຕີມ ໂທ {phone}'**
  String bookingSupportContact(String phone);

  /// No description provided for @shareCommissionReferral.
  ///
  /// In lo, this message translates to:
  /// **'ການແນະນຳ'**
  String get shareCommissionReferral;

  /// No description provided for @shareQrBrandName.
  ///
  /// In lo, this message translates to:
  /// **'xaosao — ເຊົ້າສາວ'**
  String get shareQrBrandName;

  /// No description provided for @shareQrBrandTagline.
  ///
  /// In lo, this message translates to:
  /// **'ບ້ານພັກທີ່ລວບລວມນາງ-ສາວທີ່ໂດດ ແລະ ພ້ອມທີ່ຈະບ້ານຢູ່ທ່ານ.'**
  String get shareQrBrandTagline;

  /// No description provided for @shareQrDownload.
  ///
  /// In lo, this message translates to:
  /// **'ດາວໂຫຼດ QR'**
  String get shareQrDownload;

  /// No description provided for @shareQrPermissionDenied.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາອະນຸຍາດການເຂົ້າເຖິງຄັງຮູບ'**
  String get shareQrPermissionDenied;

  /// No description provided for @shareQrSaved.
  ///
  /// In lo, this message translates to:
  /// **'ບັນທຶກ QR ລົງຄັງຮູບແລ້ວ'**
  String get shareQrSaved;

  /// No description provided for @shareQrSaveFailed.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ສາມາດບັນທຶກໄດ້ ກະລຸນາລອງໃໝ່'**
  String get shareQrSaveFailed;

  /// No description provided for @shareQrErrorGeneric.
  ///
  /// In lo, this message translates to:
  /// **'ເກີດຂໍ້ຜິດພາດ ກະລຸນາລອງໃໝ່'**
  String get shareQrErrorGeneric;

  /// No description provided for @analyticsTitle.
  ///
  /// In lo, this message translates to:
  /// **'ການວິເຄາະການແນະນຳ'**
  String get analyticsTitle;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖິຕິ ແລະ ລາຍໄດ້ຂອງທ່ານ'**
  String get analyticsSubtitle;

  /// No description provided for @analyticsLoadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ'**
  String get analyticsLoadFailed;

  /// No description provided for @analyticsRetry.
  ///
  /// In lo, this message translates to:
  /// **'ລອງໃໝ່'**
  String get analyticsRetry;

  /// No description provided for @analyticsReferralStats.
  ///
  /// In lo, this message translates to:
  /// **'ສະຖິຕິການແນະນຳ'**
  String get analyticsReferralStats;

  /// No description provided for @analyticsReferrals.
  ///
  /// In lo, this message translates to:
  /// **'ການແນະນຳ'**
  String get analyticsReferrals;

  /// No description provided for @analyticsEarnings.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍໄດ້'**
  String get analyticsEarnings;

  /// No description provided for @analyticsTierProgress.
  ///
  /// In lo, this message translates to:
  /// **'ຄວາມຄືບໜ້າລະດັບ'**
  String get analyticsTierProgress;

  /// No description provided for @analyticsModels.
  ///
  /// In lo, this message translates to:
  /// **'ໂມເດວ'**
  String get analyticsModels;

  /// No description provided for @analyticsCustomers.
  ///
  /// In lo, this message translates to:
  /// **'ລູກຄ້າ'**
  String get analyticsCustomers;

  /// No description provided for @analyticsBookings.
  ///
  /// In lo, this message translates to:
  /// **'ຈອງ'**
  String get analyticsBookings;

  /// No description provided for @analyticsSubscriptions.
  ///
  /// In lo, this message translates to:
  /// **'Package'**
  String get analyticsSubscriptions;

  /// No description provided for @analyticsApproved.
  ///
  /// In lo, this message translates to:
  /// **'ອະນຸມັດ'**
  String get analyticsApproved;

  /// No description provided for @analyticsPending.
  ///
  /// In lo, this message translates to:
  /// **'ລໍຖ້າ'**
  String get analyticsPending;

  /// No description provided for @analyticsActive.
  ///
  /// In lo, this message translates to:
  /// **'ໃຊ້ງານ'**
  String get analyticsActive;

  /// No description provided for @analyticsInactive.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ໃຊ້'**
  String get analyticsInactive;

  /// No description provided for @analyticsTotal.
  ///
  /// In lo, this message translates to:
  /// **'ທັງໝົດ'**
  String get analyticsTotal;

  /// No description provided for @analyticsTotalEarnings.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍໄດ້ທັງໝົດ'**
  String get analyticsTotalEarnings;

  /// No description provided for @analyticsModelEarnings.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍໄດ້ໂມເດວ'**
  String get analyticsModelEarnings;

  /// No description provided for @analyticsCommission.
  ///
  /// In lo, this message translates to:
  /// **'ຄ່ານາຍໜ້າ'**
  String get analyticsCommission;

  /// No description provided for @analyticsEarningsByType.
  ///
  /// In lo, this message translates to:
  /// **'ລາຍໄດ້ແຕ່ລະປະເພດ'**
  String get analyticsEarningsByType;

  /// No description provided for @analyticsAllModels.
  ///
  /// In lo, this message translates to:
  /// **'ໂມເດວທັງໝົດ'**
  String get analyticsAllModels;

  /// No description provided for @analyticsApprovedModels.
  ///
  /// In lo, this message translates to:
  /// **'ໂມເດວອະນຸມັດ'**
  String get analyticsApprovedModels;

  /// No description provided for @analyticsAllCustomers.
  ///
  /// In lo, this message translates to:
  /// **'ລູກຄ້າທັງໝົດ'**
  String get analyticsAllCustomers;

  /// No description provided for @analyticsActiveCustomers.
  ///
  /// In lo, this message translates to:
  /// **'ລູກຄ້າໃຊ້ງານ'**
  String get analyticsActiveCustomers;

  /// No description provided for @analyticsReady.
  ///
  /// In lo, this message translates to:
  /// **'ພ້ອມແລ້ວ!'**
  String get analyticsReady;

  /// No description provided for @analyticsSpecialCondition.
  ///
  /// In lo, this message translates to:
  /// **'ແນະນຳໂມເດວໃຫ້ຄົບ {n} ທ່ານ'**
  String analyticsSpecialCondition(int n);

  /// No description provided for @analyticsPartnerCondition.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງການທັງໂມເດວ ແລະ ລາຍໄດ້'**
  String get analyticsPartnerCondition;

  /// No description provided for @snackbarErrorTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຜິດພາດ'**
  String get snackbarErrorTitle;

  /// No description provided for @snackbarSuccessTitle.
  ///
  /// In lo, this message translates to:
  /// **'ສຳເລັດ'**
  String get snackbarSuccessTitle;

  /// No description provided for @snackbarInfoTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຂໍ້ມູນ'**
  String get snackbarInfoTitle;

  /// No description provided for @qrLoadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດ QR ບໍ່ສຳເລັດ'**
  String get qrLoadFailed;

  /// No description provided for @imagePickerTitle.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກຮູບໂປຣໄຟ'**
  String get imagePickerTitle;

  /// No description provided for @imagePickerGallery.
  ///
  /// In lo, this message translates to:
  /// **'ຄັງຮູບ'**
  String get imagePickerGallery;

  /// No description provided for @imagePickerCamera.
  ///
  /// In lo, this message translates to:
  /// **'ກ້ອງຖ່າຍຮູບ'**
  String get imagePickerCamera;

  /// No description provided for @serviceUnitHour.
  ///
  /// In lo, this message translates to:
  /// **'/ຮອບ'**
  String get serviceUnitHour;

  /// No description provided for @serviceUnitDay.
  ///
  /// In lo, this message translates to:
  /// **'/ວັນ'**
  String get serviceUnitDay;

  /// No description provided for @serviceUnitNight.
  ///
  /// In lo, this message translates to:
  /// **'/ຄືນ'**
  String get serviceUnitNight;

  /// No description provided for @serviceUnitOnce.
  ///
  /// In lo, this message translates to:
  /// **'ຄັ້ງດຽວ'**
  String get serviceUnitOnce;

  /// No description provided for @serviceUnitMinute.
  ///
  /// In lo, this message translates to:
  /// **'/ນາທີ'**
  String get serviceUnitMinute;

  /// No description provided for @phoneRequired.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາໃສ່ເບີໂທ'**
  String get phoneRequired;

  /// No description provided for @phoneMustStartWith20.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທຕ້ອງເລີ່ມດ້ວຍ 20'**
  String get phoneMustStartWith20;

  /// No description provided for @phonePrefixInvalid.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງເປັນ: 202, 205, 206, 207 ຫຼື 209'**
  String get phonePrefixInvalid;

  /// No description provided for @phoneLength.
  ///
  /// In lo, this message translates to:
  /// **'ເບີໂທຕ້ອງມີ {n} ຕົວເລກ'**
  String phoneLength(int n);

  /// No description provided for @deepLinkShareSelf.
  ///
  /// In lo, this message translates to:
  /// **'ມາເບິ່ງໂປຣໄຟລ໌ໃນ Xaosao'**
  String get deepLinkShareSelf;

  /// No description provided for @deepLinkShareOther.
  ///
  /// In lo, this message translates to:
  /// **'ມາເບິ່ງໂປຣໄຟລ໌ຂອງ {name} ໃນ Xaosao'**
  String deepLinkShareOther(String name);

  /// No description provided for @dateToday.
  ///
  /// In lo, this message translates to:
  /// **'ມື້ນີ້'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In lo, this message translates to:
  /// **'ມື້ວານ'**
  String get dateYesterday;

  /// No description provided for @commonSearch.
  ///
  /// In lo, this message translates to:
  /// **'ຄົ້ນຫາ...'**
  String get commonSearch;

  /// No description provided for @commonPasswordHint.
  ///
  /// In lo, this message translates to:
  /// **'ລະຫັດຜ່ານ'**
  String get commonPasswordHint;

  /// No description provided for @commonImageLoadFailed.
  ///
  /// In lo, this message translates to:
  /// **'ໂຫຼດຮູບບໍ່ໄດ້'**
  String get commonImageLoadFailed;

  /// No description provided for @walletBalanceShort.
  ///
  /// In lo, this message translates to:
  /// **'ຍອດກະເປົ໋າ'**
  String get walletBalanceShort;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In lo, this message translates to:
  /// **'ຈຳເປັນຕ້ອງອັບເດດແອັບ'**
  String get updateRequiredTitle;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດແອັບໃໝ່ພ້ອມແລ້ວ!'**
  String get updateAvailableTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In lo, this message translates to:
  /// **'ກະລຸນາອັບເດດເປັນເວີຊັນຫຼ້າສຸດ ເພື່ອສືບຕໍ່ໃຊ້ Xaosao'**
  String get updateRequiredBody;

  /// No description provided for @updateAvailableBody.
  ///
  /// In lo, this message translates to:
  /// **'ພວກເຮົາໄດ້ປັບປຸງແອັບໃຫ້ດີຂຶ້ນ — ອັບເດດເລີຍເພື່ອປະສົບການທີ່ດີທີ່ສຸດ'**
  String get updateAvailableBody;

  /// No description provided for @updateNow.
  ///
  /// In lo, this message translates to:
  /// **'ອັບເດດດຽວນີ້'**
  String get updateNow;

  /// No description provided for @updateLater.
  ///
  /// In lo, this message translates to:
  /// **'ພາຍຫຼັງ'**
  String get updateLater;

  /// No description provided for @updateCurrentVersion.
  ///
  /// In lo, this message translates to:
  /// **'ເວີຊັ່ນປັດຈຸບັນ'**
  String get updateCurrentVersion;

  /// No description provided for @updateNewVersion.
  ///
  /// In lo, this message translates to:
  /// **'ເວີຊັ່ນໃໝ່'**
  String get updateNewVersion;

  /// No description provided for @updateWhatsNew.
  ///
  /// In lo, this message translates to:
  /// **'ມີຫຍັງໃໝ່'**
  String get updateWhatsNew;

  /// No description provided for @giftSheetTitle.
  ///
  /// In lo, this message translates to:
  /// **'🎁 ສົ່ງຂອງຂວັນ'**
  String get giftSheetTitle;

  /// No description provided for @giftSheetPickFor.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກຂອງຂວັນໃຫ້ {name}'**
  String giftSheetPickFor(String name);

  /// No description provided for @giftEmpty.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ມີຂອງຂວັນໃນຂະນະນີ້'**
  String get giftEmpty;

  /// No description provided for @giftPickFirst.
  ///
  /// In lo, this message translates to:
  /// **'ເລືອກຂອງຂວັນກ່ອນ'**
  String get giftPickFirst;

  /// No description provided for @giftSendFailed.
  ///
  /// In lo, this message translates to:
  /// **'ສ່ງຂອງຂວັນບໍ່ສຳເລັດ'**
  String get giftSendFailed;

  /// No description provided for @giftSendSuccess.
  ///
  /// In lo, this message translates to:
  /// **'ສ່ງຂອງຂວັນສຳເລັດ!'**
  String get giftSendSuccess;

  /// No description provided for @giftSendButton.
  ///
  /// In lo, this message translates to:
  /// **'ສົ່ງ {name} · {price}'**
  String giftSendButton(String name, String price);

  /// No description provided for @tiersTitle.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບ Referral ໂມເດວ'**
  String get tiersTitle;

  /// No description provided for @tiersSubtitle.
  ///
  /// In lo, this message translates to:
  /// **'ຮຽນຮູ້ວິທີການເພີ່ມລາຍໄດ້ຂອງທ່ານ'**
  String get tiersSubtitle;

  /// No description provided for @tiersOverview.
  ///
  /// In lo, this message translates to:
  /// **'ໂຕແຊຣ໌ Referral link ຂອງໂມເດວ ຈະແບ່ງອອກເປັນ 3 ລະດັບ'**
  String get tiersOverview;

  /// No description provided for @tiersLevel1Title.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບທົ່ວໄປ'**
  String get tiersLevel1Title;

  /// No description provided for @tiersLevel1Desc.
  ///
  /// In lo, this message translates to:
  /// **'ສະແດງພຽງແຕ່ລິ້ງແນະນຳໃຫ້ກັບ ໂມເດວ ດ້ວຍກັນເທົ່ານັ້ນ ແລະ ໄດ້ຮັບສະເພາະເງີນແນະນຳ 10,000/ຄົນ (ບໍ່ມີເງື່ອນໄຂໃດໆ ທຸກຄົນທີ່ເປັນໂມເດວສາມາເຮັດໄດ້ໝົດ)'**
  String get tiersLevel1Desc;

  /// No description provided for @tiersLevel2Title.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບພິເສດ'**
  String get tiersLevel2Title;

  /// No description provided for @tiersLevel2Condition.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງມີຜູ້ແນະນຳຫຼາຍກວ່າ 5 ຄົນ'**
  String get tiersLevel2Condition;

  /// No description provided for @tiersLevel2Links.
  ///
  /// In lo, this message translates to:
  /// **'ຈະມີລິ້ງແນະນຳ 2 ລິ້ງຄື: ລິ້ງແນະນຳລູກຄ້າ ແລະ ລິ້ງແນະນຳໂມເດວດ້ວຍກັນ'**
  String get tiersLevel2Links;

  /// No description provided for @tiersLevel2Benefit.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ໄດ້ຮັບເງີນ 10,000 ກີບ ແຕ່ຈະໄດ້ຮັບເປັນເປີເຊັນແທນເຊັ່ນ: 20% ຂອງລູກຄ້າຊື້ Wallet Package, 2% ຂອງຜູ້ໃຫ້ບໍລິການທີ່ຕົວເອງແນະນຳເວລາມີຄົນຈອງ'**
  String get tiersLevel2Benefit;

  /// No description provided for @tiersLevel3Title.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບພາກຮ່ວມ'**
  String get tiersLevel3Title;

  /// No description provided for @tiersLevel3Condition.
  ///
  /// In lo, this message translates to:
  /// **'ຕ້ອງມີຜູ້ແນະນຳຫຼາຍກວ່າ 5 ຄົນຂຶ້ນໄປ ແລະ ລາຍໄດ້ລວມຂອງຄ່າຄອມມິສຊັນທີ່ໄດ້ຈາກ Wallet Package ຂອງລູກຄ້າ ແລະ ລູກຄ້າຈອງຜູ້ໃຫ້ບໍລິການທີ່ແນະນຳ 1,000,000 ກີບ'**
  String get tiersLevel3Condition;

  /// No description provided for @tiersLevel3Links.
  ///
  /// In lo, this message translates to:
  /// **'ຈະມີລິ້ງແນະນຳ 2 ລິ້ງຄື: ລິ້ງແນະນຳລູກຄ້າ ແລະ ລິ້ງແນະນຳຜູ້ໃຫ້ບໍລິການດ້ວຍກັນ'**
  String get tiersLevel3Links;

  /// No description provided for @tiersLevel3Benefit.
  ///
  /// In lo, this message translates to:
  /// **'ບໍ່ໄດ້ຮັບເງີນ 10,000 ກີບ ແຕ່ຈະໄດ້ຮັບເປັນເປີເຊັນແທນເຊັ່ນ: 40% ຂອງລູກຄ້າຊື້ Wallet Package, 4% ຂອງຜູ້ໃຫ້ບໍລິການທີ່ຕົວເອງແນະນຳເວລາມີຄົນຈອງ'**
  String get tiersLevel3Benefit;

  /// No description provided for @tiersConditionLabel.
  ///
  /// In lo, this message translates to:
  /// **'ເງື່ອນໄຂ'**
  String get tiersConditionLabel;

  /// No description provided for @tiersBenefitLabel.
  ///
  /// In lo, this message translates to:
  /// **'ຜົນປະໂຫຍດທີ່ຈະໄດ້ຮັບ'**
  String get tiersBenefitLabel;

  /// No description provided for @tiersLinksLabel.
  ///
  /// In lo, this message translates to:
  /// **'ລິ້ງແນະນຳ'**
  String get tiersLinksLabel;

  /// No description provided for @tiersCurrentBadge.
  ///
  /// In lo, this message translates to:
  /// **'ລະດັບປັດຈຸບັນຂອງທ່ານ'**
  String get tiersCurrentBadge;

  /// No description provided for @tiersLockedNote.
  ///
  /// In lo, this message translates to:
  /// **'ຍັງບໍ່ເຖິງລະດັບ'**
  String get tiersLockedNote;
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
