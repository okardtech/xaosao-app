import 'package:flutter/material.dart';
import 'package:xaosao/pages/dashboard/dasboard_page.dart';
import 'package:xaosao/pages/forgot_password/forgot_new_password_page.dart';
import 'package:xaosao/pages/forgot_password/forgot_otp_page.dart';
import 'package:xaosao/pages/forgot_password/forgot_phone_page.dart';
import 'package:xaosao/pages/login/login_page.dart';
import 'package:xaosao/pages/register/components/services_select.dart';
import 'package:xaosao/pages/register/components/verify_otp.dart';
import 'package:xaosao/pages/register/getx/register_state.dart';
import 'package:xaosao/pages/register/register_page.dart';
import '../pages/login/getx/login_state.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/splash/splash_screen.dart';

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
