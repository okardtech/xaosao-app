import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/pages/notification/getx/notification_list_state.dart';
import 'package:xaosao/repository/notification_repo.dart';
import 'package:xaosao/services/notification_service.dart';
import 'package:xaosao/services/storage_service.dart';

class NotifListLogic extends GetxController {
  final _repo = NotificationRepo();

  final Rx<NotifListState> _state = const NotifListState().obs;
  NotifListState get state => _state.value;
  void _update(NotifListState s) => _state.value = s;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications(refresh: true);
    // Keep global badge in sync when a new push arrives while page is open
    NotificationService.onNewNotification =
        () => fetchNotifications(refresh: true);
  }

  // ── Fetch ──────────────────────────────────────────────────────
  Future<void> fetchNotifications({bool refresh = false}) async {
    _update(state.copyWith(
      status: NotifListStatus.loading,
      page: refresh ? 1 : state.page,
    ));
    final res = await _repo.getNotifications(page: 1);
    if (res.success && res.data != null) {
      final d = res.data!;
      _update(state.copyWith(
        status: NotifListStatus.success,
        items: d.items,
        hasMore: d.hasNextPage,
        page: d.currentPage,
        unreadCount: d.unreadCount,
      ));
      // Sync global badge with the authoritative value from server
      NotificationService.unreadCount.value = d.unreadCount;
    } else {
      _update(state.copyWith(status: NotifListStatus.failure));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.status == NotifListStatus.loadingMore) return;
    _update(state.copyWith(status: NotifListStatus.loadingMore));
    final res = await _repo.getNotifications(page: state.page + 1);
    if (res.success && res.data != null) {
      final d = res.data!;
      _update(state.copyWith(
        status: NotifListStatus.success,
        items: [...state.items, ...d.items],
        hasMore: d.hasNextPage,
        page: d.currentPage,
        unreadCount: d.unreadCount,
      ));
      NotificationService.unreadCount.value = d.unreadCount;
    } else {
      _update(state.copyWith(status: NotifListStatus.success));
    }
  }

  // ── Mark read ──────────────────────────────────────────────────
  Future<void> markRead(String id) async {
    final idx = state.items.indexWhere((e) => e.id == id);
    if (idx == -1 || (state.items[idx].isRead ?? false)) return;

    final updated = List<NotificationItemModel>.from(state.items);
    final old = updated[idx];
    updated[idx] = NotificationItemModel(
      id: old.id,
      type: old.type,
      title: old.title,
      message: old.message,
      data: old.data,
      isRead: true,
      createdAt: old.createdAt,
    );
    final newCount = (state.unreadCount - 1).clamp(0, state.unreadCount);
    _update(state.copyWith(items: updated, unreadCount: newCount));
    NotificationService.unreadCount.value = newCount;

    await _repo.markRead(ids: [id]);
  }

  Future<void> markAllRead() async {
    if (state.unreadCount == 0) return;
    _update(state.copyWith(
      items: state.items
          .map(
            (e) => NotificationItemModel(
              id: e.id,
              type: e.type,
              title: e.title,
              message: e.message,
              data: e.data,
              isRead: true,
              createdAt: e.createdAt,
            ),
          )
          .toList(),
      unreadCount: 0,
    ));
    NotificationService.unreadCount.value = 0;

    await _repo.markAllRead();
  }

  // ── Tap handler (in-app notification list tap) ──────────────────
  void handleTap(NotificationItemModel item) {
    markRead(item.id ?? '');
    _navigateFromType(item.type ?? '', item.data);
  }

  // ── Type-specific navigation ────────────────────────────────────
  void _navigateFromType(String type, Data? data) {
    final isCustomer =
        Get.find<StorageService>().read<String>('role') == 'customer';

    switch (type) {
      // ── Wallet / finance ──────────────────────────────────────
      case 'topup_created':
      case 'topup_approved':
      case 'topup_rejected':
      case 'withdraw_approved':
      case 'withdraw_rejected':
      case 'booking_payout_released':
        Get.toNamed(isCustomer ? AppRoutes.wallet : AppRoutes.modelWallet);
        return;

      // ── Account ───────────────────────────────────────────────
      case 'account_approved':
      case 'account_rejected':
      case 'account_banned':
      case 'account_deleted':
      case 'account_role_changed':
      case 'account_reported':
        Get.toNamed(AppRoutes.profileDetail, arguments: isCustomer);
        return;

      // ── Booking ───────────────────────────────────────────────
      case 'booking_created':
      case 'booking_accepted':
      case 'booking_rejected':
      case 'booking_cancelled':
      case 'booking_completed':
        final bookingId = data?.bookingId ?? '';
        if (bookingId.isNotEmpty) {
          Get.toNamed(AppRoutes.bookingDetail, arguments: {
            'bookingId': bookingId,
            'isCustomer': isCustomer,
          });
        }
        return;

      // ── Post interactions → companion profile ─────────────────
      case 'post_comment':
      case 'post_comment_reply':
      case 'post_like':
      case 'post_gift_received':
        final modelId = data?.modelId ?? '';
        if (modelId.isNotEmpty) {
          Get.toNamed(AppRoutes.companionProfile, arguments: modelId);
        }
        return;

      default:
        return;
    }
  }
}
