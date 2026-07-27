// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lao (`lo`).
class AppLocalizationsLo extends AppLocalizations {
  AppLocalizationsLo([String locale = 'lo']) : super(locale);

  @override
  String get english => 'English';

  @override
  String get lao => 'ພາສາລາວ';

  @override
  String get thai => 'ภาษาไทย';

  @override
  String get languageTitle => 'ພາສາ';

  @override
  String get languageSubtitle => 'ເລືອກພາສາທີ່ທ່ານຕ້ອງການໃຊ້';

  @override
  String get commonCancel => 'ຍົກເລີກ';

  @override
  String get commonOk => 'ຕົກລົງ';

  @override
  String get commonSave => 'ບັນທຶກ';

  @override
  String get commonClose => 'ປິດ';

  @override
  String get commonLater => 'ພາຍຫຼັງ';

  @override
  String get commonSuccess => 'ສຳເລັດ';

  @override
  String get commonError => 'ເກີດຂໍ້ຜິດພາດ, ກະລຸນາລອງໃໝ່';

  @override
  String get commonDelete => 'ລຶບ';

  @override
  String get commonBack => 'ກັບຄືນ';

  @override
  String get commonYes => 'ແມ່ນ';

  @override
  String get commonNo => 'ບໍ່';

  @override
  String get profileInfoSection => 'ຂໍ້ມູນ';

  @override
  String get profileSecuritySection => 'ຄວາມປອດໄພ';

  @override
  String get profileSettingsSection => 'ຕັ້ງຄ່າ';

  @override
  String get profileHelpSection => 'ຊ່ວຍເຫຼືອ';

  @override
  String get profilePersonalInfo => 'ຂໍ້ມູນສ່ວນຕົວ';

  @override
  String get profilePersonalInfoSubtitle => 'ຊື່, ນາມສະກຸນ, ວັນເດືອນປີເກີດ';

  @override
  String get profileFinance => 'ຂໍ້ມູນທາງການເງິນ';

  @override
  String get profileFinanceSubtitle => 'ບັນຊີເງິນ, ບັດເຄຣດິດ, ການໂອນເງິນ';

  @override
  String get profileChangePassword => 'ປ່ຽນລະຫັດຜ່ານ';

  @override
  String get profileVerifyPhone => 'ຢືນຢັນເບີໂທ';

  @override
  String get profileVerifiedBadge => 'ຢືນຢັນແລ້ວ';

  @override
  String get profileVerifiedIdentity => 'ຢືນຢັນຕົວຕົນແລ້ວ';

  @override
  String get profileLanguage => 'ພາສາ';

  @override
  String get profileNotifications => 'ການແຈ້ງເຕືອນ';

  @override
  String get profileNotificationsSubtitle => 'Push, ອີເມລ, SMS, WhatsApp';

  @override
  String get profileHelpFaq => 'ຊ່ວຍເຫຼືອ / FAQ';

  @override
  String get profileFeedback => 'ຄຳຕິຊົມ';

  @override
  String get profileFeedbackSubtitle => 'ລາຍງານບັນຫາ ຫຼື ສົ່ງຄຳຄິດເຫັນ';

  @override
  String get profileTerms => 'ຂໍ້ກຳນົດ ແລະ ນະໂຍບາຍ';

  @override
  String get profileDeleteAccount => 'ລຶບບັນຊີ';

  @override
  String get profileDeleteAccountSubtitle => 'ການດຳເນີນການນີ້ບໍ່ສາມາດຍ້ອນໄດ້';

  @override
  String get profileDeleteAccountShortSubtitle => 'ບໍ່ສາມາດຍ້ອນໄດ້';

  @override
  String get profileLogout => 'ອອກຈາກລະບົບ';

  @override
  String profileAppVersion(String version) {
    return 'XAOSAO v$version';
  }

  @override
  String get profilePhotos => 'ຮູບພາບ';

  @override
  String profilePhotosCount(int count, int max) {
    return 'ຮູບພາບ ($count/$max)';
  }

  @override
  String profilePhotosMissingWarning(int max, int missing) {
    return 'ຕ້ອງເພີ່ມຄົບ $max ຮູບ — ຍັງຂາດ $missing ຮູບ';
  }

  @override
  String get profileMyServices => 'ບໍລິການຂອງຂ້ອຍ';

  @override
  String get profileMyQr => 'QR ຂອງຂ້ອຍ';

  @override
  String get profileStatLikes => 'ຖືກໃຈ';

  @override
  String get profileStatFriends => 'ໝູ່';

  @override
  String get profileStatReferrals => 'ຄໍາລິຊົມ';

  @override
  String get profileStatBookings => 'ຈອງ';

  @override
  String get profileHiddenEnabled =>
      'ໂປຣໄຟຂອງທ່ານຖືກຊ່ອນຢູ່ — ລູກຄ້າບໍ່ສາມາດເຫັນທ່ານໄດ້';

  @override
  String get profileHiddenDisabled =>
      'ເຊື່ອງໂປຣໄຟຂອງທ່ານບໍ່ໃຫ້ລູກຄ້າເຫັນ. ທ່ານສາມາດເປີດ-ປິດໄດ້ຕະຫຼອດເວລາ.';

  @override
  String get customerProfileBuyPackage => 'ການຊື້ແພັກເກດ';

  @override
  String get customerProfileBuyPackageSubtitle =>
      'ຊ່ວງໂມງ, ຊ່ວງວັນ ແລະ ຊ່ວງເດືອນ';

  @override
  String get customerProfileTopupHistory => 'ປະຫວັດເຕີມເງິນ';

  @override
  String get walletBalanceTitle => 'ກະເປົ໋າເງິນ ຍອດຄົງເຫຼືອ';

  @override
  String get walletTopup => 'ເຕີມເງິນ';

  @override
  String get walletHistory => 'ປະຫວັດ';

  @override
  String get confirmLogoutTitle => 'ອອກຈາກລະບົບ';

  @override
  String get confirmLogoutMessage => 'ທ່ານຕ້ອງການອອກຈາກລະບົບແທ້ບໍ່?';

  @override
  String get confirmLogoutConfirm => 'ອອກ';

  @override
  String get confirmDeleteTitle => 'ລຶບບັນຊີ';

  @override
  String get confirmDeleteMessage =>
      'ທ່ານແນ່ໃຈບໍ່ທີ່ຕ້ອງການລຶບບັນຊີ?\nຂໍ້ມູນທັງໝົດຈະຖືກລຶບຖາວອນ ແລະ ບໍ່ສາມາດຍ້ອນໄດ້.';

  @override
  String get commonGenericError => 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ';

  @override
  String get commonActionFailed => 'ບໍ່ສາມາດດຳເນີນການໄດ້';

  @override
  String get commonLoadDataFailed => 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ';

  @override
  String get commonAddFailed => 'ເພີ່ມບໍ່ສຳເລັດ';

  @override
  String get commonUpdateFailed => 'ອັບເດດບໍ່ສຳເລັດ';

  @override
  String get commonDeleteFailed => 'ລຶບບໍ່ສຳເລັດ';

  @override
  String get loginFailed => 'ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ';

  @override
  String get registerLoadServicesFailed => 'ໂຫຼດບໍລິການບໍ່ສຳເລັດ';

