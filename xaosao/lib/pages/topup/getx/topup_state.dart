import 'dart:io';

enum TopupPaymentType { topup, subscription }

class TopupState {
  final String? qrUrl;
  final bool loadingQr;
  final int amount;
  final List<File> slips;
  final TopupPaymentType paymentType;
  final String? subscriptionPlanId;

  const TopupState({
    this.qrUrl,
    this.loadingQr = false,
    this.amount = 0,
    this.slips = const [],
    this.paymentType = TopupPaymentType.topup,
    this.subscriptionPlanId,
  });

  bool get isSubscription =>
      paymentType == TopupPaymentType.subscription &&
      subscriptionPlanId != null;

  TopupState copyWith({
    String? qrUrl,
    bool? loadingQr,
    int? amount,
    List<File>? slips,
    TopupPaymentType? paymentType,
    String? subscriptionPlanId,
  }) =>
      TopupState(
        qrUrl: qrUrl ?? this.qrUrl,
        loadingQr: loadingQr ?? this.loadingQr,
        amount: amount ?? this.amount,
        slips: slips ?? this.slips,
        paymentType: paymentType ?? this.paymentType,
        subscriptionPlanId: subscriptionPlanId ?? this.subscriptionPlanId,
      );
}
