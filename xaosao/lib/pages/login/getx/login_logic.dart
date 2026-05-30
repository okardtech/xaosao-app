import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/getx/login_state.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/repository/login_repo.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/storage_service.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';

class LoginLogic extends GetxController {
  final _repo = LoginRepo();

  final Rx<LoginState> _state = LoginState().obs;
  LoginState get state => _state.value;
  Rx<LoginState> get getXController => _state;

  void _updateState(LoginState newState) => _state.value = newState;

  void setRole(RegisterRole role) => _updateState(state.copyWith(role: role));

  void updateProfileUrl(String url, bool isClient) {
    if (isClient && state.customerProfile != null) {
      _updateState(
        state.copyWith(
          customerProfile: state.customerProfile!.copyWith(profile: url),
        ),
      );
    } else if (!isClient && state.modelProfile != null) {
      _updateState(
        state.copyWith(
          modelProfile: state.modelProfile!.copyWith(profile: url),
        ),
      );
    }
  }

  // ── Login ─────────────────────────────────────────────────────
  Future<void> login({required String phone, required String password}) async {
    _updateState(state.copyWith(status: LoginStatus.loading));
    showLoadingDialog();
    try {
      final isCustomer = state.role == RegisterRole.customer;
      final res = await _repo.login(
        isCustomer: isCustomer,
        phoneNumber: phone,
        password: password,
      );

      if (!res.success || res.data == null) {
        _updateState(state.copyWith(status: LoginStatus.failure));
        hideLoadingDialog();
        AppSnackbar.error(res.laMessage ?? 'ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ');
        return;
      }

      final loginData = res.data!;
      final storage = Get.find<StorageService>();
      await storage.write('token', loginData.accessToken ?? '');
      await storage.write('refresh_token', loginData.refreshToken ?? '');
      await storage.write('role', isCustomer ? 'customer' : 'model');

      _updateState(state.copyWith(status: LoginStatus.success));

      // Fetch profile while loading dialog is still visible
      await fetchProfile(isCustomer: isCustomer);

      // Register FCM device token — fire-and-forget, non-critical
      saveFcmToken();

      hideLoadingDialog();
      Get.offAllNamed(AppRoutes.dashboard);
    } catch (e) {
      _updateState(state.copyWith(status: LoginStatus.failure));
      hideLoadingDialog();
      AppSnackbar.error('ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ');
    }
  }

  // ── Profile fetch (called right after login) ──────────────────
  Future<void> fetchProfile({required bool isCustomer}) async {
    _updateState(state.copyWith(profileStatus: LoginStatus.loading));
    try {
      final storage = Get.find<StorageService>();
      if (isCustomer) {
        final res = await _repo.customProfile();
        if (res.success && res.data != null) {
          await storage.write('user_gender', res.data!.gender ?? '');
          _updateState(
            state.copyWith(
              profileStatus: LoginStatus.success,
              customerProfile: res.data,
            ),
          );
          if (Get.isRegistered<WalletLogic>()) {
            Get.find<WalletLogic>().fetchWallet();
          }
        } else {
          _updateState(state.copyWith(profileStatus: LoginStatus.failure));
        }
      } else {
        final res = await _repo.modelProfile();
        if (res.success && res.data != null) {
          await storage.write('user_gender', res.data!.gender ?? '');
          _updateState(
            state.copyWith(
              profileStatus: LoginStatus.success,
              modelProfile: res.data,
            ),
          );
        } else {
          _updateState(state.copyWith(profileStatus: LoginStatus.failure));
        }
      }
    } catch (e) {
      _updateState(state.copyWith(profileStatus: LoginStatus.failure));
    }
  }

  // ── FCM token ─────────────────────────────────────────────────
  /// Registers the device FCM token with the server.
  /// Fire-and-forget — silently ignored on failure.
  Future<void> saveFcmToken() async {
    final token = NotificationService.fcmToken;
    if (token == null || token.isEmpty) return;
    try {
      await _repo.fcmTokenSave(fcmToken: token);
    } catch (_) {
      // Non-critical — do not surface errors to the user
    }
  }

  void clearState() => _updateState(LoginState());

  @override
  void onInit() {
    super.onInit();
  }
}