  @override
  String get registerSelectProfilePhoto => 'ກະລຸນາເລືອກຮູບໂປຮໄຟລ໌';

  @override
  String get registerFailed => 'ລົງທະບຽນບໍ່ສຳເລັດ';

  @override
  String get registerInvalidOtp => 'OTP ບໍ່ຖືກຕ້ອງ';

  @override
  String get registerSuccess => 'ການລົງທະບຽນສຳເລັດເເລ້ວ';

  @override
  String get registerVerifyOtpFailed => 'ກວດສອບ OTP ບໍ່ສຳເລັດ';

  @override
  String get registerResendOtpFailed => 'ສົ່ງ OTP ໃໝ່ບໍ່ສຳເລັດ';

  @override
  String get registerResendOtpSuccess => 'ສົ່ງລະຫັດ OTP ໃໝ່ແລ້ວ';

  @override
  String get meetUpsCancelSuccess => 'ຍົກເລີກການຈອງສຳເລັດ';

  @override
  String get meetUpsReleasePaymentSuccess => 'ປ່ອຍເງີນສຳເລັດ';

  @override
  String get meetUpsDisputeSuccess => 'ສົ່ງຄຳຮ້ອງຂໍສຳເລັດ';

  @override
  String get meetUpsConfirmSuccess => 'ຢືນຢັນການຈອງສຳເລັດ';

  @override
  String get meetUpsRejectSuccess => 'ປະຕິເສດການຈອງສຳເລັດ';

  @override
  String get meetUpsReceiveMoneySuccess => 'ຮັບເງີນສຳເລັດ';

  @override
  String get meetUpsDeleteSuccess => 'ລຶບລາຍການສຳເລັດ';

  @override
  String get postsFeedLoadFailed => 'ໂຫຼດຟີດບໍ່ສຳເລັດ';

  @override
  String get postsMyLoadFailed => 'ໂຫຼດໂພສຂ້ອຍບໍ່ສຳເລັດ';

  @override
  String get postsCreateSuccess => 'ສ້າງໂພສສຳເລັດ';

  @override
  String get postsCreateFailed => 'ສ້າງໂພສບໍ່ສຳເລັດ';

  @override
  String get postsDisableSuccess => 'ປິດໃຊ້ງານໂພສສຳເລັດ';

  @override
  String get postsDisableFailed => 'ປິດໃຊ້ງານໂພສບໍ່ສຳເລັດ';

  @override
  String get postsDeleteSuccess => 'ລຶບໂພສສຳເລັດ';

  @override
  String get postsDeleteFailed => 'ລຶບໂພສບໍ່ສຳເລັດ';

  @override
  String get authWelcome => 'ຍິນດີຕ້ອນຮັບ 👋';

  @override
  String get authRolePrompt => 'ທ່ານເຂົ້າໃນຖານະໃດ?';

  @override
  String get authTagline => 'ເພື່ອນຄູ່ໃຈ ທຸກທີ່ ທຸກເວລາ';

  @override
  String get authRoleCustomer => 'ລູກຄ້າ';

  @override
  String get authRoleCompanion => 'Companion';

  @override
  String get authFieldPhone => 'ເບີໂທລະສັບ';

  @override
  String get authFieldPassword => 'ລະຫັດຜ່ານ';

  @override
  String get authHintPassword => 'ລະຫັດຜ່ານ';

  @override
  String get authForgotPassword => 'ລືມລະຫັດຜ່ານ?';

  @override
  String get authNoAccount => 'ຍັງບໍ່ມີບັນຊີ?';

  @override
  String get authLoginButton => 'ເຂົ້າສູ່ລະບົບ';

  @override
  String get authCreateCustomerAccount => 'ສ້າງບັນຊີ ລູກຄ້າ';

  @override
  String get authCreateCompanionAccount => 'ສ້າງບັນຊີ ຜູ້ຮັບຈອງ';

  @override
  String get authValidPhoneRequired => 'ກະລຸນາໃສ່ເບີໂທລະສັບໃຫ້ຖືກຕ້ອງ';

  @override
  String get authPasswordRequired => 'ກະລຸນາໃສ່ລະຫັດຜ່ານ';

  @override
  String get commonCurrencyKip => 'ກີບ';

  @override
  String get monthShortJan => 'ມ.ກ';

  @override
  String get monthShortFeb => 'ກ.ພ';

  @override
  String get monthShortMar => 'ມ.ນ';

  @override
  String get monthShortApr => 'ມ.ສ';

  @override
  String get monthShortMay => 'ພ.ພ';

  @override
  String get monthShortJun => 'ມ.ຖ';

  @override
  String get monthShortJul => 'ກ.ລ';

  @override
  String get monthShortAug => 'ສ.ຫ';

  @override
  String get monthShortSep => 'ກ.ຍ';

  @override
  String get monthShortOct => 'ຕ.ລ';

  @override
  String get monthShortNov => 'ພ.ຈ';

  @override
  String get monthShortDec => 'ທ.ວ';

  @override
  String get walletTitle => 'ກະເປົ໋າເງິນ';

  @override
  String get walletSubtitle => 'ຍອດ ແລະ ປະຫວັດ';

  @override
  String get walletFilterAll => 'ທັງໝົດ';

  @override
  String get walletFilterPending => 'ລໍຖ້າອະນຸມດ';

  @override
  String get walletFilterApproved => 'ສຳເລັດເເລ້ວ';

  @override
  String get walletFilterRejected => 'ຍົກເລີກເເລ້ວ';

  @override
  String get walletRechargeHistory => 'ປະຫວັດການເຕີມ';

  @override
  String get walletEmptyTitle => 'ຍັງບໍ່ມີລາຍການ';

  @override
  String get walletEmptySubtitle => 'ລາຍການເຕີມເງິນຂອງທ່ານ\nຈະສະແດງຢູ່ທີ່ນີ້';

  @override
  String get walletTxStatusCompleted => 'ສຳເລັດ';

  @override
  String get walletTxStatusPending => 'ລໍຖ້າ';

  @override
  String get walletTxStatusProcessing => 'ກຳລັງດຳເນີນ';

  @override
  String get walletTxStatusCancelled => 'ຍົກເລີກ';

  @override
  String walletBalanceUpdated(String time) {
    return 'ຍອດຄົງເຫຼືອ, ອັບເດດ $time';
  }

  @override
  String get walletUsed => 'ໃຊ້ໄປແລ້ວ';

  @override
  String get walletTxTypeRecharge => 'ເຕີມເງິນ';

  @override
  String get walletTxTypeSubscription => 'ຊື້ Package';

  @override
  String get walletTxTypeGift => 'ສົ່ງຂອງຂວັນ';

  @override
  String get walletTxTypeBookingHold => 'ຝາກຊຳລະການຈອງ';

  @override
  String get walletTxTypeBookingRefund => 'ຄືນເງິນການຈອງ';

  @override
  String get walletTxTypeGiftEarning => 'ຮັບຂອງຂວັນ';

  @override
  String get walletTxTypeBookingEarning => 'ຮັບເງິນການຈອງ';

  @override
  String get walletTxTypeWithdrawal => 'ຖອນເງິນ';

  @override
  String get walletTxTypeReferral => 'ຄ່ານາຍໜ້າ';

