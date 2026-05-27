import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/register/getx/register_state.dart';
import 'package:xaosao/repository/register_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/image_picker_util.dart';
import 'package:xaosao/widgets/show_loading_alert.dart';
import '../../../services/storage_service.dart';
import '../../login/getx/login_state.dart';

class RegisterLogic extends GetxController {
  final _repo = RegisterRepo();

  final Rx<RegisterState> _state = RegisterState().obs;
  RegisterState get state => _state.value;
  Rx<RegisterState> get getXController => _state;

  // Pending companion data (transient — not reactive)
  String _pendingFirstName = '';
  String _pendingLastName = '';
  String? _pendingPhone;
  String _pendingPassword = '';
  String _pendingAddress = '';
  String _pendingFilePath = '';

  void _updateState(RegisterState newState) => _state.value = newState;

  void setRole(RegisterRole role) => _updateState(state.copyWith(role: role));

  void setGender(Map<String, dynamic> gender) =>
      _updateState(state.copyWith(gender: gender));

  void setDob(DateTime? dob) => _updateState(state.copyWith(dob: dob));

  Future<void> pickAvatar() async {
    final file = await ImagePickerUtil.pick();
    if (file == null) return;
    _updateState(state.copyWith(avatarFile: file));
  }

  // ── Services ──────────────────────────────────────────────────
  Future<void> fetchServices() async {
    _updateState(state.copyWith(servicesStatus: RegisterStatus.loading));
    try {
      final res = await _repo.servicePublic();
      if (res.success && res.data != null) {
        _updateState(
          state.copyWith(
            servicesStatus: RegisterStatus.success,
            services: res.data!,
          ),
        );
      } else {
        _updateState(state.copyWith(servicesStatus: RegisterStatus.failure));
        AppSnackbar.error(res.laMessage ?? 'ໂຫຼດບໍລິການບໍ່ສຳເລັດ');
      }
    } catch (e) {
      _updateState(state.copyWith(servicesStatus: RegisterStatus.failure));
      AppSnackbar.error('ໂຫຼດບໍລິການບໍ່ສຳເລັດ');
    }
  }

  // ── Registration flow ─────────────────────────────────────────
  Future<void> uploadAndRegister({
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    String? address,
  }) async {
    _updateState(state.copyWith(status: RegisterStatus.loading));
    showLoadingDialog();
    try {
      final isCompanion = state.role == RegisterRole.companion;

      if (isCompanion) {
        _pendingFirstName = firstName;
        _pendingLastName = lastName;
        _pendingPhone = phone;
        _pendingPassword = password;
        _pendingAddress = address ?? '';
        _pendingFilePath = state.avatarFile?.path ?? '';
        _updateState(state.copyWith(status: RegisterStatus.success));
        hideLoadingDialog();
        Get.toNamed(
          AppRoutes.servicesSelect,
          arguments: RegisterModel(role: RegisterRole.companion, phone: phone),
        );
      } else {
        final res = await _repo.registerCustomer(
          filePath: state.avatarFile?.path ?? '',
          firstname: firstName,
          lastname: lastName,
          whatsapp: phone,
          dob: state.dob ?? DateTime(1990),
          gender: state.gender['value'] ?? 'male',
          password: password,
        );
        _updateState(
          state.copyWith(
            signUpModel: res.data,
            status: res.success
                ? RegisterStatus.success
                : RegisterStatus.failure,
          ),
        );
        hideLoadingDialog();
        if (!res.success) {
          AppSnackbar.error(res.laMessage ?? 'ລົງທະບຽນບໍ່ສຳເລັດ');
          return;
        }
        Get.toNamed(
          AppRoutes.verifyOtp,
          arguments: RegisterModel(role: RegisterRole.customer, phone: phone),
        );
      }
    } catch (e) {
      print('error ==>${e}');
      _updateState(state.copyWith(status: RegisterStatus.failure));
      hideLoadingDialog();
      AppSnackbar.error('ລົງທະບຽນບໍ່ສຳເລັດ');
    }
  }

