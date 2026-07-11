import 'package:xaosao/models/referral_mdoel.dart';

enum ReferralStatus { initial, loading, success, failure }

class ReferralAnalyticsState {
  final ReferralStatus status;
  final ReferralModel? data;

  const ReferralAnalyticsState({
    this.status = ReferralStatus.initial,
    this.data,
  });

  ReferralAnalyticsState copyWith({
    ReferralStatus? status,
    ReferralModel? data,
  }) => ReferralAnalyticsState(
    status: status ?? this.status,
    data: data ?? this.data,
  );
}