  @override
  String get walletTxTypeBookingReferral => 'ຄ່ານາຍໜ້າ (ການຈອງ)';

  @override
  String get walletTxTypeSubscriptionReferral => 'ຄ່ານາຍໜ້າ (Package)';

  @override
  String get walletTxTypeGeneric => 'ທຸລະກຳ';

  @override
  String get commonNext => 'ຕໍ່ໄປ';

  @override
  String get commonAmount => 'ຈຳນວນ';

  @override
  String get commonDate => 'ວັນທີ';

  @override
  String commonErrorDetail(String error) {
    return 'ເກີດຂໍ້ຜິດພາດ: $error';
  }

  @override
  String get topupAmountSubtitle => 'ເລືອກ ຫຼື ປ້ອນຈຳນວນ';

  @override
  String get topupOther => 'ອື່ນໆ';

  @override
  String get topupCustomAmount => 'ກຳນົດເອງ';

  @override
  String get topupOrEnterYourself => 'ຫຼື ປ້ອນເອງ';

  @override
  String get topupEnterAmount => 'ປ້ອນຈຳນວນ';

  @override
  String get topupQrLoadFailed => 'ບໍ່ສາມາດໂຫຼດ QR ໄດ້';

  @override
  String get topupPackageFailed => 'ການຊື້ Package ບໍ່ສຳເລັດ';

  @override
  String get topupSlipUploadFailed => 'ບໍ່ສາມາດສົ່ງໃບຈ່າຍໄດ້';

  @override
  String get topupUploadTitle => 'ອັບໂຫຼດ Slip';

  @override
  String get topupUploadSubtitle => 'ຢືນຢັນການຊຳລະ';

  @override
  String get topupUploadFileTypes =>
      'ຮອງຮັບຮູບແບບ: JPG, PNG, PDF (ຂຸງສຸດ 10MB)';

  @override
  String get topupUploadSubmit => 'ສົ່ງ ແລະ ຢືນຢັນ';

  @override
  String get topupUploadReceipt => 'ອັບໂຫຼດໃບບິນການຊຳລະ';

  @override
  String get topupUploadReceiptSubtitle => 'ສາມາດອັບໃບຍືນຢັນໄດ້ທີ່ນີ້';

  @override
  String get topupSelectFile => 'ເລືອກໄຟລ໌';

  @override
  String get topupAddMoreSlip => 'ເພີ່ມ slip ອີກ';

  @override
  String get topupExampleReceipt => 'ຕົວຢ່າງໃບບິນການຊຳລະ';

  @override
  String get topupThankYouMessage =>
      'ຂອບໃຈສຳລັບຄວາມໄວ້ວາງໃຈ: ທີມງານຈະກວດສອບ ແລະ ດຳເນີນການ ພາຍໃນ 1–2 ຊົ່ວໂມງ. ຫຼັງຈາກໄດ້ຮັບໃບຍືນຢັນແລ້ວ.';

  @override
  String get topupBackToWallet => 'ກັບໜ້າກະເປົ໋າ';

  @override
  String get topupSuccessTitle => 'ເຕີມສຳເລັດ!';

  @override
  String get topupSuccessSubtitle => 'ກຳລັງລໍຖ້າການກວດສອບຈາກ Admin';

  @override
  String get topupWaitingReview => 'ລໍຖ້າການກວດສອບ';

  @override
  String get topupQrTitle => 'ສະແກນ QR';

  @override
  String get topupQrSubtitle => 'ຊຳລະຜ່ານ app ທະນາຄານ';

  @override
  String get topupQrPaidUploadSlip => 'ຊຳລະແລ້ວ — ອັບ slip';

  @override
  String get topupQrAmountToPay => 'ຈຳນວນທີ່ຕ້ອງຊຳລະ';

  @override
  String get topupQrInstructions =>
      'ສະແກນ QR ດ້ວຍ app ທະນາຄານ\nຈາກນັ້ນກົດ \"ຊຳລະແລ້ວ\" ເພື່ອອັບ slip';

  @override
  String get topupQrSaving => 'ກຳລັງບັນທຶກ...';

  @override
  String get topupQrDownload => 'ດາວໂຫຼດ QR';

  @override
  String get commonAll => 'ທັງໝົດ';

  @override
  String get commonRetry => 'ລອງໃໝ່';

  @override
  String get commonPleaseRetry => 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ';

  @override
  String get serviceTypeSocial => 'ສັງຄົມ';

  @override
  String get serviceTypeMassage => 'ນວດ';

  @override
  String get serviceTypeTravel => 'ທ່ຽວ';

  @override
  String get viewCompanionPageTitle => 'ທັງໝົດ';

  @override
  String get viewCompanionFilterLikedByMe => 'ຂ້ອຍ Like';

  @override
  String get viewCompanionFilterWhoLikedMe => 'Like ຂ້ອຍ';

  @override
  String get viewCompanionFilterNearby => 'ໃກ້ຂ້ອຍ';

  @override
  String get viewCompanionFilterNew => 'ໃໝ່';

  @override
  String get viewCompanionFilterPopular => 'ນິຍົມ';

  @override
  String get viewCompanionEmptyTitle => 'ບໍ່ພົບຂໍ້ມູນ';

  @override
  String get viewCompanionEmptySubtitle => 'ລອງປ່ຽນ filter ຫຼືຄົ້ນຫາໃໝ່';

  @override
  String get viewCompanionSearchHint => 'ຄົ້ນຫາຊື່...';

  @override
  String get genderMale => 'ຜູ້ຊາຍ';

  @override
  String get genderFemale => 'ຜູ້ຍິງ';

  @override
  String get homeSearch => 'ຄົ້ນຫາ';

  @override
  String get homeFindCompanion => 'ຄົ້ນພົບຜູ້ຮ່ວມທາງຂອງທ່ານ';

  @override
  String get homeSearchHint => 'ຄົ້ນຫາດ້ວຍຊື່...';

  @override
  String get homeOnlineNow => 'ກຳລັງອອນລາຍ';

  @override
  String get homeRecommended => 'ແນະນຳສຳລັບທ່ານ';

  @override
  String get homeSeeAll => 'ເບິ່ງທັງໝົດ';

  @override
  String get homeNoResults => 'ບໍ່ພົບຜົນໄດ້ຮັບ';

  @override
  String get homeTryFilter => 'ລອງປ່ຽນ filter ໃໝ່';

  @override
  String get homeFilters => 'ຕົວກອງ';

  @override
  String get homeMaxDistance => 'ໄລຍະທາງສູງສຸດ';

  @override
  String get homeApplyFilter => 'ນຳໃຊ້ Filter';

  @override
  String get homeFilterNearby => 'ໃກ້ຄຽງ';

  @override
  String get homeServiceSocial => 'ເພື່ອນສັງຄົມ';

  @override
  String get homeServiceTravel => 'ທ່ອງທ່ຽວ';

  @override
  String get homeCardSubtitleSocial => 'ທ່ຽວ, ງານລ້ຽງ, ທຸກໂອກາດ';

  @override
  String get homeCardSubtitleMassage => 'ນວດສຸຂະພາບໂດຍມືອາຊີບ';

  @override
  String get homeCardSubtitleTravel => 'Guide ໃນ ແລະ ຕ່າງປະເທດ';

