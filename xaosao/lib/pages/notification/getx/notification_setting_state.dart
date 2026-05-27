enum NotifSettingStatus { initial, loading, success, failure }

class NotifSettingState {
  final NotifSettingStatus status;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool whatsappEnabled;

  const NotifSettingState({
    this.status = NotifSettingStatus.initial,
    this.pushEnabled = false,
    this.emailEnabled = false,
    this.smsEnabled = false,
    this.whatsappEnabled = false,
  });

  NotifSettingState copyWith({
    NotifSettingStatus? status,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? whatsappEnabled,
  }) =>
      NotifSettingState(
        status: status ?? this.status,
        pushEnabled: pushEnabled ?? this.pushEnabled,
        emailEnabled: emailEnabled ?? this.emailEnabled,
        smsEnabled: smsEnabled ?? this.smsEnabled,
        whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      );
}
