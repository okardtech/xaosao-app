import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/services/initial_binding.dart';
import 'package:xaosao/services/language_service.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/storage_service.dart';
import 'constants/app_color.dart';

// Must be a top-level function — Flutter runs background handlers in a separate
// isolate. All logic lives in NotificationService.handleBackgroundMessage.
@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) =>
    NotificationService.handleBackgroundMessage(message);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  await Get.putAsync(() => StorageService().init(), permanent: true);
  InitialBinding().dependencies();
  await NotificationService.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langService = Get.find<LanguageService>();
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => Obx(() {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Xaosao',
          locale: langService.locale,
          fallbackLocale: const Locale('lo'),
          supportedLocales: const [
            Locale('en'),
            Locale('lo'),
            Locale('th'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: AppColors.bg,
            fontFamily: 'NotoSansLao',
          ),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                  mediaQuery.textScaler.scale(1.0).clamp(0.9, 1.1),
                ),
              ),
              child: child!,
            );
          },
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          navigatorKey: NavigationService.navigatorKey,
          home: child,
        );
      }),
    );
  }
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