  Future<void> registerModel({
    required List<Map<String, dynamic>> selectedServices,
  }) async {
    final phone = _pendingPhone;
    if (phone == null) return;
    _updateState(state.copyWith(status: RegisterStatus.loading));
    showLoadingDialog();
    try {
      final res = await _repo.registerModel(
        filePath: _pendingFilePath,
        firstname: _pendingFirstName,
        lastname: _pendingLastName,
        address: _pendingAddress,
        whatsapp: phone,
        dob: state.dob ?? DateTime(1990),
        gender: state.gender['value'] ?? 'male',
        password: _pendingPassword,
        services: selectedServices,
      );
      _updateState(
        state.copyWith(
          signUpModel: res.data,
          status: res.success ? RegisterStatus.success : RegisterStatus.failure,
        ),
      );
      hideLoadingDialog();
      if (!res.success) {
        AppSnackbar.error(res.laMessage ?? 'ລົງທະບຽນບໍ່ສຳເລັດ');
        return;
      }
      Get.toNamed(
        AppRoutes.verifyOtp,
        arguments: RegisterModel(role: RegisterRole.companion, phone: phone),
      );
    } catch (e) {
      _updateState(state.copyWith(status: RegisterStatus.failure));
      hideLoadingDialog();
      AppSnackbar.error('ລົງທະບຽນບໍ່ສຳເລັດ');
    }
  }

  // ── OTP ───────────────────────────────────────────────────────
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
    required bool isCustomer,
  }) async {
    _updateState(state.copyWith(status: RegisterStatus.loading));
    showLoadingDialog();
    try {
      final res = await _repo.verifyOtp(
        phone: phone,
        otp: otp,
        isCustomer: isCustomer,
      );
      _updateState(
        state.copyWith(
          status: res.success ? RegisterStatus.success : RegisterStatus.failure,
        ),
      );
      hideLoadingDialog();
      if (!res.success || res.data == null) {
        AppSnackbar.error(res.laMessage ?? 'OTP ບໍ່ຖືກຕ້ອງ');
        return false;
      }
      if (isCustomer) {
        await Get.find<StorageService>().write(
          'token',
          state.signUpModel?.token,
        );
        await Get.find<StorageService>().write(
          'refresh_token',
          state.signUpModel?.refreshToken,
        );
        await Get.find<StorageService>().write(
          'role',
          isCustomer ? 'customer' : 'model',
        );
        await Get.find<LoginLogic>().fetchProfile(isCustomer: isCustomer);
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        AppSnackbar.success(res.laMessage ?? 'ການລົງທະບຽນສຳເລັດເເລ້ວ');
        Get.offAllNamed(AppRoutes.login);
      }
      return true;
    } catch (e) {
      _updateState(state.copyWith(status: RegisterStatus.failure));
      hideLoadingDialog();
      AppSnackbar.error('ກວດສອບ OTP ບໍ່ສຳເລັດ');
      return false;
    }
  }

  Future<bool> resendOtp({
    required String phone,
    required bool isCustomer,
  }) async {
    showLoadingDialog();
    try {
      final res = await _repo.resendOtp(phone: phone, isCustomer: isCustomer);
      hideLoadingDialog();
      if (!res.success) {
        AppSnackbar.error(res.laMessage ?? 'ສົ່ງ OTP ໃໝ່ບໍ່ສຳເລັດ');
        return false;
      }
      AppSnackbar.success('ສົ່ງລະຫັດ OTP ໃໝ່ແລ້ວ');
      return true;
    } catch (e) {
      hideLoadingDialog();
      AppSnackbar.error('ສົ່ງ OTP ໃໝ່ບໍ່ສຳເລັດ');
      return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  void clearState() {
    _updateState(RegisterState());
    _pendingFirstName = '';
    _pendingLastName = '';
    _pendingPhone = null;
    _pendingPassword = '';
    _pendingAddress = '';
    _pendingFilePath = '';
  }
}
