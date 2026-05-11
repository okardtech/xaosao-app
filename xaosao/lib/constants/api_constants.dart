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

  //
  static const String recommended = '/discover/recommended';
  static const String online = 'discover/online';
}
