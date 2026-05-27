import 'package:flutter/material.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/pages/companion_profile/add_review_page.dart';
import 'package:xaosao/pages/companion_profile/companion_profile_page.dart';
import 'package:xaosao/pages/dashboard/dasboard_page.dart';
import 'package:xaosao/pages/feedback/feedback_page.dart';
import 'package:xaosao/pages/notification/components/notification_setting.dart';
import 'package:xaosao/pages/forgot_password/forgot_new_password_page.dart';
import 'package:xaosao/pages/forgot_password/forgot_otp_page.dart';
import 'package:xaosao/pages/forgot_password/forgot_phone_page.dart';
import 'package:xaosao/pages/login/login_page.dart';
import 'package:xaosao/pages/profile/change_password/change_password_page.dart';
import 'package:xaosao/pages/profile_detail/compoents/update_info_page.dart';
import 'package:xaosao/pages/profile_detail/profile_detail_page.dart';
import 'package:xaosao/pages/register/components/services_select.dart';
import 'package:xaosao/pages/register/components/verify_otp.dart';
import 'package:xaosao/pages/register/getx/register_state.dart';
import 'package:xaosao/pages/register/register_page.dart';
import '../pages/login/getx/login_state.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/splash/splash_screen.dart';
import '../pages/wallet/wallet_page.dart';
import '../pages/topup/topup_amount.dart';
import '../pages/topup/components/topup_qr.dart';
import '../pages/topup/components/topup_upload.dart';
import '../pages/topup/components/topup_success.dart';
import '../pages/model_wallet/model_wallet_page.dart';
import '../pages/model_wallet/withdraw_page.dart';
import '../pages/package/package_page.dart';
import '../pages/package/components/package_history.dart';
import '../pages/package/subscription_checkout_page.dart';
import '../pages/booking/booking_args.dart';
import '../pages/booking/booking_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String xaosaoHome = 'xaosao-home';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String servicesSelect = '/services-select';
  static const String forgotPassword = '/forgot-password';
  static const String forgotOtp = '/forgot-otp';
  static const String forgotNewPassword = '/forgot-new-password';
  static const String profileDetail = '/profile-detail';
  static const String updateInfo = '/update-info';
  static const String changePassword = '/change-password';
  static const String feedback = '/feedback';
  static const String notificationSettings = '/notification-settings';
  static const String companionProfile = '/companion-profile';
  static const String addReview = '/add-review';
  static const String wallet = '/wallet';
  static const String topupAmount = '/topup-amount';
  static const String topupQr = '/topup-qr';
  static const String topupUpload = '/topup-upload';
  static const String topupSuccess = '/topup-success';
  static const String modelWallet = '/model-wallet';
  static const String withdraw = '/withdraw';
  static const String package = '/package';
  static const String packageHistory = '/package-history';
  static const String subscriptionCheckout = '/subscription-checkout';
  static const String booking = '/booking';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fade(const SplashPage());
      case login:
        return _slideRight(const LoginPage());
      case dashboard:
        return _fade(const DashboardPage());
      case xaosaoHome:
        return _slideUp(const XaosaoHomePage());
      case register:
        final role = settings.arguments as RegisterRole;
        return _slideRight(RegisterPage(role: role));
      case verifyOtp:
        final otpModel = settings.arguments as RegisterModel;
        return _slideRight(OtpPage(model: otpModel));
      case servicesSelect:
        final svcModel = settings.arguments as RegisterModel;
        return _slideRight(ServicesSelect(model: svcModel));
      case forgotPassword:
        return _slideRight(const ForgotPhonePage());
      case forgotOtp:
        final phone = settings.arguments as String;
        return _slideRight(ForgotOtpPage(phone: phone));
      case forgotNewPassword:
        final phone = settings.arguments as String;
        return _slideRight(ForgotNewPasswordPage(phone: phone));
      case profileDetail:
        final isClient = settings.arguments as bool;
        return _slideRight(ProfileDetailPage(isClient: isClient));
      case updateInfo:
        final args = settings.arguments as Map<String, dynamic>;
        return _slideRight(UpdateInfoPage(
          isClient: args['isClient'] as bool,
          profile: args['profile'] as BaseProfileModel,
        ));
      case changePassword:
        return _slideRight(const ChangePasswordPage());
      case feedback:
        return _slideRight(const FeedbackPage());
      case notificationSettings:
        return _slideRight(const NotificationSettingPage());
      case companionProfile:
        final model = settings.arguments as RecommendedModel;
        return _slideRight(CompanionProfilePage(model: model));
      case addReview:
        final args = settings.arguments as Map<String, dynamic>;
        return _slideRight(AddReviewPage(
          modelId: args['modelId'] as String? ?? '',
          companionName: args['companionName'] as String? ?? '',
          tag: args['tag'] as String? ?? '',
        ));
      case wallet:
        return _slideRight(const WalletPage());
      case topupAmount:
        final topupArgs = settings.arguments;
        int? initialAmount;
        String? subscriptionPlanId;
        if (topupArgs is Map) {
          if (topupArgs['initialAmount'] is int) initialAmount = topupArgs['initialAmount'] as int;
          if (topupArgs['subscriptionPlanId'] is String) subscriptionPlanId = topupArgs['subscriptionPlanId'] as String;
        }
        return _slideRight(TopUpAmountPage(initialAmount: initialAmount, subscriptionPlanId: subscriptionPlanId));
      case topupQr:
        return _slideRight(const TopUpQRPage());
      case topupUpload:
        return _slideRight(const TopUpUploadSlipPage());
      case topupSuccess:
        return _fadeScale(const TopUpSuccessPage());
      case modelWallet:
        return _slideRight(const ModelWalletPage());
      case withdraw:
        return _slideRight(const WithdrawPage());
      case package:
        return _slideRight(const PackagePage());
      case packageHistory:
        return _slideRight(const PackageHistoryPage());
      case subscriptionCheckout:
        final checkoutArgs = settings.arguments as SubscriptionCheckoutArgs;
        return _slideUp(SubscriptionCheckoutPage(args: checkoutArgs));
      case booking:
        final bookingArgs = settings.arguments as BookingArgs;
        return _slideUp(BookingPage(args: bookingArgs));
      default:
        return _fade(const SplashPage());
    }
  }

  // ── Slide from right (standard navigation)
  static Route _slideRight(Widget page) => PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (_, anim, secAnim, child) {
      final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      );
    },
  );

  // ── Slide up from bottom (modal/sheet feel — checkout flow)
  static Route _slideUp(Widget page) => PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (_, anim, secAnim, child) {
      final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutQuart);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1.0),
          end: Offset.zero,
        ).animate(curve),
        child: child,
      );
    },
  );

  // ── Fade (splash, dashboard)
  static Route _fade(Widget page) => PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );

  // ── Fade + Scale (success — feels rewarding)
  static Route _fadeScale(Widget page) => PageRouteBuilder(
    pageBuilder: (_, anim, __) => page,
    transitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (_, anim, __, child) {
      final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.88, end: 1.0).animate(curve),
          child: child,
        ),
      );
    },
  );
}
