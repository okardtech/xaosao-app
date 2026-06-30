import 'package:get/get.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/pages/model_wallet/getx/model_wallet_logic.dart';
import 'package:xaosao/pages/posts/getx/post_logic.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/repository/chat_repo.dart';
import 'package:xaosao/repository/notification_repo.dart';
import 'package:xaosao/services/location_service.dart';
import 'package:xaosao/services/notification_service.dart';
import '../../package/getx/package_logic.dart';
import 'dashboard_state.dart';

class DashboardLogic extends GetxController {
  final bool isCustomer;
  DashboardLogic({required this.isCustomer});

  final _notifRepo = NotificationRepo();
  final _chatRepo = ChatRepo();

  static const _walletTypes = {
    'topup_created',
    'topup_approved',
    'topup_rejected',
    'withdraw_approved',
    'withdraw_rejected',
    'booking_payout_released',
  };

  @override
  void onInit() {
    super.onInit();
    _fetchUnreadCount();
    _fetchBadgeCounts();
    LocationService.push();
    NotificationService.addForegroundListener(_onForegroundPush);
  }

  @override
  void onClose() {
    NotificationService.removeForegroundListener(_onForegroundPush);
    super.onClose();
  }

  void _onForegroundPush(String type, Map<String, dynamic> data) {
    // Refresh API-based counts on every push
    _fetchUnreadCount();
    _fetchBadgeCounts();

    // Booking push → MeetUpLogic owns its own state update (subscribes directly
    // to the foreground broadcaster), so nothing to do here for booking_*.

    // Post push → sync counts for the specific post (foreground only)
    if (type.startsWith('post_')) {
      final postId = data['postId'] as String? ?? '';
      if (postId.isNotEmpty) {
        try {
          Get.find<PostLogic>().syncPostCount(postId);
        } catch (_) {}
      }
    }

    // Wallet/topup/withdraw push → refresh the wallet page data
    if (_walletTypes.contains(type)) {
      if (isCustomer) {
        try {
          Get.find<WalletLogic>().refresh();
        } catch (_) {}
        try {
          Get.find<PackageLogic>().fetchPackages();
        } catch (_) {}
      } else {
        try {
          Get.find<ModelWalletLogic>().refresh();
        } catch (_) {}
        try {
          Get.find<PackageLogic>().fetchPackages();
        } catch (_) {}
      }
    }
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final res = await _notifRepo.unreadCount();
      if (res.success && res.data != null) {
        NotificationService.unreadCount.value = res.data!;
      }
    } catch (_) {}
  }

  void refreshBadges() => _fetchBadgeCounts();

  Future<void> _fetchBadgeCounts() async {
    try {
      final res = await _chatRepo.bageUnreadCount();
      if (res.success && res.data != null) {
        final b = res.data!;
        NotificationService.chatUnreadCount.value = b.unreadChats ?? 0;
        NotificationService.bookingUnreadCount.value = b.pendingBookings ?? 0;
        NotificationService.postUnreadCount.value = b.activePosts ?? 0;
      }
    } catch (_) {}
  }

  final _state = const DashboardState().obs;
  DashboardState get state => _state.value;

  void jumpTo(int index) {
    _state.value = state.copyWith(currentIndex: index);
    if (index == 1) {
      _fetchBadgeCounts();
      try {
        Get.find<ChatLogic>().fetchConversations();
      } catch (_) {}
    }
    if (index == 2) {
      try {
        Get.find<MeetUpLogic>().filterBy(null);
      } catch (_) {}
    }
    if (index == 3) {
      try {
        Get.find<PostLogic>().resetToFirst();
      } catch (_) {}
    }
    if (index == 4 && isCustomer) {
      try {
        Get.find<WalletLogic>().refresh();
      } catch (_) {}
    }
  }
}
