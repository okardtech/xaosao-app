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
  String get serviceTypeSocial => 'ກິດຈະກຳທ້ອງຖິ່ນ';

  @override
  String get serviceTypeMassage => 'ນວດ';

  @override
  String get serviceTypeTravel => 'ປະສົບການທ້ອງຖິ່ນ';

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
    return '$hours ຮອບ';
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
  String get profileShareLink => 'ແຊຣ໌ລິ້ງແນະນຳຂອງທ່ານ';

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

  @override
  String get packageHistoryTitle => 'ປະຫວັດ Package';

  @override
  String get packageHistorySubtitle => 'ລາຍການຊື້ທັງໝົດ';

  @override
  String get packageHistoryEmpty => 'ບໍ່ມີລາຍການ';

  @override
  String get packageStatusActive => 'ກຳລັງໃຊ້';

  @override
  String get packageStatusCompleted => 'ສຳເລັດ';

  @override
  String get packageStatusPending => 'ລໍຖ້າ';

  @override
  String get packageStatusPendingRelease => 'ລໍຖ້າໂອນ';

  @override
  String get packageStatusCanceled => 'ຍົກເລີກ';

  @override
  String get packageStatusRefunded => 'ຄືນເງິນ';

  @override
  String get packageStatusExpired => 'ໝົດອາຍຸ';

  @override
  String get packageStatusUpgraded => 'ອັບເກຣດ';

  @override
  String get packageStatusHeld => 'ຄ້ຳປະກັນ';

  @override
  String get packageStatusSuperseded => 'ຖືກແທນທີ່';

  @override
  String get packageAmount => 'ຈຳນວນ';

  @override
  String packageDaysRemaining(int days) {
    return 'ຍັງເຫຼືອ $days ວັນ';
  }

  @override
  String packageExpiresShort(String date) {
    return 'ໝົດ $date';
  }

  @override
  String get subscriptionPrice => 'ລາຄາ';

  @override
  String get subscriptionDuration => 'ໄລຍະເວລາ';

  @override
  String get subscriptionBenefits => 'ສິ່ງທີ່ທ່ານຈະໄດ້ຮັບ:';

  @override
  String get subscriptionViewAll => 'ເບິ່ງແພັກທັງໝົດ';

  @override
  String get subscriptionClose => 'ປິດ';

  @override
  String get subscriptionBuyNow => 'ຊື້ເລີຍ';

  @override
  String get subscriptionTopUp => 'ຕື່ມເງິນ';

  @override
  String subscriptionDurationHours(int hours) {
    return '$hours ຊ.ມ';
  }

  @override
  String get subscriptionDuration1Day => '1 ວັນ';

  @override
  String get subscriptionDuration1Week => '1 ອາທິດ';

  @override
  String get subscriptionDuration1Month => '1 ເດືອນ';

  @override
  String get subscriptionDuration3Months => '3 ເດືອນ';

  @override
  String get subscriptionDuration1Year => '1 ປີ';

  @override
  String subscriptionDurationDays(int days) {
    return '$days ວັນ';
  }

  @override
  String get subscriptionSpecialPack => 'ແພັກພິເສດ';

  @override
  String get subscriptionYourBalance => 'ຍອດເງິນຂອງທ່ານ';

  @override
  String subscriptionNeedMore(String amount) {
    return 'ຕ້ອງການ +$amount KIP';
  }

  @override
  String get subscriptionCanPay => 'ຊຳລະໄດ້ເລີຍ';

  @override
  String get subscriptionNeedPackageBody =>
      'ກະລຸນາຊື້ Package ກ່ອນ ຈຶ່ງສາມາດຈອງບໍລິການໄດ້. Package ຈະໃຫ້ທ່ານສິດໃນການຈອງ ແລະ ໃຊ້ງານຕ່າງໆ.';

  @override
  String get subscriptionViewPackage => 'ເບິ່ງ Package';

  @override
  String get subscriptionNeedPackage => 'ຕ້ອງການ Wallet Package';

  @override
  String get subscriptionNoActive => 'ຍັງບໍ່ມີ Wallet Package ໃຊ້ງານ';

  @override
  String get subscriptionServicePrice => 'ລາຄາບໍລິການ';

  @override
  String get subscriptionShortfall => 'ຂາດຢູ່';

  @override
  String subscriptionTopUpAmount(String amount) {
    return 'ຕື່ມ $amount KIP';
  }

  @override
  String get subscriptionInsufficient => 'ຍອດເງິນບໍ່ພຽງພໍ';

  @override
  String get subscriptionPleaseTopup => 'ກະລຸນາຕື່ມເງິນກ່ອນຈອງ';

  @override
  String get subscriptionPendingVerification => 'ລໍຖ້າການຢືນຢັນ';

  @override
  String get subscriptionAlreadySubscribed =>
      'ທ່ານມີ Wallet Package ໃຊ້ງານຢູ່ແລ້ວ';

  @override
  String get subscriptionPendingBadge => 'ລໍຖ້າ';

  @override
  String get subscriptionPendingBody =>
      'Package ຂອງທ່ານກຳລັງລໍຖ້າການຢືນຢັນຈາກ Admin. ກະລຸນາລໍຖ້າ ຫຼື ຕິດຕໍ່ Admin ເພື່ອຢືນຢັນໂດຍໄວ.';

  @override
  String get subscriptionAdminPhone => 'ເບີໂທ Admin';

  @override
  String get subscriptionCallAdmin => 'ໂທຫາ Admin';

  @override
  String get subscriptionWaitingVerification => 'ກຳລັງລໍຖ້າການຢືນຢັນ';

  @override
  String get subscriptionAdminChecking => 'Package ຂອງທ່ານລໍຖ້າ Admin ກວດສອບ';

  @override
  String get packagePurchaseFailed => 'ການຊື້ບໍ່ສຳເລັດ';

  @override
  String get packageFeature1 =>
      'ຈອງບໍລິການຈາກຜູ້ໃຫ້ບໍລິການໃນທ້ອງຖິ່ນໄດ້ບໍ່ຈຳກັດຕໍ່ວັນ';

  @override
  String get packageFeature2 =>
      'ຕິດຕໍ່ຜູ້ໃຫ້ບໍລິການເພື່ອປະສານງານການຈອງ ແລະ ກິດຈະກຳ';

  @override
  String get packageFeature3 =>
      'ຈອງກິດຈະກຳ ແລະ ບໍລິການໃນຊີວິດຈິງໄດ້ບໍ່ຈຳກັດຕໍ່ວັນ';

  @override
  String get packageFeature4 =>
      'ຄົ້ນພົບຜູ້ໃຫ້ບໍລິການທີ່ໄດ້ຮັບຄະແນນສູງໃນເຂດຂອງທ່ານ';

  @override
  String get packageFeature5 =>
      'ຄົ້ນຫາຜູ້ໃຫ້ບໍລິການຕາມປະເພດ, ສະຖານທີ່ ແລະ ຄວາມພ້ອມ';

  @override
  String get packageFeature6 => 'ບໍລິການຊ່ວຍເຫຼືອລູກຄ້າ 24/7';

  @override
  String get packageFeature7 => 'ໂປຣໄຟລ໌ຜູ້ໃຫ້ບໍລິການເຫັນເດັ່ນຊັດຂຶ້ນ';

  @override
  String get packagePlanShort1 =>
      'ຈອງບໍລິການ ແລະ ເຊື່ອມຕໍ່ກັບຜູ້ໃຫ້ບໍລິການໃນທ້ອງຖິ່ນ';

  @override
  String get packagePlanShort2 =>
      'ທົດລອງໃຊ້ 24 ຊົ່ວໂມງ ສຳລັບການຈອງ ແລະ ຕິດຕໍ່ຜູ້ໃຫ້ບໍລິການ';

  @override
  String get packagePlanShort3 =>
      'ຄຸ້ມທີ່ສຸດສຳລັບການຈອງໄລຍະຍາວ ແລະ ວາງແຜນກິດຈະກຳ';

  @override
  String get packageChooseTitle => 'ເລືອກແຜນ';

  @override
  String get packageChooseSubtitle => 'ເລືອກ Wallet Package';

  @override
  String get packageHistoryButton => 'ປະຫວັດ';

  @override
  String get packageCancelAnytime => 'ຍົກເລີກໄດ້ທຸກເວລາ · ໂອນຄືນຕາມນະໂຍບາຍ';

  @override
  String get packageWaitingVerification => 'ລໍຖ້າການຢືນຢັນ';

  @override
  String get packageExpiredLabel => 'ໝົດອາຍຸແລ້ວ';

  @override
  String get packageNearExpiry => 'ໃກ້ໝົດອາຍຸ';

  @override
  String get packageActive => 'ກຳລັງໃຊ້ງານ';

  @override
  String get packageProcessingVerification => 'ກຳລັງດຳເນີນການຢືນຢັນ...';

  @override
  String packageExpiresOn(String date) {
    return 'ໝົດອາຍຸ $date';
  }

  @override
  String get packageDays => 'ວັນ';

  @override
  String get packageRemainingLabel => 'ຄົງເຫຼືອ';

  @override
  String get packageChooseYourPlan => 'ເລືອກແຜນຂອງທ່ານ';

  @override
  String get packageUpgradeExperience => 'ຂະຫຍາຍການເຂົ້າເຖິງການຈອງ';

  @override
  String get packageChooseFitPlan => 'ເລືອກແຜນທີ່ເໝາະສົມກັບຄວາມຕ້ອງການຈອງ';

  @override
  String get packageLoadFailedShort => 'ໂຫຼດບໍ່ສຳເລັດ';

  @override
  String get packageNoPackage => 'ບໍ່ມີ Package';

  @override
  String get packageRequestProcessing =>
      'ຄຳຮ້ອງຂໍຂອງທ່ານກຳລັງຖືກດຳເນີນການ · ກະລຸນາລໍຖ້າ';

  @override
  String get packageCurrent => 'ແພັກເກດປັດຈຸບັນ';

  @override
  String get packageSelectPlan => 'ເລືອກແຜນນີ້';

  @override
  String get checkoutPurchaseSuccess => 'ຊື້ Package ສຳເລັດ';

  @override
  String get checkoutUpgradeTitle => 'ອັບເກຣດ Package';

  @override
  String get checkoutUpgradeSubtitle => 'ກວດສອບ ແລະ ຢືນຢັນການຊຳລະ';

  @override
  String get checkoutProcessPayment => 'ດຳເນີນການຊຳລະ';

  @override
  String get checkoutAlreadySubscribed => 'Wallet Package ໃຊ້ງານຢູ່ແລ້ວ';

  @override
  String checkoutPillPlan(String name) {
    return 'ແຜນ $name';
  }

  @override
  String checkoutPillRemainingDays(int days) {
    return 'ເຫຼືອ $days ວັນ';
  }

  @override
  String get checkoutUpgradeInfo =>
      'ການຊຳລະໃໝ່ຈະເລີ່ມຕໍ່ຈາກ Package ປັດຈຸບັນ ແລະ ວັນທີ່ຍັງເຫຼືອຈະຖືກນຳໃສ່ Package ໃໝ່.';

  @override
  String get checkoutPackageDuration => 'ໄລຍະ Package';

  @override
  String get checkoutNewPackageDuration => 'ໄລຍະ Package ໃໝ່';

  @override
  String get checkoutBonusFromOld => '+ ໂບນັດ (Package ເດີມ)';

  @override
  String get checkoutTotalDuration => 'ໄລຍະທັງໝົດ';

  @override
  String get checkoutPaymentSummary => 'ສະຫຼຸບການຊຳລະ';

  @override
  String get checkoutWalletBalance => 'ຍອດ Wallet';

  @override
  String get checkoutPackagePrice => 'ລາຄາ Package';

  @override
  String get checkoutRemaining => 'ຍອດຄົງເຫຼືອ';

  @override
  String get checkoutShortfallSuffix => ' (ຂາດ)';

  @override
  String get checkoutWalletDeductInfo =>
      'ຍອດ Wallet ຈະຖືກຕັດທັນທີ. Package ຈະເປີດໃຊ້ງານຫຼັງຈາກການຊຳລະສຳເລັດ.';

  @override
  String get onboardingTopCompanions => 'ເພື່ອນແນະນຳຍອດນິຍົມ';

  @override
  String get onboardingTopCompanionsSubtitle =>
      'ຄົ້ນພົບຜູ້ໃຫ້ບໍລິການທີ່ໄດ້ຮັບຄະແນນສູງ';

  @override
  String get onboardingWelcome => 'ຍິນດີຕ້ອນຮັບ 👋';

  @override
  String get onboardingFindYourCompanion => 'ຊອກຫາເພື່ອນຂອງທ່ານ';

  @override
  String get onboardingLoginOrSignup => 'ເຂົ້າສູ່ລະບົບ / ສ້າງບັນຊີ';

  @override
  String get onboardingActionsHint =>
      'ເບິ່ງໂປຣໄຟລ໌ · ສົ່ງຂໍ້ຄວາມ · ຈອງໄດ້ທັນທີ';

  @override
  String get onboardingLogin => 'ເຂົ້າສູ່ລະບົບ';

  @override
  String get onboardingOurServices => 'ບໍລິການຂອງພວກເຮົາ';

  @override
  String get onboardingMassageTitle => 'ບໍລິການນວດ';

  @override
  String get onboardingMassageSubtitle =>
      'ບໍລິການນວດສຸຂະພາບໂດຍຜູ້ໃຫ້ບໍລິການມືອາຊີບ ສະດວກຮອດບ້ານ';

  @override
  String get onboardingSocialSubtitle =>
      'ຄູ່ຮ່ວມງານສຳລັບງານສັງຄົມ ເພື່ອເພີ່ມຄວາມມ່ວນຊື່ນ ແລະ ຄວາມປະທັບໃຈ';

  @override
  String get onboardingTravelTitle => 'ເພື່ອນທ່ອງທ່ຽວ';

  @override
  String get onboardingTravelSubtitle =>
      'ຄູ່ຮ່ວມທ່ອງທ່ຽວທີ່ພ້ອມພາເຈົ້າຄົ້ນພົບປະສົບການໃໝ່ ທັງໃນ ແລະ ຕ່າງປະເທດ';

  @override
  String get onboardingLevelGeneral => 'ທົ່ວໄປ';

  @override
  String get onboardingLevelSpecial => 'ພິເສດ';

  @override
  String get onboardingLevelPartner => 'ພາກຮ່ວມ';

  @override
  String get onboardingPartnerBenefits => 'ສິດປະໂຫຍດພາກຮ່ວມ';

  @override
  String get onboardingIncreaseIncome => 'ເພີ່ມລາຍຮັບຂອງທ່ານ';

  @override
  String get onboardingJoinNow => 'ເຂົ້າຮ່ວມເລີຍ';

  @override
  String get onboardingConditionRegister => 'ລົງທະບຽນເປັນຄູ່ຮ່ວມ';

  @override
  String get onboardingEarnPer20 => 'ຕໍ່ 1 ຄົນທີ່ແນະນຳ · ສູງສຸດ 20 ຄົນ';

  @override
  String get onboardingCondition20People => 'ແນະນຳຄູ່ຮ່ວມ 20 ຄົນ';

  @override
  String get onboardingEarnCommission => 'ຄ່າຄອມມິຊັນ ແລະ ຈຳນວນແນະນຳ';

  @override
  String get onboardingEarnVipSummary => 'ສະຫຼຸບ VIP ແລະ ຄ່າຄອມມິຊັນໃນເວລາ';

  @override
  String get onboardingReadyToEarn => 'ພ້ອມເລີ່ມຫາລາຍຮັບບໍ?';

  @override
  String get onboardingRegisterUnlock =>
      'ລົງທະບຽນຕອນນີ້ ແລະ ເພີ່ມລາງວັນຂອງທ່ານ ໂດຍການແນະນຳຜູ້ອື່ນ';

  @override
  String get onboardingGetStarted => 'ເລີ່ມຕົ້ນ';

  @override
  String get notifSettingTitle => 'ຕັ້ງຄ່າລະບົບ';

  @override
  String get notifSettingSubtitle => 'ຈັດການການແຈ້ງເຕືອນຂອງທ່ານ';

  @override
  String get notifSettingChannelsSection => 'ຊ່ອງທາງການແຈ້ງເຕືອນ';

  @override
  String get notifSettingPushSubtitle => 'ແຈ້ງເຕືອນໂດຍກົງໃສ່ໂທລະສັບ';

  @override
  String get notifSettingSmsSubtitle => 'ຮັບຂໍ້ຄວາມສັ້ນໃສ່ເບີໂທ';

  @override
  String get notifSettingBannerTitle => 'ການຕັ້ງຄ່າການແຈ້ງເຕືອນ';

  @override
  String get notifSettingBannerBody =>
      'ເລືອກຊ່ອງທາງທີ່ທ່ານຕ້ອງການຮັບຂໍ້ຄວາມ\nການປ່ຽນແປງຈະຖືກບັນທຶກໂດຍອັດຕະໂນມັດ';

  @override
  String get notifSettingFooterNote =>
      'ການປ່ຽນແປງຈະຖືກບັນທຶກທັນທີ. ທ່ານສາມາດປ່ຽນການຕັ້ງຄ່າໄດ້ຕະຫຼອດເວລາ.';

  @override
  String get notifSettingUpdateFailed => 'ອັບເດດບໍ່ສຳເລັດ';

  @override
  String get notifListTitle => 'ການແຈ້ງເຕືອນ';

  @override
  String get notifListSubtitle => 'ລາຍການແຈ້ງເຕືອນທັງໝົດຂອງທ່ານ';

  @override
  String get notifListMarkAllRead => 'ອ່ານທັງໝົດ';

  @override
  String get notifListEmptyTitle => 'ຍັງບໍ່ມີການແຈ້ງເຕືອນ';

  @override
  String get notifListEmptySubtitle => 'ການແຈ້ງເຕືອນຈະສະແດງທີ່ນີ້';

  @override
  String get notifTimeJustNow => 'ຫາກໍ່ນີ້';

  @override
  String notifTimeMinutes(int n) {
    return '$n ນາທີ';
  }

  @override
  String notifTimeHours(int n) {
    return '$n ຊົ່ວໂມງ';
  }

  @override
  String get notifTimeYesterday => 'ມື້ວານ';

  @override
  String notifTimeDaysAgo(int n) {
    return '$n ມື້ກ່ອນ';
  }

  @override
  String notifTimeWeeksAgo(int n) {
    return '$n ອາທິດຜ່ານມາ';
  }

  @override
  String notifTimeMonthsAgo(int n) {
    return '$n ເດືອນກ່ອນ';
  }

  @override
  String get welcomeTitle => 'ຍິນດີຕ້ອນຮັບ!';

  @override
  String get welcomeBody =>
      'ບັນຊີຂອງທ່ານສ້າງສຳເລັດແລ້ວ.\nຂໍໃຫ້ທ່ານມີຄວາມສຸກໃນການໃຊ້ງານ!';

  @override
  String get welcomeCanDoTitle => 'ສິ່ງທີ່ທ່ານສາມາດເຮັດໄດ້';

  @override
  String get welcomeChat => 'ສົນທະນາ';

  @override
  String get welcomeBook => 'ຈອງ';

  @override
  String get welcomeExplore => 'ຄົ້ນຫາ';

  @override
  String get welcomeGetStartedCta => 'ເລີ່ມໃຊ້ງານເລີຍ';

  @override
  String get modelWalletAvailableBalance => 'ຍອດເງິນສາມາດຖອນໄດ້';

  @override
  String get modelWalletStatPending => 'ລໍຖ້າ';

  @override
  String get modelWalletStatWithdrawn => 'ຖອນແລ້ວ';

  @override
  String get modelWalletStatTotalIncome => 'ລາຍຮັບທັງໝົດ';

  @override
  String get modelWalletWithdrawBtn => 'ຖອນເງິນ';

  @override
  String get modelWalletIncomeHistory => 'ປະຫວັດລາຍຮັບ';

  @override
  String get modelWalletEmptyTitle => 'ຍັງບໍ່ມີລາຍການ';

  @override
  String get modelWalletEmptySubtitle =>
      'ລາຍການລາຍຮັບຂອງທ່ານ\nຈະສະແດງຢູ່ທີ່ນີ້';

  @override
  String get modelWalletWithdrawFailed => 'ບໍ່ສາມາດຖອນເງິນໄດ້';

  @override
  String get withdrawTitle => 'ຖອນເງິນ';

  @override
  String get withdrawSubtitle => 'ຈ່າຍໃຫ້ບັນຊີທະນາຄານ';

  @override
  String get withdrawSelectBank => 'ເລືອກບັນຊີທະນາຄານ';

  @override
  String get withdrawAmountLabel => 'ຈໍານວນເງິນ';

  @override
  String get withdrawAmountHint => 'ປ້ອນຈໍານວນ';

  @override
  String get withdrawHintMin => 'ຕ່ຳສຸດ';

  @override
  String get withdrawHintMax => 'ສູງສຸດ';

  @override
  String withdrawBelowMin(String amount) {
    return 'ຈໍານວນຕ່ຳກວ່າຂີດຈໍາກັດ ($amount)';
  }

  @override
  String withdrawAboveMax(String amount) {
    return 'ເກີນຍອດທີ່ສາມາດຖອນໄດ້ ($amount)';
  }

  @override
  String get withdrawConfirmBtn => 'ຢືນຢັນການຖອນ';

  @override
  String get withdrawableBalance => 'ຍອດທີ່ຖອນໄດ້';

  @override
  String get withdrawAll => 'ຖອນທັງໝົດ';

  @override
  String get withdrawUnavailable => 'ຖອນບໍ່ໄດ້';

  @override
  String get withdrawNoBankTitle => 'ຍັງບໍ່ມີບັນຊີທະນາຄານ';

  @override
  String get withdrawNoBankSubtitle => 'ກະລຸນາເພີ່ມບັນຊີກ່ອນທີ່ຈະຖອນເງິນ';

  @override
  String get withdrawAddBank => 'ເພີ່ມບັນຊີທະນາຄານ';

  @override
  String get discoverTitle => 'ຄົ້ນພົບ';

  @override
  String get discoverSubtitle => 'ຄົ້ນຫາຜູ້ໃຊ້ທີ່ທ່ານໃຈ';

  @override
  String get discoverSearchHint => 'ຄົ້ນຫາດ້ວຍຊື່...';

  @override
  String get discoverTabForYou => 'ສຳລັບທ່ານ';

  @override
  String get discoverTabWhoLikedMe => 'ຖືກໃຈຂ້ອຍ';

  @override
  String get discoverTabILiked => 'ຂ້ອຍຖືກໃຈ';

  @override
  String get discoverEmptyAllTitle => 'ບໍ່ພົບຜູ້ໃຊ້';

  @override
  String get discoverEmptyAllSubtitle => 'ລອງປ່ຽນຕົວກອງ ຫຼື ຄົ້ນຫາໃໝ່ອີກຄັ້ງ';

  @override
  String get discoverEmptyForYouTitle => 'ຍັງບໍ່ມີຄຳແນະນຳ';

  @override
  String get discoverEmptyForYouSubtitle => 'ລະບົບຈະຊອກຫາຜູ້ທີ່ເໝາະສົມໃຫ້ທ່ານ';

  @override
  String get discoverEmptyWhoLikedMeTitle => 'ຍັງບໍ່ມີໃຜຖືກໃຈທ່ານ';

  @override
  String get discoverEmptyWhoLikedMeSubtitle => 'ສ້າງໂປຣໄຟລ໌ທີ່ດີເພື່ອດຶງດູດ';

  @override
  String get discoverEmptyILikedTitle => 'ທ່ານຍັງບໍ່ໄດ້ຖືກໃຈໃຜ';

  @override
  String get discoverEmptyILikedSubtitle =>
      'ຄົ້ນຫາແລ້ວກົດ ♥ ເພື່ອສະແດງຄວາມສົນໃຈ';

  @override
  String get detailPersonalInfo => 'ຂໍ້ມູນຜູ້ໃຫ້ບໍລິການ';

  @override
  String get detailStatAge => 'ອາຍຸ';

  @override
  String get detailStatMemberSince => 'ສະມາຊິກຕັ້ງແຕ່';

  @override
  String get detailStatTier => 'ລະດັບ';

  @override
  String get detailViewPhotos => 'ດູຮູບ';

  @override
  String get detailTapPhotoToExpand => 'ກົດທີ່ຮູບເພື່ອຂະຫຍາຍ';

  @override
  String get detailStatRating => 'ຄະເເນນ';

  @override
  String get detailStatPosts => 'ໂພສ';

  @override
  String get detailStatGifts => 'ຂອງຂວັນ';

  @override
  String get detailStatCount => 'ຈໍານວນ';

  @override
  String get meetupsEntryFromMeetUps => 'ຈາກໜ້ານັດພົບ';

  @override
  String get meetupsEntryFromChat => 'ຈາກ Chat';

  @override
  String get meetupsDayShortSun => 'ອາ';

  @override
  String get meetupsDayShortMon => 'ຈ';

  @override
  String get meetupsDayShortTue => 'ອ';

  @override
  String get meetupsDayShortWed => 'ພ';

  @override
  String get meetupsDayShortThu => 'ພຫ';

  @override
  String get meetupsDayShortFri => 'ສຸ';

  @override
  String get meetupsDayShortSat => 'ສ';

  @override
  String get meetupsClockSuffix => 'ໂມງ';

  @override
  String meetupsCountdownDays(int days, int hours) {
    return 'ເຫຼືອອີກ $days ວັນ $hours ຊ.ມ.';
  }

  @override
  String meetupsCountdownHours(int hours) {
    return 'ເຫຼືອອີກ $hours ຊ.ມ.';
  }

  @override
  String meetupsCountdownMinutes(int minutes) {
    return 'ເຫຼືອ $minutes ນາທີ';
  }

  @override
  String meetupsServiceMultiplier(String name, int n, String unit) {
    return '$name × $n $unit';
  }

  @override
  String get meetupsUnitDays => 'ວັນ';

  @override
  String get meetupsUnitHours => 'ຊົ່ວໂມງ';

  @override
  String get meetupsServiceFallback => 'ບໍລິການ';

  @override
  String get meetupsStepCreateBooking => 'ສ້າງການຈອງ';

  @override
  String get meetupsStepWaitCompanionConfirm => 'ລໍຖ້າ Companion ຢືນຢັນ';

  @override
  String get meetupsStepCompanionConfirmed => 'Companion ຢືນຢັນ';

  @override
  String get meetupsStepWaitingMeetup => 'ລໍຖ້ານັດພົບ';

  @override
  String get meetupsStepInProgress => 'ກຳລັງດຳເນີນ';

  @override
  String get meetupsStepWaitingConfirmation => 'ລໍຢືນຢັນ';

  @override
  String get meetupsStepMeetingUp => 'ດຳເນີນນັດພົບ';

  @override
  String get meetupsStepCompleted => 'ສຳເລັດ';

  @override
  String get meetupsStepCancelled => 'ຍົກເລີກ';

  @override
  String get meetupsStepRejected => 'ຖືກປະຕິເສດ';

  @override
  String get meetupsStepDisputed => 'ຂໍ້ຂັດແຍ້ງ';

  @override
  String get meetupsCantLoadData => 'ບໍ່ສາມາດໂຫຼດຂໍ້ມູນ';

  @override
  String get meetupsCantPerform => 'ບໍ່ສາມາດດຳເນີນການໄດ້';

  @override
  String get meetupsSectionDateTime => 'ວັນທີ ແລະ ເວລາ';

  @override
  String get meetupsSectionLocation => 'ສະຖານທີ່ນັດພົບ';

  @override
  String get meetupsSectionServices => 'ບໍລິການ';

  @override
  String get meetupsMapLink => 'ແຜນທີ່ ›';

  @override
  String get meetupsPriceSummary => 'ສະຫຼຸບລາຄາ';

  @override
  String get meetupsPriceTotal => 'ລວມທັງໝົດ';

  @override
  String get meetupsYourReview => 'ຄຳຕິຊົມຂອງທ່ານ';

  @override
  String meetupsYouRated(String name) {
    return 'ທ່ານໃຫ້ຄະແນນ $name';
  }

  @override
  String get meetupsProgress => 'ຄວາມຄືບໜ້າ';

  @override
  String get meetupsCancellationPolicy => 'ນະໂຍບາຍຍົກເລີກ';

  @override
  String get meetupsCancelBefore => 'ຍົກເລີກກ່ອນ ';

  @override
  String get meetupsWillRefund => ' ຈະໄດ້ຄືນ ';

  @override
  String get meetupsWithin24h => ' ພາຍໃນ 24 ຊ.ມ.';

  @override
  String get meetupsActionMessage => 'ຂໍ້ຄວາມ';

  @override
  String get meetupsActionCall => 'ໂທ';

  @override
  String get meetupsActionCancel => 'ຍົກເລີກ';

  @override
  String get meetupsActionShare => 'ແຊຣ໌';

  @override
  String get meetupsActionReport => 'ລາຍງານ';

  @override
  String get meetupsActionConfirmShort => 'ຢືນຢັນ';

  @override
  String get meetupsSnackPleaseTitle => 'ກະລຸນາ';

  @override
  String get loginRoleCustomerLabel => 'ຜູ້ຈອງ';

  @override
  String get loginRoleCustomerSub => 'ຄົ້ນຫາ ແລະ ຈອງບໍລິການ';

  @override
  String get loginRoleCompanionLabel => 'ຜູ້ໃຫ້ບໍລິການ';

  @override
  String get loginRoleCompanionSub => 'ໂພສບໍລິການ ແລະ ຮັບການຈອງ';

  @override
  String get forgotTitle => 'ລືມລະຫັດຜ່ານ';

  @override
  String get forgotEnterRegistered => 'ໃສ່ເບີໂທທີ່ລົງທະບຽນ';

  @override
  String get forgotOtpWillSendHere => 'ລະຫັດ OTP ຈະຖືກສົ່ງໄປຫາເບີນີ້';

  @override
  String get forgotSendOtp => 'ສົ່ງລະຫັດ OTP';

  @override
  String get forgotBackToLogin => 'ກັບຄືນໜ້າເຂົ້າສູ່ລະບົບ';

  @override
  String get forgotIdentityVerifyTitle => 'ຢືນຢັນຕົວຕົນ';

  @override
  String get forgotSetNewPasswordTitle => 'ຕັ້ງລະຫັດຜ່ານໃໝ່';

  @override
  String get forgotSetNewPasswordSubtitle => 'ຕັ້ງລະຫັດຜ່ານໃໝ່ທີ່ປອດໄພ';

  @override
  String get forgotSavePassword => 'ບັນທຶກລະຫັດຜ່ານ';

  @override
  String get forgotStepPhone => 'ໂທລະສັບ';

  @override
  String get forgotConfirmPassword => 'ຢືນຢັນລະຫັດຜ່ານ';

  @override
  String get feedbackTitle => 'ຄຳຕິຊົມ';

  @override
  String get feedbackSubtitle => 'ສົ່ງຄຳຄິດເຫັນ ຫຼື ລາຍງານບັນຫາ';

  @override
  String get feedbackSendNew => 'ສົ່ງຄຳຕິຊົມໃໝ່';

  @override
  String get feedbackMine => 'ຄຳຕິຊົມຂອງຂ້ອຍ';

  @override
  String get feedbackTypeLabel => 'ປະເພດ';

  @override
  String get feedbackTypeHint => 'ເລືອກປະເພດຄຳຕິຊົມ';

  @override
  String get feedbackSubjectLabel => 'ຫົວຂໍ້';

  @override
  String get feedbackSubjectHint => 'ໃສ່ຫົວຂໍ້ຄຳຕິຊົມ...';

  @override
  String get feedbackDescLabel => 'ລາຍລະອຽດ';

  @override
  String get feedbackDescHint => 'ອະທິບາຍລາຍລະອຽດເພີ່ມເຕີມ...';

  @override
  String get feedbackDescMinLength => 'ກະລຸນາໃສ່ລາຍລະອຽດຢ່າງໜ້ອຍ 10 ຕົວອັກສອນ';

  @override
  String get feedbackSubmit => 'ສົ່ງຄຳຕິຊົມ';

  @override
  String get feedbackSubmitFailed => 'ສົ່ງຄຳຕິຊົມບໍ່ສຳເລັດ';

  @override
  String get feedbackEmptyTitle => 'ຍັງບໍ່ມີຄຳຕິຊົມ';

  @override
  String get feedbackEmptySubtitle => 'ສົ່ງຄຳຕິຊົມຂອງທ່ານດ້ານເທິງ';

  @override
  String get feedbackStatusResolved => 'ແກ້ໄຂແລ້ວ';

  @override
  String get feedbackTypeBug => 'ຂໍ້ຜິດພາດ (Bug)';

  @override
  String get feedbackTypeFeature => 'ຂໍ້ສະເໜີ (Feature)';

  @override
  String get feedbackTypeGeneral => 'ທົ່ວໄປ (General)';

  @override
  String get feedbackTypePayment => 'ບັນຫາການຊຳລະ (Payment)';

  @override
  String get feedbackTypePerformance => 'ປະສິດທິພາບ (Performance)';

  @override
  String get feedbackTypeOther => 'ອື່ນໆ (Other)';

  @override
  String get dashboardTabChat => 'ຄູ່ເເຊັດ';

  @override
  String get dashboardTabPosts => 'ໂພສຫາຄູ່';

  @override
  String get reviewRatingRequired => 'ກະລຸນາໃຫ້ຄະແນນ';

  @override
  String get reviewTextRequired => 'ກະລຸນາຂຽນລີວິວ';

  @override
  String get reviewSubmitSuccess => 'ສົ່ງລີວິວສຳເລັດ';

  @override
  String get reviewSubmitFailed => 'ສົ່ງລີວິວບໍ່ສຳເລັດ';

  @override
  String get reviewWriteTitle => 'ຂຽນລີວິວ';

  @override
  String reviewForCompanion(String name) {
    return 'ສຳລັບ $name';
  }

  @override
  String get reviewGiveRating => 'ໃຫ້ຄະແນນ';

  @override
  String get reviewSubjectLabel => 'ຫົວຂໍ້ (ທາງເລືອກ)';

  @override
  String get reviewSubjectHint => 'ໃສ່ຫົວຂໍ້ລີວິວ...';

  @override
  String get reviewYourReview => 'ລີວິວຂອງທ່ານ';

  @override
  String get reviewShareHint => 'ແບ່ງປັນປະສົບການຂອງທ່ານ...';

  @override
  String get reviewSubmit => 'ສົ່ງລີວິວ';

  @override
  String get reviewRatingBad => 'ບໍ່ດີ';

  @override
  String get reviewRatingOk => 'ພໍໃຊ້ໄດ້';

  @override
  String get reviewRatingGood => 'ດີ';

  @override
  String get reviewRatingVeryGood => 'ດີຫຼາຍ';

  @override
  String get reviewRatingExcellent => 'ດີເລີດ!';

  @override
  String get reviewRatingPick => 'ເລືອກຄະແນນ';

  @override
  String get cpRatingsSection => 'ຄະແນນ ແລະ ລີວິວ';

  @override
  String get cpStatusAvailable => 'ຮັບຈອງ';

  @override
  String get cpStatusUnavailable => 'ບໍ່ຮັບຈອງ';

  @override
  String get cpStatusLabel => 'ການຈອງ';

  @override
  String get cpNoServicesNow => 'ບໍ່ມີບໍລິການໃນຂະນະນີ້';

  @override
  String get cpNoReviewsBeFirst => 'ຍັງບໍ່ມີລີວິວ ເປັນຄົນທຳອິດ!';

  @override
  String get cpLoadMoreReviews => 'ໂຫຼດລີວິວເພີ່ມ';

  @override
  String cpReviewsCount(int count) {
    return '$count ລີວິວ';
  }

  @override
  String get cpOnline => 'ອອນລາຍ';

  @override
  String get cpStatReviews => 'ລີວິວ';

  @override
  String get cpStatFollowers => 'ຕິດຕາມ';

  @override
  String get cpAnonymous => 'ນິລະນາມ';

  @override
  String get cpBookNow => 'ຈອງດຽວນີ້';

  @override
  String get chatTitle => 'ສົນທະນາ';

  @override
  String chatNewMessages(int count) {
    return '$count ຂໍ້ຄວາມໃໝ່';
  }

  @override
  String get chatSearchHint => 'ຄົ້ນຫາ...';

  @override
  String get chatFallbackName => 'ການສົນທະນານີ້';

  @override
  String get chatDeleteConvTitle => 'ລຶບການສົນທະນາ';

  @override
  String chatDeleteConvMessage(String name) {
    return 'ລຶບການສົນທະນາກັບ $name?\nຂໍ້ຄວາມຍັງສາມາດເຫັນໄດ້ຈາກອີກຝ່າຍ';
  }

  @override
  String get chatCantEnter => 'ບໍ່ສາມາດເຂົ້າໄດ້';

  @override
  String get chatBlockedByYou => 'ທ່ານໄດ້ບລັອກການສົນທະນານີ້';

  @override
  String get chatBlockedByOther => 'ການສົນທະນານີ້ຖືກບລັອກ';

  @override
  String chatUnblockName(String name) {
    return 'ຍົກເລີກການບລັອກ $name';
  }

  @override
  String chatBlockName(String name) {
    return 'ບລັອກ $name';
  }

  @override
  String get chatUnblockConfirmMsg => 'ຍົກເລີກການບລັອກ ແລະ ສືບຕໍ່ສົນທະນາ?';

  @override
  String chatBlockConfirmMsg(String name) {
    return 'ທ່ານ ແລະ $name ຈະບໍ່ສາມາດສົ່ງຂໍ້ຄວາມຫາກັນໄດ້';
  }

  @override
  String get chatUnblock => 'ຍົກເລີກການບລັອກ';

  @override
  String get chatBlock => 'ບລັອກ';

  @override
  String get chatEmpty => 'ບໍ່ພົບການສົນທະນາ';

  @override
  String get chatConversationBlocked => 'ການສົນທະນາຖືກບລັອກ';

  @override
  String get chatTyping => 'ກຳລັງພິມ...';

  @override
  String get chatOffline => 'ອອຟລາຍ';

  @override
  String get chatSelectedImage => 'ຮູບພາບທີ່ເລືອກ';

  @override
  String get chatInputHint => 'ພິມຂໍ້ຄວາມ...';

  @override
  String get chatSendFailed => 'ສົ່ງບໍ່ສຳເລັດ';

  @override
  String get chatSendPleaseRetry => 'ກະລຸນາລອງໃໝ່';

  @override
  String get chatDateToday => 'ມື້ນີ້';

  @override
  String get chatDeleteMsgTitle => 'ລຶບຂໍ້ຄວາມ';

  @override
  String get chatDeleteMsgBody =>
      'ຂໍ້ຄວາມຈະຖືກລຶບອອກຈາກຝ່າຍຂອງທ່ານເທົ່ານັ້ນ\nອີກຝ່າຍຍັງສາມາດເຫັນຂໍ້ຄວາມໄດ້';

  @override
  String get chatImagePrefix => '📷 ຮູບພາບ';

  @override
  String get bookingLabelDate => 'ວັນທີ';

  @override
  String get bookingHoursCount => 'ຈຳນວນຮອບ';

  @override
  String bookingHoursValue(int hours) {
    return '$hours ຮອບ';
  }

  @override
  String bookingHoursShortValue(int hours) {
    return '$hours ຮ.';
  }

  @override
  String get bookingTotalPriceShort => 'ລາຄາລວມ';

  @override
  String get bookingGoToMeetups => 'ໄປໜ້າການນັດພົບ';

  @override
  String get bookingSuccessTitle => 'ຈອງສຳເລັດ!';

  @override
  String get bookingSuccessBody => 'ການຈອງຂອງທ່ານໄດ້ຖືກຮັບແລ້ວ';

  @override
  String get bookingUnitNight => 'ຄືນ';

  @override
  String get bookingDateDeparture => 'ວັນທີອອກເດີນທາງ';

  @override
  String get bookingDateReturn => 'ວັນທີກັບມາ';

  @override
  String get bookingDatePlaceholder => 'ວັນ/ເດືອນ/ປີ';

  @override
  String get bookingLocationHint => 'ໃສ່ທີ່ຢູ່ ຫຼື ສະຖານທີ່...';

  @override
  String get bookingAttireLabel => 'ການແຕ່ງກາຍທີ່ຕ້ອງການ';

  @override
  String get bookingAttireHint => 'ຕົວຢ່າງ: ແຕ່ງຕົວເຊັກຊີ(ທາງເລືອກ)';

  @override
  String get bookingTipService => 'ທິບ / ບໍລິການ';

  @override
  String bookingAddTipTo(String name) {
    return 'ເພີ່ມທິບໃຫ້ $name';
  }

  @override
  String bookingRatePerUnit(String rate, String unit) {
    return '$rate ກີບ / $unit';
  }

  @override
  String bookingRatePerHour(String rate) {
    return '$rate ກີບ / ຮອບ';
  }

  @override
  String bookingRatePerHourShort(String rate) {
    return '$rate ກີບ / ຮ.';
  }

  @override
  String bookingCountUnit(String unit) {
    return 'ຈຳນວນ$unit';
  }

  @override
  String get bookingSelectTime => 'ເລືອກເວລາ';

  @override
  String get bookingSlotBooked => 'ຈອງແລ້ວ';

  @override
  String get bookingSelectMassageType => 'ເລືອກປະເພດນວດ';

  @override
  String bookingVariantsCount(int count) {
    return '$count ປະເພດ';
  }

  @override
  String get bookingDateAppointment => 'ວັນທີນັດໝາຍ';

  @override
  String get bookingTimeMeeting => 'ເວລາພົບກັນ';

  @override
  String get bookingTimeFormat => 'ຊົ່ວໂມງ:ນາທີ';

  @override
  String get bookingSelectPlaceholder => 'ເລືອກ';

  @override
  String get bookingMassageTypeLabel => 'ປະເພດນວດ';

  @override
  String get bookingSelectVariant => 'ເລືອກປະເພດ';

  @override
  String get bookingCreationFailed => 'ການຈອງລົ້ມເຫຼວ';

  @override
  String get shareTitle => 'ແນະນຳໝູ່';

  @override
  String get shareAppbarSubtitle => 'ແບ່ງປັນລິ້ງ ແລະ ເພີ່ມລາຍຮັບຂອງທ່ານ';

  @override
  String get shareSubtitleGeneral => 'ຮັບ 10,000 ກີບ ຕໍ່ການແນະນຳ';

  @override
  String get shareSubtitleCommission => 'ຮັບຄ່າຄອມມິສຊັນຈາກການແນະນຳ';

  @override
  String get shareTierGeneral => 'ທົ່ວໄປ';

  @override
  String get shareTierSpecial => 'ພິເສດ';

  @override
  String get shareTierPartner => 'ພາກຮ່ວມ';

  @override
  String shareTierBadge(String tier) {
    return 'ລະດັບ $tier';
  }

  @override
  String get shareTabModel => 'ລິ້ງແນະນຳໂມເດວ';

  @override
  String get shareTabCustomer => 'ລິ້ງແນະນຳລູກຄ້າ';

  @override
  String get shareLinkModelDesc => 'ແບ່ງປັນລິ້ງນີ້ໃຫ້ໝູ່ທີ່ຢາກເປັນໂມເດວ';

  @override
  String get shareLinkCustomerDesc => 'ແບ່ງປັນລິ້ງນີ້ໃຫ້ລູກຄ້າສະໝັກ';

  @override
  String get shareCopy => 'ຄັດລອກ';

  @override
  String get shareCopied => 'ຄັດລອກແລ້ວ';

  @override
  String get shareShareLink => 'ແບ່ງປັນ';

  @override
  String get shareViewQr => 'QR';

  @override
  String get shareStatsModels => 'ໂມເດວທີ່ແນະນຳ';

  @override
  String get shareStatsCustomers => 'ລູກຄ້າທີ່ແນະນຳ';

  @override
  String get shareStatsCommission => 'ຄ່າຄອມມິສຊັນ';

  @override
  String get shareStatsTotal => 'ລາຍໄດ້ລວມ';

  @override
  String get shareCommissionsTitle => 'ປະຫວັດຄ່າຄອມມິສຊັນ';

  @override
  String get shareCommissionsEmpty => 'ຍັງບໍ່ມີຄ່າຄອມມິສຊັນ';

  @override
  String get shareCommissionsEmptySub =>
      'ຄ່າຄອມມິສຊັນຈາກລູກຄ້າ ຫຼື ໂມເດວທີ່ທ່ານແນະນຳ ຈະສະແດງທີ່ນີ້';

  @override
  String get shareLearnMore => 'ຮຽນຮູ້ເພີ່ມກ່ຽວກັບລະດັບ';

  @override
  String get shareProgressToNext => 'ຄວາມຄືບໜ້າສູ່ລະດັບຕໍ່ໄປ';

  @override
  String shareUpgradeToSpecialRemaining(int n) {
    return 'ອີກ $n ຄົນ ຈຶ່ງໄດ້ລະດັບພິເສດ';
  }

  @override
  String shareUpgradeToPartnerRemainingModels(int n) {
    return 'ອີກ $n ຄົນ ຈຶ່ງໄດ້ລະດັບພາກຮ່ວມ';
  }

  @override
  String shareUpgradeToPartnerRemainingEarnings(String amount) {
    return 'ອີກ $amount ກີບ ຈຶ່ງໄດ້ລະດັບພາກຮ່ວມ';
  }

  @override
  String get shareTierMaxed => 'ທ່ານໄດ້ຮັບລະດັບສູງສຸດແລ້ວ';

  @override
  String get shareCurrentTier => 'ລະດັບປັດຈຸບັນ';

  @override
  String shareEarnPerReferral(String amount) {
    return 'ຮັບ $amount ກີບ/ຄົນ';
  }

  @override
  String get shareInviteMessage => 'ສະໝັກກັບ Xaosao ຜ່ານລິ້ງຂອງຂ້ອຍ!';

  @override
  String get shareInviteSubject => 'ເຂົ້າຮ່ວມ Xaosao';

  @override
  String get appName => 'Xaosao';

  @override
  String bookingThankYouFor(String appName) {
    return 'ຂໍຂອບໃຈທີ່ໃຊ້ບໍລິການຜ່ານ $appName';
  }

  @override
  String bookingSupportContact(String phone) {
    return 'ສອບຖາມເພີ່ມເຕີມ ໂທ $phone';
  }

  @override
  String get shareCommissionReferral => 'ການແນະນຳ';

  @override
  String get shareQrBrandName => 'xaosao — ເຊົ້າສາວ';

  @override
  String get shareQrBrandTagline =>
      'ບ້ານພັກທີ່ລວບລວມນາງ-ສາວທີ່ໂດດ ແລະ ພ້ອມທີ່ຈະບ້ານຢູ່ທ່ານ.';

  @override
  String get shareQrDownload => 'ດາວໂຫຼດ QR';

  @override
  String get shareQrPermissionDenied => 'ກະລຸນາອະນຸຍາດການເຂົ້າເຖິງຄັງຮູບ';

  @override
  String get shareQrSaved => 'ບັນທຶກ QR ລົງຄັງຮູບແລ້ວ';

  @override
  String get shareQrSaveFailed => 'ບໍ່ສາມາດບັນທຶກໄດ້ ກະລຸນາລອງໃໝ່';

  @override
  String get shareQrErrorGeneric => 'ເກີດຂໍ້ຜິດພາດ ກະລຸນາລອງໃໝ່';

  @override
  String get analyticsTitle => 'ການວິເຄາະການແນະນຳ';

  @override
  String get analyticsSubtitle => 'ສະຖິຕິ ແລະ ລາຍໄດ້ຂອງທ່ານ';

  @override
  String get analyticsLoadFailed => 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ';

  @override
  String get analyticsRetry => 'ລອງໃໝ່';

  @override
  String get analyticsReferralStats => 'ສະຖິຕິການແນະນຳ';

  @override
  String get analyticsReferrals => 'ການແນະນຳ';

  @override
  String get analyticsEarnings => 'ລາຍໄດ້';

  @override
  String get analyticsTierProgress => 'ຄວາມຄືບໜ້າລະດັບ';

  @override
  String get analyticsModels => 'ໂມເດວ';

  @override
  String get analyticsCustomers => 'ລູກຄ້າ';

  @override
  String get analyticsBookings => 'ຈອງ';

  @override
  String get analyticsSubscriptions => 'Package';

  @override
  String get analyticsApproved => 'ອະນຸມັດ';

  @override
  String get analyticsPending => 'ລໍຖ້າ';

  @override
  String get analyticsActive => 'ໃຊ້ງານ';

  @override
  String get analyticsInactive => 'ບໍ່ໃຊ້';

  @override
  String get analyticsTotal => 'ທັງໝົດ';

  @override
  String get analyticsTotalEarnings => 'ລາຍໄດ້ທັງໝົດ';

  @override
  String get analyticsModelEarnings => 'ລາຍໄດ້ໂມເດວ';

  @override
  String get analyticsCommission => 'ຄ່ານາຍໜ້າ';

  @override
  String get analyticsEarningsByType => 'ລາຍໄດ້ແຕ່ລະປະເພດ';

  @override
  String get analyticsAllModels => 'ໂມເດວທັງໝົດ';

  @override
  String get analyticsApprovedModels => 'ໂມເດວອະນຸມັດ';

  @override
  String get analyticsAllCustomers => 'ລູກຄ້າທັງໝົດ';

  @override
  String get analyticsActiveCustomers => 'ລູກຄ້າໃຊ້ງານ';

  @override
  String get analyticsReady => 'ພ້ອມແລ້ວ!';

  @override
  String analyticsSpecialCondition(int n) {
    return 'ແນະນຳໂມເດວໃຫ້ຄົບ $n ທ່ານ';
  }

  @override
  String get analyticsPartnerCondition => 'ຕ້ອງການທັງໂມເດວ ແລະ ລາຍໄດ້';

  @override
  String get snackbarErrorTitle => 'ຜິດພາດ';

  @override
  String get snackbarSuccessTitle => 'ສຳເລັດ';

  @override
  String get snackbarInfoTitle => 'ຂໍ້ມູນ';

  @override
  String get qrLoadFailed => 'ໂຫຼດ QR ບໍ່ສຳເລັດ';

  @override
  String get imagePickerTitle => 'ເລືອກຮູບໂປຣໄຟ';

  @override
  String get imagePickerGallery => 'ຄັງຮູບ';

  @override
  String get imagePickerCamera => 'ກ້ອງຖ່າຍຮູບ';

  @override
  String get serviceUnitHour => '/ຮອບ';

  @override
  String get serviceUnitDay => '/ວັນ';

  @override
  String get serviceUnitNight => '/ຄືນ';

  @override
  String get serviceUnitOnce => 'ຄັ້ງດຽວ';

  @override
  String get serviceUnitMinute => '/ນາທີ';

  @override
  String get phoneRequired => 'ກະລຸນາໃສ່ເບີໂທ';

  @override
  String get phoneMustStartWith20 => 'ເບີໂທຕ້ອງເລີ່ມດ້ວຍ 20';

  @override
  String get phonePrefixInvalid => 'ຕ້ອງເປັນ: 202, 205, 206, 207 ຫຼື 209';

  @override
  String phoneLength(int n) {
    return 'ເບີໂທຕ້ອງມີ $n ຕົວເລກ';
  }

  @override
  String get deepLinkShareSelf => 'ມາເບິ່ງໂປຣໄຟລ໌ໃນ Xaosao';

  @override
  String deepLinkShareOther(String name) {
    return 'ມາເບິ່ງໂປຣໄຟລ໌ຂອງ $name ໃນ Xaosao';
  }

  @override
  String get dateToday => 'ມື້ນີ້';

  @override
  String get dateYesterday => 'ມື້ວານ';

  @override
  String get commonSearch => 'ຄົ້ນຫາ...';

  @override
  String get commonPasswordHint => 'ລະຫັດຜ່ານ';

  @override
  String get commonImageLoadFailed => 'ໂຫຼດຮູບບໍ່ໄດ້';

  @override
  String get walletBalanceShort => 'ຍອດກະເປົ໋າ';

  @override
  String get updateRequiredTitle => 'ຈຳເປັນຕ້ອງອັບເດດແອັບ';

  @override
  String get updateAvailableTitle => 'ອັບເດດແອັບໃໝ່ພ້ອມແລ້ວ!';

  @override
  String get updateRequiredBody =>
      'ກະລຸນາອັບເດດເປັນເວີຊັນຫຼ້າສຸດ ເພື່ອສືບຕໍ່ໃຊ້ Xaosao';

  @override
  String get updateAvailableBody =>
      'ພວກເຮົາໄດ້ປັບປຸງແອັບໃຫ້ດີຂຶ້ນ — ອັບເດດເລີຍເພື່ອປະສົບການທີ່ດີທີ່ສຸດ';

  @override
  String get updateNow => 'ອັບເດດດຽວນີ້';

  @override
  String get updateLater => 'ພາຍຫຼັງ';

  @override
  String get updateCurrentVersion => 'ເວີຊັ່ນປັດຈຸບັນ';

  @override
  String get updateNewVersion => 'ເວີຊັ່ນໃໝ່';

  @override
  String get updateWhatsNew => 'ມີຫຍັງໃໝ່';

  @override
  String get giftSheetTitle => '🎁 ສົ່ງຂອງຂວັນ';

  @override
  String giftSheetPickFor(String name) {
    return 'ເລືອກຂອງຂວັນໃຫ້ $name';
  }

  @override
  String get giftEmpty => 'ບໍ່ມີຂອງຂວັນໃນຂະນະນີ້';

  @override
  String get giftPickFirst => 'ເລືອກຂອງຂວັນກ່ອນ';

  @override
  String get giftSendFailed => 'ສ່ງຂອງຂວັນບໍ່ສຳເລັດ';

  @override
  String get giftSendSuccess => 'ສ່ງຂອງຂວັນສຳເລັດ!';

  @override
  String giftSendButton(String name, String price) {
    return 'ສົ່ງ $name · $price';
  }

  @override
  String get tiersTitle => 'ລະດັບ Referral ໂມເດວ';

  @override
  String get tiersSubtitle => 'ຮຽນຮູ້ວິທີການເພີ່ມລາຍໄດ້ຂອງທ່ານ';

  @override
  String get tiersOverview =>
      'ໂຕແຊຣ໌ Referral link ຂອງໂມເດວ ຈະແບ່ງອອກເປັນ 3 ລະດັບ';

  @override
  String get tiersLevel1Title => 'ລະດັບທົ່ວໄປ';

  @override
  String get tiersLevel1Desc =>
      'ສະແດງພຽງແຕ່ລິ້ງແນະນຳໃຫ້ກັບ ໂມເດວ ດ້ວຍກັນເທົ່ານັ້ນ ແລະ ໄດ້ຮັບສະເພາະເງີນແນະນຳ 10,000/ຄົນ (ບໍ່ມີເງື່ອນໄຂໃດໆ ທຸກຄົນທີ່ເປັນໂມເດວສາມາເຮັດໄດ້ໝົດ)';

  @override
  String get tiersLevel2Title => 'ລະດັບພິເສດ';

  @override
  String get tiersLevel2Condition => 'ຕ້ອງມີຜູ້ແນະນຳຫຼາຍກວ່າ 5 ຄົນ';

  @override
  String get tiersLevel2Links =>
      'ຈະມີລິ້ງແນະນຳ 2 ລິ້ງຄື: ລິ້ງແນະນຳລູກຄ້າ ແລະ ລິ້ງແນະນຳໂມເດວດ້ວຍກັນ';

  @override
  String get tiersLevel2Benefit =>
      'ບໍ່ໄດ້ຮັບເງີນ 10,000 ກີບ ແຕ່ຈະໄດ້ຮັບເປັນເປີເຊັນແທນເຊັ່ນ: 20% ຂອງລູກຄ້າຊື້ Wallet Package, 2% ຂອງຜູ້ໃຫ້ບໍລິການທີ່ຕົວເອງແນະນຳເວລາມີຄົນຈອງ';

  @override
  String get tiersLevel3Title => 'ລະດັບພາກຮ່ວມ';

  @override
  String get tiersLevel3Condition =>
      'ຕ້ອງມີຜູ້ແນະນຳຫຼາຍກວ່າ 5 ຄົນຂຶ້ນໄປ ແລະ ລາຍໄດ້ລວມຂອງຄ່າຄອມມິສຊັນທີ່ໄດ້ຈາກ Wallet Package ຂອງລູກຄ້າ ແລະ ລູກຄ້າຈອງຜູ້ໃຫ້ບໍລິການທີ່ແນະນຳ 1,000,000 ກີບ';

  @override
  String get tiersLevel3Links =>
      'ຈະມີລິ້ງແນະນຳ 2 ລິ້ງຄື: ລິ້ງແນະນຳລູກຄ້າ ແລະ ລິ້ງແນະນຳຜູ້ໃຫ້ບໍລິການດ້ວຍກັນ';

  @override
  String get tiersLevel3Benefit =>
      'ບໍ່ໄດ້ຮັບເງີນ 10,000 ກີບ ແຕ່ຈະໄດ້ຮັບເປັນເປີເຊັນແທນເຊັ່ນ: 40% ຂອງລູກຄ້າຊື້ Wallet Package, 4% ຂອງຜູ້ໃຫ້ບໍລິການທີ່ຕົວເອງແນະນຳເວລາມີຄົນຈອງ';

  @override
  String get tiersConditionLabel => 'ເງື່ອນໄຂ';

  @override
  String get tiersBenefitLabel => 'ຜົນປະໂຫຍດທີ່ຈະໄດ້ຮັບ';

  @override
  String get tiersLinksLabel => 'ລິ້ງແນະນຳ';

  @override
  String get tiersCurrentBadge => 'ລະດັບປັດຈຸບັນຂອງທ່ານ';

  @override
  String get tiersLockedNote => 'ຍັງບໍ່ເຖິງລະດັບ';
}
