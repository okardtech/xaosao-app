import 'package:xaosao/models/checkin_model.dart';

enum CheckinStatus { initial, loading, success, failure }

class CheckinPageState {
  final CheckinStatus status;
  final CheckinInfo? info;

  /// True while a claim is in flight, so the button can be held shut.
  /// Separate from [status] — reloading the card must not make the
  /// button spin, and claiming must not blank the strip.
  final bool claiming;

  /// What the last successful claim paid, for the confirmation line.
  /// Cleared on the next reload.
  final CheckinClaim? justClaimed;

  /// Why the last claim failed, in the server's words.
  final String? error;

  const CheckinPageState({
    this.status = CheckinStatus.initial,
    this.info,
    this.claiming = false,
    this.justClaimed,
    this.error,
  });

  CheckinPageState copyWith({
    CheckinStatus? status,
    CheckinInfo? info,
    bool? claiming,
    CheckinClaim? justClaimed,
    String? error,
    bool clearJustClaimed = false,
    bool clearError = false,
  }) => CheckinPageState(
    status: status ?? this.status,
    info: info ?? this.info,
    claiming: claiming ?? this.claiming,
    justClaimed: clearJustClaimed ? null : (justClaimed ?? this.justClaimed),
    error: clearError ? null : (error ?? this.error),
  );
}