  @override
  String get homeLoadRecommendationsFailed => 'ໂຫຼດຂໍ້ມູນແນະນຳບໍ່ສຳເລັດ';

  @override
  String get homeLoadOnlineFailed => 'ໂຫຼດຂໍ້ມູນອອນລາຍບໍ່ສຳເລັດ';

  @override
  String commonAgeYears(int years) {
    return '$years ປີ';
  }

  @override
  String commonHours(int hours) {
    return '$hours ຊົ່ວໂມງ';
  }

  @override
  String commonDays(int days) {
    return '$days ວັນ';
  }

  @override
  String get commonConfirm => 'ຢືນຢັນ';

  @override
  String get commonPleaseTitle => 'ກະລຸນາ';

  @override
  String get bookingStatusConfirmed => 'ຢືນຢັນ';

  @override
  String get bookingStatusConfirmedShort => 'ຮັບເເລ້ວ';

  @override
  String get bookingStatusInProgress => 'ກຳລັງດຳເນີນ';

  @override
  String get bookingStatusAwaitingConfirmation => 'ລໍຢືນຢັນ';

  @override
  String get bookingStatusAwaitingConfirmationShort => 'ລໍຮັບຢືນຢັນ';

  @override
  String get bookingStatusCompletedFull => 'ສຳເລັດເເລ້ວ';

  @override
  String get bookingStatusCancelledFull => 'ຍົກເລີກເເລ້ວ';

  @override
  String get bookingStatusRejected => 'ຖືກປະຕິເສດ';

  @override
  String get bookingStatusDisputed => 'ຂໍ້ຂັດແຍ້ງ';

  @override
  String get paymentStatusPaid => 'ຊຳລະແລ້ວ';

  @override
  String get paymentStatusPending => 'ລໍຖ້າຊຳລະ';

  @override
  String get paymentStatusReleased => 'ປ່ອຍເງີນແລ້ວ';

  @override
  String get paymentStatusRefunded => 'ຄືນເງີນແລ້ວ';

  @override
  String get meetUpsTitle => 'ນັດພົບ';

  @override
  String get meetUpsAllHistory => 'ປະຫວັດການຈອງທັງໝົດ';

  @override
  String meetUpsItemsWithStatus(int count, String status) {
    return '$count ລາຍການ · $status';
  }

  @override
  String get meetUpsEmptyTitle => 'ບໍ່ມີລາຍການ';

  @override
  String get meetUpsEmptySubtitle => 'ລາຍການຈອງຈະສະແດງທີ່ນີ້';

  @override
  String get meetUpsLoadMore => 'ໂຫຼດເພີ່ມ';

  @override
  String get bookingDetailTitle => 'ລາຍລະອຽດການຈອງ';

  @override
  String get bookingLocation => 'ສະຖານທີ່';

  @override
  String get bookingPhone => 'ເບີໂທລະສັບ';

  @override
  String get bookingTip => 'ທິບ';

  @override
  String get bookingTipReady => 'ມີທິບໃຫ້ພ້ອມ';

  @override
  String get bookingAttire => 'ການເເຕ່ງກາຍ';

  @override
  String get bookingId => 'ລະຫັດການຈອງ';

  @override
  String get bookingCreatedAt => 'ເວລາຈອງ';

  @override
  String get bookingNoName => 'ບໍ່ມີຊື່';

  @override
  String get bookingTotalPrice => 'ລາຄາທັງໝົດ';

  @override
  String get bookingActionChat => 'ເເຊັດ';

  @override
  String get bookingActionReleasePayment => 'ປ່ອຍເງີນ';

  @override
  String get bookingActionRefund => 'ເງິນຄືນ';

  @override
  String get bookingActionReject => 'ປະຕິເສດ';

  @override
  String get bookingActionReceiveMoney => 'ຮັບເງີນ';

  @override
  String get cancelBookingTitle => 'ຍົກເລີກການຈອງ';

  @override
  String get cancelBookingMessage =>
      'ທ່ານຕ້ອງການຍົກເລີກການຈອງນີ້ແທ້ບໍ່?\nການຍົກເລີກນີ້ບໍ່ສາມາດຖືກຄືນໄດ້.';

  @override
  String get cancelBookingMessageShort => 'ທ່ານຕ້ອງການຍົກເລີກການຈອງນີ້ແທ້ບໍ່?';

  @override
  String get deleteItemTitle => 'ລຶບລາຍການ';

  @override
  String get deleteItemMessage => 'ທ່ານຕ້ອງການລຶບລາຍການນີ້ແທ້ບໍ່?';

  @override
  String get refundReasonTitle => 'ເຫດຜົນການຮ້ອງຂໍເງິນຄືນ';

  @override
  String get rejectReasonTitle => 'ເຫດຜົນການປະຕິເສດ';

  @override
  String get reasonMinLength => 'ເຫດຜົນຕ້ອງມີຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ';

  @override
  String get reasonHint => 'ກະລຸນາລະບຸເຫດຜົນ (ຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ)';

  @override
  String get cancellationPolicyCanCancel => 'ຍົກເລີກໄດ້';

  @override
  String get cancellationPolicyTitle => 'ນະໂຍບາຍຍົກເລີກ & ຄືນເງິນ';

  @override
  String get cancellationPolicyExpand => 'ດູເພີ່ມ';

  @override
  String get cancellationPolicyCollapse => 'ຫຍໍ້';

  @override
  String get cancellationTier1Title => 'ຍົກເລີກກ່ອນ 30 ນາທີ';

  @override
  String get cancellationTier1Subtitle => 'ຄືນເງິນທັນທີ ພາຍໃນ 24 ຊົ່ວໂມງ';

  @override
  String get cancellationTier2Title => 'ຍົກເລີກຫຼັງ 30 ນາທີ';

  @override
  String get cancellationTier2Subtitle => 'ຄືນເງິນພາຍໃນ 24 ຊົ່ວໂມງ';

  @override
  String get cancellationTier3Title => 'ຍົກເລີກຫຼັງເລີ່ມນັດ';

  @override
  String get cancellationTier3Subtitle => 'ບໍ່ສາມາດຄືນເງິນໄດ້';

  @override
  String get cancellationRefundInfo =>
      'ເງິນຈະຖືກໂອນຄືນໄປຍັງຊ່ອງທາງທີ່ທ່ານຊຳລະ ພາຍໃນ 24 ຊົ່ວໂມງ';

  @override
  String get bookingSummaryActive => 'ກຳລັງມາ';

  @override
  String get commonAdd => 'ເພີ່ມ';

  @override
  String get commonUpdate => 'ອັບເດດ';

  @override
  String get commonEnable => 'ເປີດໃຊ້';

  @override
  String get billingPerHourShort => '/ຊ.ມ';

  @override
  String get billingPerDayShort => '/ມື້';

  @override
  String get billingPerNightShort => '/ຄືນ';

  @override
  String get billingPerSession => '/ຄັ້ງ';

  @override
  String get billingPerMinute => '/ນາທີ';

  @override
  String get servicesManageSubtitle => 'ຈັດການ ແລະ ຕັ້ງລາຄາບໍລິການ';

  @override
  String servicesManageDeleteTitle(String name) {
    return 'ລຶບ $name';
  }

