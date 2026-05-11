import 'package:get/get.dart';
import 'package:xaosao/pages/forgot_password/getx/forgot_logic.dart';
import 'package:xaosao/pages/home/getx/home_logic.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/onboarding/getx/onboarding_logic.dart';
import 'package:xaosao/pages/profile/getx/profile_logic.dart';
import 'package:xaosao/services/api_service.dart';
import 'package:xaosao/services/authe_service.dart';

import '../pages/register/getx/register_logic.dart';

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
    Get.lazyPut<ForgotLogic>(() => ForgotLogic(), fenix: true);
  }
}
