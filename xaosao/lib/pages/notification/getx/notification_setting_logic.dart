import 'package:get/get.dart';
import 'package:xaosao/repository/setting_repo.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'notification_setting_state.dart';

class NotifSettingLogic extends GetxController {
  final _repo = SettingRepo();
  final Rx<NotifSettingState> _state = const NotifSettingState().obs;

  NotifSettingState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    _state.value = state.copyWith(status: NotifSettingStatus.loading);
    final res = await _repo.myNotifcation();
    if (res.success && res.data != null) {
      final d = res.data!;
      _state.value = state.copyWith(
        status: NotifSettingStatus.success,
        pushEnabled: d.pushEnabled ?? false,
        emailEnabled: d.emailEnabled ?? false,
        smsEnabled: d.smsEnabled ?? false,
        whatsappEnabled: d.whatsappEnabled ?? false,
      );
    } else {
      _state.value = state.copyWith(status: NotifSettingStatus.failure);
    }
  }

  Future<void> togglePush(bool val) => _update(push: val);
  Future<void> toggleEmail(bool val) => _update(email: val);
  Future<void> toggleSms(bool val) => _update(sms: val);
  Future<void> toggleWhatsapp(bool val) => _update(whatsapp: val);

  Future<void> _update({bool? push, bool? email, bool? sms, bool? whatsapp}) async {
    final prev = state;
    _state.value = state.copyWith(
      pushEnabled: push ?? state.pushEnabled,
      emailEnabled: email ?? state.emailEnabled,
      smsEnabled: sms ?? state.smsEnabled,
      whatsappEnabled: whatsapp ?? state.whatsappEnabled,
    );

    final cur = _state.value;
    final res = await _repo.updateNotification(
      pushEnabled: cur.pushEnabled,
      emailEnabled: cur.emailEnabled,
      smsEnabled: cur.smsEnabled,
      whatsappEnabled: cur.whatsappEnabled,
    );

    if (!res.success) {
      _state.value = prev;
      AppSnackbar.error(res.message ?? 'ອັບເດດບໍ່ສຳເລັດ');
    }
  }
}
