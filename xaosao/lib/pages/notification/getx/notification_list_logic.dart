import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/pages/posts/components/comment_sheet.dart';
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
      // ── Home ──────────────────────────────────────────────────
      case 'welcome':
      case 'account_deleted':
        Get.until((r) => r.settings.name == AppRoutes.dashboard);
        return;

      // ── Account (profile) ─────────────────────────────────────
      case 'account_approved':
      case 'account_rejected':
      case 'account_banned':
      case 'account_role_changed':
      case 'account_reported':
        Get.toNamed(AppRoutes.profileDetail, arguments: isCustomer);
        return;

      // ── New model / service ───────────────────────────────────
      case 'new_model_registered':
      case 'new_model_service':
        final modelId = data?.modelId ?? '';
        if (modelId.isNotEmpty) {
          Get.toNamed(AppRoutes.companionProfile, arguments: modelId);
        }
        return;

      // ── Post gifts ────────────────────────────────────────────
      case 'post_gift_received':
        final giftPostId = data?.postId ?? '';
        if (giftPostId.isNotEmpty) {
          Get.toNamed(AppRoutes.myGifts, arguments: giftPostId);
        }
        return;

      // ── Post comments ─────────────────────────────────────────
      case 'post_comment':
      case 'post_comment_reply':
        final commentPostId = data?.postId ?? '';
        if (commentPostId.isNotEmpty && Get.context != null) {
          CommentSheet.show(Get.context!, postId: commentPostId);
        }
        return;

      // ── Post views / new posts ────────────────────────────────
      case 'post_like':
      case 'new_model_post':
      case 'new_customer_post':
        final viewPostId = data?.postId ?? '';
        if (viewPostId.isNotEmpty) {
          Get.toNamed(AppRoutes.postDetail, arguments: viewPostId);
        }
        return;

      // ── Profile interactions ──────────────────────────────────
      case 'profile_viewed':
        final id = data?.viewerId ?? data?.modelId ?? '';
        if (id.isNotEmpty) Get.toNamed(AppRoutes.companionProfile, arguments: id);
        return;

      case 'profile_liked':
        final id = data?.likerId ?? data?.modelId ?? '';
        if (id.isNotEmpty) Get.toNamed(AppRoutes.companionProfile, arguments: id);
        return;

      case 'friend_added':
        final id = data?.friendId ?? data?.modelId ?? '';
        if (id.isNotEmpty) Get.toNamed(AppRoutes.companionProfile, arguments: id);
        return;

      case 'gift_received':
        final giftPostId2 = data?.postId ?? '';
        if (giftPostId2.isNotEmpty) {
          Get.toNamed(AppRoutes.myGifts, arguments: giftPostId2);
        }
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

      // ── Wallet / finance ──────────────────────────────────────
      case 'topup_created':
      case 'topup_approved':
      case 'topup_rejected':
      case 'withdraw_approved':
      case 'withdraw_rejected':
      case 'booking_payout_released':
        Get.toNamed(isCustomer ? AppRoutes.wallet : AppRoutes.modelWallet);
        return;

      default:
        return;
    }
  }
}