  @override
  String get servicesManageDeleteMessage =>
      'ທ່ານຕ້ອງການລຶບບໍລິການນີ້ອອກຈາກໂປຣໄຟຂອງທ່ານແທ້ບໍ່?';

  @override
  String get servicesManageYourRate => 'ລາຄາທ່ານກຳນົດ';

  @override
  String get servicesManageFeePerSession => 'ຄ່າບໍລິການ/ຄັ້ງ';

  @override
  String get servicesManageActualEarnings => 'ເງິນທີ່ໄດ້ຮັບຕົວຈິງ';

  @override
  String get servicesManagePriceList => 'ລາຍການລາຄາ';

  @override
  String get servicesManageCommissionPerSession => 'ຄ່ານາຍໜ້າ/ຄັ້ງ';

  @override
  String get servicesManageCommission => 'ຄ່ານາຍໜ້າ';

  @override
  String get servicesManageBaseRate => 'ລາຄາພື້ນຖານ';

  @override
  String get servicesManageAddThis => 'ເພີ່ມບໍລິການນີ້';

  @override
  String get servicesManageLocationRequired => 'ກະລຸນາໃສ່ທີ່ຢູ່/ສະຖານທີ່';

  @override
  String get servicesManageUpdateMassageRate => 'ອັບເດດລາຄານວດ';

  @override
  String get servicesManageAddMassageRate => 'ເພີ່ມລາຄານວດ';

  @override
  String get servicesManageVariantName => 'ຊື່ປະເພດ';

  @override
  String get servicesManagePriceKipPerHour => 'ລາຄາ (ກີບ/ຊມ)';

  @override
  String servicesManagePriceKipPerHourShort(String amount) {
    return '$amount ກີບ/ຊມ';
  }

  @override
  String servicesManageMinimum(String amount) {
    return 'ຕ່ຳສຸດ $amount';
  }

  @override
  String get servicesManageAddVariant => 'ເພີ່ມປະເພດ';

  @override
  String get servicesManageAddressLabel => 'ທີ່ຢູ່/ສະຖານທີ່';

  @override
  String get servicesManageAddressHint => 'ເຊັ່ນ: ນະຄອນຫຼວງວຽງຈັນ, ສີສັດຕະນາກ';

  @override
  String get servicesManageInstructions =>
      'ເລືອກເພີ່ມບໍລິການທີ່ທ່ານສາມາດໃຫ້ໄດ້ ແລະ ຕັ້ງລາຄາຂອງທ່ານເອງ. ລູກຄ້າຈະເຫັນລາຍການທີ່ທ່ານເປີດໃຊ້ເທົ່ານັ້ນ.';

  @override
  String get servicesManageNoData => 'ບໍ່ມີຂໍ້ມູນບໍລິການ';

  @override
  String get servicesManageValidRateRequired => 'ກະລຸນາໃສ່ລາຄາທີ່ຖືກຕ້ອງ';

  @override
  String servicesManageMinRate(String amount) {
    return 'ລາຄາຕ່ຳສຸດ: $amount ກີບ';
  }

  @override
  String get servicesManageUpdatePrice => 'ອັບເດດລາຄາ';

  @override
  String get servicesManageAddService => 'ເພີ່ມບໍລິການ';

  @override
  String servicesManagePriceWithBilling(String billing) {
    return 'ລາຄາ$billing (ກີບ)';
  }

  @override
  String get registerCompanionTitle => 'ສ້າງບັນຊີ ສຳລັບຜູ້ໃຫ້ບໍລິການ';

  @override
  String get registerCustomerTitle => 'ສ້າງບັນຊີ ສຳລັບລູກຄ້າ';

  @override
  String get registerFillInfo => 'ກະລຸນາຕື່ມຂໍ້ມູນໃຫ້ຄົບ';

  @override
  String get registerFirstName => 'ຊື່';

  @override
  String get registerLastName => 'ນາມສະກຸນ';

  @override
  String get registerFirstNameHint => 'ປ້ອນຊື່';

  @override
  String get registerLastNameHint => 'ປ້ອນນາມສະກຸນ';

  @override
  String get registerPhone => 'ເບີໂທລະສັບ';

  @override
  String get registerSelectGender => 'ເລືອກເພດ';

  @override
  String get registerDob => 'ວັນເດືອນປີເກີດ';

  @override
  String get registerPassword => 'ລະຫັດຜ່ານ';

  @override
  String get registerPasswordHint => 'ປ້ອນລະຫັດຜ່ານ';

  @override
  String get registerAddress => 'ທີ່ຢູ່';

  @override
  String get registerAddressHint => 'ນາທົ່ມ,ໜອງວຽງຄຳ,ວຽງຈັນ...';

  @override
  String get registerReferredBy => 'ທ່ານໄດ້ຮັບການແນະນຳຈາກ';

  @override
  String get registerCta => 'ສ້າງບັນຊື';

  @override
  String get registerTermsPrefix => 'ຂ້ອຍໄດ້ອ່ານ ແລະ ຍອມຮັບ ';

  @override
  String get registerTermsOfUse => 'ຂໍ້ກຳນົດການໃຊ້ງານ';

  @override
  String get registerTermsAnd => ' ແລະ ';

  @override
  String get registerPrivacyPolicy => 'ນະໂຍບາຍຄວາມເປັນສ່ວນຕົວ';

  @override
  String get registerTermsSuffix => ' ຂອງ XAOSAO';

  @override
  String get registerAvatarChange => 'ກົດເພື່ອປ່ຽນຮູບ';

  @override
  String get registerAvatarPick => 'ກົດເພື່ອເລືອກຮູບ';

  @override
  String get registerStepInfo => 'ຂໍ້ມູນ';

  @override
  String get registerStepServices => 'ບໍລິການ';

  @override
  String get registerStepOtp => 'OTP';

  @override
  String get registerServicesTitle => 'ເລືອກບໍລິການ';

  @override
  String get registerServicesSubtitle => 'ກຳນົດປະເພດ ແລະ ລາຄາບໍລິການຂອງທ່ານ';

  @override
  String get registerNoServices => 'ບໍ່ມີບໍລິການ';

  @override
  String get registerServicesInfoPrefix => 'ກະລຸນາດຳເນີນການ';

  @override
  String get registerServicesInfoSelect => 'ເລືອກບໍລິການ';

  @override
  String get registerServicesInfoMid => ' ທີ່ທ່ານຕ້ອງການ ແລະ ';

  @override
  String get registerServicesInfoSetPrice => 'ຕັ້ງລາຄາ';

  @override
  String get registerServicesInfoDot => '.';

  @override
  String get registerPriceRequired => 'ກະລຸນາໃສ່ລາຄາ';

  @override
  String registerMinPrice(String amount) {
    return 'ລາຄາຕ່ຳສຸດ $amount ກີບ';
  }

  @override
  String get registerPricePerHourLabel => 'ລາຄາ (ກີບ/ຊົ່ວໂມງ) *';

  @override
  String registerMinPriceKip(String amount) {
    return 'ຕ່ຳສຸດ $amount ກີບ';
  }

  @override
  String get registerAllVariants => 'ເພີ່ມໄດ້ທຸກປະເພດ';

