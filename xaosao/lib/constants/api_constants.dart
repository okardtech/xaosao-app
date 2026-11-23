import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kDebugMode, TargetPlatform;

class ApiConstants {
  /// Where the backend lives.
  ///
  /// Debug builds talk to the backend running on this machine; release
  /// builds always talk to production. The split is deliberate: a
  /// hardcoded `localhost` that reaches the App Store is an app that
  /// does nothing at all, and that mistake is only ever caught by a
  /// human remembering to change a line back.
  ///
  /// To point a debug build somewhere else — a colleague's machine, a
  /// staging box, or production:
  ///
  ///     flutter run --dart-define=API_HOST=https://api.xaosao.com
  ///     flutter run --dart-define=API_HOST=http://192.168.1.50:3055
  ///
  /// A physical phone cannot reach your Mac on `localhost`; give it the
  /// Mac's LAN address with the define above.
  static const String _hostOverride = String.fromEnvironment('API_HOST');

  static const String _productionHost = 'https://api.xaosao.com';

  /// The port xs_backend listens on (see its `.env`).
  static const int _localPort = 3055;

  static String get _host {
    if (_hostOverride.isNotEmpty) return _hostOverride;
    if (!kDebugMode) return _productionHost;
    // The Android emulator cannot see the host's loopback — 10.0.2.2 is
    // the alias it provides for the machine it runs on. The iOS
    // simulator shares the host's network, so localhost is literal.
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$_localPort';
    }
    return 'http://localhost:$_localPort';
  }

  static String get baseUrl => '$_host/api/v1/';

  // ── Per-minute calls (xs_backend CallsController) ───────────
  static const String calls = 'calls';
  static String callRate(String modelId) => 'calls/rate/$modelId';
  static String callNotify(String modelId) => 'calls/notify/$modelId';
  static String callState(String sessionId) => 'calls/$sessionId';
  static String callToken(String sessionId) => 'calls/$sessionId/token';
  static String callAnswer(String sessionId) => 'calls/$sessionId/answer';
  static String callDecline(String sessionId) => 'calls/$sessionId/decline';
  static String callHangup(String sessionId) => 'calls/$sessionId/hangup';
  static const String cleintRefreshToken = 'client/auth/token/refresh';
  static const String modelRefreshToken = 'model/auth/token/refresh';
  // authen
  static const String modelsHot = 'models/hot?limit=12';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';

  // file upload api
  static const String uploadFile = 'upload';

  // client API
  static const String clientRegister = 'client/auth/register';
  static const String clientVerifyOTP = 'client/auth/register/verify-otp';
  static const String clientResendOTP = 'client/auth/register/resend-otp';
  static const String clientLogin = 'client/auth/login';
  static const String clientProfile = 'client/profile/me';
  static const String clientPhoto = 'client/profile/me/gallery';
  static const String clientUpdateImage = 'client/profile/me/avatar';
  static const String clientDeleteAccount = 'client/profile/deletion';
  static const String clientChangePass = 'client/profile/password';

  // model API
  static const String modelRegister = 'model/auth/register';
  static const String modelVerifyOTP = 'model/auth/register/verify-otp';
  static const String modelResendOTP = 'model/auth/register/resend-otp';
  static const String modelLogin = 'model/auth/login';
  static const String modelProfile = 'models/me/profile';
  static const String modelPhoto = 'models/me/photos';
  static const String modelVisibility = 'models/me/visibility';
  static const String modelUpdateImage = 'models/me/profile/avatar';
  static const String modelDeleteAccount = 'models/me/account';
  static const String modelChangePass = 'models/me/password';

  // Forgot password customer
  static const String clientForgotPassPhone =
      'client/auth/forgot-password-phone';
  static const String clientForgotVerifyOTP = 'client/auth/verify-reset-token';
  static const String clientForgotResend = 'client/auth/resend-reset-token';
  static const String clientNewPass = 'client/auth/reset-password-phone';
  // Forgot password model
  static const String modelForgotPassPhone = 'model/auth/forgot-password-phone';
  static const String modelForgotVerifyOTP = 'model/auth/verify-reset-token';
  static const String modelForgotResend = 'model/auth/resend-reset-token';
  static const String modelNewPass = 'model/auth/reset-password-phone';
  /////////// service API
  static const String servicePublic = 'services';
  static const String serviceAvailable = '/model/services/available';
  static const String modelService = 'model/services';
  static const String modeAvailable = 'discover';

  // client to see model
  static const String recommended = '/discover/recommended';
  static const String online = 'discover/online';
  static const String discover = 'discover/list';
  // model to see customer
  static const String modelDiscover = '/model/discover/customers';
  static const String modelDiscoverCustomer = '/model/discover/customer';

  // feedback
  static const String feedback = 'feedback';
  // notification
  static const String notification = 'notifications/settings';
  static const String myNotificaiton = 'notifications';
  static const String notificationRead = 'notifications/read';
  static const String notificationReadAll = 'notifications/read-all';
  static const String notificationUnreadCount = 'notifications/unread-count';
  // reivew
  static const String addReview = 'reviews';
  static const String reviewList = 'reviews/model';

  // like api
  static const String modelLike = 'model/interactions/customers/';
  static const String clientLike = 'customer/interactions/models/';
  static const String modelAddFriend = 'model/interactions/friends/';
  static const String clientAddFriend = 'customer/interactions/friends/';
  // package
  static const String package = 'customer/subscriptions/packages';
  static const String packageHistory = 'customer/subscriptions/history';
  static const String packageActive = 'customer/subscriptions/check-active';
  static const String packageHour = 'customer/subscriptions/trial';
  static const String subcriptionPaid = 'customer/subscriptions/wallet';
  static const String subcriptionNoBalance = 'customer/subscriptions';
  // wallet
  static const String clientWallet = 'wallet';
  static const String clientTopup = 'topup';
  static const String clientTransactions = 'transactions';
  static const String modelTransactions = 'model/wallet/transactions';
  static const String modelWallet = 'model/wallet';
  static const String modelWithdraw = 'model/wallet/withdraw';
  // bank account
  static const String modelBankAccount = 'model-banks';
  // system QR code
  static const String systemQR = 'system/payment-qr-code';
  // booking
  static const String booking = 'bookings';
  static const String bookingSlots = 'bookings/booked-slots';
  // model booking
  static const String modelBooking = 'model/bookings';
  // my post
  static const String myPost = 'posts';
  // my gift
  static const String gift = 'gifts';
  static const String giftPost = 'gifts/post';
  // location
  static const String meLocation = 'me/location';
  // chat
  static String get chatSocketUrl => '$_host/chat';
  static const String chatConversations = 'chat/conversations';
  static const String chatMessages = 'chat/messages';
  static const String bages = 'me/badges';
  // "ask admin" assistant (customer only)
  static const String assistantAsk = 'assistant/ask';
  static const String assistantHistory = 'assistant/history';
  // daily check-in (model only)
  static const String rewardsCheckin = 'rewards/checkin';
  static const String rewardsCheckinClaim = 'rewards/checkin/claim';
  // referral
  static const String referral = 'model/referrals';
  static const String referralValidate = 'referrals/validate';
  static const String referralComission = 'model/referrals/commissions';
}
