import 'package:get/get.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/models/customer_public_profile.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/model_discover/getx/customer_detail_state.dart';
import 'package:xaosao/repository/discover_repo.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';

class CustomerDetailLogic extends GetxController {
  final String customerId;
  CustomerDetailLogic({required this.customerId});

  final _repo = DiscoverRepo();
  final Rx<CustomerDetailState> _state = const CustomerDetailState().obs;
  final chatLoading = false.obs;
  final friendLoading = false.obs;
  final isFriend = false.obs;
  final showTitle = false.obs;

  CustomerDetailState get state => _state.value;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    _state.value = const CustomerDetailState(status: CustomerDetailStatus.loading);
    try {
      final res = await _repo.getCustomerById(customerId: customerId);
      if (res.success && res.data != null) {
        _state.value = CustomerDetailState(
          status: CustomerDetailStatus.success,
          profile: res.data,
        );
      } else {
        _state.value = CustomerDetailState(
          status: CustomerDetailStatus.failure,
          error: res.laMessage ?? 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
        );
      }
    } catch (_) {
      _state.value = const CustomerDetailState(
        status: CustomerDetailStatus.failure,
        error: 'ມີຂໍ້ຜິດພາດເກີດຂຶ້ນ',
      );
    }
  }

  Future<void> startChat(CustomerPublicProfile profile) async {
    if (chatLoading.value) return;
    chatLoading.value = true;
    try {
      await Get.find<ChatLogic>().startConversation(
        profile.id,
        partnerHint: ConversationParticipant(
          id: profile.id,
          firstName: profile.firstName,
          lastName: profile.lastName,
          profileImage: profile.profile,
        ),
      );
    } finally {
      chatLoading.value = false;
    }
  }

  Future<void> toggleFriend() async {
    if (friendLoading.value) return;
    final profile = state.profile;
    if (profile == null) return;
    final wasFriend = isFriend.value;
    isFriend.value = !wasFriend;
    friendLoading.value = true;
    try {
      final isClient =
          Get.find<StorageService>().read<String>('role') == 'customer';
      final res = wasFriend
          ? await ReviewRepo().unFriend(isClient: isClient, id: profile.id)
          : await ReviewRepo().addFriend(isClient: isClient, id: profile.id);
      if (!res.success) isFriend.value = wasFriend;
    } catch (_) {
      isFriend.value = wasFriend;
    } finally {
      friendLoading.value = false;
    }
  }
}
