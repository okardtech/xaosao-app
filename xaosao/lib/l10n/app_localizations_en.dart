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
  String get serviceTypeSocial => 'Local Activities';

  @override
  String get serviceTypeMassage => 'Massage';

  @override
  String get serviceTypeTravel => 'Local Tours';

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
    return '$hours session';
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
  String get profileShareLink => 'Share your referral link';

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

  @override
  String get packageHistoryTitle => 'Package history';

  @override
  String get packageHistorySubtitle => 'All purchases';

  @override
  String get packageHistoryEmpty => 'No records';

  @override
  String get packageStatusActive => 'Active';

  @override
  String get packageStatusCompleted => 'Completed';

  @override
  String get packageStatusPending => 'Pending';

  @override
  String get packageStatusPendingRelease => 'Pending release';

  @override
  String get packageStatusCanceled => 'Canceled';

  @override
  String get packageStatusRefunded => 'Refunded';

  @override
  String get packageStatusExpired => 'Expired';

  @override
  String get packageStatusUpgraded => 'Upgraded';

  @override
  String get packageStatusHeld => 'Held';

  @override
  String get packageStatusSuperseded => 'Superseded';

  @override
  String get packageAmount => 'Amount';

  @override
  String packageDaysRemaining(int days) {
    return '$days days left';
  }

  @override
  String packageExpiresShort(String date) {
    return 'Expires $date';
  }

  @override
  String get subscriptionPrice => 'Price';

  @override
  String get subscriptionDuration => 'Duration';

  @override
  String get subscriptionBenefits => 'What you\'ll get:';

  @override
  String get subscriptionViewAll => 'View all packages';

  @override
  String get subscriptionClose => 'Close';

  @override
  String get subscriptionBuyNow => 'Buy now';

  @override
  String get subscriptionTopUp => 'Top up';

  @override
  String subscriptionDurationHours(int hours) {
    return '$hours h';
  }

  @override
  String get subscriptionDuration1Day => '1 day';

  @override
  String get subscriptionDuration1Week => '1 week';

  @override
  String get subscriptionDuration1Month => '1 month';

  @override
  String get subscriptionDuration3Months => '3 months';

  @override
  String get subscriptionDuration1Year => '1 year';

  @override
  String subscriptionDurationDays(int days) {
    return '$days days';
  }

  @override
  String get subscriptionSpecialPack => 'Special pack';

  @override
  String get subscriptionYourBalance => 'Your balance';

  @override
  String subscriptionNeedMore(String amount) {
    return 'Need +$amount KIP';
  }

  @override
  String get subscriptionCanPay => 'You can pay';

  @override
  String get subscriptionNeedPackageBody =>
      'Please purchase a Package first to book services. A Package grants you booking and usage rights.';

  @override
  String get subscriptionViewPackage => 'View Package';

  @override
  String get subscriptionNeedPackage => 'Wallet Package required';

  @override
  String get subscriptionNoActive => 'No active Wallet Package yet';

  @override
  String get subscriptionServicePrice => 'Service price';

  @override
  String get subscriptionShortfall => 'Short';

  @override
  String subscriptionTopUpAmount(String amount) {
    return 'Top up $amount KIP';
  }

  @override
  String get subscriptionInsufficient => 'Insufficient balance';

  @override
  String get subscriptionPleaseTopup => 'Please top up before booking';

  @override
  String get subscriptionPendingVerification => 'Pending verification';

  @override
  String get subscriptionAlreadySubscribed =>
      'You already have an active Wallet Package';

  @override
  String get subscriptionPendingBadge => 'Pending';

  @override
  String get subscriptionPendingBody =>
      'Your Package is pending Admin verification. Please wait or contact Admin for faster verification.';

  @override
  String get subscriptionAdminPhone => 'Admin phone';

  @override
  String get subscriptionCallAdmin => 'Call Admin';

  @override
  String get subscriptionWaitingVerification => 'Waiting for verification';

  @override
  String get subscriptionAdminChecking =>
      'Your Package is waiting for Admin review';

  @override
  String get packagePurchaseFailed => 'Purchase failed';

  @override
  String get packageFeature1 =>
      'Book services from local providers with no daily limit';

  @override
  String get packageFeature2 =>
      'Message providers to coordinate bookings and activities';

  @override
  String get packageFeature3 =>
      'Reserve real-world activities and services with no daily cap';

  @override
  String get packageFeature4 =>
      'Discover top-rated service providers in your area';

  @override
  String get packageFeature5 =>
      'Search providers by service, location, and availability';

  @override
  String get packageFeature6 => '24/7 customer support';

  @override
  String get packageFeature7 => 'Higher visibility as a service provider';

  @override
  String get packagePlanShort1 =>
      'Book services and connect with local providers right away';

  @override
  String get packagePlanShort2 =>
      '24-hour trial for booking and provider communication';

  @override
  String get packagePlanShort3 =>
      'Best value for long-term booking and activity planning';

  @override
  String get packageChooseTitle => 'Choose a plan';

  @override
  String get packageChooseSubtitle => 'Choose your Wallet Package';

  @override
  String get packageHistoryButton => 'History';

  @override
  String get packageCancelAnytime => 'Cancel anytime · Refund per policy';

  @override
  String get packageWaitingVerification => 'Pending verification';

  @override
  String get packageExpiredLabel => 'Expired';

  @override
  String get packageNearExpiry => 'Near expiry';

  @override
  String get packageActive => 'Active';

  @override
  String get packageProcessingVerification => 'Processing verification...';

  @override
  String packageExpiresOn(String date) {
    return 'Expires $date';
  }

  @override
  String get packageDays => 'days';

  @override
  String get packageRemainingLabel => 'Remaining';

  @override
  String get packageChooseYourPlan => 'Choose your plan';

  @override
  String get packageUpgradeExperience => 'Enhance your booking access';

  @override
  String get packageChooseFitPlan => 'Pick a plan that fits your booking needs';

  @override
  String get packageLoadFailedShort => 'Load failed';

  @override
  String get packageNoPackage => 'No Package';

  @override
  String get packageRequestProcessing =>
      'Your request is being processed · please wait';

  @override
  String get packageCurrent => 'Current package';

  @override
  String get packageSelectPlan => 'Select this plan';

  @override
  String get checkoutPurchaseSuccess => 'Package purchased successfully';

  @override
  String get checkoutUpgradeTitle => 'Upgrade Package';

  @override
  String get checkoutUpgradeSubtitle => 'Review and confirm payment';

  @override
  String get checkoutProcessPayment => 'Process payment';

  @override
  String get checkoutAlreadySubscribed => 'Wallet Package already active';

  @override
  String checkoutPillPlan(String name) {
    return 'Plan $name';
  }

  @override
  String checkoutPillRemainingDays(int days) {
    return '$days days left';
  }

  @override
  String get checkoutUpgradeInfo =>
      'The new payment will start after the current Package, and remaining days will be carried into the new Package.';

  @override
  String get checkoutPackageDuration => 'Package duration';

  @override
  String get checkoutNewPackageDuration => 'New Package duration';

  @override
  String get checkoutBonusFromOld => '+ Bonus (from previous Package)';

  @override
  String get checkoutTotalDuration => 'Total duration';

  @override
  String get checkoutPaymentSummary => 'Payment summary';

  @override
  String get checkoutWalletBalance => 'Wallet balance';

  @override
  String get checkoutPackagePrice => 'Package price';

  @override
  String get checkoutRemaining => 'Remaining balance';

  @override
  String get checkoutShortfallSuffix => ' (short)';

  @override
  String get checkoutWalletDeductInfo =>
      'Wallet balance will be deducted immediately. The Package will activate after payment succeeds.';

  @override
  String get onboardingTopCompanions => 'Top companions';

  @override
  String get onboardingTopCompanionsSubtitle =>
      'Discover our highest-rated companions';

  @override
  String get onboardingWelcome => 'Welcome 👋';

  @override
  String get onboardingFindYourCompanion => 'Find your companion';

  @override
  String get onboardingLoginOrSignup => 'Log in / Sign up';

  @override
  String get onboardingActionsHint => 'View profiles · Chat · Book instantly';

  @override
  String get onboardingLogin => 'Log in';

  @override
  String get onboardingOurServices => 'Our services';

  @override
  String get onboardingMassageTitle => 'Massage';

  @override
  String get onboardingMassageSubtitle =>
      'Professional wellness massage at home, delivered by verified therapists';

  @override
  String get onboardingSocialSubtitle =>
      'Social event partners to add fun and make lasting impressions';

  @override
  String get onboardingTravelTitle => 'Travel companion';

  @override
  String get onboardingTravelSubtitle =>
      'Travel partners ready to help you discover new experiences at home and abroad';

  @override
  String get onboardingLevelGeneral => 'General';

  @override
  String get onboardingLevelSpecial => 'Special';

  @override
  String get onboardingLevelPartner => 'Partner';

  @override
  String get onboardingPartnerBenefits => 'Partner benefits';

  @override
  String get onboardingIncreaseIncome => 'Grow your income';

  @override
  String get onboardingJoinNow => 'Join now';

  @override
  String get onboardingConditionRegister => 'Register as a partner';

  @override
  String get onboardingEarnPer20 => 'Per referral · up to 20 people';

  @override
  String get onboardingCondition20People => 'Refer 20 partners';

  @override
  String get onboardingEarnCommission => 'Commission and referral bonuses';

  @override
  String get onboardingEarnVipSummary => 'VIP summary and on-time commissions';

  @override
  String get onboardingReadyToEarn => 'Ready to start earning?';

  @override
  String get onboardingRegisterUnlock =>
      'Register now and grow your rewards by referring others';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get notifSettingTitle => 'System settings';

  @override
  String get notifSettingSubtitle => 'Manage your notifications';

  @override
  String get notifSettingChannelsSection => 'Notification channels';

  @override
  String get notifSettingPushSubtitle => 'Alerts sent straight to your phone';

  @override
  String get notifSettingSmsSubtitle => 'Short messages to your number';

  @override
  String get notifSettingBannerTitle => 'Notification preferences';

  @override
  String get notifSettingBannerBody =>
      'Choose how you want to receive messages\nChanges are saved automatically';

  @override
  String get notifSettingFooterNote =>
      'Changes are saved immediately. You can adjust settings anytime.';

  @override
  String get notifSettingUpdateFailed => 'Update failed';

  @override
  String get notifListTitle => 'Notifications';

  @override
  String get notifListSubtitle => 'All your notifications';

  @override
  String get notifListMarkAllRead => 'Mark all read';

  @override
  String get notifListEmptyTitle => 'No notifications yet';

  @override
  String get notifListEmptySubtitle => 'Notifications will appear here';

  @override
  String get notifTimeJustNow => 'Just now';

  @override
  String notifTimeMinutes(int n) {
    return '$n min';
  }

  @override
  String notifTimeHours(int n) {
    return '$n h';
  }

  @override
  String get notifTimeYesterday => 'Yesterday';

  @override
  String notifTimeDaysAgo(int n) {
    return '$n days ago';
  }

  @override
  String notifTimeWeeksAgo(int n) {
    return '$n weeks ago';
  }

  @override
  String notifTimeMonthsAgo(int n) {
    return '$n months ago';
  }

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeBody =>
      'Your account has been created.\nEnjoy using the app!';

  @override
  String get welcomeCanDoTitle => 'What you can do';

  @override
  String get welcomeChat => 'Chat';

  @override
  String get welcomeBook => 'Book';

  @override
  String get welcomeExplore => 'Explore';

  @override
  String get welcomeGetStartedCta => 'Get started now';

  @override
  String get modelWalletAvailableBalance => 'Available balance';

  @override
  String get modelWalletStatPending => 'Pending';

  @override
  String get modelWalletStatWithdrawn => 'Withdrawn';

  @override
  String get modelWalletStatTotalIncome => 'Total income';

  @override
  String get modelWalletWithdrawBtn => 'Withdraw';

  @override
  String get modelWalletIncomeHistory => 'Income history';

  @override
  String get modelWalletEmptyTitle => 'No transactions yet';

  @override
  String get modelWalletEmptySubtitle =>
      'Your income entries\nwill appear here';

  @override
  String get modelWalletWithdrawFailed => 'Withdrawal failed';

  @override
  String get withdrawTitle => 'Withdraw';

  @override
  String get withdrawSubtitle => 'Send to a bank account';

  @override
  String get withdrawSelectBank => 'Select a bank account';

  @override
  String get withdrawAmountLabel => 'Amount';

  @override
  String get withdrawAmountHint => 'Enter amount';

  @override
  String get withdrawHintMin => 'Minimum';

  @override
  String get withdrawHintMax => 'Maximum';

  @override
  String withdrawBelowMin(String amount) {
    return 'Amount is below minimum ($amount)';
  }

  @override
  String withdrawAboveMax(String amount) {
    return 'Exceeds withdrawable balance ($amount)';
  }

  @override
  String get withdrawConfirmBtn => 'Confirm withdrawal';

  @override
  String get withdrawableBalance => 'Withdrawable balance';

  @override
  String get withdrawAll => 'Withdraw all';

  @override
  String get withdrawUnavailable => 'Cannot withdraw';

  @override
  String get withdrawNoBankTitle => 'No bank account yet';

  @override
  String get withdrawNoBankSubtitle =>
      'Please add a bank account before withdrawing';

  @override
  String get withdrawAddBank => 'Add bank account';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get discoverSubtitle => 'Find people you like';

  @override
  String get discoverSearchHint => 'Search by name...';

  @override
  String get discoverTabForYou => 'For you';

  @override
  String get discoverTabWhoLikedMe => 'Liked me';

  @override
  String get discoverTabILiked => 'I liked';

  @override
  String get discoverEmptyAllTitle => 'No users found';

  @override
  String get discoverEmptyAllSubtitle =>
      'Try changing filters or searching again';

  @override
  String get discoverEmptyForYouTitle => 'No recommendations yet';

  @override
  String get discoverEmptyForYouSubtitle => 'We\'ll find people that match you';

  @override
  String get discoverEmptyWhoLikedMeTitle => 'No one has liked you yet';

  @override
  String get discoverEmptyWhoLikedMeSubtitle =>
      'Create a great profile to attract likes';

  @override
  String get discoverEmptyILikedTitle => 'You haven\'t liked anyone';

  @override
  String get discoverEmptyILikedSubtitle => 'Browse and tap ♥ to show interest';

  @override
  String get detailPersonalInfo => 'Personal info';

  @override
  String get detailStatAge => 'Age';

  @override
  String get detailStatMemberSince => 'Member since';

  @override
  String get detailStatTier => 'Tier';

  @override
  String get detailViewPhotos => 'View photos';

  @override
  String get detailTapPhotoToExpand => 'Tap a photo to expand';

  @override
  String get detailStatRating => 'Rating';

  @override
  String get detailStatPosts => 'Posts';

  @override
  String get detailStatGifts => 'Gifts';

  @override
  String get detailStatCount => 'Count';

  @override
  String get meetupsEntryFromMeetUps => 'From meet-ups';

  @override
  String get meetupsEntryFromChat => 'From Chat';

  @override
  String get meetupsDayShortSun => 'Sun';

  @override
  String get meetupsDayShortMon => 'Mon';

  @override
  String get meetupsDayShortTue => 'Tue';

  @override
  String get meetupsDayShortWed => 'Wed';

  @override
  String get meetupsDayShortThu => 'Thu';

  @override
  String get meetupsDayShortFri => 'Fri';

  @override
  String get meetupsDayShortSat => 'Sat';

  @override
  String get meetupsClockSuffix => 'hrs';

  @override
  String meetupsCountdownDays(int days, int hours) {
    return '$days d $hours h left';
  }

  @override
  String meetupsCountdownHours(int hours) {
    return '$hours h left';
  }

  @override
  String meetupsCountdownMinutes(int minutes) {
    return '$minutes min left';
  }

  @override
  String meetupsServiceMultiplier(String name, int n, String unit) {
    return '$name × $n $unit';
  }

  @override
  String get meetupsUnitDays => 'days';

  @override
  String get meetupsUnitHours => 'hours';

  @override
  String get meetupsServiceFallback => 'Service';

  @override
  String get meetupsStepCreateBooking => 'Booking created';

  @override
  String get meetupsStepWaitCompanionConfirm => 'Waiting for companion';

  @override
  String get meetupsStepCompanionConfirmed => 'Companion confirmed';

  @override
  String get meetupsStepWaitingMeetup => 'Waiting for meet-up';

  @override
  String get meetupsStepInProgress => 'In progress';

  @override
  String get meetupsStepWaitingConfirmation => 'Waiting for confirmation';

  @override
  String get meetupsStepMeetingUp => 'Meeting up';

  @override
  String get meetupsStepCompleted => 'Completed';

  @override
  String get meetupsStepCancelled => 'Cancelled';

  @override
  String get meetupsStepRejected => 'Rejected';

  @override
  String get meetupsStepDisputed => 'Disputed';

  @override
  String get meetupsCantLoadData => 'Cannot load data';

  @override
  String get meetupsCantPerform => 'Cannot perform action';

  @override
  String get meetupsSectionDateTime => 'Date and time';

  @override
  String get meetupsSectionLocation => 'Meet-up location';

  @override
  String get meetupsSectionServices => 'Services';

  @override
  String get meetupsMapLink => 'Map ›';

  @override
  String get meetupsPriceSummary => 'Price summary';

  @override
  String get meetupsPriceTotal => 'Total';

  @override
  String get meetupsYourReview => 'Your review';

  @override
  String meetupsYouRated(String name) {
    return 'You rated $name';
  }

  @override
  String get meetupsProgress => 'Progress';

  @override
  String get meetupsCancellationPolicy => 'Cancellation policy';

  @override
  String get meetupsCancelBefore => 'Cancel before ';

  @override
  String get meetupsWillRefund => ' to get back ';

  @override
  String get meetupsWithin24h => ' within 24 h.';

  @override
  String get meetupsActionMessage => 'Message';

  @override
  String get meetupsActionCall => 'Call';

  @override
  String get meetupsActionCancel => 'Cancel';

  @override
  String get meetupsActionShare => 'Share';

  @override
  String get meetupsActionReport => 'Report';

  @override
  String get meetupsActionConfirmShort => 'Confirm';

  @override
  String get meetupsSnackPleaseTitle => 'Please';

  @override
  String get loginRoleCustomerLabel => 'Customer';

  @override
  String get loginRoleCustomerSub => 'Browse and book services';

  @override
  String get loginRoleCompanionLabel => 'Companion';

  @override
  String get loginRoleCompanionSub => 'Post services and receive bookings';

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get forgotEnterRegistered => 'Enter your registered phone';

  @override
  String get forgotOtpWillSendHere => 'An OTP code will be sent to this number';

  @override
  String get forgotSendOtp => 'Send OTP';

  @override
  String get forgotBackToLogin => 'Back to login';

  @override
  String get forgotIdentityVerifyTitle => 'Verify identity';

  @override
  String get forgotSetNewPasswordTitle => 'Set a new password';

  @override
  String get forgotSetNewPasswordSubtitle => 'Set a secure new password';

  @override
  String get forgotSavePassword => 'Save password';

  @override
  String get forgotStepPhone => 'Phone';

  @override
  String get forgotConfirmPassword => 'Confirm password';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get feedbackSubtitle => 'Send suggestions or report an issue';

  @override
  String get feedbackSendNew => 'Send new feedback';

  @override
  String get feedbackMine => 'My feedback';

  @override
  String get feedbackTypeLabel => 'Category';

  @override
  String get feedbackTypeHint => 'Choose a feedback category';

  @override
  String get feedbackSubjectLabel => 'Subject';

  @override
  String get feedbackSubjectHint => 'Enter feedback subject...';

  @override
  String get feedbackDescLabel => 'Description';

  @override
  String get feedbackDescHint => 'Add more details...';

  @override
  String get feedbackDescMinLength => 'Please enter at least 10 characters';

  @override
  String get feedbackSubmit => 'Send feedback';

  @override
  String get feedbackSubmitFailed => 'Failed to send feedback';

  @override
  String get feedbackEmptyTitle => 'No feedback yet';

  @override
  String get feedbackEmptySubtitle => 'Send your feedback above';

  @override
  String get feedbackStatusResolved => 'Resolved';

  @override
  String get feedbackTypeBug => 'Bug';

  @override
  String get feedbackTypeFeature => 'Feature';

  @override
  String get feedbackTypeGeneral => 'General';

  @override
  String get feedbackTypePayment => 'Payment';

  @override
  String get feedbackTypePerformance => 'Performance';

  @override
  String get feedbackTypeOther => 'Other';

  @override
  String get dashboardTabChat => 'Chats';

  @override
  String get dashboardTabPosts => 'Posts';

  @override
  String get reviewRatingRequired => 'Please give a rating';

  @override
  String get reviewTextRequired => 'Please write a review';

  @override
  String get reviewSubmitSuccess => 'Review submitted';

  @override
  String get reviewSubmitFailed => 'Failed to submit review';

  @override
  String get reviewWriteTitle => 'Write a review';

  @override
  String reviewForCompanion(String name) {
    return 'For $name';
  }

  @override
  String get reviewGiveRating => 'Rate';

  @override
  String get reviewSubjectLabel => 'Subject (optional)';

  @override
  String get reviewSubjectHint => 'Enter review subject...';

  @override
  String get reviewYourReview => 'Your review';

  @override
  String get reviewShareHint => 'Share your experience...';

  @override
  String get reviewSubmit => 'Submit review';

  @override
  String get reviewRatingBad => 'Bad';

  @override
  String get reviewRatingOk => 'OK';

  @override
  String get reviewRatingGood => 'Good';

  @override
  String get reviewRatingVeryGood => 'Very good';

  @override
  String get reviewRatingExcellent => 'Excellent!';

  @override
  String get reviewRatingPick => 'Pick a rating';

  @override
  String get cpRatingsSection => 'Ratings and reviews';

  @override
  String get cpStatusAvailable => 'Available';

  @override
  String get cpStatusUnavailable => 'Unavailable';

  @override
  String get cpStatusLabel => 'Status';

  @override
  String get cpNoServicesNow => 'No services right now';

  @override
  String get cpNoReviewsBeFirst => 'No reviews yet, be the first!';

  @override
  String get cpLoadMoreReviews => 'Load more reviews';

  @override
  String cpReviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get cpOnline => 'Online';

  @override
  String get cpStatReviews => 'Reviews';

  @override
  String get cpStatFollowers => 'Followers';

  @override
  String get cpAnonymous => 'Anonymous';

  @override
  String get cpBookNow => 'Book now';

  @override
  String get chatTitle => 'Chats';

  @override
  String chatNewMessages(int count) {
    return '$count new messages';
  }

  @override
  String get chatSearchHint => 'Search...';

  @override
  String get chatFallbackName => 'this conversation';

  @override
  String get chatDeleteConvTitle => 'Delete conversation';

  @override
  String chatDeleteConvMessage(String name) {
    return 'Delete conversation with $name?\nMessages will still be visible on their side';
  }

  @override
  String get chatCantEnter => 'Cannot open';

  @override
  String get chatBlockedByYou => 'You have blocked this conversation';

  @override
  String get chatBlockedByOther => 'This conversation is blocked';

  @override
  String chatUnblockName(String name) {
    return 'Unblock $name';
  }

  @override
  String chatBlockName(String name) {
    return 'Block $name';
  }

  @override
  String get chatUnblockConfirmMsg => 'Unblock and continue chatting?';

  @override
  String chatBlockConfirmMsg(String name) {
    return 'You and $name will not be able to send each other messages';
  }

  @override
  String get chatUnblock => 'Unblock';

  @override
  String get chatBlock => 'Block';

  @override
  String get chatEmpty => 'No conversations found';

  @override
  String get chatConversationBlocked => 'Conversation blocked';

  @override
  String get chatTyping => 'typing...';

  @override
  String get chatOffline => 'Offline';

  @override
  String get chatSelectedImage => 'Selected image';

  @override
  String get chatInputHint => 'Type a message...';

  @override
  String get chatSendFailed => 'Failed to send';

  @override
  String get chatSendPleaseRetry => 'Please try again';

  @override
  String get chatDateToday => 'Today';

  @override
  String get chatDeleteMsgTitle => 'Delete message';

  @override
  String get chatDeleteMsgBody =>
      'The message will only be deleted from your side\nThe other person will still see it';

  @override
  String get chatImagePrefix => '📷 Image';

  @override
  String get bookingLabelDate => 'Date';

  @override
  String get bookingHoursCount => 'Sessions';

  @override
  String bookingHoursValue(int hours) {
    return '$hours sessions';
  }

  @override
  String bookingHoursShortValue(int hours) {
    return '$hours sess';
  }

  @override
  String get bookingTotalPriceShort => 'Total price';

  @override
  String get bookingGoToMeetups => 'Go to meet-ups';

  @override
  String get bookingSuccessTitle => 'Booking confirmed!';

  @override
  String get bookingSuccessBody => 'Your booking has been received';

  @override
  String get bookingUnitNight => 'night';

  @override
  String get bookingDateDeparture => 'Departure date';

  @override
  String get bookingDateReturn => 'Return date';

  @override
  String get bookingDatePlaceholder => 'dd/mm/yyyy';

  @override
  String get bookingLocationHint => 'Enter address or location...';

  @override
  String get bookingAttireLabel => 'Preferred attire';

  @override
  String get bookingAttireHint => 'e.g. dress sexy (optional)';

  @override
  String get bookingTipService => 'Tip / service';

  @override
  String bookingAddTipTo(String name) {
    return 'Add a tip for $name';
  }

  @override
  String bookingRatePerUnit(String rate, String unit) {
    return '$rate KIP / $unit';
  }

  @override
  String bookingRatePerHour(String rate) {
    return '$rate KIP / session';
  }

  @override
  String bookingRatePerHourShort(String rate) {
    return '$rate KIP / sess';
  }

  @override
  String bookingCountUnit(String unit) {
    return '$unit count';
  }

  @override
  String get bookingSelectTime => 'Select time';

  @override
  String get bookingSlotBooked => 'Booked';

  @override
  String get bookingSelectMassageType => 'Select massage type';

  @override
  String bookingVariantsCount(int count) {
    return '$count variants';
  }

  @override
  String get bookingDateAppointment => 'Appointment date';

  @override
  String get bookingTimeMeeting => 'Meeting time';

  @override
  String get bookingTimeFormat => 'hh:mm';

  @override
  String get bookingSelectPlaceholder => 'Select';

  @override
  String get bookingMassageTypeLabel => 'Massage type';

  @override
  String get bookingSelectVariant => 'Select variant';

  @override
  String get bookingCreationFailed => 'Booking failed';

  @override
  String get shareTitle => 'Invite friends';

  @override
  String get shareAppbarSubtitle => 'Share your link and grow your income';

  @override
  String get shareSubtitleGeneral => 'Earn 10,000 KIP per referral';

  @override
  String get shareSubtitleCommission => 'Earn commissions from your referrals';

  @override
  String get shareTierGeneral => 'General';

  @override
  String get shareTierSpecial => 'Special';

  @override
  String get shareTierPartner => 'Partner';

  @override
  String shareTierBadge(String tier) {
    return '$tier tier';
  }

  @override
  String get shareTabModel => 'Model referral';

  @override
  String get shareTabCustomer => 'Customer referral';

  @override
  String get shareLinkModelDesc =>
      'Share this link with people who want to be a model';

  @override
  String get shareLinkCustomerDesc =>
      'Share this link with customers to sign up';

  @override
  String get shareCopy => 'Copy';

  @override
  String get shareCopied => 'Copied';

  @override
  String get shareShareLink => 'Share';

  @override
  String get shareViewQr => 'QR';

  @override
  String get shareStatsModels => 'Models referred';

  @override
  String get shareStatsCustomers => 'Customers referred';

  @override
  String get shareStatsCommission => 'Commission';

  @override
  String get shareStatsTotal => 'Total earnings';

  @override
  String get shareCommissionsTitle => 'Commission history';

  @override
  String get shareCommissionsEmpty => 'No commissions yet';

  @override
  String get shareCommissionsEmptySub =>
      'Commissions from customers or models you refer will appear here';

  @override
  String get shareLearnMore => 'Learn more about tiers';

  @override
  String get shareProgressToNext => 'Progress to next tier';

  @override
  String shareUpgradeToSpecialRemaining(int n) {
    return '$n more referrals to reach Special';
  }

  @override
  String shareUpgradeToPartnerRemainingModels(int n) {
    return '$n more referrals to reach Partner';
  }

  @override
  String shareUpgradeToPartnerRemainingEarnings(String amount) {
    return '$amount KIP more to reach Partner';
  }

  @override
  String get shareTierMaxed => 'You\'ve reached the top tier';

  @override
  String get shareCurrentTier => 'Current tier';

  @override
  String shareEarnPerReferral(String amount) {
    return 'Earn $amount KIP / person';
  }

  @override
  String get shareInviteMessage => 'Sign up on Xaosao with my link!';

  @override
  String get shareInviteSubject => 'Join Xaosao';

  @override
  String get appName => 'Xaosao';

  @override
  String bookingThankYouFor(String appName) {
    return 'Thank you for booking with $appName';
  }

  @override
  String bookingSupportContact(String phone) {
    return 'Need help? Call $phone';
  }

  @override
  String get shareCommissionReferral => 'Referral';

  @override
  String get shareQrBrandName => 'xaosao — companions';

  @override
  String get shareQrBrandTagline =>
      'A curated companion experience, always ready when you are.';

  @override
  String get shareQrDownload => 'Download QR';

  @override
  String get shareQrPermissionDenied => 'Please allow access to Photos';

  @override
  String get shareQrSaved => 'QR code saved to Photos';

  @override
  String get shareQrSaveFailed =>
      'Couldn\'t save the QR code, please try again';

  @override
  String get shareQrErrorGeneric => 'Something went wrong, please try again';

  @override
  String get analyticsTitle => 'Referral analytics';

  @override
  String get analyticsSubtitle => 'Your stats and earnings';

  @override
  String get analyticsLoadFailed => 'Failed to load data';

  @override
  String get analyticsRetry => 'Retry';

  @override
  String get analyticsReferralStats => 'Referral stats';

  @override
  String get analyticsReferrals => 'Referrals';

  @override
  String get analyticsEarnings => 'Earnings';

  @override
  String get analyticsTierProgress => 'Tier progress';

  @override
  String get analyticsModels => 'Models';

  @override
  String get analyticsCustomers => 'Customers';

  @override
  String get analyticsBookings => 'Bookings';

  @override
  String get analyticsSubscriptions => 'Packages';

  @override
  String get analyticsApproved => 'Approved';

  @override
  String get analyticsPending => 'Pending';

  @override
  String get analyticsActive => 'Active';

  @override
  String get analyticsInactive => 'Inactive';

  @override
  String get analyticsTotal => 'Total';

  @override
  String get analyticsTotalEarnings => 'Total earnings';

  @override
  String get analyticsModelEarnings => 'Model earnings';

  @override
  String get analyticsCommission => 'Commission';

  @override
  String get analyticsEarningsByType => 'Earnings by type';

  @override
  String get analyticsAllModels => 'All models';

  @override
  String get analyticsApprovedModels => 'Approved models';

  @override
  String get analyticsAllCustomers => 'All customers';

  @override
  String get analyticsActiveCustomers => 'Active customers';

  @override
  String get analyticsReady => 'Ready!';

  @override
  String analyticsSpecialCondition(int n) {
    return 'Refer $n approved models';
  }

  @override
  String get analyticsPartnerCondition => 'Requires both models and earnings';

  @override
  String get snackbarErrorTitle => 'Error';

  @override
  String get snackbarSuccessTitle => 'Success';

  @override
  String get snackbarInfoTitle => 'Info';

  @override
  String get qrLoadFailed => 'Failed to load QR';

  @override
  String get imagePickerTitle => 'Choose profile photo';

  @override
  String get imagePickerGallery => 'Gallery';

  @override
  String get imagePickerCamera => 'Camera';

  @override
  String get serviceUnitHour => '/session';

  @override
  String get serviceUnitDay => '/day';

  @override
  String get serviceUnitNight => '/night';

  @override
  String get serviceUnitOnce => 'One-time';

  @override
  String get serviceUnitMinute => '/min';

  @override
  String get phoneRequired => 'Please enter phone number';

  @override
  String get phoneMustStartWith20 => 'Phone must start with 20';

  @override
  String get phonePrefixInvalid => 'Must be: 202, 205, 206, 207 or 209';

  @override
  String phoneLength(int n) {
    return 'Phone must be $n digits';
  }

  @override
  String get deepLinkShareSelf => 'Check out my profile on Xaosao';

  @override
  String deepLinkShareOther(String name) {
    return 'Check out $name\'s profile on Xaosao';
  }

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get commonSearch => 'Search...';

  @override
  String get commonPasswordHint => 'Password';

  @override
  String get commonImageLoadFailed => 'Couldn\'t load image';

  @override
  String get walletBalanceShort => 'Wallet balance';

  @override
  String get updateRequiredTitle => 'App update required';

  @override
  String get updateAvailableTitle => 'A new app version is available!';

  @override
  String get updateRequiredBody =>
      'Please update to the latest version to keep using Xaosao';

  @override
  String get updateAvailableBody =>
      'We\'ve made the app better — update now for the best experience';

  @override
  String get updateNow => 'Update now';

  @override
  String get updateLater => 'Later';

  @override
  String get updateCurrentVersion => 'Current version';

  @override
  String get updateNewVersion => 'New version';

  @override
  String get updateWhatsNew => 'What\'s new';

  @override
  String get giftSheetTitle => '🎁 Send a gift';

  @override
  String giftSheetPickFor(String name) {
    return 'Choose a gift for $name';
  }

  @override
  String get giftEmpty => 'No gifts available right now';

  @override
  String get giftPickFirst => 'Please pick a gift first';

  @override
  String get giftSendFailed => 'Failed to send the gift';

  @override
  String get giftSendSuccess => 'Gift sent!';

  @override
  String giftSendButton(String name, String price) {
    return 'Send $name · $price';
  }

  @override
  String get tiersTitle => 'Model referral tiers';

  @override
  String get tiersSubtitle => 'Learn how to boost your earnings';

  @override
  String get tiersOverview => 'Model referral links are divided into 3 tiers';

  @override
  String get tiersLevel1Title => 'General tier';

  @override
  String get tiersLevel1Desc =>
      'Only a model referral link is available; you earn 10,000 KIP per referral (no conditions — every model qualifies).';

  @override
  String get tiersLevel2Title => 'Special tier';

  @override
  String get tiersLevel2Condition => 'Refer more than 5 people';

  @override
  String get tiersLevel2Links =>
      'You get 2 links: a customer referral link and a model referral link';

  @override
  String get tiersLevel2Benefit =>
      'No flat 10,000 KIP anymore — instead you earn 20% of customer Wallet Package purchases, and 2% of bookings made with providers you referred.';

  @override
  String get tiersLevel3Title => 'Partner tier';

  @override
  String get tiersLevel3Condition =>
      'Refer more than 5 people AND earn 1,000,000 KIP in total commissions (from customer packages + bookings on your referred providers)';

  @override
  String get tiersLevel3Links =>
      'You get 2 links: a customer referral link and a provider referral link';

  @override
  String get tiersLevel3Benefit =>
      'No flat 10,000 KIP — instead you earn 40% of customer Wallet Package purchases, and 4% of bookings made with providers you referred.';

  @override
  String get tiersConditionLabel => 'Condition';

  @override
  String get tiersBenefitLabel => 'Benefits';

  @override
  String get tiersLinksLabel => 'Referral links';

  @override
  String get tiersCurrentBadge => 'Your current tier';

  @override
  String get tiersLockedNote => 'Not yet reached';
}
