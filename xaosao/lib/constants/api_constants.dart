class ApiConstants {
  static String baseUrl = "https://api.xaosao.com/api/v1/";
  // static String baseUrl = ";
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

  // feedback
  static const String feedback = 'feedback';
  // notification
  static const String notification = 'notifications/settings';
  // reivew
  static const String addReview = 'reviews';
  static const String reviewList = 'reviews/model';

  // like api
  static const String modelLike = 'model/interactions/customers/';
  static const String clientLike = 'customer/interactions/models/';
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
  // model booking
  static const String modelBooking = 'model/bookings';
  // my post
  static const String myPost = '/posts';
  // my gift
  static const String gift = 'gifts';
}
