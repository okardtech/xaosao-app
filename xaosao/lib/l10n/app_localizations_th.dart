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
  String get serviceTypeSocial => 'กิจกรรมท้องถิ่น';

  @override
  String get serviceTypeMassage => 'นวด';

  @override
  String get serviceTypeTravel => 'ประสบการณ์ท้องถิ่น';

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
    return '$hours รอบ';
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
  String get profileShareLink => 'แชร์ลิงก์แนะนำของคุณ';

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

  @override
  String get packageHistoryTitle => 'ประวัติ Package';

  @override
  String get packageHistorySubtitle => 'รายการซื้อทั้งหมด';

  @override
  String get packageHistoryEmpty => 'ไม่มีรายการ';

  @override
  String get packageStatusActive => 'กำลังใช้';

  @override
  String get packageStatusCompleted => 'สำเร็จ';

  @override
  String get packageStatusPending => 'รอ';

  @override
  String get packageStatusPendingRelease => 'รอโอน';

  @override
  String get packageStatusCanceled => 'ยกเลิก';

  @override
  String get packageStatusRefunded => 'คืนเงิน';

  @override
  String get packageStatusExpired => 'หมดอายุ';

  @override
  String get packageStatusUpgraded => 'อัปเกรด';

  @override
  String get packageStatusHeld => 'ค้ำประกัน';

  @override
  String get packageStatusSuperseded => 'ถูกแทนที่';

  @override
  String get packageAmount => 'จำนวน';

  @override
  String packageDaysRemaining(int days) {
    return 'เหลืออีก $days วัน';
  }

  @override
  String packageExpiresShort(String date) {
    return 'หมด $date';
  }

  @override
  String get subscriptionPrice => 'ราคา';

  @override
  String get subscriptionDuration => 'ระยะเวลา';

  @override
  String get subscriptionBenefits => 'สิ่งที่คุณจะได้รับ:';

  @override
  String get subscriptionViewAll => 'ดูแพ็กทั้งหมด';

  @override
  String get subscriptionClose => 'ปิด';

  @override
  String get subscriptionBuyNow => 'ซื้อเลย';

  @override
  String get subscriptionTopUp => 'เติมเงิน';

  @override
  String subscriptionDurationHours(int hours) {
    return '$hours ชม.';
  }

  @override
  String get subscriptionDuration1Day => '1 วัน';

  @override
  String get subscriptionDuration1Week => '1 สัปดาห์';

  @override
  String get subscriptionDuration1Month => '1 เดือน';

  @override
  String get subscriptionDuration3Months => '3 เดือน';

  @override
  String get subscriptionDuration1Year => '1 ปี';

  @override
  String subscriptionDurationDays(int days) {
    return '$days วัน';
  }

  @override
  String get subscriptionSpecialPack => 'แพ็กพิเศษ';

  @override
  String get subscriptionYourBalance => 'ยอดเงินของคุณ';

  @override
  String subscriptionNeedMore(String amount) {
    return 'ต้องการ +$amount KIP';
  }

  @override
  String get subscriptionCanPay => 'ชำระได้เลย';

  @override
  String get subscriptionNeedPackageBody =>
      'กรุณาซื้อ Package ก่อน จึงสามารถจองบริการได้ Package จะให้สิทธิ์ในการจองและใช้งานต่างๆ';

  @override
  String get subscriptionViewPackage => 'ดู Package';

  @override
  String get subscriptionNeedPackage => 'ต้องการ Wallet Package';

  @override
  String get subscriptionNoActive => 'ยังไม่มี Wallet Package ใช้งาน';

  @override
  String get subscriptionServicePrice => 'ราคาบริการ';

  @override
  String get subscriptionShortfall => 'ขาดอยู่';

  @override
  String subscriptionTopUpAmount(String amount) {
    return 'เติม $amount KIP';
  }

  @override
  String get subscriptionInsufficient => 'ยอดเงินไม่เพียงพอ';

  @override
  String get subscriptionPleaseTopup => 'กรุณาเติมเงินก่อนจอง';

  @override
  String get subscriptionPendingVerification => 'รอการยืนยัน';

  @override
  String get subscriptionAlreadySubscribed =>
      'คุณมี Wallet Package ใช้งานอยู่แล้ว';

  @override
  String get subscriptionPendingBadge => 'รอ';

  @override
  String get subscriptionPendingBody =>
      'Package ของคุณกำลังรอการยืนยันจาก Admin กรุณารอหรือติดต่อ Admin เพื่อยืนยันโดยไว';

  @override
  String get subscriptionAdminPhone => 'เบอร์โทร Admin';

  @override
  String get subscriptionCallAdmin => 'โทรหา Admin';

  @override
  String get subscriptionWaitingVerification => 'กำลังรอการยืนยัน';

  @override
  String get subscriptionAdminChecking => 'Package ของคุณรอ Admin ตรวจสอบ';

  @override
  String get packagePurchaseFailed => 'การซื้อไม่สำเร็จ';

  @override
  String get packageFeature1 =>
      'จองบริการจากผู้ให้บริการในท้องถิ่นได้ไม่จำกัดต่อวัน';

  @override
  String get packageFeature2 =>
      'ติดต่อผู้ให้บริการเพื่อประสานงานการจองและกิจกรรม';

  @override
  String get packageFeature3 =>
      'จองกิจกรรมและบริการในชีวิตจริงได้ไม่จำกัดต่อวัน';

  @override
  String get packageFeature4 =>
      'ค้นพบผู้ให้บริการที่ได้รับคะแนนสูงในพื้นที่ของคุณ';

  @override
  String get packageFeature5 =>
      'ค้นหาผู้ให้บริการตามประเภท สถานที่ และความพร้อม';

  @override
  String get packageFeature6 => 'บริการช่วยเหลือลูกค้าตลอด 24/7';

  @override
  String get packageFeature7 => 'โปรไฟล์ผู้ให้บริการเห็นเด่นชัดขึ้น';

  @override
  String get packagePlanShort1 =>
      'จองบริการและเชื่อมต่อกับผู้ให้บริการในท้องถิ่นได้ทันที';

  @override
  String get packagePlanShort2 =>
      'ทดลองใช้ 24 ชั่วโมง สำหรับการจองและติดต่อผู้ให้บริการ';

  @override
  String get packagePlanShort3 =>
      'คุ้มที่สุดสำหรับการจองระยะยาวและวางแผนกิจกรรม';

  @override
  String get packageChooseTitle => 'เลือกแผน';

  @override
  String get packageChooseSubtitle => 'เลือก Wallet Package';

  @override
  String get packageHistoryButton => 'ประวัติ';

  @override
  String get packageCancelAnytime => 'ยกเลิกได้ทุกเวลา · คืนเงินตามนโยบาย';

  @override
  String get packageWaitingVerification => 'รอการยืนยัน';

  @override
  String get packageExpiredLabel => 'หมดอายุแล้ว';

  @override
  String get packageNearExpiry => 'ใกล้หมดอายุ';

  @override
  String get packageActive => 'กำลังใช้งาน';

  @override
  String get packageProcessingVerification => 'กำลังดำเนินการยืนยัน...';

  @override
  String packageExpiresOn(String date) {
    return 'หมดอายุ $date';
  }

  @override
  String get packageDays => 'วัน';

  @override
  String get packageRemainingLabel => 'คงเหลือ';

  @override
  String get packageChooseYourPlan => 'เลือกแผนของคุณ';

  @override
  String get packageUpgradeExperience => 'ขยายการเข้าถึงการจอง';

  @override
  String get packageChooseFitPlan => 'เลือกแผนที่ตรงกับความต้องการจองของคุณ';

  @override
  String get packageLoadFailedShort => 'โหลดไม่สำเร็จ';

  @override
  String get packageNoPackage => 'ไม่มี Package';

  @override
  String get packageRequestProcessing =>
      'คำร้องขอของคุณกำลังถูกดำเนินการ · กรุณารอ';

  @override
  String get packageCurrent => 'แพ็กเกจปัจจุบัน';

  @override
  String get packageSelectPlan => 'เลือกแผนนี้';

  @override
  String get checkoutPurchaseSuccess => 'ซื้อ Package สำเร็จ';

  @override
  String get checkoutUpgradeTitle => 'อัปเกรด Package';

  @override
  String get checkoutUpgradeSubtitle => 'ตรวจสอบและยืนยันการชำระ';

  @override
  String get checkoutProcessPayment => 'ดำเนินการชำระ';

  @override
  String get checkoutAlreadySubscribed => 'Wallet Package ใช้งานอยู่แล้ว';

  @override
  String checkoutPillPlan(String name) {
    return 'แผน $name';
  }

  @override
  String checkoutPillRemainingDays(int days) {
    return 'เหลือ $days วัน';
  }

  @override
  String get checkoutUpgradeInfo =>
      'การชำระใหม่จะเริ่มต่อจาก Package ปัจจุบัน และวันที่ยังเหลือจะถูกนำใส่ Package ใหม่';

  @override
  String get checkoutPackageDuration => 'ระยะ Package';

  @override
  String get checkoutNewPackageDuration => 'ระยะ Package ใหม่';

  @override
  String get checkoutBonusFromOld => '+ โบนัส (Package เดิม)';

  @override
  String get checkoutTotalDuration => 'ระยะทั้งหมด';

  @override
  String get checkoutPaymentSummary => 'สรุปการชำระ';

  @override
  String get checkoutWalletBalance => 'ยอด Wallet';

  @override
  String get checkoutPackagePrice => 'ราคา Package';

  @override
  String get checkoutRemaining => 'ยอดคงเหลือ';

  @override
  String get checkoutShortfallSuffix => ' (ขาด)';

  @override
  String get checkoutWalletDeductInfo =>
      'ยอด Wallet จะถูกตัดทันที Package จะเปิดใช้งานหลังจากการชำระสำเร็จ';

  @override
  String get onboardingTopCompanions => 'เพื่อนแนะนำยอดนิยม';

  @override
  String get onboardingTopCompanionsSubtitle =>
      'ค้นพบผู้ให้บริการที่ได้รับคะแนนสูง';

  @override
  String get onboardingWelcome => 'ยินดีต้อนรับ 👋';

  @override
  String get onboardingFindYourCompanion => 'ค้นหาเพื่อนของคุณ';

  @override
  String get onboardingLoginOrSignup => 'เข้าสู่ระบบ / สร้างบัญชี';

  @override
  String get onboardingActionsHint => 'ดูโปรไฟล์ · ส่งข้อความ · จองได้ทันที';

  @override
  String get onboardingLogin => 'เข้าสู่ระบบ';

  @override
  String get onboardingOurServices => 'บริการของเรา';

  @override
  String get onboardingMassageTitle => 'บริการนวด';

  @override
  String get onboardingMassageSubtitle =>
      'บริการนวดสุขภาพโดยผู้ให้บริการมืออาชีพ สะดวกถึงบ้าน';

  @override
  String get onboardingSocialSubtitle =>
      'คู่ร่วมงานสำหรับงานสังคม เพื่อเพิ่มความสนุกและความประทับใจ';

  @override
  String get onboardingTravelTitle => 'เพื่อนท่องเที่ยว';

  @override
  String get onboardingTravelSubtitle =>
      'คู่ร่วมท่องเที่ยวที่พร้อมพาคุณค้นพบประสบการณ์ใหม่ ทั้งในและต่างประเทศ';

  @override
  String get onboardingLevelGeneral => 'ทั่วไป';

  @override
  String get onboardingLevelSpecial => 'พิเศษ';

  @override
  String get onboardingLevelPartner => 'พาร์ทเนอร์';

  @override
  String get onboardingPartnerBenefits => 'สิทธิประโยชน์พาร์ทเนอร์';

  @override
  String get onboardingIncreaseIncome => 'เพิ่มรายได้ของคุณ';

  @override
  String get onboardingJoinNow => 'เข้าร่วมเลย';

  @override
  String get onboardingConditionRegister => 'ลงทะเบียนเป็นคู่ร่วม';

  @override
  String get onboardingEarnPer20 => 'ต่อ 1 คนที่แนะนำ · สูงสุด 20 คน';

  @override
  String get onboardingCondition20People => 'แนะนำคู่ร่วม 20 คน';

  @override
  String get onboardingEarnCommission => 'ค่าคอมมิชชั่นและจำนวนแนะนำ';

  @override
  String get onboardingEarnVipSummary => 'สรุป VIP และค่าคอมมิชชั่นในเวลา';

  @override
  String get onboardingReadyToEarn => 'พร้อมเริ่มหารายได้หรือยัง?';

  @override
  String get onboardingRegisterUnlock =>
      'ลงทะเบียนตอนนี้ และเพิ่มรางวัลของคุณด้วยการแนะนำผู้อื่น';

  @override
  String get onboardingGetStarted => 'เริ่มต้น';

  @override
  String get notifSettingTitle => 'ตั้งค่าระบบ';

  @override
  String get notifSettingSubtitle => 'จัดการการแจ้งเตือนของคุณ';

  @override
  String get notifSettingChannelsSection => 'ช่องทางการแจ้งเตือน';

  @override
  String get notifSettingPushSubtitle => 'แจ้งเตือนโดยตรงบนโทรศัพท์';

  @override
  String get notifSettingSmsSubtitle => 'รับข้อความสั้นทางเบอร์โทร';

  @override
  String get notifSettingBannerTitle => 'การตั้งค่าการแจ้งเตือน';

  @override
  String get notifSettingBannerBody =>
      'เลือกช่องทางที่คุณต้องการรับข้อความ\nการเปลี่ยนแปลงจะถูกบันทึกอัตโนมัติ';

  @override
  String get notifSettingFooterNote =>
      'การเปลี่ยนแปลงจะถูกบันทึกทันที คุณสามารถเปลี่ยนการตั้งค่าได้ตลอดเวลา';

  @override
  String get notifSettingUpdateFailed => 'อัปเดตไม่สำเร็จ';

  @override
  String get notifListTitle => 'การแจ้งเตือน';

  @override
  String get notifListSubtitle => 'รายการแจ้งเตือนทั้งหมดของคุณ';

  @override
  String get notifListMarkAllRead => 'อ่านทั้งหมด';

  @override
  String get notifListEmptyTitle => 'ยังไม่มีการแจ้งเตือน';

  @override
  String get notifListEmptySubtitle => 'การแจ้งเตือนจะแสดงที่นี่';

  @override
  String get notifTimeJustNow => 'เมื่อสักครู่';

  @override
  String notifTimeMinutes(int n) {
    return '$n นาที';
  }

  @override
  String notifTimeHours(int n) {
    return '$n ชั่วโมง';
  }

  @override
  String get notifTimeYesterday => 'เมื่อวาน';

  @override
  String notifTimeDaysAgo(int n) {
    return '$n วันที่แล้ว';
  }

  @override
  String notifTimeWeeksAgo(int n) {
    return '$n สัปดาห์ที่แล้ว';
  }

  @override
  String notifTimeMonthsAgo(int n) {
    return '$n เดือนที่แล้ว';
  }

  @override
  String get welcomeTitle => 'ยินดีต้อนรับ!';

  @override
  String get welcomeBody =>
      'บัญชีของคุณสร้างสำเร็จแล้ว\nขอให้คุณมีความสุขในการใช้งาน!';

  @override
  String get welcomeCanDoTitle => 'สิ่งที่คุณสามารถทำได้';

  @override
  String get welcomeChat => 'สนทนา';

  @override
  String get welcomeBook => 'จอง';

  @override
  String get welcomeExplore => 'ค้นหา';

  @override
  String get welcomeGetStartedCta => 'เริ่มใช้งานเลย';

  @override
  String get modelWalletAvailableBalance => 'ยอดเงินที่ถอนได้';

  @override
  String get modelWalletStatPending => 'รอ';

  @override
  String get modelWalletStatWithdrawn => 'ถอนแล้ว';

  @override
  String get modelWalletStatTotalIncome => 'รายได้ทั้งหมด';

  @override
  String get modelWalletWithdrawBtn => 'ถอนเงิน';

  @override
  String get modelWalletIncomeHistory => 'ประวัติรายได้';

  @override
  String get modelWalletEmptyTitle => 'ยังไม่มีรายการ';

  @override
  String get modelWalletEmptySubtitle => 'รายการรายได้ของคุณ\nจะแสดงที่นี่';

  @override
  String get modelWalletWithdrawFailed => 'ไม่สามารถถอนเงินได้';

  @override
  String get withdrawTitle => 'ถอนเงิน';

  @override
  String get withdrawSubtitle => 'จ่ายให้บัญชีธนาคาร';

  @override
  String get withdrawSelectBank => 'เลือกบัญชีธนาคาร';

  @override
  String get withdrawAmountLabel => 'จำนวนเงิน';

  @override
  String get withdrawAmountHint => 'ป้อนจำนวน';

  @override
  String get withdrawHintMin => 'ต่ำสุด';

  @override
  String get withdrawHintMax => 'สูงสุด';

  @override
  String withdrawBelowMin(String amount) {
    return 'จำนวนต่ำกว่าขีดจำกัด ($amount)';
  }

  @override
  String withdrawAboveMax(String amount) {
    return 'เกินยอดที่สามารถถอนได้ ($amount)';
  }

  @override
  String get withdrawConfirmBtn => 'ยืนยันการถอน';

  @override
  String get withdrawableBalance => 'ยอดที่ถอนได้';

  @override
  String get withdrawAll => 'ถอนทั้งหมด';

  @override
  String get withdrawUnavailable => 'ถอนไม่ได้';

  @override
  String get withdrawNoBankTitle => 'ยังไม่มีบัญชีธนาคาร';

  @override
  String get withdrawNoBankSubtitle => 'กรุณาเพิ่มบัญชีก่อนที่จะถอนเงิน';

  @override
  String get withdrawAddBank => 'เพิ่มบัญชีธนาคาร';

  @override
  String get discoverTitle => 'ค้นพบ';

  @override
  String get discoverSubtitle => 'ค้นหาผู้ใช้ที่คุณชอบ';

  @override
  String get discoverSearchHint => 'ค้นหาด้วยชื่อ...';

  @override
  String get discoverTabForYou => 'สำหรับคุณ';

  @override
  String get discoverTabWhoLikedMe => 'ถูกใจฉัน';

  @override
  String get discoverTabILiked => 'ฉันถูกใจ';

  @override
  String get discoverEmptyAllTitle => 'ไม่พบผู้ใช้';

  @override
  String get discoverEmptyAllSubtitle =>
      'ลองเปลี่ยนตัวกรองหรือค้นหาใหม่อีกครั้ง';

  @override
  String get discoverEmptyForYouTitle => 'ยังไม่มีคำแนะนำ';

  @override
  String get discoverEmptyForYouSubtitle => 'ระบบจะค้นหาผู้ที่เหมาะสมให้คุณ';

  @override
  String get discoverEmptyWhoLikedMeTitle => 'ยังไม่มีใครถูกใจคุณ';

  @override
  String get discoverEmptyWhoLikedMeSubtitle => 'สร้างโปรไฟล์ที่ดีเพื่อดึงดูด';

  @override
  String get discoverEmptyILikedTitle => 'คุณยังไม่ได้ถูกใจใคร';

  @override
  String get discoverEmptyILikedSubtitle => 'ค้นหาแล้วกด ♥ เพื่อแสดงความสนใจ';

  @override
  String get detailPersonalInfo => 'ข้อมูลผู้ให้บริการ';

  @override
  String get detailStatAge => 'อายุ';

  @override
  String get detailStatMemberSince => 'สมาชิกตั้งแต่';

  @override
  String get detailStatTier => 'ระดับ';

  @override
  String get detailViewPhotos => 'ดูรูป';

  @override
  String get detailTapPhotoToExpand => 'กดที่รูปเพื่อขยาย';

  @override
  String get detailStatRating => 'คะแนน';

  @override
  String get detailStatPosts => 'โพสต์';

  @override
  String get detailStatGifts => 'ของขวัญ';

  @override
  String get detailStatCount => 'จำนวน';

  @override
  String get meetupsEntryFromMeetUps => 'จากหน้านัดพบ';

  @override
  String get meetupsEntryFromChat => 'จาก Chat';

  @override
  String get meetupsDayShortSun => 'อา';

  @override
  String get meetupsDayShortMon => 'จ';

  @override
  String get meetupsDayShortTue => 'อ';

  @override
  String get meetupsDayShortWed => 'พ';

  @override
  String get meetupsDayShortThu => 'พฤ';

  @override
  String get meetupsDayShortFri => 'ศ';

  @override
  String get meetupsDayShortSat => 'ส';

  @override
  String get meetupsClockSuffix => 'น.';

  @override
  String meetupsCountdownDays(int days, int hours) {
    return 'เหลืออีก $days วัน $hours ชม.';
  }

  @override
  String meetupsCountdownHours(int hours) {
    return 'เหลืออีก $hours ชม.';
  }

  @override
  String meetupsCountdownMinutes(int minutes) {
    return 'เหลือ $minutes นาที';
  }

  @override
  String meetupsServiceMultiplier(String name, int n, String unit) {
    return '$name × $n $unit';
  }

  @override
  String get meetupsUnitDays => 'วัน';

  @override
  String get meetupsUnitHours => 'ชั่วโมง';

  @override
  String get meetupsServiceFallback => 'บริการ';

  @override
  String get meetupsStepCreateBooking => 'สร้างการจอง';

  @override
  String get meetupsStepWaitCompanionConfirm => 'รอ Companion ยืนยัน';

  @override
  String get meetupsStepCompanionConfirmed => 'Companion ยืนยัน';

  @override
  String get meetupsStepWaitingMeetup => 'รอนัดพบ';

  @override
  String get meetupsStepInProgress => 'กำลังดำเนินการ';

  @override
  String get meetupsStepWaitingConfirmation => 'รอยืนยัน';

  @override
  String get meetupsStepMeetingUp => 'ดำเนินนัดพบ';

  @override
  String get meetupsStepCompleted => 'สำเร็จ';

  @override
  String get meetupsStepCancelled => 'ยกเลิก';

  @override
  String get meetupsStepRejected => 'ถูกปฏิเสธ';

  @override
  String get meetupsStepDisputed => 'ข้อขัดแย้ง';

  @override
  String get meetupsCantLoadData => 'ไม่สามารถโหลดข้อมูล';

  @override
  String get meetupsCantPerform => 'ไม่สามารถดำเนินการได้';

  @override
  String get meetupsSectionDateTime => 'วันที่และเวลา';

  @override
  String get meetupsSectionLocation => 'สถานที่นัดพบ';

  @override
  String get meetupsSectionServices => 'บริการ';

  @override
  String get meetupsMapLink => 'แผนที่ ›';

  @override
  String get meetupsPriceSummary => 'สรุปราคา';

  @override
  String get meetupsPriceTotal => 'รวมทั้งหมด';

  @override
  String get meetupsYourReview => 'คำวิจารณ์ของคุณ';

  @override
  String meetupsYouRated(String name) {
    return 'คุณให้คะแนน $name';
  }

  @override
  String get meetupsProgress => 'ความคืบหน้า';

  @override
  String get meetupsCancellationPolicy => 'นโยบายยกเลิก';

  @override
  String get meetupsCancelBefore => 'ยกเลิกก่อน ';

  @override
  String get meetupsWillRefund => ' จะได้คืน ';

  @override
  String get meetupsWithin24h => ' ภายใน 24 ชม.';

  @override
  String get meetupsActionMessage => 'ข้อความ';

  @override
  String get meetupsActionCall => 'โทร';

  @override
  String get meetupsActionCancel => 'ยกเลิก';

  @override
  String get meetupsActionShare => 'แชร์';

  @override
  String get meetupsActionReport => 'รายงาน';

  @override
  String get meetupsActionConfirmShort => 'ยืนยัน';

  @override
  String get meetupsSnackPleaseTitle => 'กรุณา';

  @override
  String get loginRoleCustomerLabel => 'ลูกค้า';

  @override
  String get loginRoleCustomerSub => 'ค้นหาและจองบริการ';

  @override
  String get loginRoleCompanionLabel => 'ผู้ให้บริการ';

  @override
  String get loginRoleCompanionSub => 'โพสต์บริการและรับการจอง';

  @override
  String get forgotTitle => 'ลืมรหัสผ่าน';

  @override
  String get forgotEnterRegistered => 'ใส่เบอร์โทรที่ลงทะเบียน';

  @override
  String get forgotOtpWillSendHere => 'รหัส OTP จะถูกส่งไปยังเบอร์นี้';

  @override
  String get forgotSendOtp => 'ส่งรหัส OTP';

  @override
  String get forgotBackToLogin => 'กลับไปหน้าเข้าสู่ระบบ';

  @override
  String get forgotIdentityVerifyTitle => 'ยืนยันตัวตน';

  @override
  String get forgotSetNewPasswordTitle => 'ตั้งรหัสผ่านใหม่';

  @override
  String get forgotSetNewPasswordSubtitle => 'ตั้งรหัสผ่านใหม่ที่ปลอดภัย';

  @override
  String get forgotSavePassword => 'บันทึกรหัสผ่าน';

  @override
  String get forgotStepPhone => 'โทรศัพท์';

  @override
  String get forgotConfirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get feedbackTitle => 'คำติชม';

  @override
  String get feedbackSubtitle => 'ส่งความคิดเห็นหรือรายงานปัญหา';

  @override
  String get feedbackSendNew => 'ส่งคำติชมใหม่';

  @override
  String get feedbackMine => 'คำติชมของฉัน';

  @override
  String get feedbackTypeLabel => 'ประเภท';

  @override
  String get feedbackTypeHint => 'เลือกประเภทคำติชม';

  @override
  String get feedbackSubjectLabel => 'หัวข้อ';

  @override
  String get feedbackSubjectHint => 'ใส่หัวข้อคำติชม...';

  @override
  String get feedbackDescLabel => 'รายละเอียด';

  @override
  String get feedbackDescHint => 'อธิบายรายละเอียดเพิ่มเติม...';

  @override
  String get feedbackDescMinLength => 'กรุณาใส่รายละเอียดอย่างน้อย 10 ตัวอักษร';

  @override
  String get feedbackSubmit => 'ส่งคำติชม';

  @override
  String get feedbackSubmitFailed => 'ส่งคำติชมไม่สำเร็จ';

  @override
  String get feedbackEmptyTitle => 'ยังไม่มีคำติชม';

  @override
  String get feedbackEmptySubtitle => 'ส่งคำติชมของคุณด้านบน';

  @override
  String get feedbackStatusResolved => 'แก้ไขแล้ว';

  @override
  String get feedbackTypeBug => 'ข้อผิดพลาด (Bug)';

  @override
  String get feedbackTypeFeature => 'ข้อเสนอ (Feature)';

  @override
  String get feedbackTypeGeneral => 'ทั่วไป (General)';

  @override
  String get feedbackTypePayment => 'ปัญหาการชำระ (Payment)';

  @override
  String get feedbackTypePerformance => 'ประสิทธิภาพ (Performance)';

  @override
  String get feedbackTypeOther => 'อื่นๆ (Other)';

  @override
  String get dashboardTabChat => 'คู่แชท';

  @override
  String get dashboardTabPosts => 'โพสต์หาคู่';

  @override
  String get reviewRatingRequired => 'กรุณาให้คะแนน';

  @override
  String get reviewTextRequired => 'กรุณาเขียนรีวิว';

  @override
  String get reviewSubmitSuccess => 'ส่งรีวิวสำเร็จ';

  @override
  String get reviewSubmitFailed => 'ส่งรีวิวไม่สำเร็จ';

  @override
  String get reviewWriteTitle => 'เขียนรีวิว';

  @override
  String reviewForCompanion(String name) {
    return 'สำหรับ $name';
  }

  @override
  String get reviewGiveRating => 'ให้คะแนน';

  @override
  String get reviewSubjectLabel => 'หัวข้อ (ทางเลือก)';

  @override
  String get reviewSubjectHint => 'ใส่หัวข้อรีวิว...';

  @override
  String get reviewYourReview => 'รีวิวของคุณ';

  @override
  String get reviewShareHint => 'แบ่งปันประสบการณ์ของคุณ...';

  @override
  String get reviewSubmit => 'ส่งรีวิว';

  @override
  String get reviewRatingBad => 'ไม่ดี';

  @override
  String get reviewRatingOk => 'พอใช้ได้';

  @override
  String get reviewRatingGood => 'ดี';

  @override
  String get reviewRatingVeryGood => 'ดีมาก';

  @override
  String get reviewRatingExcellent => 'ยอดเยี่ยม!';

  @override
  String get reviewRatingPick => 'เลือกคะแนน';

  @override
  String get cpRatingsSection => 'คะแนนและรีวิว';

  @override
  String get cpStatusAvailable => 'รับจอง';

  @override
  String get cpStatusUnavailable => 'ไม่รับจอง';

  @override
  String get cpStatusLabel => 'การจอง';

  @override
  String get cpNoServicesNow => 'ไม่มีบริการในขณะนี้';

  @override
  String get cpNoReviewsBeFirst => 'ยังไม่มีรีวิว เป็นคนแรก!';

  @override
  String get cpLoadMoreReviews => 'โหลดรีวิวเพิ่ม';

  @override
  String cpReviewsCount(int count) {
    return '$count รีวิว';
  }

  @override
  String get cpOnline => 'ออนไลน์';

  @override
  String get cpStatReviews => 'รีวิว';

  @override
  String get cpStatFollowers => 'ติดตาม';

  @override
  String get cpAnonymous => 'นิรนาม';

  @override
  String get cpBookNow => 'จองเลย';

  @override
  String get chatTitle => 'สนทนา';

  @override
  String chatNewMessages(int count) {
    return '$count ข้อความใหม่';
  }

  @override
  String get chatSearchHint => 'ค้นหา...';

  @override
  String get chatFallbackName => 'การสนทนานี้';

  @override
  String get chatDeleteConvTitle => 'ลบการสนทนา';

  @override
  String chatDeleteConvMessage(String name) {
    return 'ลบการสนทนากับ $name?\nข้อความยังคงมองเห็นได้จากอีกฝ่าย';
  }

  @override
  String get chatCantEnter => 'ไม่สามารถเข้าได้';

  @override
  String get chatBlockedByYou => 'คุณได้บล็อกการสนทนานี้';

  @override
  String get chatBlockedByOther => 'การสนทนานี้ถูกบล็อก';

  @override
  String chatUnblockName(String name) {
    return 'ยกเลิกการบล็อก $name';
  }

  @override
  String chatBlockName(String name) {
    return 'บล็อก $name';
  }

  @override
  String get chatUnblockConfirmMsg => 'ยกเลิกการบล็อกและสนทนาต่อ?';

  @override
  String chatBlockConfirmMsg(String name) {
    return 'คุณและ $name จะไม่สามารถส่งข้อความหากันได้';
  }

  @override
  String get chatUnblock => 'ยกเลิกการบล็อก';

  @override
  String get chatBlock => 'บล็อก';

  @override
  String get chatEmpty => 'ไม่พบการสนทนา';

  @override
  String get chatConversationBlocked => 'การสนทนาถูกบล็อก';

  @override
  String get chatTyping => 'กำลังพิมพ์...';

  @override
  String get chatOffline => 'ออฟไลน์';

  @override
  String get chatSelectedImage => 'รูปภาพที่เลือก';

  @override
  String get chatInputHint => 'พิมพ์ข้อความ...';

  @override
  String get chatSendFailed => 'ส่งไม่สำเร็จ';

  @override
  String get chatSendPleaseRetry => 'กรุณาลองใหม่';

  @override
  String get chatDateToday => 'วันนี้';

  @override
  String get chatDeleteMsgTitle => 'ลบข้อความ';

  @override
  String get chatDeleteMsgBody =>
      'ข้อความจะถูกลบออกจากฝ่ายของคุณเท่านั้น\nอีกฝ่ายยังคงเห็นข้อความได้';

  @override
  String get chatImagePrefix => '📷 รูปภาพ';

  @override
  String get bookingLabelDate => 'วันที่';

  @override
  String get bookingHoursCount => 'จำนวนรอบ';

  @override
  String bookingHoursValue(int hours) {
    return '$hours รอบ';
  }

  @override
  String bookingHoursShortValue(int hours) {
    return '$hours รอบ';
  }

  @override
  String get bookingTotalPriceShort => 'ราคารวม';

  @override
  String get bookingGoToMeetups => 'ไปหน้าการนัดพบ';

  @override
  String get bookingSuccessTitle => 'จองสำเร็จ!';

  @override
  String get bookingSuccessBody => 'การจองของคุณได้รับแล้ว';

  @override
  String get bookingUnitNight => 'คืน';

  @override
  String get bookingDateDeparture => 'วันเดินทาง';

  @override
  String get bookingDateReturn => 'วันกลับ';

  @override
  String get bookingDatePlaceholder => 'วัน/เดือน/ปี';

  @override
  String get bookingLocationHint => 'ใส่ที่อยู่หรือสถานที่...';

  @override
  String get bookingAttireLabel => 'การแต่งกายที่ต้องการ';

  @override
  String get bookingAttireHint => 'ตัวอย่าง: แต่งตัวเซ็กซี่ (ทางเลือก)';

  @override
  String get bookingTipService => 'ทิป / บริการ';

  @override
  String bookingAddTipTo(String name) {
    return 'เพิ่มทิปให้ $name';
  }

  @override
  String bookingRatePerUnit(String rate, String unit) {
    return '$rate กีบ / $unit';
  }

  @override
  String bookingRatePerHour(String rate) {
    return '$rate กีบ / รอบ';
  }

  @override
  String bookingRatePerHourShort(String rate) {
    return '$rate กีบ / รอบ';
  }

  @override
  String bookingCountUnit(String unit) {
    return 'จำนวน$unit';
  }

  @override
  String get bookingSelectTime => 'เลือกเวลา';

  @override
  String get bookingSlotBooked => 'จองแล้ว';

  @override
  String get bookingSelectMassageType => 'เลือกประเภทนวด';

  @override
  String bookingVariantsCount(int count) {
    return '$count ประเภท';
  }

  @override
  String get bookingDateAppointment => 'วันที่นัดหมาย';

  @override
  String get bookingTimeMeeting => 'เวลาพบกัน';

  @override
  String get bookingTimeFormat => 'ชั่วโมง:นาที';

  @override
  String get bookingSelectPlaceholder => 'เลือก';

  @override
  String get bookingMassageTypeLabel => 'ประเภทนวด';

  @override
  String get bookingSelectVariant => 'เลือกประเภท';

  @override
  String get bookingCreationFailed => 'การจองล้มเหลว';

  @override
  String get shareTitle => 'ชวนเพื่อน';

  @override
  String get shareAppbarSubtitle => 'แชร์ลิงก์และเพิ่มรายได้ของคุณ';

  @override
  String get shareSubtitleGeneral => 'รับ 10,000 กีบ ต่อการแนะนำ';

  @override
  String get shareSubtitleCommission => 'รับค่าคอมมิชชั่นจากการแนะนำ';

  @override
  String get shareTierGeneral => 'ทั่วไป';

  @override
  String get shareTierSpecial => 'พิเศษ';

  @override
  String get shareTierPartner => 'พาร์ทเนอร์';

  @override
  String shareTierBadge(String tier) {
    return 'ระดับ $tier';
  }

  @override
  String get shareTabModel => 'ลิงก์แนะนำโมเดล';

  @override
  String get shareTabCustomer => 'ลิงก์แนะนำลูกค้า';

  @override
  String get shareLinkModelDesc => 'แชร์ลิงก์นี้ให้เพื่อนที่ต้องการเป็นโมเดล';

  @override
  String get shareLinkCustomerDesc => 'แชร์ลิงก์นี้ให้ลูกค้าสมัครสมาชิก';

  @override
  String get shareCopy => 'คัดลอก';

  @override
  String get shareCopied => 'คัดลอกแล้ว';

  @override
  String get shareShareLink => 'แชร์';

  @override
  String get shareViewQr => 'QR';

  @override
  String get shareStatsModels => 'โมเดลที่แนะนำ';

  @override
  String get shareStatsCustomers => 'ลูกค้าที่แนะนำ';

  @override
  String get shareStatsCommission => 'ค่าคอมมิชชั่น';

  @override
  String get shareStatsTotal => 'รายได้รวม';

  @override
  String get shareCommissionsTitle => 'ประวัติค่าคอมมิชชั่น';

  @override
  String get shareCommissionsEmpty => 'ยังไม่มีค่าคอมมิชชั่น';

  @override
  String get shareCommissionsEmptySub =>
      'ค่าคอมมิชชั่นจากลูกค้าหรือโมเดลที่คุณแนะนำจะแสดงที่นี่';

  @override
  String get shareLearnMore => 'เรียนรู้เพิ่มเติมเกี่ยวกับระดับ';

  @override
  String get shareProgressToNext => 'ความคืบหน้าสู่ระดับต่อไป';

  @override
  String shareUpgradeToSpecialRemaining(int n) {
    return 'อีก $n คน ถึงจะได้ระดับพิเศษ';
  }

  @override
  String shareUpgradeToPartnerRemainingModels(int n) {
    return 'อีก $n คน ถึงจะได้ระดับพาร์ทเนอร์';
  }

  @override
  String shareUpgradeToPartnerRemainingEarnings(String amount) {
    return 'อีก $amount กีบ ถึงจะได้ระดับพาร์ทเนอร์';
  }

  @override
  String get shareTierMaxed => 'คุณได้ระดับสูงสุดแล้ว';

  @override
  String get shareCurrentTier => 'ระดับปัจจุบัน';

  @override
  String shareEarnPerReferral(String amount) {
    return 'รับ $amount กีบ / คน';
  }

  @override
  String get shareInviteMessage => 'สมัคร Xaosao ผ่านลิงก์ของฉัน!';

  @override
  String get shareInviteSubject => 'เข้าร่วม Xaosao';

  @override
  String get appName => 'Xaosao';

  @override
  String bookingThankYouFor(String appName) {
    return 'ขอบคุณที่ใช้บริการผ่าน $appName';
  }

  @override
  String bookingSupportContact(String phone) {
    return 'สอบถามเพิ่มเติม โทร $phone';
  }

  @override
  String get shareCommissionReferral => 'การแนะนำ';

  @override
  String get shareQrBrandName => 'xaosao — เพื่อนสาว';

  @override
  String get shareQrBrandTagline =>
      'แหล่งรวมเพื่อนสาวคุณภาพ พร้อมอยู่เคียงข้างคุณเสมอ';

  @override
  String get shareQrDownload => 'ดาวน์โหลด QR';

  @override
  String get shareQrPermissionDenied => 'โปรดอนุญาตการเข้าถึงคลังรูปภาพ';

  @override
  String get shareQrSaved => 'บันทึก QR ลงคลังรูปภาพแล้ว';

  @override
  String get shareQrSaveFailed => 'ไม่สามารถบันทึกได้ กรุณาลองใหม่';

  @override
  String get shareQrErrorGeneric => 'เกิดข้อผิดพลาด กรุณาลองใหม่';

  @override
  String get analyticsTitle => 'การวิเคราะห์การแนะนำ';

  @override
  String get analyticsSubtitle => 'สถิติและรายได้ของคุณ';

  @override
  String get analyticsLoadFailed => 'โหลดข้อมูลไม่สำเร็จ';

  @override
  String get analyticsRetry => 'ลองใหม่';

  @override
  String get analyticsReferralStats => 'สถิติการแนะนำ';

  @override
  String get analyticsReferrals => 'การแนะนำ';

  @override
  String get analyticsEarnings => 'รายได้';

  @override
  String get analyticsTierProgress => 'ความคืบหน้าระดับ';

  @override
  String get analyticsModels => 'โมเดล';

  @override
  String get analyticsCustomers => 'ลูกค้า';

  @override
  String get analyticsBookings => 'การจอง';

  @override
  String get analyticsSubscriptions => 'Package';

  @override
  String get analyticsApproved => 'อนุมัติ';

  @override
  String get analyticsPending => 'รอ';

  @override
  String get analyticsActive => 'ใช้งาน';

  @override
  String get analyticsInactive => 'ไม่ใช้';

  @override
  String get analyticsTotal => 'ทั้งหมด';

  @override
  String get analyticsTotalEarnings => 'รายได้ทั้งหมด';

  @override
  String get analyticsModelEarnings => 'รายได้จากโมเดล';

  @override
  String get analyticsCommission => 'ค่าคอมมิชชั่น';

  @override
  String get analyticsEarningsByType => 'รายได้แต่ละประเภท';

  @override
  String get analyticsAllModels => 'โมเดลทั้งหมด';

  @override
  String get analyticsApprovedModels => 'โมเดลที่อนุมัติ';

  @override
  String get analyticsAllCustomers => 'ลูกค้าทั้งหมด';

  @override
  String get analyticsActiveCustomers => 'ลูกค้าที่ใช้งาน';

  @override
  String get analyticsReady => 'พร้อมแล้ว!';

  @override
  String analyticsSpecialCondition(int n) {
    return 'แนะนำโมเดลให้ครบ $n คน';
  }

  @override
  String get analyticsPartnerCondition => 'ต้องมีทั้งโมเดลและรายได้';

  @override
  String get snackbarErrorTitle => 'ผิดพลาด';

  @override
  String get snackbarSuccessTitle => 'สำเร็จ';

  @override
  String get snackbarInfoTitle => 'ข้อมูล';

  @override
  String get qrLoadFailed => 'โหลด QR ไม่สำเร็จ';

  @override
  String get imagePickerTitle => 'เลือกรูปโปรไฟล์';

  @override
  String get imagePickerGallery => 'คลังรูปภาพ';

  @override
  String get imagePickerCamera => 'กล้องถ่ายรูป';

  @override
  String get serviceUnitHour => '/รอบ';

  @override
  String get serviceUnitDay => '/วัน';

  @override
  String get serviceUnitNight => '/คืน';

  @override
  String get serviceUnitOnce => 'ครั้งเดียว';

  @override
  String get serviceUnitMinute => '/นาที';

  @override
  String get phoneRequired => 'โปรดกรอกเบอร์โทร';

  @override
  String get phoneMustStartWith20 => 'เบอร์โทรต้องขึ้นต้นด้วย 20';

  @override
  String get phonePrefixInvalid => 'ต้องเป็น: 202, 205, 206, 207 หรือ 209';

  @override
  String phoneLength(int n) {
    return 'เบอร์โทรต้องมี $n หลัก';
  }

  @override
  String get deepLinkShareSelf => 'ดูโปรไฟล์ของฉันบน Xaosao';

  @override
  String deepLinkShareOther(String name) {
    return 'ดูโปรไฟล์ของ $name บน Xaosao';
  }

  @override
  String get dateToday => 'วันนี้';

  @override
  String get dateYesterday => 'เมื่อวาน';

  @override
  String get commonSearch => 'ค้นหา...';

  @override
  String get commonPasswordHint => 'รหัสผ่าน';

  @override
  String get commonImageLoadFailed => 'โหลดรูปไม่ได้';

  @override
  String get walletBalanceShort => 'ยอดกระเป๋า';

  @override
  String get updateRequiredTitle => 'จำเป็นต้องอัปเดตแอป';

  @override
  String get updateAvailableTitle => 'อัปเดตแอปเวอร์ชันใหม่พร้อมแล้ว!';

  @override
  String get updateRequiredBody =>
      'โปรดอัปเดตเป็นเวอร์ชันล่าสุดเพื่อใช้ Xaosao ต่อ';

  @override
  String get updateAvailableBody =>
      'เราได้ปรับปรุงแอปให้ดีขึ้น — อัปเดตเลยเพื่อประสบการณ์ที่ดีที่สุด';

  @override
  String get updateNow => 'อัปเดตเดี๋ยวนี้';

  @override
  String get updateLater => 'ภายหลัง';

  @override
  String get updateCurrentVersion => 'เวอร์ชันปัจจุบัน';

  @override
  String get updateNewVersion => 'เวอร์ชันใหม่';

  @override
  String get updateWhatsNew => 'มีอะไรใหม่';

  @override
  String get giftSheetTitle => '🎁 ส่งของขวัญ';

  @override
  String giftSheetPickFor(String name) {
    return 'เลือกของขวัญให้ $name';
  }

  @override
  String get giftEmpty => 'ไม่มีของขวัญในขณะนี้';

  @override
  String get giftPickFirst => 'โปรดเลือกของขวัญก่อน';

  @override
  String get giftSendFailed => 'ส่งของขวัญไม่สำเร็จ';

  @override
  String get giftSendSuccess => 'ส่งของขวัญสำเร็จ!';

  @override
  String giftSendButton(String name, String price) {
    return 'ส่ง $name · $price';
  }

  @override
  String get tiersTitle => 'ระดับ Referral โมเดล';

  @override
  String get tiersSubtitle => 'เรียนรู้วิธีเพิ่มรายได้ของคุณ';

  @override
  String get tiersOverview => 'ลิงก์ Referral ของโมเดล แบ่งออกเป็น 3 ระดับ';

  @override
  String get tiersLevel1Title => 'ระดับทั่วไป';

  @override
  String get tiersLevel1Desc =>
      'แสดงเฉพาะลิงก์แนะนำให้กับโมเดลด้วยกันเท่านั้น และรับเฉพาะเงินแนะนำ 10,000 กีบ/คน (ไม่มีเงื่อนไข ทุกคนที่เป็นโมเดลทำได้)';

  @override
  String get tiersLevel2Title => 'ระดับพิเศษ';

  @override
  String get tiersLevel2Condition => 'ต้องมีผู้แนะนำมากกว่า 5 คน';

  @override
  String get tiersLevel2Links =>
      'จะมีลิงก์แนะนำ 2 ลิงก์: ลิงก์แนะนำลูกค้า และลิงก์แนะนำโมเดลด้วยกัน';

  @override
  String get tiersLevel2Benefit =>
      'ไม่ได้รับเงิน 10,000 กีบ แต่จะได้เป็นเปอร์เซ็นต์แทน เช่น: 20% ของลูกค้าซื้อ Wallet Package, 2% ของผู้ให้บริการที่ตัวเองแนะนำเวลามีคนจอง';

  @override
  String get tiersLevel3Title => 'ระดับพาร์ทเนอร์';

  @override
  String get tiersLevel3Condition =>
      'ต้องมีผู้แนะนำมากกว่า 5 คนขึ้นไป และรายได้รวมของค่าคอมมิชชั่นที่ได้จาก Wallet Package ของลูกค้าและลูกค้าจองผู้ให้บริการที่แนะนำ 1,000,000 กีบ';

  @override
  String get tiersLevel3Links =>
      'จะมีลิงก์แนะนำ 2 ลิงก์: ลิงก์แนะนำลูกค้า และลิงก์แนะนำผู้ให้บริการด้วยกัน';

  @override
  String get tiersLevel3Benefit =>
      'ไม่ได้รับเงิน 10,000 กีบ แต่จะได้เป็นเปอร์เซ็นต์แทน เช่น: 40% ของลูกค้าซื้อ Wallet Package, 4% ของผู้ให้บริการที่ตัวเองแนะนำเวลามีคนจอง';

  @override
  String get tiersConditionLabel => 'เงื่อนไข';

  @override
  String get tiersBenefitLabel => 'ผลประโยชน์ที่จะได้รับ';

  @override
  String get tiersLinksLabel => 'ลิงก์แนะนำ';

  @override
  String get tiersCurrentBadge => 'ระดับปัจจุบันของคุณ';

  @override
  String get tiersLockedNote => 'ยังไม่ถึงระดับ';
}
