// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get english => 'English';

  @override
  String get lao => 'ພາສາລາວ';

  @override
  String get thai => 'ภาษาไทย';

  @override
  String get languageTitle => 'ภาษา';

  @override
  String get languageSubtitle => 'เลือกภาษาที่คุณต้องการใช้';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonOk => 'ตกลง';

  @override
  String get commonSave => 'บันทึก';

  @override
  String get commonClose => 'ปิด';

  @override
  String get commonLater => 'ภายหลัง';

  @override
  String get commonSuccess => 'สำเร็จ';

  @override
  String get commonError => 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  @override
  String get commonDelete => 'ลบ';

  @override
  String get commonBack => 'ย้อนกลับ';

  @override
  String get commonYes => 'ใช่';

  @override
  String get commonNo => 'ไม่';

  @override
  String get profileInfoSection => 'ข้อมูล';

  @override
  String get profileSecuritySection => 'ความปลอดภัย';

  @override
  String get profileSettingsSection => 'ตั้งค่า';

  @override
  String get profileHelpSection => 'ช่วยเหลือ';

  @override
  String get profilePersonalInfo => 'ข้อมูลส่วนตัว';

  @override
  String get profilePersonalInfoSubtitle => 'ชื่อ, นามสกุล, วันเดือนปีเกิด';

  @override
  String get profileFinance => 'ข้อมูลทางการเงิน';

  @override
  String get profileFinanceSubtitle => 'บัญชีเงิน, บัตรเครดิต, การโอนเงิน';

  @override
  String get profileChangePassword => 'เปลี่ยนรหัสผ่าน';

  @override
  String get profileVerifyPhone => 'ยืนยันเบอร์โทร';

  @override
  String get profileVerifiedBadge => 'ยืนยันแล้ว';

  @override
  String get profileVerifiedIdentity => 'ยืนยันตัวตนแล้ว';

  @override
  String get profileLanguage => 'ภาษา';

  @override
  String get profileNotifications => 'การแจ้งเตือน';

  @override
  String get profileNotificationsSubtitle => 'Push, อีเมล, SMS, WhatsApp';

  @override
  String get profileHelpFaq => 'ช่วยเหลือ / FAQ';

  @override
  String get profileFeedback => 'คำติชม';

  @override
  String get profileFeedbackSubtitle => 'รายงานปัญหา หรือ ส่งความคิดเห็น';

  @override
  String get profileTerms => 'ข้อกำหนดและนโยบาย';

  @override
  String get profileDeleteAccount => 'ลบบัญชี';

  @override
  String get profileDeleteAccountSubtitle =>
      'การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get profileDeleteAccountShortSubtitle => 'ไม่สามารถย้อนกลับได้';

  @override
  String get profileLogout => 'ออกจากระบบ';

  @override
  String profileAppVersion(String version) {
    return 'XAOSAO v$version';
  }

  @override
  String get profilePhotos => 'รูปภาพ';

  @override
  String profilePhotosCount(int count, int max) {
    return 'รูปภาพ ($count/$max)';
  }

  @override
  String profilePhotosMissingWarning(int max, int missing) {
    return 'ต้องเพิ่มให้ครบ $max รูป — ยังขาดอีก $missing รูป';
  }

  @override
  String get profileMyServices => 'บริการของฉัน';

  @override
  String get profileMyQr => 'QR ของฉัน';

  @override
  String get profileStatLikes => 'ถูกใจ';

  @override
  String get profileStatFriends => 'เพื่อน';

  @override
  String get profileStatReferrals => 'แนะนำ';

  @override
  String get profileStatBookings => 'จอง';

  @override
  String get profileHiddenEnabled =>
      'โปรไฟล์ของคุณถูกซ่อนอยู่ — ลูกค้าไม่สามารถเห็นคุณได้';

  @override
  String get profileHiddenDisabled =>
      'ซ่อนโปรไฟล์ของคุณไม่ให้ลูกค้าเห็น สามารถเปิด-ปิดได้ตลอดเวลา';

  @override
  String get customerProfileBuyPackage => 'ซื้อแพ็กเกจ';

  @override
  String get customerProfileBuyPackageSubtitle =>
      'รายชั่วโมง, รายวัน และรายเดือน';

  @override
  String get customerProfileTopupHistory => 'ประวัติเติมเงิน';

  @override
  String get walletBalanceTitle => 'ยอดคงเหลือในกระเป๋า';

  @override
  String get walletTopup => 'เติมเงิน';

  @override
  String get walletHistory => 'ประวัติ';

  @override
  String get confirmLogoutTitle => 'ออกจากระบบ';

  @override
  String get confirmLogoutMessage => 'คุณต้องการออกจากระบบใช่หรือไม่?';

  @override
  String get confirmLogoutConfirm => 'ออก';

  @override
  String get confirmDeleteTitle => 'ลบบัญชี';

  @override
  String get confirmDeleteMessage =>
      'คุณแน่ใจหรือไม่ที่ต้องการลบบัญชี?\nข้อมูลทั้งหมดจะถูกลบถาวรและไม่สามารถกู้คืนได้';

  @override
  String get commonGenericError => 'เกิดข้อผิดพลาด! กรุณาลองใหม่อีกครั้ง';

  @override
  String get commonActionFailed => 'ไม่สามารถดำเนินการได้';

  @override
  String get commonLoadDataFailed => 'โหลดข้อมูลไม่สำเร็จ';

  @override
  String get commonAddFailed => 'เพิ่มไม่สำเร็จ';

  @override
  String get commonUpdateFailed => 'อัปเดตไม่สำเร็จ';

  @override
  String get commonDeleteFailed => 'ลบไม่สำเร็จ';

  @override
  String get loginFailed => 'เข้าสู่ระบบไม่สำเร็จ';

  @override
  String get registerLoadServicesFailed => 'โหลดบริการไม่สำเร็จ';

  @override
  String get registerSelectProfilePhoto => 'กรุณาเลือกรูปโปรไฟล์';

  @override
  String get registerFailed => 'ลงทะเบียนไม่สำเร็จ';

  @override
  String get registerInvalidOtp => 'OTP ไม่ถูกต้อง';

  @override
  String get registerSuccess => 'ลงทะเบียนสำเร็จแล้ว';

  @override
  String get registerVerifyOtpFailed => 'ตรวจสอบ OTP ไม่สำเร็จ';

  @override
  String get registerResendOtpFailed => 'ส่ง OTP ใหม่ไม่สำเร็จ';

  @override
  String get registerResendOtpSuccess => 'ส่งรหัส OTP ใหม่แล้ว';

  @override
  String get meetUpsCancelSuccess => 'ยกเลิกการจองสำเร็จ';

  @override
  String get meetUpsReleasePaymentSuccess => 'ปล่อยเงินสำเร็จ';

  @override
  String get meetUpsDisputeSuccess => 'ส่งคำร้องขอสำเร็จ';

  @override
  String get meetUpsConfirmSuccess => 'ยืนยันการจองสำเร็จ';

  @override
  String get meetUpsRejectSuccess => 'ปฏิเสธการจองสำเร็จ';

  @override
  String get meetUpsReceiveMoneySuccess => 'รับเงินสำเร็จ';

  @override
  String get meetUpsDeleteSuccess => 'ลบรายการสำเร็จ';

  @override
  String get postsFeedLoadFailed => 'โหลดฟีดไม่สำเร็จ';

  @override
  String get postsMyLoadFailed => 'โหลดโพสต์ของฉันไม่สำเร็จ';

  @override
  String get postsCreateSuccess => 'สร้างโพสต์สำเร็จ';

  @override
  String get postsCreateFailed => 'สร้างโพสต์ไม่สำเร็จ';

  @override
  String get postsDisableSuccess => 'ปิดใช้งานโพสต์สำเร็จ';

  @override
  String get postsDisableFailed => 'ปิดใช้งานโพสต์ไม่สำเร็จ';

  @override
  String get postsDeleteSuccess => 'ลบโพสต์สำเร็จ';

  @override
  String get postsDeleteFailed => 'ลบโพสต์ไม่สำเร็จ';

  @override
  String get authWelcome => 'ยินดีต้อนรับ 👋';

  @override
  String get authRolePrompt => 'คุณต้องการเข้าใช้งานในฐานะใด?';

  @override
  String get authTagline => 'เพื่อนคู่ใจ ทุกที่ ทุกเวลา';

  @override
  String get authRoleCustomer => 'ลูกค้า';

  @override
  String get authRoleCompanion => 'Companion';

  @override
  String get authFieldPhone => 'เบอร์โทรศัพท์';

  @override
  String get authFieldPassword => 'รหัสผ่าน';

  @override
  String get authHintPassword => 'รหัสผ่าน';

  @override
  String get authForgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get authNoAccount => 'ยังไม่มีบัญชี?';

  @override
  String get authLoginButton => 'เข้าสู่ระบบ';

  @override
  String get authCreateCustomerAccount => 'สร้างบัญชีลูกค้า';

  @override
  String get authCreateCompanionAccount => 'สร้างบัญชี Companion';

  @override
  String get authValidPhoneRequired => 'กรุณาใส่เบอร์โทรศัพท์ให้ถูกต้อง';

  @override
  String get authPasswordRequired => 'กรุณาใส่รหัสผ่าน';

  @override
  String get commonCurrencyKip => 'กีบ';

  @override
  String get monthShortJan => 'ม.ค.';

  @override
  String get monthShortFeb => 'ก.พ.';

  @override
  String get monthShortMar => 'มี.ค.';

  @override
  String get monthShortApr => 'เม.ย.';

  @override
  String get monthShortMay => 'พ.ค.';

  @override
  String get monthShortJun => 'มิ.ย.';

  @override
  String get monthShortJul => 'ก.ค.';

  @override
  String get monthShortAug => 'ส.ค.';

  @override
  String get monthShortSep => 'ก.ย.';

  @override
  String get monthShortOct => 'ต.ค.';

  @override
  String get monthShortNov => 'พ.ย.';

  @override
  String get monthShortDec => 'ธ.ค.';

  @override
  String get walletTitle => 'กระเป๋าเงิน';

  @override
  String get walletSubtitle => 'ยอดคงเหลือและประวัติ';

  @override
  String get walletFilterAll => 'ทั้งหมด';

  @override
  String get walletFilterPending => 'รออนุมัติ';

  @override
  String get walletFilterApproved => 'สำเร็จแล้ว';

  @override
  String get walletFilterRejected => 'ยกเลิกแล้ว';

  @override
  String get walletRechargeHistory => 'ประวัติการเติม';

  @override
  String get walletEmptyTitle => 'ยังไม่มีรายการ';

  @override
  String get walletEmptySubtitle => 'รายการเติมเงินของคุณ\nจะแสดงที่นี่';

  @override
  String get walletTxStatusCompleted => 'สำเร็จ';

  @override
  String get walletTxStatusPending => 'รอดำเนินการ';

  @override
  String get walletTxStatusProcessing => 'กำลังดำเนินการ';

  @override
  String get walletTxStatusCancelled => 'ยกเลิก';

  @override
  String walletBalanceUpdated(String time) {
    return 'ยอดคงเหลือ อัปเดต $time';
  }

  @override
  String get walletUsed => 'ใช้ไปแล้ว';

  @override
  String get walletTxTypeRecharge => 'เติมเงิน';

  @override
  String get walletTxTypeSubscription => 'ซื้อแพ็กเกจ';

  @override
  String get walletTxTypeGift => 'ส่งของขวัญ';

  @override
  String get walletTxTypeBookingHold => 'ฝากชำระการจอง';

  @override
  String get walletTxTypeBookingRefund => 'คืนเงินการจอง';

  @override
  String get walletTxTypeGiftEarning => 'รับของขวัญ';

  @override
  String get walletTxTypeBookingEarning => 'รับเงินจากการจอง';

  @override
  String get walletTxTypeWithdrawal => 'ถอนเงิน';

  @override
  String get walletTxTypeReferral => 'ค่านายหน้า';

  @override
  String get walletTxTypeBookingReferral => 'ค่านายหน้า (การจอง)';

  @override
  String get walletTxTypeSubscriptionReferral => 'ค่านายหน้า (แพ็กเกจ)';

  @override
  String get walletTxTypeGeneric => 'ธุรกรรม';

  @override
  String get commonNext => 'ถัดไป';

  @override
  String get commonAmount => 'จำนวน';

  @override
  String get commonDate => 'วันที่';

  @override
  String commonErrorDetail(String error) {
    return 'เกิดข้อผิดพลาด: $error';
  }

  @override
  String get topupAmountSubtitle => 'เลือกหรือใส่จำนวน';

  @override
  String get topupOther => 'อื่นๆ';

  @override
  String get topupCustomAmount => 'กำหนดเอง';

  @override
  String get topupOrEnterYourself => 'หรือใส่เอง';

  @override
  String get topupEnterAmount => 'ใส่จำนวน';

  @override
  String get topupQrLoadFailed => 'ไม่สามารถโหลด QR ได้';

  @override
  String get topupPackageFailed => 'ซื้อแพ็กเกจไม่สำเร็จ';

  @override
  String get topupSlipUploadFailed => 'ไม่สามารถส่งใบชำระได้';

  @override
  String get topupUploadTitle => 'อัปโหลดสลิป';

  @override
  String get topupUploadSubtitle => 'ยืนยันการชำระ';

  @override
  String get topupUploadFileTypes => 'รองรับ: JPG, PNG, PDF (สูงสุด 10MB)';

  @override
  String get topupUploadSubmit => 'ส่งและยืนยัน';

  @override
  String get topupUploadReceipt => 'อัปโหลดใบเสร็จการชำระ';

  @override
  String get topupUploadReceiptSubtitle => 'สามารถอัปโหลดใบยืนยันได้ที่นี่';

  @override
  String get topupSelectFile => 'เลือกไฟล์';

  @override
  String get topupAddMoreSlip => 'เพิ่มสลิปอีก';

  @override
  String get topupExampleReceipt => 'ตัวอย่างใบเสร็จการชำระ';

  @override
  String get topupThankYouMessage =>
      'ขอบคุณที่ไว้วางใจ: ทีมงานจะตรวจสอบและดำเนินการภายใน 1–2 ชั่วโมง แล้วจะได้รับใบยืนยัน';

  @override
  String get topupBackToWallet => 'กลับหน้ากระเป๋า';

  @override
  String get topupSuccessTitle => 'เติมสำเร็จ!';

  @override
  String get topupSuccessSubtitle => 'กำลังรอการตรวจสอบจาก Admin';

  @override
  String get topupWaitingReview => 'รอการตรวจสอบ';

  @override
  String get topupQrTitle => 'สแกน QR';

  @override
  String get topupQrSubtitle => 'ชำระผ่านแอปธนาคาร';

  @override
  String get topupQrPaidUploadSlip => 'ชำระแล้ว — อัปสลิป';

  @override
  String get topupQrAmountToPay => 'จำนวนที่ต้องชำระ';

  @override
  String get topupQrInstructions =>
      'สแกน QR ด้วยแอปธนาคาร\nจากนั้นกด \"ชำระแล้ว\" เพื่ออัปสลิป';

  @override
  String get topupQrSaving => 'กำลังบันทึก...';

  @override
  String get topupQrDownload => 'ดาวน์โหลด QR';

  @override
  String get commonAll => 'ทั้งหมด';

  @override
  String get commonRetry => 'ลองใหม่';

  @override
  String get commonPleaseRetry => 'กรุณาลองใหม่อีกครั้ง';

  @override
  String get serviceTypeSocial => 'สังคม';

  @override
  String get serviceTypeMassage => 'นวด';

  @override
  String get serviceTypeTravel => 'ท่องเที่ยว';

  @override
  String get viewCompanionPageTitle => 'ทั้งหมด';

  @override
  String get viewCompanionFilterLikedByMe => 'ที่ฉันไลค์';

  @override
  String get viewCompanionFilterWhoLikedMe => 'ไลค์ฉัน';

  @override
  String get viewCompanionFilterNearby => 'ใกล้ฉัน';

  @override
  String get viewCompanionFilterNew => 'ใหม่';

  @override
  String get viewCompanionFilterPopular => 'ยอดนิยม';

  @override
  String get viewCompanionEmptyTitle => 'ไม่พบข้อมูล';

  @override
  String get viewCompanionEmptySubtitle => 'ลองเปลี่ยนตัวกรองหรือค้นหาใหม่';

  @override
  String get viewCompanionSearchHint => 'ค้นหาชื่อ...';

  @override
  String get genderMale => 'ผู้ชาย';

  @override
  String get genderFemale => 'ผู้หญิง';

  @override
  String get homeSearch => 'ค้นหา';

  @override
  String get homeFindCompanion => 'ค้นหาเพื่อนคู่ใจของคุณ';

  @override
  String get homeSearchHint => 'ค้นหาด้วยชื่อ...';

  @override
  String get homeOnlineNow => 'กำลังออนไลน์';

  @override
  String get homeRecommended => 'แนะนำสำหรับคุณ';

  @override
  String get homeSeeAll => 'ดูทั้งหมด';

  @override
  String get homeNoResults => 'ไม่พบผลลัพธ์';

  @override
  String get homeTryFilter => 'ลองเปลี่ยนตัวกรองใหม่';

  @override
  String get homeFilters => 'ตัวกรอง';

  @override
  String get homeMaxDistance => 'ระยะทางสูงสุด';

  @override
  String get homeApplyFilter => 'ใช้ตัวกรอง';

  @override
  String get homeFilterNearby => 'ใกล้เคียง';

  @override
  String get homeServiceSocial => 'เพื่อนสังคม';

  @override
  String get homeServiceTravel => 'ท่องเที่ยว';

  @override
  String get homeCardSubtitleSocial => 'เที่ยว งานเลี้ยง ทุกโอกาส';

  @override
  String get homeCardSubtitleMassage => 'นวดสุขภาพโดยมืออาชีพ';

  @override
  String get homeCardSubtitleTravel => 'ไกด์ในและต่างประเทศ';

  @override
  String get homeLoadRecommendationsFailed => 'โหลดข้อมูลแนะนำไม่สำเร็จ';

  @override
  String get homeLoadOnlineFailed => 'โหลดข้อมูลออนไลน์ไม่สำเร็จ';

  @override
  String commonAgeYears(int years) {
    return '$years ปี';
  }

  @override
  String commonHours(int hours) {
    return '$hours ชม.';
  }

  @override
  String commonDays(int days) {
    return '$days วัน';
  }

  @override
  String get commonConfirm => 'ยืนยัน';

  @override
  String get commonPleaseTitle => 'กรุณา';

  @override
  String get bookingStatusConfirmed => 'ยืนยัน';

  @override
  String get bookingStatusConfirmedShort => 'รับแล้ว';

  @override
  String get bookingStatusInProgress => 'กำลังดำเนินการ';

  @override
  String get bookingStatusAwaitingConfirmation => 'รอยืนยัน';

  @override
  String get bookingStatusAwaitingConfirmationShort => 'รอรับยืนยัน';

  @override
  String get bookingStatusCompletedFull => 'สำเร็จแล้ว';

  @override
  String get bookingStatusCancelledFull => 'ยกเลิกแล้ว';

  @override
  String get bookingStatusRejected => 'ถูกปฏิเสธ';

  @override
  String get bookingStatusDisputed => 'ข้อพิพาท';

  @override
  String get paymentStatusPaid => 'ชำระแล้ว';

  @override
  String get paymentStatusPending => 'รอชำระ';

  @override
  String get paymentStatusReleased => 'ปล่อยเงินแล้ว';

  @override
  String get paymentStatusRefunded => 'คืนเงินแล้ว';

  @override
  String get meetUpsTitle => 'นัดพบ';

  @override
  String get meetUpsAllHistory => 'ประวัติการจองทั้งหมด';

  @override
  String meetUpsItemsWithStatus(int count, String status) {
    return '$count รายการ · $status';
  }

  @override
  String get meetUpsEmptyTitle => 'ไม่มีรายการ';

  @override
  String get meetUpsEmptySubtitle => 'รายการจองของคุณจะแสดงที่นี่';

  @override
  String get meetUpsLoadMore => 'โหลดเพิ่ม';

  @override
  String get bookingDetailTitle => 'รายละเอียดการจอง';

  @override
  String get bookingLocation => 'สถานที่';

  @override
  String get bookingPhone => 'เบอร์โทรศัพท์';

  @override
  String get bookingTip => 'ทิป';

  @override
  String get bookingTipReady => 'เตรียมทิปพร้อม';

  @override
  String get bookingAttire => 'การแต่งกาย';

  @override
  String get bookingId => 'รหัสการจอง';

  @override
  String get bookingCreatedAt => 'เวลาจอง';

  @override
  String get bookingNoName => 'ไม่มีชื่อ';

  @override
  String get bookingTotalPrice => 'ราคารวม';

  @override
  String get bookingActionChat => 'แชท';

  @override
  String get bookingActionReleasePayment => 'ปล่อยเงิน';

  @override
  String get bookingActionRefund => 'คืนเงิน';

  @override
  String get bookingActionReject => 'ปฏิเสธ';

  @override
  String get bookingActionReceiveMoney => 'รับเงิน';

  @override
  String get cancelBookingTitle => 'ยกเลิกการจอง';

  @override
  String get cancelBookingMessage =>
      'คุณต้องการยกเลิกการจองนี้ใช่หรือไม่?\nการยกเลิกนี้ไม่สามารถกู้คืนได้';

  @override
  String get cancelBookingMessageShort =>
      'คุณต้องการยกเลิกการจองนี้ใช่หรือไม่?';

  @override
  String get deleteItemTitle => 'ลบรายการ';

  @override
  String get deleteItemMessage => 'คุณต้องการลบรายการนี้ใช่หรือไม่?';

  @override
  String get refundReasonTitle => 'เหตุผลในการขอคืนเงิน';

  @override
  String get rejectReasonTitle => 'เหตุผลในการปฏิเสธ';

  @override
  String get reasonMinLength => 'เหตุผลต้องมีอย่างน้อย 10 ตัวอักษร';

  @override
  String get reasonHint => 'กรุณาระบุเหตุผล (อย่างน้อย 10 ตัวอักษร)';

  @override
  String get cancellationPolicyCanCancel => 'ยกเลิกได้';

  @override
  String get cancellationPolicyTitle => 'นโยบายยกเลิก & คืนเงิน';

  @override
  String get cancellationPolicyExpand => 'ดูเพิ่ม';

  @override
  String get cancellationPolicyCollapse => 'ย่อ';

  @override
  String get cancellationTier1Title => 'ยกเลิกก่อน 30 นาที';

  @override
  String get cancellationTier1Subtitle => 'คืนเงินทันทีภายใน 24 ชั่วโมง';

  @override
  String get cancellationTier2Title => 'ยกเลิกหลัง 30 นาที';

  @override
  String get cancellationTier2Subtitle => 'คืนเงินภายใน 24 ชั่วโมง';

  @override
  String get cancellationTier3Title => 'ยกเลิกหลังเริ่มนัด';

  @override
  String get cancellationTier3Subtitle => 'ไม่สามารถคืนเงินได้';

  @override
  String get cancellationRefundInfo =>
      'เงินจะถูกโอนคืนไปยังช่องทางที่คุณชำระภายใน 24 ชั่วโมง';

  @override
  String get bookingSummaryActive => 'กำลังมา';

  @override
  String get commonAdd => 'เพิ่ม';

  @override
  String get commonUpdate => 'อัปเดต';

  @override
  String get commonEnable => 'เปิดใช้';

  @override
  String get billingPerHourShort => '/ชม.';

  @override
  String get billingPerDayShort => '/วัน';

  @override
  String get billingPerNightShort => '/คืน';

  @override
  String get billingPerSession => '/ครั้ง';

  @override
  String get billingPerMinute => '/นาที';

  @override
  String get servicesManageSubtitle => 'จัดการและตั้งราคาบริการ';

  @override
  String servicesManageDeleteTitle(String name) {
    return 'ลบ $name';
  }

  @override
  String get servicesManageDeleteMessage =>
      'คุณต้องการลบบริการนี้ออกจากโปรไฟล์ของคุณใช่หรือไม่?';

  @override
  String get servicesManageYourRate => 'ราคาที่คุณกำหนด';

  @override
  String get servicesManageFeePerSession => 'ค่าบริการ/ครั้ง';

  @override
  String get servicesManageActualEarnings => 'เงินที่ได้รับจริง';

  @override
  String get servicesManagePriceList => 'รายการราคา';

  @override
  String get servicesManageCommissionPerSession => 'ค่านายหน้า/ครั้ง';

  @override
  String get servicesManageCommission => 'ค่านายหน้า';

  @override
  String get servicesManageBaseRate => 'ราคาพื้นฐาน';

  @override
  String get servicesManageAddThis => 'เพิ่มบริการนี้';

  @override
  String get servicesManageLocationRequired => 'กรุณาใส่ที่อยู่/สถานที่';

  @override
  String get servicesManageUpdateMassageRate => 'อัปเดตราคานวด';

  @override
  String get servicesManageAddMassageRate => 'เพิ่มราคานวด';

  @override
  String get servicesManageVariantName => 'ชื่อประเภท';

  @override
  String get servicesManagePriceKipPerHour => 'ราคา (กีบ/ชม.)';

  @override
  String servicesManagePriceKipPerHourShort(String amount) {
    return '$amount กีบ/ชม.';
  }

  @override
  String servicesManageMinimum(String amount) {
    return 'ต่ำสุด $amount';
  }

  @override
  String get servicesManageAddVariant => 'เพิ่มประเภท';

  @override
  String get servicesManageAddressLabel => 'ที่อยู่/สถานที่';

  @override
  String get servicesManageAddressHint =>
      'เช่น: นครหลวงเวียงจันทน์, สีสัตตะนาก';

  @override
  String get servicesManageInstructions =>
      'เลือกเพิ่มบริการที่คุณสามารถให้ได้ และตั้งราคาของคุณเอง ลูกค้าจะเห็นเฉพาะรายการที่คุณเปิดใช้เท่านั้น';

  @override
  String get servicesManageNoData => 'ไม่มีข้อมูลบริการ';

  @override
  String get servicesManageValidRateRequired => 'กรุณาใส่ราคาที่ถูกต้อง';

  @override
  String servicesManageMinRate(String amount) {
    return 'ราคาต่ำสุด: $amount กีบ';
  }

  @override
  String get servicesManageUpdatePrice => 'อัปเดตราคา';

  @override
  String get servicesManageAddService => 'เพิ่มบริการ';

  @override
  String servicesManagePriceWithBilling(String billing) {
    return 'ราคา$billing (กีบ)';
  }

  @override
  String get registerCompanionTitle => 'สร้างบัญชีสำหรับผู้ให้บริการ';

  @override
  String get registerCustomerTitle => 'สร้างบัญชีสำหรับลูกค้า';

  @override
  String get registerFillInfo => 'กรุณากรอกข้อมูลให้ครบ';

  @override
  String get registerFirstName => 'ชื่อ';

  @override
  String get registerLastName => 'นามสกุล';

  @override
  String get registerFirstNameHint => 'กรอกชื่อ';

  @override
  String get registerLastNameHint => 'กรอกนามสกุล';

  @override
  String get registerPhone => 'เบอร์โทรศัพท์';

  @override
  String get registerSelectGender => 'เลือกเพศ';

  @override
  String get registerDob => 'วันเดือนปีเกิด';

  @override
  String get registerPassword => 'รหัสผ่าน';

  @override
  String get registerPasswordHint => 'กรอกรหัสผ่าน';

  @override
  String get registerAddress => 'ที่อยู่';

  @override
  String get registerAddressHint => 'นาทม, หนองเวียงคำ, เวียงจันทน์...';

  @override
  String get registerReferredBy => 'คุณได้รับการแนะนำจาก';

  @override
  String get registerCta => 'สร้างบัญชี';

  @override
  String get registerTermsPrefix => 'ฉันได้อ่านและยอมรับ ';

  @override
  String get registerTermsOfUse => 'ข้อกำหนดการใช้งาน';

  @override
  String get registerTermsAnd => ' และ ';

  @override
  String get registerPrivacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get registerTermsSuffix => ' ของ XAOSAO';

  @override
  String get registerAvatarChange => 'กดเพื่อเปลี่ยนรูป';

  @override
  String get registerAvatarPick => 'กดเพื่อเลือกรูป';

  @override
  String get registerStepInfo => 'ข้อมูล';

  @override
  String get registerStepServices => 'บริการ';

  @override
  String get registerStepOtp => 'OTP';

  @override
  String get registerServicesTitle => 'เลือกบริการ';

  @override
  String get registerServicesSubtitle => 'กำหนดประเภทและราคาบริการของคุณ';

  @override
  String get registerNoServices => 'ไม่มีบริการ';

  @override
  String get registerServicesInfoPrefix => 'กรุณาดำเนินการ';

  @override
  String get registerServicesInfoSelect => 'เลือกบริการ';

  @override
  String get registerServicesInfoMid => ' ที่คุณต้องการ และ ';

  @override
  String get registerServicesInfoSetPrice => 'ตั้งราคา';

  @override
  String get registerServicesInfoDot => '.';

  @override
  String get registerPriceRequired => 'กรุณาใส่ราคา';

  @override
  String registerMinPrice(String amount) {
    return 'ราคาต่ำสุด $amount กีบ';
  }

  @override
  String get registerPricePerHourLabel => 'ราคา (กีบ/ชั่วโมง) *';

  @override
  String registerMinPriceKip(String amount) {
    return 'ต่ำสุด $amount กีบ';
  }

  @override
  String get registerAllVariants => 'เพิ่มได้ทุกประเภท';

  @override
  String get registerServiceLocation => 'สถานที่ให้บริการ *';

  @override
  String get registerServiceLocationHint => 'เช่น: บ้าน, โรงแรม, สถานที่ลูกค้า';

  @override
  String get registerVariantsPriceLabel => 'ประเภทและราคา (กีบ/ชั่วโมง) *';

  @override
  String get registerContinueCta => 'ดำเนินการต่อ';

  @override
  String get registerCurrencyPerHour => 'กีบ/ชม.';

  @override
  String get registerOtpSmsInfo =>
      'กรุณาตรวจสอบ SMS ของคุณ\nรหัสใช้ได้ 5 นาทีเท่านั้น';

  @override
  String get registerOtpInvalid => 'รหัส OTP ไม่ถูกต้อง — ลองใหม่';

  @override
  String get registerOtpInvalidRetry => 'รหัส OTP ไม่ถูกต้อง กรุณาลองใหม่';

  @override
  String get registerOtpExpiresIn => 'รหัสหมดอายุใน ';

  @override
  String get registerOtpExpired => 'รหัสหมดอายุแล้ว';

  @override
  String get registerOtpNotReceived => 'ยังไม่ได้รับรหัส? ';

  @override
  String get registerOtpResend => 'ส่งใหม่';

  @override
  String get registerOtpChangePhone => 'เปลี่ยนเบอร์โทรศัพท์';

  @override
  String get registerOtpConfirmPhone => 'ยืนยันเบอร์โทร';

  @override
  String get registerOtpEnter6Digits => 'ใส่รหัส 6 หลักที่ส่งไปยัง';

  @override
  String get registerOtpVerify => 'ยืนยัน OTP';

  @override
  String get commonEdit => 'แก้ไข';

  @override
  String get commonConnectionRetry => 'ตรวจสอบการเชื่อมต่อแล้วลองใหม่';

  @override
  String get commonBank => 'ธนาคาร';

  @override
  String get qrTitle => 'QR โอนเงิน';

  @override
  String get qrSubtitle => 'จัดการ QR Code ของฉัน';

  @override
  String get qrDeleteTitle => 'ลบ QR Code';

  @override
  String get qrDeleteMessage => 'คุณแน่ใจหรือไม่ว่าต้องการลบ QR Code นี้?';

  @override
  String get qrDefaultLabel => 'บัญชีหลัก';

  @override
  String get qrScanHint => 'ให้ลูกค้าสแกน QR นี้เพื่อโอนเงิน';

  @override
  String get qrEmptyTitle => 'ยังไม่มี QR Code';

  @override
  String get qrEmptySubtitle =>
      'เพิ่ม QR Code ธนาคารของคุณ\nเพื่อรับเงินจากลูกค้า';

  @override
  String get qrEmptyAddFirst => 'เพิ่ม QR Code แรก';

  @override
  String get qrSetPrimary => 'ตั้งเป็น QR หลัก';

  @override
  String get qrAddNew => 'เพิ่ม QR ใหม่';

  @override
  String get qrInfoBanner =>
      'QR ที่ตั้งเป็นหลักจะแสดงในหน้า Profile ของคุณ เพื่อให้ลูกค้าสามารถสแกนโอนเงินได้ทันที';

  @override
  String get qrAddFailed => 'เพิ่ม QR ไม่สำเร็จ';

  @override
  String get qrUpdateFailed => 'อัปเดต QR ไม่สำเร็จ';

  @override
  String get qrDeleteFailed => 'ลบ QR ไม่สำเร็จ';

  @override
  String get qrSetDefaultFailed => 'ตั้ง QR หลักไม่สำเร็จ';

  @override
  String get genderMaleShort => 'ชาย';

  @override
  String get genderFemaleShort => 'หญิง';

  @override
  String get genderOther => 'อื่นๆ';

  @override
  String get monthLongJan => 'มกราคม';

  @override
  String get monthLongFeb => 'กุมภาพันธ์';

  @override
  String get monthLongMar => 'มีนาคม';

  @override
  String get monthLongApr => 'เมษายน';

  @override
  String get monthLongMay => 'พฤษภาคม';

  @override
  String get monthLongJun => 'มิถุนายน';

  @override
  String get monthLongJul => 'กรกฎาคม';

  @override
  String get monthLongAug => 'สิงหาคม';

  @override
  String get monthLongSep => 'กันยายน';

  @override
  String get monthLongOct => 'ตุลาคม';

  @override
  String get monthLongNov => 'พฤศจิกายน';

  @override
  String get monthLongDec => 'ธันวาคม';

  @override
  String get profileTitle => 'โปรไฟล์';

  @override
  String get profileSectionGeneralInfo => 'ข้อมูลทั่วไป';

  @override
  String get profileSectionAccountInfo => 'ข้อมูลบัญชี';

  @override
  String get profileSectionServices => 'บริการ';

  @override
  String get profileFullName => 'ชื่อ-นามสกุล';

  @override
  String get profilePhone => 'เบอร์โทร';

  @override
  String get profileGender => 'เพศ';

  @override
  String get profileAccountCreated => 'สร้างบัญชี';

  @override
  String get profileNoServices => 'ยังไม่มีบริการ';

  @override
  String get profileVerifiedCustomer => 'ยืนยันแล้ว';

  @override
  String get profileVerifiedCompanion => 'Companion ยืนยันแล้ว';

  @override
  String get profileUpdateSuccess => 'อัปเดตข้อมูลสำเร็จ';

  @override
  String get profileUpdateFailed => 'อัปเดตข้อมูลไม่สำเร็จ';

  @override
  String get profileEditTitle => 'แก้ไขข้อมูล';

  @override
  String get profilePhoneReadonlyLabel => 'เบอร์โทร (ไม่สามารถเปลี่ยน)';

  @override
  String get profileAddressHint => 'เช่น: โซน 1, เวียงจันทน์';

  @override
  String get profileEditNote =>
      'การเปลี่ยนรหัสผ่านและเบอร์โทร ต้องไปที่หน้าตั้งค่า';

  @override
  String get profileSave => 'บันทึก';

  @override
  String get commonErrorTryAgain => 'เกิดข้อผิดพลาด! กรุณาลองใหม่อีกครั้ง';

  @override
  String get commonUploadFailed => 'อัปโหลดไม่สำเร็จ';

  @override
  String get changePasswordTitle => 'เปลี่ยนรหัสผ่าน';

  @override
  String get changePasswordSubtitle => 'ต้องใส่รหัสผ่านปัจจุบันก่อน';

  @override
  String get changePasswordSectionCurrent => 'รหัสผ่าน';

  @override
  String get changePasswordCurrentLabel => 'รหัสผ่านปัจจุบัน';

  @override
  String get changePasswordMin6 => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัว';

  @override
  String get changePasswordSectionNew => 'รหัสใหม่';

  @override
  String get changePasswordNewLabel => 'รหัสผ่านใหม่';

  @override
  String get changePasswordNewHint => 'ใส่รหัสผ่านใหม่';

  @override
  String get changePasswordConfirmLabel => 'ยืนยันรหัสผ่านใหม่';

  @override
  String get changePasswordMismatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get changePasswordSave => 'บันทึกรหัสใหม่';

  @override
  String get changePasswordSecurityTitle => 'ความปลอดภัย';

  @override
  String get changePasswordSecurityRule =>
      'รหัสผ่านต้องอย่างน้อย 8 ตัว รวมทั้งตัวใหญ่ ตัวเลข และสัญลักษณ์';

  @override
  String get changePasswordStrengthWeak => 'อ่อน';

  @override
  String get changePasswordStrengthFair => 'ปานกลาง';

  @override
  String get changePasswordStrengthStrong => 'แข็งแรง';

  @override
  String get changePasswordSuccess => 'เปลี่ยนรหัสผ่านสำเร็จ';

  @override
  String get changePasswordFailed => 'เปลี่ยนรหัสผ่านไม่สำเร็จ';

  @override
  String get profileToggleStatusFailed => 'เปลี่ยนสถานะไม่สำเร็จ';

  @override
  String get profileUploadPhotoFailed => 'อัปโหลดรูปโปรไฟล์ไม่สำเร็จ';

  @override
  String get profileNoPhotos => 'ยังไม่มีรูป';

  @override
  String get profileGalleryTitle => 'รูปภาพทั้งหมด';

  @override
  String profileGalleryCount(int count, int max) {
    return '$count / $max รูป';
  }

  @override
  String get profileDeletePhotoTitle => 'ลบรูป';

  @override
  String get profileDeletePhotoMessage => 'คุณต้องการลบรูปนี้ใช่หรือไม่?';

  @override
  String get profileAddPhoto => 'เพิ่มรูป';

  @override
  String get profileHiddenShowSuccess => 'แสดงโปรไฟล์สำเร็จ';

  @override
  String get profileHiddenBannerBody =>
      'ลูกค้าไม่สามารถเห็นโปรไฟล์ของคุณตอนนี้ เมื่อคุณพร้อมรับการจองอีกครั้ง กดแสดงโปรไฟล์ของคุณ';

  @override
  String get profileHiddenClose => 'ปิด';

  @override
  String get profileHiddenShow => 'แสดงโปรไฟล์';

  @override
  String get profileHiddenHeaderTitle => 'โปรไฟล์ของคุณถูกซ่อนอยู่';

  @override
  String get profileHiddenHeaderSubtitle => 'คุณจะไม่แสดงในผลค้นหา';

  @override
  String get profileShareLink => 'แชร์ Profile Link';

  @override
  String get profileHideYourProfile => 'ซ่อนโปรไฟล์ของคุณ';

  @override
  String get qrRowScanToTransfer => 'สแกนเพื่อโอนเงิน';

  @override
  String get servicesEditAddLabel => 'แก้ไข / เพิ่ม บริการ';

  @override
  String get servicesEditAddSub => 'ตั้งราคาและคำอธิบาย';

  @override
  String get timeJustNow => 'เมื่อสักครู่';

  @override
  String get timeJustNowShort => 'เมื่อกี้';

  @override
  String timeMinutesAgo(int n) {
    return '$n นาทีที่แล้ว';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n ชั่วโมงที่แล้ว';
  }

  @override
  String timeDaysAgo(int n) {
    return '$n วันที่แล้ว';
  }

  @override
  String timeWeeksAgo(int n) {
    return '$n สัปดาห์ที่แล้ว';
  }

  @override
  String timeMinutesShort(int n) {
    return '$nนาที';
  }

  @override
  String timeHoursShort(int n) {
    return '$nชั่วโมง';
  }

  @override
  String timeDaysShort(int n) {
    return '$nวัน';
  }

  @override
  String timeWeeksShort(int n) {
    return '$nสัปดาห์';
  }

  @override
  String timeDaysShortSpaced(int n) {
    return '$n วัน';
  }

  @override
  String timeWeeksShortSpaced(int n) {
    return '$n สัปดาห์';
  }

  @override
  String get commonUser => 'ผู้ใช้';

  @override
  String get commonYou => 'คุณ';

  @override
  String get commonLoadMore => 'โหลดเพิ่ม';

  @override
  String commonAmountKip(String amount) {
    return '$amount กีบ';
  }

  @override
  String get postsTitle => 'โพสต์';

  @override
  String get postsSubtitle => 'ค้นหาผู้ให้บริการใกล้คุณ';

  @override
  String get postsCantLoad => 'ไม่สามารถโหลดข้อมูล';

  @override
  String get postsPleaseRetry => 'กรุณาลองใหม่อีกครั้ง';

  @override
  String get postsEmpty => 'ยังไม่มีโพสต์';

  @override
  String get postsEmptyFeedSubtitle => 'โพสต์จาก Companion จะแสดงที่นี่';

  @override
  String get postsEmptyMySubtitle => 'กด \"สร้างโพสต์\" เพื่อเริ่มโพสต์';

  @override
  String get postsShare => 'แชร์โพสต์';

  @override
  String get postsReport => 'รายงาน';

  @override
  String get postsDeleteTitle => 'ลบโพสต์';

  @override
  String get postsDeleteMessage =>
      'คุณแน่ใจที่จะลบโพสต์นี้ใช่หรือไม่?\nการกระทำนี้ไม่สามารถย้อนคืนได้';

  @override
  String get postsDisableTitle => 'ปิดโพสต์';

  @override
  String get postsDisableMessage =>
      'คุณแน่ใจที่จะปิดโพสต์นี้ใช่หรือไม่?\nลูกค้าจะไม่สามารถเห็นโพสต์นี้ได้';

  @override
  String get postsDisableConfirm => 'ปิดโพสต์';

  @override
  String get postsCreate => 'สร้างโพสต์';

  @override
  String get postsTabAll => 'ทั้งหมด';

  @override
  String get postsTabMine => 'ของฉัน';

  @override
  String get postsPublicPost => 'โพสต์สาธารณะ';

  @override
  String get postsWhatLookingFor => 'คุณกำลังหาคู่แบบไหน?';

  @override
  String get postsHintCustomer =>
      'ตัวอย่าง: ฉันกำลังช่วยลูกค้าที่โพสต์นี้ เพื่อหาคู่ดื่ม';

  @override
  String get postsHintModel => 'ตัวอย่าง: ฉันต้องการ 2 คนเป็นคู่ดื่มคืนนี้';

  @override
  String get postsAddPhotos => 'เพิ่มรูปภาพ';

  @override
  String get postsChangePhoto => 'เปลี่ยนรูป';

  @override
  String get postsSelectGender => 'เลือกเพศ';

  @override
  String get postsSelectService => 'เลือกบริการ';

  @override
  String get postsLocation => 'สถานที่';

  @override
  String get postsLocationHint => 'ตัวอย่าง: ร้านอาหาร, ดาวอังคาร...';

  @override
  String get postsWillTip => 'ฉันจะให้ทิป';

  @override
  String get postsWillTipHelp => 'เพื่อให้รู้ว่าจะให้ทิป จึงมีคนสนใจมากขึ้น';

  @override
  String get postsSubmitAndNotify => 'โพสต์และแจ้งเตือน';

  @override
  String get postsGenderAny => 'ทุกเพศ';

  @override
  String get postsGiftHistory => 'ประวัติของขวัญ';

  @override
  String get postsGiftHistorySubtitle => 'ดูรายการของขวัญที่คุณส่งให้โมเดล';

  @override
  String get postsAuthorFallback => 'ผู้โพสต์';

  @override
  String get postStatusActive => 'กำลังใช้';

  @override
  String get postStatusExpired => 'หมดอายุ';

  @override
  String get postStatusHidden => 'ซ่อน';

  @override
  String get postStatusFulfilled => 'ปิดใช้งานแล้ว';

  @override
  String get postActionBook => 'จอง';

  @override
  String get postActionChat => 'แชท';

  @override
  String get commentsTitle => 'ความคิดเห็น';

  @override
  String get commentsEmptyTitle => 'ยังไม่มีความคิดเห็น';

  @override
  String get commentsEmptySubtitle => 'เป็นคนแรกที่คอมเมนต์!';

  @override
  String get commentReply => 'ตอบกลับ';

  @override
  String get commentCollapseReplies => 'ย่อคำตอบ';

  @override
  String commentViewReplies(int count) {
    return 'ดู $count คำตอบ';
  }

  @override
  String commentReplyToHint(String name) {
    return 'ตอบ $name...';
  }

  @override
  String get commentWriteHint => 'เขียนความคิดเห็น...';

  @override
  String get postDetailTitle => 'รายละเอียดโพสต์';

  @override
  String get postDetailActive => 'กำลังเปิด';

  @override
  String get postDetailClosed => 'ปิดแล้ว';

  @override
  String get postDetailCollapse => 'ย่อลง';

  @override
  String get postDetailReadMore => 'อ่านเพิ่ม';

  @override
  String get postDetailInterested => 'สนใจ';

  @override
  String get postDetailGift => 'ของขวัญ';

  @override
  String get postDetailComment => 'ความคิดเห็น';

  @override
  String get interestTitle => 'ผู้สนใจ';

  @override
  String get interestSubtitle => 'รายชื่อผู้ที่สนใจโพสต์ของคุณ';

  @override
  String get interestEmptyTitle => 'ยังไม่มีผู้สนใจ';

  @override
  String get interestEmptySubtitle =>
      'เมื่อมีคนกดสนใจโพสต์นี้\nชื่อของพวกเขาจะแสดงที่นี่';

  @override
  String get giftReceivedTitle => 'ของขวัญ';

  @override
  String get giftReceivedSubtitle => 'ของขวัญที่คุณได้รับ';

  @override
  String get giftEmptyReceivedTitle => 'ยังไม่มีของขวัญ';

  @override
  String get giftEmptyReceivedSubtitle => 'ของขวัญที่คนส่งให้จะแสดงที่นี่';

  @override
  String get giftSenderLabel => 'ผู้ส่งของขวัญ';

  @override
  String get giftReceivedTotal => 'ของขวัญที่ได้รับทั้งหมด';

  @override
  String get giftFallback => 'ของขวัญ';

  @override
  String get giftHistoryTitle => 'ประวัติของขวัญ';

  @override
  String get giftHistorySubtitle => 'รายการของขวัญที่คุณได้ส่ง';

  @override
  String get giftHistoryEmptyTitle => 'ยังไม่มีประวัติของขวัญ';

  @override
  String get giftHistoryEmptySubtitle =>
      'เมื่อคุณส่งของขวัญให้โมเดล\nรายการจะแสดงที่นี่';

  @override
  String get giftDetailsTitle => 'รายละเอียดของขวัญ';

  @override
  String get giftHistorySentTimes => 'ครั้งที่คุณส่งของขวัญ';

  @override
  String giftHistorySpent(String amount) {
    return 'ใช้จ่าย $amount กีบ';
  }

  @override
  String get commonErrorOccurred => 'มีข้อผิดพลาดเกิดขึ้น';

  @override
  String get commonCantLoadData => 'ไม่สามารถโหลดข้อมูลได้';
}