  @override
  String get registerServiceLocation => 'ສະຖານທີ່ໃຫ້ບໍລິການ *';

  @override
  String get registerServiceLocationHint =>
      'ເຊັ່ນ: ເຮືອນ, ໂຮງແຮມ, ສະຖານທີ່ລູກຄ້າ';

  @override
  String get registerVariantsPriceLabel => 'ປະເພດ ແລະ ລາຄາ (ກີບ/ຊົ່ວໂມງ) *';

  @override
  String get registerContinueCta => 'ດຳເນີນການຕໍ່';

  @override
  String get registerCurrencyPerHour => 'ກີບ/ຊມ';

  @override
  String get registerOtpSmsInfo =>
      'ກະລຸນາກວດເບິ່ງ SMS ຂອງທ່ານ\nລະຫັດໃຊ້ໄດ້ 5 ນາທີ ເທົ່ານັ້ນ';

  @override
  String get registerOtpInvalid => 'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ — ລອງໃໝ່';

  @override
  String get registerOtpInvalidRetry => 'ລະຫັດ OTP ບໍ່ຖືກຕ້ອງ ກະລຸນາລອງໃໝ່';

  @override
  String get registerOtpExpiresIn => 'ລະຫັດໝົດອາຍຸໃນ ';

  @override
  String get registerOtpExpired => 'ລະຫັດໝົດອາຍຸແລ້ວ';

  @override
  String get registerOtpNotReceived => 'ຍັງບໍ່ໄດ້ຮັບລະຫັດ? ';

  @override
  String get registerOtpResend => 'ສົ່ງໃໝ່';

  @override
  String get registerOtpChangePhone => 'ປ່ຽນເບີໂທລະສັບ';

  @override
  String get registerOtpConfirmPhone => 'ຢືນຢັນເບີໂທ';

  @override
  String get registerOtpEnter6Digits => 'ໃສ່ລະຫັດ 6 ໂຕທີ່ສົ່ງໄປຫາ';

  @override
  String get registerOtpVerify => 'ຢືນຢັນ OTP';

  @override
  String get commonEdit => 'ແກ້ໄຂ';

  @override
  String get commonConnectionRetry => 'ກວດສອບການເຊື່ອມຕໍ່ແລ້ວລອງໃໝ່';

  @override
  String get commonBank => 'ທະນາຄານ';

  @override
  String get qrTitle => 'QR ໂອນເງິນ';

  @override
  String get qrSubtitle => 'ຈັດການ QR Code ຂອງຂ້ອຍ';

  @override
  String get qrDeleteTitle => 'ລຶບ QR Code';

  @override
  String get qrDeleteMessage => 'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບ QR Code ນີ້?';

  @override
  String get qrDefaultLabel => 'ບັນຊີຫຼັກ';

  @override
  String get qrScanHint => 'ໃຫ້ລູກຄ້າສະແກນ QR ນີ້ເພື່ອໂອນເງິນ';

  @override
  String get qrEmptyTitle => 'ຍັງບໍ່ມີ QR Code';

  @override
  String get qrEmptySubtitle =>
      'ເພີ່ມ QR Code ທະນາຄານຂອງທ່ານ\nເພື່ອຮັບເງິນຈາກລູກຄ້າ';

  @override
  String get qrEmptyAddFirst => 'ເພີ່ມ QR Code ທຳອິດ';

  @override
  String get qrSetPrimary => 'ຕັ້ງເປັນ QR ຫຼັກ';

  @override
  String get qrAddNew => 'ເພີ່ມ QR ໃໝ່';

  @override
  String get qrInfoBanner =>
      'QR ທີ່ຕັ້ງເປັນ ຫຼັກ ຈະໂຊໃນໜ້າ Profile ຂອງທ່ານ ເພື່ອໃຫ້ລູກຄ້າສາມາດສະແກນໂອນເງິນໄດ້ທັນທີ.';

  @override
  String get qrAddFailed => 'ເພີ່ມ QR ບໍ່ສຳເລັດ';

  @override
  String get qrUpdateFailed => 'ອັບເດດ QR ບໍ່ສຳເລັດ';

  @override
  String get qrDeleteFailed => 'ລຶບ QR ບໍ່ສຳເລັດ';

  @override
  String get qrSetDefaultFailed => 'ຕັ້ງ QR ຫຼັກບໍ່ສຳເລັດ';

  @override
  String get genderMaleShort => 'ຊາຍ';

  @override
  String get genderFemaleShort => 'ຍິງ';

  @override
  String get genderOther => 'ອື່ນໆ';

  @override
  String get monthLongJan => 'ມັງກອນ';

  @override
  String get monthLongFeb => 'ກຸມພາ';

  @override
  String get monthLongMar => 'ມີນາ';

  @override
  String get monthLongApr => 'ເມສາ';

  @override
  String get monthLongMay => 'ພຶດສະພາ';

  @override
  String get monthLongJun => 'ມິຖຸນາ';

  @override
  String get monthLongJul => 'ກໍລະກົດ';

  @override
  String get monthLongAug => 'ສິງຫາ';

  @override
  String get monthLongSep => 'ກັນຍາ';

  @override
  String get monthLongOct => 'ຕຸລາ';

  @override
  String get monthLongNov => 'ພະຈິກ';

  @override
  String get monthLongDec => 'ທັນວາ';

  @override
  String get profileTitle => 'ໂປຣໄຟລ໌';

  @override
  String get profileSectionGeneralInfo => 'ຂໍ້ມູນທົ່ວໄປ';

  @override
  String get profileSectionAccountInfo => 'ຂໍ້ມູນບັນຊີ';

  @override
  String get profileSectionServices => 'ບໍລິການ';

  @override
  String get profileFullName => 'ຊື່-ນາມສະກຸນ';

  @override
  String get profilePhone => 'ເບີໂທ';

  @override
  String get profileGender => 'ເພດ';

  @override
  String get profileAccountCreated => 'ສ້າງບັນຊີ';

  @override
  String get profileNoServices => 'ຍັງບໍ່ມີບໍລິການ';

  @override
  String get profileVerifiedCustomer => 'ຢືນຢັງແລ້ວ';

  @override
  String get profileVerifiedCompanion => 'Companion ຢືນຢັງ';

  @override
  String get profileUpdateSuccess => 'ອັບເດດຂໍ້ມູນສຳເລັດ';

  @override
  String get profileUpdateFailed => 'ອັບເດດຂໍ້ມູນບໍ່ສຳເລັດ';

  @override
  String get profileEditTitle => 'ແກ້ໄຂຂໍ້ມູນ';

  @override
  String get profilePhoneReadonlyLabel => 'ເບີໂທ (ບໍ່ສາມາດປ່ຽນ)';

  @override
  String get profileAddressHint => 'ເຊັ່ນ: ໂຊນ 1, ວຽງຈັນ';

  @override
  String get profileEditNote =>
      'ການປ່ຽນລະຫັດຜ່ານ ແລະ ເລກໂທ, ຕ້ອງໄປທີ່ ໜ້າຕັ້ງຄ່າ';

  @override
  String get profileSave => 'ບັນທຶກ';

  @override
  String get commonErrorTryAgain => 'ເກີດຂໍ້ຜິດພາດ! ກະລຸນາລອງໃໝ່ອີກຄັ້ງ';

