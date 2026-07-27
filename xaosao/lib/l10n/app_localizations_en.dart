// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get english => 'English';

  @override
  String get lao => 'ພາສາລາວ';

  @override
  String get thai => 'ภาษาไทย';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Choose the language you want to use';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonLater => 'Later';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonError => 'Something went wrong, please try again';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonBack => 'Back';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get profileInfoSection => 'Information';

  @override
  String get profileSecuritySection => 'Security';

  @override
  String get profileSettingsSection => 'Settings';

  @override
  String get profileHelpSection => 'Help';

  @override
  String get profilePersonalInfo => 'Personal information';

  @override
  String get profilePersonalInfoSubtitle => 'Name, surname, date of birth';

  @override
  String get profileFinance => 'Financial information';

  @override
  String get profileFinanceSubtitle => 'Bank account, credit card, transfers';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get profileVerifyPhone => 'Verify phone number';

  @override
  String get profileVerifiedBadge => 'Verified';

  @override
  String get profileVerifiedIdentity => 'Identity verified';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileNotificationsSubtitle => 'Push, email, SMS, WhatsApp';

  @override
  String get profileHelpFaq => 'Help / FAQ';

  @override
  String get profileFeedback => 'Feedback';

  @override
  String get profileFeedbackSubtitle => 'Report an issue or share suggestions';

  @override
  String get profileTerms => 'Terms & Policies';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteAccountSubtitle => 'This action cannot be undone';

  @override
  String get profileDeleteAccountShortSubtitle => 'Cannot be undone';

  @override
  String get profileLogout => 'Log out';

  @override
  String profileAppVersion(String version) {
    return 'XAOSAO v$version';
  }

  @override
  String get profilePhotos => 'Photos';

  @override
  String profilePhotosCount(int count, int max) {
    return 'Photos ($count/$max)';
  }

  @override
  String profilePhotosMissingWarning(int max, int missing) {
    return 'Need $max photos in total — $missing more to go';
  }

  @override
  String get profileMyServices => 'My services';

  @override
  String get profileMyQr => 'My QR';

  @override
  String get profileStatLikes => 'Likes';

  @override
  String get profileStatFriends => 'Friends';

  @override
  String get profileStatReferrals => 'Referrals';

  @override
  String get profileStatBookings => 'Bookings';

  @override
  String get profileHiddenEnabled =>
      'Your profile is hidden — customers can\'t see you';

  @override
  String get profileHiddenDisabled =>
      'Hide your profile from customers. You can toggle this at any time.';

  @override
  String get customerProfileBuyPackage => 'Buy a package';

  @override
  String get customerProfileBuyPackageSubtitle =>
      'Hourly, daily and monthly plans';

  @override
  String get customerProfileTopupHistory => 'Top-up history';

  @override
  String get walletBalanceTitle => 'Wallet balance';

  @override
  String get walletTopup => 'Top up';

  @override
  String get walletHistory => 'History';

  @override
  String get confirmLogoutTitle => 'Log out';

  @override
  String get confirmLogoutMessage => 'Are you sure you want to log out?';

  @override
  String get confirmLogoutConfirm => 'Log out';

  @override
  String get confirmDeleteTitle => 'Delete account';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete your account?\nAll data will be permanently removed and cannot be recovered.';

  @override
  String get commonGenericError => 'Something went wrong! Please try again.';

  @override
  String get commonActionFailed => 'Action could not be completed';

  @override
  String get commonLoadDataFailed => 'Failed to load data';

  @override
  String get commonAddFailed => 'Failed to add';

  @override
  String get commonUpdateFailed => 'Failed to update';

  @override
  String get commonDeleteFailed => 'Delete failed';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registerLoadServicesFailed => 'Failed to load services';

  @override
  String get registerSelectProfilePhoto => 'Please select a profile photo';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get registerInvalidOtp => 'Invalid OTP';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get registerVerifyOtpFailed => 'OTP verification failed';

  @override
  String get registerResendOtpFailed => 'Failed to resend OTP';

  @override
  String get registerResendOtpSuccess => 'A new OTP has been sent';

  @override
  String get meetUpsCancelSuccess => 'Booking cancelled';

  @override
  String get meetUpsReleasePaymentSuccess => 'Payment released';

  @override
  String get meetUpsDisputeSuccess => 'Request submitted';

  @override
  String get meetUpsConfirmSuccess => 'Booking confirmed';

  @override
  String get meetUpsRejectSuccess => 'Booking rejected';

  @override
  String get meetUpsReceiveMoneySuccess => 'Payment received';

  @override
  String get meetUpsDeleteSuccess => 'Item deleted';

  @override
  String get postsFeedLoadFailed => 'Failed to load feed';

  @override
  String get postsMyLoadFailed => 'Failed to load your posts';

  @override
  String get postsCreateSuccess => 'Post created';

  @override
  String get postsCreateFailed => 'Failed to create post';

  @override
  String get postsDisableSuccess => 'Post disabled';

  @override
  String get postsDisableFailed => 'Failed to disable post';

  @override
  String get postsDeleteSuccess => 'Post deleted';

  @override
  String get postsDeleteFailed => 'Failed to delete post';

  @override
  String get authWelcome => 'Welcome 👋';

  @override
  String get authRolePrompt => 'How do you want to sign in?';

  @override
  String get authTagline => 'Your companion, everywhere, anytime';

  @override
  String get authRoleCustomer => 'Customer';

  @override
  String get authRoleCompanion => 'Companion';

  @override
  String get authFieldPhone => 'Phone number';

  @override
  String get authFieldPassword => 'Password';

  @override
  String get authHintPassword => 'Password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authLoginButton => 'Log in';

  @override
  String get authCreateCustomerAccount => 'Create a customer account';

  @override
  String get authCreateCompanionAccount => 'Create a companion account';

  @override
  String get authValidPhoneRequired => 'Please enter a valid phone number';

  @override
  String get authPasswordRequired => 'Please enter your password';

  @override
  String get commonCurrencyKip => 'Kip';

  @override
  String get monthShortJan => 'Jan';

  @override
  String get monthShortFeb => 'Feb';

  @override
  String get monthShortMar => 'Mar';

  @override
  String get monthShortApr => 'Apr';

  @override
  String get monthShortMay => 'May';

  @override
  String get monthShortJun => 'Jun';

  @override
  String get monthShortJul => 'Jul';

  @override
  String get monthShortAug => 'Aug';

  @override
  String get monthShortSep => 'Sep';

  @override
  String get monthShortOct => 'Oct';

  @override
  String get monthShortNov => 'Nov';

  @override
  String get monthShortDec => 'Dec';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletSubtitle => 'Balance & history';

  @override
  String get walletFilterAll => 'All';

  @override
  String get walletFilterPending => 'Pending';

  @override
  String get walletFilterApproved => 'Approved';

  @override
  String get walletFilterRejected => 'Rejected';

  @override
  String get walletRechargeHistory => 'Top-up history';

  @override
  String get walletEmptyTitle => 'No transactions yet';

  @override
  String get walletEmptySubtitle =>
      'Your top-up transactions\nwill appear here';

  @override
  String get walletTxStatusCompleted => 'Completed';

  @override
  String get walletTxStatusPending => 'Pending';

  @override
  String get walletTxStatusProcessing => 'Processing';

  @override
  String get walletTxStatusCancelled => 'Cancelled';

  @override
  String walletBalanceUpdated(String time) {
    return 'Balance, updated $time';
  }

  @override
  String get walletUsed => 'Spent';

  @override
  String get walletTxTypeRecharge => 'Top-up';

  @override
  String get walletTxTypeSubscription => 'Package purchase';

  @override
  String get walletTxTypeGift => 'Sent gift';

  @override
  String get walletTxTypeBookingHold => 'Booking deposit';

  @override
  String get walletTxTypeBookingRefund => 'Booking refund';

  @override
  String get walletTxTypeGiftEarning => 'Received gift';

  @override
  String get walletTxTypeBookingEarning => 'Booking earning';

  @override
  String get walletTxTypeWithdrawal => 'Withdrawal';

  @override
  String get walletTxTypeReferral => 'Referral bonus';

  @override
  String get walletTxTypeBookingReferral => 'Referral bonus (booking)';

  @override
  String get walletTxTypeSubscriptionReferral => 'Referral bonus (Package)';

  @override
  String get walletTxTypeGeneric => 'Transaction';

  @override
  String get commonNext => 'Next';

  @override
  String get commonAmount => 'Amount';

  @override
  String get commonDate => 'Date';

  @override
  String commonErrorDetail(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get topupAmountSubtitle => 'Choose or enter an amount';

  @override
  String get topupOther => 'Other';

  @override
  String get topupCustomAmount => 'Custom';

  @override
  String get topupOrEnterYourself => 'Or enter manually';

  @override
  String get topupEnterAmount => 'Enter amount';

  @override
  String get topupQrLoadFailed => 'Could not load QR';

  @override
  String get topupPackageFailed => 'Package purchase failed';

  @override
  String get topupSlipUploadFailed => 'Could not send payment slip';

  @override
  String get topupUploadTitle => 'Upload Slip';

  @override
  String get topupUploadSubtitle => 'Confirm payment';

  @override
  String get topupUploadFileTypes => 'Supported: JPG, PNG, PDF (max 10MB)';

  @override
  String get topupUploadSubmit => 'Send & confirm';

  @override
  String get topupUploadReceipt => 'Upload payment receipt';

  @override
  String get topupUploadReceiptSubtitle =>
      'You can upload your confirmation here';

  @override
  String get topupSelectFile => 'Choose file';

  @override
  String get topupAddMoreSlip => 'Add more slips';

  @override
  String get topupExampleReceipt => 'Sample payment receipt';

  @override
  String get topupThankYouMessage =>
      'Thanks for your trust: our team will review and process within 1–2 hours. You\'ll get a confirmation afterwards.';

  @override
  String get topupBackToWallet => 'Back to wallet';

  @override
  String get topupSuccessTitle => 'Top-up submitted!';

  @override
  String get topupSuccessSubtitle => 'Waiting for admin review';

  @override
  String get topupWaitingReview => 'Awaiting review';

  @override
  String get topupQrTitle => 'Scan QR';

  @override
  String get topupQrSubtitle => 'Pay via your bank app';

  @override
  String get topupQrPaidUploadSlip => 'Paid — upload slip';

  @override
  String get topupQrAmountToPay => 'Amount to pay';

  @override
  String get topupQrInstructions =>
      'Scan the QR with your bank app,\nthen tap \"Paid\" to upload the slip';

  @override
  String get topupQrSaving => 'Saving...';

  @override
  String get topupQrDownload => 'Download QR';

  @override
  String get commonAll => 'All';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonPleaseRetry => 'Please try again';

  @override
  String get serviceTypeSocial => 'Social';

  @override
  String get serviceTypeMassage => 'Massage';

  @override
  String get serviceTypeTravel => 'Travel';

  @override
  String get viewCompanionPageTitle => 'All companions';

  @override
  String get viewCompanionFilterLikedByMe => 'Liked by me';

  @override
  String get viewCompanionFilterWhoLikedMe => 'Likes me';

  @override
  String get viewCompanionFilterNearby => 'Nearby';

  @override
  String get viewCompanionFilterNew => 'New';

  @override
  String get viewCompanionFilterPopular => 'Popular';

  @override
  String get viewCompanionEmptyTitle => 'No results';

  @override
  String get viewCompanionEmptySubtitle => 'Try a different filter or search';

  @override
  String get viewCompanionSearchHint => 'Search by name...';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get homeSearch => 'Search';

  @override
  String get homeFindCompanion => 'Find your companion';

  @override
  String get homeSearchHint => 'Search by name...';

  @override
  String get homeOnlineNow => 'Online now';

  @override
  String get homeRecommended => 'Recommended for you';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeNoResults => 'No results found';

  @override
  String get homeTryFilter => 'Try a different filter';

  @override
  String get homeFilters => 'Filters';

  @override
  String get homeMaxDistance => 'Max distance';

  @override
  String get homeApplyFilter => 'Apply filter';

  @override
  String get homeFilterNearby => 'Nearby';

  @override
  String get homeServiceSocial => 'Social companion';

  @override
  String get homeServiceTravel => 'Travel companion';

  @override
  String get homeCardSubtitleSocial => 'Trips, parties, any occasion';

  @override
  String get homeCardSubtitleMassage => 'Professional wellness massage';

  @override
  String get homeCardSubtitleTravel => 'Local & international guides';

  @override
  String get homeLoadRecommendationsFailed => 'Failed to load recommendations';

  @override
  String get homeLoadOnlineFailed => 'Failed to load online users';

  @override
  String commonAgeYears(int years) {
    return '$years yr';
  }

  @override
  String commonHours(int hours) {
    return '$hours hr';
  }

  @override
  String commonDays(int days) {
    return '$days d';
  }

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonPleaseTitle => 'Please';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusConfirmedShort => 'Accepted';

  @override
  String get bookingStatusInProgress => 'In progress';

  @override
  String get bookingStatusAwaitingConfirmation => 'Awaiting confirmation';

  @override
  String get bookingStatusAwaitingConfirmationShort => 'Awaiting confirmation';

  @override
  String get bookingStatusCompletedFull => 'Completed';

  @override
  String get bookingStatusCancelledFull => 'Cancelled';

  @override
  String get bookingStatusRejected => 'Rejected';

  @override
  String get bookingStatusDisputed => 'Disputed';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusPending => 'Awaiting payment';

  @override
  String get paymentStatusReleased => 'Released';

  @override
  String get paymentStatusRefunded => 'Refunded';

  @override
  String get meetUpsTitle => 'Meet-ups';

  @override
  String get meetUpsAllHistory => 'All booking history';

  @override
  String meetUpsItemsWithStatus(int count, String status) {
    return '$count items · $status';
  }

  @override
  String get meetUpsEmptyTitle => 'No items';

  @override
  String get meetUpsEmptySubtitle => 'Your bookings will appear here';

  @override
  String get meetUpsLoadMore => 'Load more';

  @override
  String get bookingDetailTitle => 'Booking details';

  @override
  String get bookingLocation => 'Location';

  @override
  String get bookingPhone => 'Phone number';

  @override
  String get bookingTip => 'Tip';

  @override
  String get bookingTipReady => 'Tip ready';

  @override
  String get bookingAttire => 'Attire';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get bookingCreatedAt => 'Booked at';

  @override
  String get bookingNoName => 'No name';

  @override
  String get bookingTotalPrice => 'Total price';

  @override
  String get bookingActionChat => 'Chat';

  @override
  String get bookingActionReleasePayment => 'Release payment';

  @override
  String get bookingActionRefund => 'Refund';

  @override
  String get bookingActionReject => 'Reject';

  @override
  String get bookingActionReceiveMoney => 'Receive payment';

  @override
  String get cancelBookingTitle => 'Cancel booking';

  @override
  String get cancelBookingMessage =>
      'Do you really want to cancel this booking?\nThis cancellation cannot be undone.';

  @override
  String get cancelBookingMessageShort =>
      'Do you really want to cancel this booking?';

  @override
  String get deleteItemTitle => 'Delete item';

  @override
  String get deleteItemMessage => 'Do you really want to delete this item?';

  @override
  String get refundReasonTitle => 'Refund request reason';

  @override
  String get rejectReasonTitle => 'Rejection reason';

  @override
  String get reasonMinLength => 'Reason must be at least 10 characters';

  @override
  String get reasonHint => 'Please provide a reason (at least 10 characters)';

  @override
  String get cancellationPolicyCanCancel => 'Cancellable';

  @override
  String get cancellationPolicyTitle => 'Cancellation & refund policy';

  @override
  String get cancellationPolicyExpand => 'See more';

  @override
  String get cancellationPolicyCollapse => 'Collapse';

  @override
  String get cancellationTier1Title => 'Cancel before 30 minutes';

  @override
  String get cancellationTier1Subtitle => 'Instant refund within 24 hours';

  @override
  String get cancellationTier2Title => 'Cancel after 30 minutes';

  @override
  String get cancellationTier2Subtitle => 'Refund within 24 hours';

  @override
  String get cancellationTier3Title => 'Cancel after the meet-up starts';

  @override
  String get cancellationTier3Subtitle => 'No refund available';

  @override
  String get cancellationRefundInfo =>
      'Funds will be returned to your original payment method within 24 hours';

  @override
  String get bookingSummaryActive => 'Upcoming';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonUpdate => 'Update';

  @override
  String get commonEnable => 'Enable';

  @override
  String get billingPerHourShort => '/hr';

  @override
  String get billingPerDayShort => '/day';

  @override
  String get billingPerNightShort => '/night';

  @override
  String get billingPerSession => '/session';

  @override
  String get billingPerMinute => '/min';

  @override
  String get servicesManageSubtitle => 'Manage and set service prices';

  @override
  String servicesManageDeleteTitle(String name) {
    return 'Delete $name';
  }

  @override
  String get servicesManageDeleteMessage =>
      'Do you really want to remove this service from your profile?';

  @override
  String get servicesManageYourRate => 'Your rate';

  @override
  String get servicesManageFeePerSession => 'Service fee/session';

  @override
  String get servicesManageActualEarnings => 'Actual earnings';

  @override
  String get servicesManagePriceList => 'Price list';

  @override
  String get servicesManageCommissionPerSession => 'Commission/session';

  @override
  String get servicesManageCommission => 'Commission';

  @override
  String get servicesManageBaseRate => 'Base rate';

  @override
  String get servicesManageAddThis => 'Add this service';

  @override
  String get servicesManageLocationRequired =>
      'Please enter an address/location';

  @override
  String get servicesManageUpdateMassageRate => 'Update massage rate';

  @override
  String get servicesManageAddMassageRate => 'Add massage rate';

  @override
  String get servicesManageVariantName => 'Variant name';

  @override
  String get servicesManagePriceKipPerHour => 'Price (KIP/hr)';

  @override
  String servicesManagePriceKipPerHourShort(String amount) {
    return '$amount KIP/hr';
  }

  @override
  String servicesManageMinimum(String amount) {
    return 'Minimum $amount';
  }

  @override
  String get servicesManageAddVariant => 'Add variant';

  @override
  String get servicesManageAddressLabel => 'Address/location';

  @override
  String get servicesManageAddressHint => 'e.g. Vientiane, Sisattanak';

  @override
  String get servicesManageInstructions =>
      'Choose additional services you can offer and set your own prices. Customers will only see the services you have enabled.';

  @override
  String get servicesManageNoData => 'No service data';

  @override
  String get servicesManageValidRateRequired => 'Please enter a valid price';

  @override
  String servicesManageMinRate(String amount) {
    return 'Minimum price: $amount KIP';
  }

  @override
  String get servicesManageUpdatePrice => 'Update price';

  @override
  String get servicesManageAddService => 'Add service';

  @override
  String servicesManagePriceWithBilling(String billing) {
    return 'Price$billing (KIP)';
  }

  @override
  String get registerCompanionTitle => 'Create companion account';

  @override
  String get registerCustomerTitle => 'Create customer account';

  @override
  String get registerFillInfo => 'Please complete all fields';

  @override
  String get registerFirstName => 'First name';

  @override
  String get registerLastName => 'Last name';

  @override
  String get registerFirstNameHint => 'Enter first name';

  @override
  String get registerLastNameHint => 'Enter last name';

  @override
  String get registerPhone => 'Phone number';

  @override
  String get registerSelectGender => 'Select gender';

  @override
  String get registerDob => 'Date of birth';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerPasswordHint => 'Enter password';

  @override
  String get registerAddress => 'Address';

  @override
  String get registerAddressHint => 'e.g. Nathom, Nongviengkham, Vientiane...';

  @override
  String get registerReferredBy => 'You were referred by';

  @override
  String get registerCta => 'Create account';

  @override
  String get registerTermsPrefix => 'I have read and accept ';

  @override
  String get registerTermsOfUse => 'Terms of Use';

  @override
  String get registerTermsAnd => ' and ';

  @override
  String get registerPrivacyPolicy => 'Privacy Policy';

  @override
  String get registerTermsSuffix => ' of XAOSAO';

  @override
  String get registerAvatarChange => 'Tap to change photo';

  @override
  String get registerAvatarPick => 'Tap to select photo';

  @override
  String get registerStepInfo => 'Info';

  @override
  String get registerStepServices => 'Services';

  @override
  String get registerStepOtp => 'OTP';

  @override
  String get registerServicesTitle => 'Select services';

  @override
  String get registerServicesSubtitle => 'Set your service types and prices';

  @override
  String get registerNoServices => 'No services';

  @override
  String get registerServicesInfoPrefix => 'Please ';

  @override
  String get registerServicesInfoSelect => 'select services';

  @override
  String get registerServicesInfoMid => ' you want and ';

  @override
  String get registerServicesInfoSetPrice => 'set prices';

  @override
  String get registerServicesInfoDot => '.';

  @override
  String get registerPriceRequired => 'Please enter a price';

  @override
  String registerMinPrice(String amount) {
    return 'Minimum price $amount KIP';
  }

  @override
  String get registerPricePerHourLabel => 'Price (KIP/hour) *';

  @override
  String registerMinPriceKip(String amount) {
    return 'Minimum $amount KIP';
  }

  @override
  String get registerAllVariants => 'Add all variants';

  @override
  String get registerServiceLocation => 'Service location *';

  @override
  String get registerServiceLocationHint =>
      'e.g. home, hotel, customer\'s place';

  @override
  String get registerVariantsPriceLabel => 'Variants & price (KIP/hour) *';

  @override
  String get registerContinueCta => 'Continue';

  @override
  String get registerCurrencyPerHour => 'KIP/hr';

  @override
  String get registerOtpSmsInfo =>
      'Please check your SMS.\nThe code is valid for 5 minutes only';

  @override
  String get registerOtpInvalid => 'Invalid OTP — try again';

  @override
  String get registerOtpInvalidRetry => 'Invalid OTP, please try again';

  @override
  String get registerOtpExpiresIn => 'Code expires in ';

  @override
  String get registerOtpExpired => 'Code expired';

  @override
  String get registerOtpNotReceived => 'Didn\'t receive the code? ';

  @override
  String get registerOtpResend => 'Resend';

  @override
  String get registerOtpChangePhone => 'Change phone number';

  @override
  String get registerOtpConfirmPhone => 'Verify phone';

  @override
  String get registerOtpEnter6Digits => 'Enter the 6-digit code sent to';

  @override
  String get registerOtpVerify => 'Verify OTP';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonConnectionRetry => 'Check your connection and try again';

  @override
  String get commonBank => 'Bank';

  @override
  String get qrTitle => 'Transfer QR';

  @override
  String get qrSubtitle => 'Manage my QR codes';

  @override
  String get qrDeleteTitle => 'Delete QR Code';

  @override
  String get qrDeleteMessage => 'Are you sure you want to delete this QR code?';

  @override
  String get qrDefaultLabel => 'Primary account';

  @override
  String get qrScanHint => 'Let customers scan this QR to transfer money';

  @override
  String get qrEmptyTitle => 'No QR code yet';

  @override
  String get qrEmptySubtitle =>
      'Add your bank QR code\nto receive money from customers';

  @override
  String get qrEmptyAddFirst => 'Add your first QR code';

  @override
  String get qrSetPrimary => 'Set as primary QR';

  @override
  String get qrAddNew => 'Add new QR';

  @override
  String get qrInfoBanner =>
      'The QR set as primary appears on your Profile so customers can scan and transfer immediately.';

  @override
  String get qrAddFailed => 'Failed to add QR';

  @override
  String get qrUpdateFailed => 'Failed to update QR';

  @override
  String get qrDeleteFailed => 'Failed to delete QR';

  @override
  String get qrSetDefaultFailed => 'Failed to set primary QR';

  @override
  String get genderMaleShort => 'Male';

  @override
  String get genderFemaleShort => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get monthLongJan => 'January';

  @override
  String get monthLongFeb => 'February';

  @override
  String get monthLongMar => 'March';

  @override
  String get monthLongApr => 'April';

  @override
  String get monthLongMay => 'May';

  @override
  String get monthLongJun => 'June';

  @override
  String get monthLongJul => 'July';

  @override
  String get monthLongAug => 'August';

  @override
  String get monthLongSep => 'September';

  @override
  String get monthLongOct => 'October';

  @override
  String get monthLongNov => 'November';

  @override
  String get monthLongDec => 'December';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSectionGeneralInfo => 'General info';

  @override
  String get profileSectionAccountInfo => 'Account info';

  @override
  String get profileSectionServices => 'Services';

  @override
  String get profileFullName => 'Full name';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileGender => 'Gender';

  @override
  String get profileAccountCreated => 'Account created';

  @override
  String get profileNoServices => 'No services yet';

  @override
  String get profileVerifiedCustomer => 'Verified';

  @override
  String get profileVerifiedCompanion => 'Verified companion';

  @override
  String get profileUpdateSuccess => 'Profile updated';

  @override
  String get profileUpdateFailed => 'Failed to update profile';

  @override
  String get profileEditTitle => 'Edit profile';

  @override
  String get profilePhoneReadonlyLabel => 'Phone (cannot be changed)';

  @override
  String get profileAddressHint => 'e.g. Zone 1, Vientiane';

  @override
  String get profileEditNote =>
      'To change password or phone number, go to Settings';

  @override
  String get profileSave => 'Save';

  @override
  String get commonErrorTryAgain => 'Something went wrong. Please try again.';

  @override
  String get commonUploadFailed => 'Upload failed';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordSubtitle => 'Enter your current password first';

  @override
  String get changePasswordSectionCurrent => 'Password';

  @override
  String get changePasswordCurrentLabel => 'Current password';

  @override
  String get changePasswordMin6 => 'Password must be at least 6 characters';

  @override
  String get changePasswordSectionNew => 'New password';

  @override
  String get changePasswordNewLabel => 'New password';

  @override
  String get changePasswordNewHint => 'Enter new password';

  @override
  String get changePasswordConfirmLabel => 'Confirm new password';

  @override
  String get changePasswordMismatch => 'Passwords do not match';

  @override
  String get changePasswordSave => 'Save new password';

  @override
  String get changePasswordSecurityTitle => 'Security';

  @override
  String get changePasswordSecurityRule =>
      'Password must be at least 8 characters, including uppercase, numbers and symbols';

  @override
  String get changePasswordStrengthWeak => 'Weak';

  @override
  String get changePasswordStrengthFair => 'Fair';

  @override
  String get changePasswordStrengthStrong => 'Strong';

  @override
  String get changePasswordSuccess => 'Password changed successfully';

  @override
  String get changePasswordFailed => 'Failed to change password';

  @override
  String get profileToggleStatusFailed => 'Failed to change status';

  @override
  String get profileUploadPhotoFailed => 'Failed to upload profile photo';

  @override
  String get profileNoPhotos => 'No photos yet';

  @override
  String get profileGalleryTitle => 'All photos';

  @override
  String profileGalleryCount(int count, int max) {
    return '$count / $max photos';
  }

  @override
  String get profileDeletePhotoTitle => 'Delete photo';

  @override
  String get profileDeletePhotoMessage =>
      'Do you really want to delete this photo?';

  @override
  String get profileAddPhoto => 'Add photo';

  @override
  String get profileHiddenShowSuccess => 'Profile shown successfully';

  @override
  String get profileHiddenBannerBody =>
      'Customers cannot see your profile right now. When you\'re ready to accept bookings again, tap Show profile.';

  @override
  String get profileHiddenClose => 'Close';

  @override
  String get profileHiddenShow => 'Show profile';

  @override
  String get profileHiddenHeaderTitle => 'Your profile is hidden';

  @override
  String get profileHiddenHeaderSubtitle =>
      'You will not appear in search results';

  @override
  String get profileShareLink => 'Share profile link';

  @override
  String get profileHideYourProfile => 'Hide your profile';

  @override
  String get qrRowScanToTransfer => 'Scan to transfer money';

  @override
  String get servicesEditAddLabel => 'Edit / add services';

  @override
  String get servicesEditAddSub => 'Set price and description';

  @override
  String get timeJustNow => 'Just now';

  @override
  String get timeJustNowShort => 'Just now';

  @override
  String timeMinutesAgo(int n) {
    return '$n min ago';
  }

  @override
  String timeHoursAgo(int n) {
    return '$n h ago';
  }

  @override
  String timeDaysAgo(int n) {
    return '$n d ago';
  }

  @override
  String timeWeeksAgo(int n) {
    return '$n w ago';
  }

  @override
  String timeMinutesShort(int n) {
    return '${n}m';
  }

  @override
  String timeHoursShort(int n) {
    return '${n}h';
  }

  @override
  String timeDaysShort(int n) {
    return '${n}d';
  }

  @override
  String timeWeeksShort(int n) {
    return '${n}w';
  }

  @override
  String timeDaysShortSpaced(int n) {
    return '$n d';
  }

  @override
  String timeWeeksShortSpaced(int n) {
    return '$n w';
  }

  @override
  String get commonUser => 'User';

  @override
  String get commonYou => 'You';

  @override
  String get commonLoadMore => 'Load more';

  @override
  String commonAmountKip(String amount) {
    return '$amount KIP';
  }

  @override
  String get postsTitle => 'Posts';

  @override
  String get postsSubtitle => 'Find companions near you';

  @override
  String get postsCantLoad => 'Cannot load data';

  @override
  String get postsPleaseRetry => 'Please try again';

  @override
  String get postsEmpty => 'No posts yet';

  @override
  String get postsEmptyFeedSubtitle => 'Posts from companions will appear here';

  @override
  String get postsEmptyMySubtitle => 'Tap \"Create post\" to start posting';

  @override
  String get postsShare => 'Share post';

  @override
  String get postsReport => 'Report';

  @override
  String get postsDeleteTitle => 'Delete post';

  @override
  String get postsDeleteMessage =>
      'Are you sure you want to delete this post?\nThis action cannot be undone.';

  @override
  String get postsDisableTitle => 'Close post';

  @override
  String get postsDisableMessage =>
      'Are you sure you want to close this post?\nCustomers will no longer see it.';

  @override
  String get postsDisableConfirm => 'Close post';

  @override
  String get postsCreate => 'Create post';

  @override
  String get postsTabAll => 'All';

  @override
  String get postsTabMine => 'Mine';

  @override
  String get postsPublicPost => 'Public post';

  @override
  String get postsWhatLookingFor =>
      'What kind of companion are you looking for?';

  @override
  String get postsHintCustomer =>
      'Example: I\'m helping a customer in this post find a drinking buddy';

  @override
  String get postsHintModel => 'Example: I need 2 people to drink with tonight';

  @override
  String get postsAddPhotos => 'Add photos';

  @override
  String get postsChangePhoto => 'Change photo';

  @override
  String get postsSelectGender => 'Select gender';

  @override
  String get postsSelectService => 'Select service';

  @override
  String get postsLocation => 'Location';

  @override
  String get postsLocationHint => 'Example: restaurant, Dao Angkarn...';

  @override
  String get postsWillTip => 'I will tip';

  @override
  String get postsWillTipHelp =>
      'Show that you\'ll tip to attract more interest';

  @override
  String get postsSubmitAndNotify => 'Post and notify';

  @override
  String get postsGenderAny => 'Any';

  @override
  String get postsGiftHistory => 'Gift history';

  @override
  String get postsGiftHistorySubtitle =>
      'See the gifts you have sent to companions';

  @override
  String get postsAuthorFallback => 'Poster';

  @override
  String get postStatusActive => 'Active';

  @override
  String get postStatusExpired => 'Expired';

  @override
  String get postStatusHidden => 'Hidden';

  @override
  String get postStatusFulfilled => 'Closed';

  @override
  String get postActionBook => 'Book';

  @override
  String get postActionChat => 'Chat';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsEmptyTitle => 'No comments yet';

  @override
  String get commentsEmptySubtitle => 'Be the first to comment!';

  @override
  String get commentReply => 'Reply';

  @override
  String get commentCollapseReplies => 'Collapse replies';

  @override
  String commentViewReplies(int count) {
    return 'View $count replies';
  }

  @override
  String commentReplyToHint(String name) {
    return 'Reply to $name...';
  }

  @override
  String get commentWriteHint => 'Write a comment...';

  @override
  String get postDetailTitle => 'Post details';

  @override
  String get postDetailActive => 'Active';

  @override
  String get postDetailClosed => 'Closed';

  @override
  String get postDetailCollapse => 'Show less';

  @override
  String get postDetailReadMore => 'Read more';

  @override
  String get postDetailInterested => 'Interested';

  @override
  String get postDetailGift => 'Gift';

  @override
  String get postDetailComment => 'Comment';

  @override
  String get interestTitle => 'Interested';

  @override
  String get interestSubtitle => 'People interested in your post';

  @override
  String get interestEmptyTitle => 'No one interested yet';

  @override
  String get interestEmptySubtitle =>
      'When someone likes this post,\ntheir name will appear here';

  @override
  String get giftReceivedTitle => 'Gifts';

  @override
  String get giftReceivedSubtitle => 'Gifts you have received';

  @override
  String get giftEmptyReceivedTitle => 'No gifts yet';

  @override
  String get giftEmptyReceivedSubtitle => 'Gifts sent to you will appear here';

  @override
  String get giftSenderLabel => 'Sender';

  @override
  String get giftReceivedTotal => 'Total gifts received';

  @override
  String get giftFallback => 'Gift';

  @override
  String get giftHistoryTitle => 'Gift history';

  @override
  String get giftHistorySubtitle => 'Gifts you have sent';

  @override
  String get giftHistoryEmptyTitle => 'No gift history yet';

  @override
  String get giftHistoryEmptySubtitle =>
      'When you send a gift to a companion,\nit will appear here';

  @override
  String get giftDetailsTitle => 'Gift details';

  @override
  String get giftHistorySentTimes => 'Gifts you have sent';

  @override
  String giftHistorySpent(String amount) {
    return 'Spent $amount KIP';
  }

  @override
  String get commonErrorOccurred => 'An error occurred';

  @override
  String get commonCantLoadData => 'Cannot load data';
}
