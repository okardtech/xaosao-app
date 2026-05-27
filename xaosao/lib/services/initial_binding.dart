import 'package:get/get.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_logic.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/pages/onboarding/getx/onboarding_logic.dart';
import 'package:xaosao/pages/posts/getx/post_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/pages/feedback/getx/feedback_logic.dart';
import 'package:xaosao/pages/notification/getx/notification_setting_logic.dart';
import 'package:xaosao/pages/model_discover/getx/model_discover_logic.dart';
import 'package:xaosao/pages/qr_manage/getx/qr_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_logic.dart';
import 'package:xaosao/services/api_service.dart';
import 'package:xaosao/services/authe_service.dart';

import '../pages/register/getx/register_logic.dart';
import '../pages/view_companion/getx/view_companion_logic.dart';
import '../pages/wallet/getx/wallet_logic.dart';
import '../pages/topup/getx/topup_logic.dart';
import '../pages/model_wallet/getx/model_wallet_logic.dart';
import '../pages/package/getx/package_logic.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<ApiService>(() => ApiService().init(), permanent: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    Get.lazyPut<LoginLogic>(() => LoginLogic(), fenix: true);
    Get.lazyPut<OnboardingLogic>(() => OnboardingLogic(), fenix: true);
    Get.lazyPut<RegisterLogic>(() => RegisterLogic(), fenix: true);
    Get.lazyPut<HomeLogic>(() => HomeLogic(), fenix: true);
    Get.lazyPut<ProfileLogic>(() => ProfileLogic(), fenix: true);
    Get.lazyPut<ServiceLogic>(() => ServiceLogic(), fenix: true);
    Get.lazyPut<FeedbackLogic>(() => FeedbackLogic(), fenix: true);
    Get.lazyPut<NotifSettingLogic>(() => NotifSettingLogic(), fenix: true);
    Get.lazyPut<ForgotLogic>(() => ForgotLogic(), fenix: true);
    Get.lazyPut<ModelDiscoverLogic>(() => ModelDiscoverLogic(), fenix: true);
    Get.lazyPut<QrLogic>(() => QrLogic(), fenix: true);
    Get.lazyPut<WalletLogic>(() => WalletLogic(), fenix: true);
    Get.lazyPut<TopupLogic>(() => TopupLogic(), fenix: true);
    Get.lazyPut<ModelWalletLogic>(() => ModelWalletLogic(), fenix: true);
    Get.lazyPut<PackageLogic>(() => PackageLogic(), fenix: true);
    Get.lazyPut<MeetUpLogic>(() => MeetUpLogic(), fenix: true);
    Get.lazyPut<ViewCompanionLogic>(() => ViewCompanionLogic(), fenix: true);
     Get.lazyPut<PostLogic>(() => PostLogic(), fenix: true);
  }
}