  @override
  String get commonUploadFailed => 'ອັບໂຫຼດບໍ່ສຳເລັດ';

  @override
  String get changePasswordTitle => 'ປ່ຽນລະຫັດຜ່ານ';

  @override
  String get changePasswordSubtitle => 'ຕ້ອງໃສ່ລະຫັດທຳກ່ອນ';

  @override
  String get changePasswordSectionCurrent => 'ລະຫັດຜ່ານ';

  @override
  String get changePasswordCurrentLabel => 'ລະຫັດຜ່ານປັດຈຸບັນ';

  @override
  String get changePasswordMin6 => 'ລະຫັດຜ່ານຕ້ອງຢ່າງໜ້ອຍ 6 ໂຕ';

  @override
  String get changePasswordSectionNew => 'ລະຫັດໃໝ່';

  @override
  String get changePasswordNewLabel => 'ລະຫັດຜ່ານໃໝ່';

  @override
  String get changePasswordNewHint => 'ໃສ່ລະຫັດໃໝ່';

  @override
  String get changePasswordConfirmLabel => 'ຢືນຢັນລະຫັດໃໝ່';

  @override
  String get changePasswordMismatch => 'ລະຫັດຜ່ານບໍ່ກົງກັນ';

  @override
  String get changePasswordSave => 'ບັນທຶກລະຫັດໃໝ່';

  @override
  String get changePasswordSecurityTitle => 'ຄວາມປອດໄພ';

  @override
  String get changePasswordSecurityRule =>
      'ລະຫັດຜ່ານຕ້ອງຢ່າງໜ້ອຍ 8 ໂຕ, ລວມທັງຕົວໃຫຍ່, ຕົວເລກ ແລະ ສັນຍາລັກ';

  @override
  String get changePasswordStrengthWeak => 'ອ່ອນ';

  @override
  String get changePasswordStrengthFair => 'ປານກາງ';

  @override
  String get changePasswordStrengthStrong => 'ແຂງແຮງ';

  @override
  String get changePasswordSuccess => 'ປ່ຽນລະຫັດຜ່ານສຳເລັດ';

  @override
  String get changePasswordFailed => 'ປ່ຽນລະຫັດຜ່ານບໍ່ສຳເລັດ';

  @override
  String get profileToggleStatusFailed => 'ປ່ຽນສະຖານະບໍ່ສຳເລັດ';

  @override
  String get profileUploadPhotoFailed => 'ອັບໂຫຼດຮູບໂປຣໄຟບໍ່ສຳເລັດ';

  @override
  String get profileNoPhotos => 'ຍັງບໍ່ມີຮູບ';

  @override
  String get profileGalleryTitle => 'ຮູບພາບທັງໝົດ';

  @override
  String profileGalleryCount(int count, int max) {
    return '$count / $max ຮູບ';
  }

  @override
  String get profileDeletePhotoTitle => 'ລຶບຮູບ';

  @override
  String get profileDeletePhotoMessage => 'ທ່ານຕ້ອງການລຶບຮູບນີ້ແທ້ບໍ່?';

  @override
  String get profileAddPhoto => 'ເພີ່ມຮູບ';

  @override
  String get profileHiddenShowSuccess => 'ສະແດງໂປຣໄຟສຳເລັດ';

  @override
  String get profileHiddenBannerBody =>
      'ລູກຄ້າບໍ່ສາມາດເຫັນໂປຣໄຟຂອງທ່ານໃນຕອນນີ້. ເມື່ອທ່ານພ້ອມຮັບການຈອງອີກຄັ້ງ, ກົດສະແດງໂປຣໄຟຂອງທ່ານ.';

  @override
  String get profileHiddenClose => 'ປິດ';

  @override
  String get profileHiddenShow => 'ສະແດງໂປຣໄຟ';

  @override
  String get profileHiddenHeaderTitle => 'ໂປຣໄຟຂອງທ່ານຖືກຊ່ອນຢູ່';

  @override
  String get profileHiddenHeaderSubtitle => 'ທ່ານຈະບໍ່ສະແດງໃນຜົນຄົ້ນຫາ';

  @override
  String get profileShareLink => 'ແຊຣ໌ Profile Link';

  @override
  String get profileHideYourProfile => 'ເຊື່ອງໂປຣໄຟຂອງທ່ານ';

  @override
  String get qrRowScanToTransfer => 'ສະແກນເພື່ອໂອນເງິນ';

  @override
  String get servicesEditAddLabel => 'ແກ້ໄຂ / ເພີ່ມ ບໍລິການ';

  @override
  String get servicesEditAddSub => 'ຕັ້ງລາຄາ ແລະ ຄຳອະທິບາຍ';

  @override
  String get timeJustNow => 'ໃໝ່ໆ';

  @override
  String get timeJustNowShort => 'ຫາກໍ່';

  @override
  String timeMinutesAgo(int n) {
    return '$n ນາທີກ່ອນ';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n ຊົ່ວໂມງກ່ອນ';
  }

  @override
  String timeDaysAgo(int n) {
    return '$n ວັນກ່ອນ';
  }

  @override
  String timeWeeksAgo(int n) {
    return '$n ອາທິດກ່ອນ';
  }

  @override
  String timeMinutesShort(int n) {
    return '$nນາທີ';
  }

  @override
  String timeHoursShort(int n) {
    return '$nຊົ່ວໂມງ';
  }

  @override
  String timeDaysShort(int n) {
    return '$nວັນ';
  }

  @override
  String timeWeeksShort(int n) {
    return '$nອາທິດ';
  }

  @override
  String timeDaysShortSpaced(int n) {
    return '$n ວັນ';
  }

  @override
  String timeWeeksShortSpaced(int n) {
    return '$n ອາທິດ';
  }

  @override
  String get commonUser => 'ຜູ້ໃຊ້';

  @override
  String get commonYou => 'ທ່ານ';

  @override
  String get commonLoadMore => 'ໂຫຼດເພີ່ມ';

  @override
  String commonAmountKip(String amount) {
    return '$amount ກີບ';
  }

  @override
  String get postsTitle => 'ໂພສ';

  @override
  String get postsSubtitle => 'ຄົ້ນຫາຜູ້ໃຫ້ບໍລິການທີ່ໃຊ້ຂອງທ່ານ';

  @override
  String get postsCantLoad => 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ';

  @override
  String get postsPleaseRetry => 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ';

  @override
  String get postsEmpty => 'ຍັງບໍ່ມີໂພສ';

  @override
  String get postsEmptyFeedSubtitle => 'ໂພສຈາກ Companion ຈະສະແດງທີ່ນີ້';

  @override
  String get postsEmptyMySubtitle => 'ກົດ \"ສ້າງໂພສ\" ເພື່ອເລີ່ມໂພສ';

  @override
  String get postsShare => 'ແຊຣ໌ໂພສ';

  @override
  String get postsReport => 'ລາຍງານ';

  @override
  String get postsDeleteTitle => 'ລຶບໂພສ';

  @override
  String get postsDeleteMessage =>
      'ທ່ານແນ່ໃຈທີ່ຈະລຶບໂພສນີ້ບໍ?\nການດຳເນີນການນີ້ບໍ່ສາມາດຍ້ອນຄືນໄດ້';

