import 'package:xaosao/models/notification_item_model.dart';

enum NotifListStatus { initial, loading, loadingMore, success, failure }

class NotifListState {
  final NotifListStatus status;
  final List<NotificationItemModel> items;
  final bool hasMore;
  final int page;
  final int unreadCount;

  const NotifListState({
    this.status = NotifListStatus.initial,
    this.items = const [],
    this.hasMore = false,
    this.page = 1,
    this.unreadCount = 0,
  });

  NotifListState copyWith({
    NotifListStatus? status,
    List<NotificationItemModel>? items,
    bool? hasMore,
    int? page,
    int? unreadCount,
  }) =>
      NotifListState(
        status: status ?? this.status,
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        unreadCount: unreadCount ?? this.unreadCount,
      );
}
