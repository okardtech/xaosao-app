import 'package:xaosao/models/my_gift_history_model.dart';

enum GiftHistoryStatus { initial, loading, success, failure }

class GiftHistoryState {
  final GiftHistoryStatus status;
  final List<MyGiftHistoryModel> items;
  final String? error;

  const GiftHistoryState({
    this.status = GiftHistoryStatus.initial,
    this.items = const [],
    this.error,
  });

  GiftHistoryState copyWith({
    GiftHistoryStatus? status,
    List<MyGiftHistoryModel>? items,
    String? error,
  }) =>
      GiftHistoryState(
        status: status ?? this.status,
        items: items ?? this.items,
        error: error ?? this.error,
      );
}
