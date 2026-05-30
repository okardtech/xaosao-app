import 'package:get/get.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/meet_ups/getx/meet_ups_logic.dart';
import 'package:xaosao/pages/posts/getx/post_logic.dart';
import 'package:xaosao/pages/wallet/getx/wallet_logic.dart';
import 'package:xaosao/repository/notification_repo.dart';
import 'package:xaosao/services/notification_service.dart';
import 'dashboard_state.dart';

class DashboardLogic extends GetxController {
  final bool isCustomer;
  DashboardLogic({required this.isCustomer});

  final _notifRepo = NotificationRepo();

  @override
  void onInit() {
    super.onInit();
    _fetchUnreadCount();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final res = await _notifRepo.unreadCount();
      if (res.success && res.data != null) {
        NotificationService.unreadCount.value = res.data!;
      }
    } catch (_) {}
  }

  final _state = const DashboardState().obs;
  DashboardState get state => _state.value;

  void jumpTo(int index) {
    _state.value = state.copyWith(currentIndex: index);
    if (index == 1) {
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