  @override
  String get postsDisableTitle => 'ປິດໂພສ';

  @override
  String get postsDisableMessage =>
      'ທ່ານແນ່ໃຈທີ່ຈະປິດໂພສນີ້ບໍ?\nລູກຄ້າຈະບໍ່ສາມາດເຫັນໂພສນີ້ໄດ້';

  @override
  String get postsDisableConfirm => 'ປິດໂພສ';

  @override
  String get postsCreate => 'ສ້າງໂພສ';

  @override
  String get postsTabAll => 'ທັງໝົດ';

  @override
  String get postsTabMine => 'ຂອງຂ້ອຍ';

  @override
  String get postsPublicPost => 'ໂພສສາທາລະນະ';

  @override
  String get postsWhatLookingFor => 'ທ່ານກຳລັງຊອກຫາຄູ່ເເບບໃດ?';

  @override
  String get postsHintCustomer =>
      'ຕົວຢ່າງ: ຂ້ອຍກຳລັງຊ່ວຍລູກຄ້າທີ່ໂພສນີ້ ເພື່ອຫາຄູ່ດື່ມ';

  @override
  String get postsHintModel => 'ຕົວຢ່າງ: ຂ້ອຍຕ້ອງການ 2 ຄົນເປັນຄູ່ດື່ມຄືນນີ້';

  @override
  String get postsAddPhotos => 'ເພີ່ມຮູບພາບ';

  @override
  String get postsChangePhoto => 'ປ່ຽນຮູບ';

  @override
  String get postsSelectGender => 'ເລືອກເພດ';

  @override
  String get postsSelectService => 'ເລືອກບໍລິການ';

  @override
  String get postsLocation => 'ສະຖານທີ';

  @override
  String get postsLocationHint => 'ຕົວຢ່າງ: ຮ້ານອາຫານ,ດາວອັງຄານ...';

  @override
  String get postsWillTip => 'ຂ້ອຍຈະໃຫ້ທິບ';

  @override
  String get postsWillTipHelp =>
      'ເພື່ອໃຫ້ຮູ້ວ່າຈະໃຫ້ທິບ, ຈຶ່ງມີຄົນສົນໃຈຫຼາຍຂຶ້ນ';

  @override
  String get postsSubmitAndNotify => 'ໂພສ ແລະ ແຈ້ງເຕື່ອນ';

  @override
  String get postsGenderAny => 'ທຸກເພດ';

  @override
  String get postsGiftHistory => 'ປະຫວັດຂອງຂວັນ';

  @override
  String get postsGiftHistorySubtitle => 'ດູລາຍການຂອງຂວັນທີ່ທ່ານສົ່ງໃຫ້ໂມເດວ';

  @override
  String get postsAuthorFallback => 'ຜູ້ໂພສ';

  @override
  String get postStatusActive => 'ກຳລັງໃຊ້';

  @override
  String get postStatusExpired => 'ໝົດອາຍຸ';

  @override
  String get postStatusHidden => 'ຊ່ອນ';

  @override
  String get postStatusFulfilled => 'ປິດໃຊ້ງານເເລ້ວ';

  @override
  String get postActionBook => 'ຈອງ';

  @override
  String get postActionChat => 'ແຊັດ';

  @override
  String get commentsTitle => 'ຄໍາເຫັນ';

  @override
  String get commentsEmptyTitle => 'ຍັງບໍ່ມີຄໍາເຫັນ';

  @override
  String get commentsEmptySubtitle => 'ເປັນຄົນທໍາອິດທີ່ຄອມເມັນ!';

  @override
  String get commentReply => 'ຕອບກັບ';

  @override
  String get commentCollapseReplies => 'ຫຍໍ້ຄໍາຕອບ';

  @override
  String commentViewReplies(int count) {
    return 'ເບິ່ງ $count ຄໍາຕອບ';
  }

  @override
  String commentReplyToHint(String name) {
    return 'ຕອບ $name...';
  }

  @override
  String get commentWriteHint => 'ຂຽນຄໍາເຫັນ...';

  @override
  String get postDetailTitle => 'ລາຍລະອຽດໂພສ';

  @override
  String get postDetailActive => 'ກຳລັງເປີດ';

  @override
  String get postDetailClosed => 'ປິດເເລ້ວ';

  @override
  String get postDetailCollapse => 'ຫຍໍ້ລົງ';

  @override
  String get postDetailReadMore => 'ອ່ານເພີ່ມ';

  @override
  String get postDetailInterested => 'ສົນໃຈ';

  @override
  String get postDetailGift => 'ຂອງຂວັນ';

  @override
  String get postDetailComment => 'ຄຳເຫັນ';

  @override
  String get interestTitle => 'ຜູ້ສົນໃຈ';

  @override
  String get interestSubtitle => 'ລາຍຊື່ຜູ້ທີ່ສົນໃຈໂພສຂອງທ່ານ';

  @override
  String get interestEmptyTitle => 'ຍັງບໍ່ມີຜູ້ສົນໃຈ';

  @override
  String get interestEmptySubtitle =>
      'ເມື່ອມີຜູ້ກົດໃຈໂພສນີ້,\nຊື່ຂອງພວກເຂົາຈະສະແດງຢູ່ນີ້';

  @override
  String get giftReceivedTitle => 'ຂອງຂວັນ';

  @override
  String get giftReceivedSubtitle => 'ຂອງຂວັນທີ່ທ່ານໄດ້ຮັບ';

  @override
  String get giftEmptyReceivedTitle => 'ຍັງບໍ່ມີຂອງຂວັນ';

  @override
  String get giftEmptyReceivedSubtitle => 'ຂອງຂວັນທີ່ຄົນສົ່ງໃຫ້ຈະສະແດງທີ່ນີ້';

  @override
  String get giftSenderLabel => 'ຜູ້ສົ່ງຂອງຂວັນ';

  @override
  String get giftReceivedTotal => 'ຂອງຂວັນທີ່ໄດ້ຮັບທັງໝົດ';

  @override
  String get giftFallback => 'ຂອງຂວັນ';

  @override
  String get giftHistoryTitle => 'ປະຫວັດຂອງຂວັນ';

  @override
  String get giftHistorySubtitle => 'ລາຍການຂອງຂວັນທີ່ທ່ານໄດ້ສົ່ງ';

  @override
  String get giftHistoryEmptyTitle => 'ຍັງບໍ່ມີປະຫວັດຂອງຂວັນ';

  @override
  String get giftHistoryEmptySubtitle =>
      'ເມື່ອທ່ານສົ່ງຂອງຂວັນໃຫ້ໂມເດວ,\nລາຍການຈະສະແດງຢູ່ນີ້';

  @override
  String get giftDetailsTitle => 'ລາຍລະອຽດຂອງຂວັນ';

  @override
  String get giftHistorySentTimes => 'ຄັ້ງທີ່ທ່ານສົ່ງຂອງຂວັນ';

  @override
  String giftHistorySpent(String amount) {
    return 'ໃຊ້ຈ່າຍ $amount ກີບ';
  }

  @override
  String get commonErrorOccurred => 'ມີຂໍ້ຜິດພາດເກີດຂຶ້ນ';

  @override
  String get commonCantLoadData => 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນໄດ້';
}
