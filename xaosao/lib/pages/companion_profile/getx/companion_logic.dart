import 'package:get/get.dart';
import 'package:xaosao/models/Recommended_model.dart';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/repository/discover_repo.dart';
import 'package:xaosao/repository/review_repo.dart';
import 'package:xaosao/services/storage_service.dart';
import '../../../models/model_available.dart';
import 'companion_state.dart';

class CompanionLogic extends GetxController {
  final String modelId;
  CompanionLogic({required this.modelId});

  final _repo = ReviewRepo();
  final _discoverRepo = DiscoverRepo();
  final Rx<CompanionState> _state = const CompanionState().obs;

  CompanionState get state => _state.value;
  Rx<CompanionState> get rxState => _state;

  final RxBool chatLoading = false.obs;
  final RxBool friendLoading = false.obs;

  static const _limit = 10;
  bool _loadingReviews = false;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadServices();
    loadReviews(refresh: true);
  }

  // ── Profile ────────────────────────────────────────────────────
  Future<void> loadProfile() async {
    _update(state.copyWith(profileStatus: CompanionLoadStatus.loading));
    try {
      final res = await _discoverRepo.getRecommendedById(modelId: modelId);
      if (res.success && res.data != null) {
        _update(state.copyWith(
          profile: res.data,
          profileStatus: CompanionLoadStatus.success,
        ));
      } else {
        _update(state.copyWith(profileStatus: CompanionLoadStatus.failure));
      }
    } catch (_) {
      _update(state.copyWith(profileStatus: CompanionLoadStatus.failure));
    }
  }

  // ── Services ───────────────────────────────────────────────────
  Future<void> loadServices() async {
    _update(state.copyWith(servicesStatus: CompanionLoadStatus.loading));
    try {
      final res = await _repo.modelAvailable(modelId: modelId);
      if (res.success && res.data != null) {
        _update(state.copyWith(
          services: res.data!,
          servicesStatus: CompanionLoadStatus.success,
        ));
      } else {
        _update(state.copyWith(servicesStatus: CompanionLoadStatus.failure));
      }
    } catch (_) {
      _update(state.copyWith(servicesStatus: CompanionLoadStatus.failure));
    }
  }

  // ── Reviews ────────────────────────────────────────────────────
  Future<void> loadReviews({bool refresh = false}) async {
    if (_loadingReviews) return;
    if (!refresh && !state.reviewHasMore) return;

    _loadingReviews = true;
    final isFirst = refresh;
    final page = isFirst ? 1 : state.reviewPage + 1;

    _update(state.copyWith(
      reviewStatus:
          isFirst ? ReviewLoadStatus.loading : ReviewLoadStatus.loadingMore,
    ));
    try {
      final res = await _repo.getReview(
        modelId: modelId,
        limit: '$_limit',
        page: '$page',
      );
      if (res.success && res.data != null) {
        final merged =
            isFirst ? res.data! : [...state.reviews, ...res.data!];
        _update(state.copyWith(
          reviews: merged,
          reviewPage: page,
          reviewHasMore: (res.data?.length ?? 0) >= _limit,
          reviewStatus: ReviewLoadStatus.success,
        ));
      } else {
        _update(state.copyWith(reviewStatus: ReviewLoadStatus.failure));
      }
    } catch (_) {
      _update(state.copyWith(reviewStatus: ReviewLoadStatus.failure));
    } finally {
      _loadingReviews = false;
    }
  }

  // ── Service selection ──────────────────────────────────────────
  void selectService(String serviceId) {
    if (state.selectedServiceId == serviceId) {
      _update(state.copyWith(clearSelectedService: true));
    } else {
      _update(state.copyWith(selectedServiceId: serviceId));
    }
  }

  ModelAvailable? get selectedService =>
      state.services.firstWhereOrNull((s) => s.id == state.selectedServiceId);

  // ── Review submit ──────────────────────────────────────────────
  Future<bool> submitReview({
    required double rating,
    required String title,
    required String desc,
  }) async {
    try {
      final res = await _repo.addReview(
        modelId: modelId,
        rating: rating,
        title: title,
        desc: desc,
      );
      if (res.success) {
        await loadReviews(refresh: true);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Friend toggle ──────────────────────────────────────────────
  Future<void> toggleFriend() async {
    if (friendLoading.value) return;
    final profile = state.profile;
    if (profile == null) return;

    final wasFriend = profile.isFriend ?? false;
    final count = profile.friendsCount ?? 0;
    _update(state.copyWith(
      profile: profile.copyWith(
        isFriend: !wasFriend,
        friendsCount: wasFriend ? (count - 1).clamp(0, 999999) : count + 1,
      ),
    ));
    friendLoading.value = true;
    try {
      final isClient =
          Get.find<StorageService>().read<String>('role') == 'customer';
      final res = wasFriend
          ? await _repo.unFriend(isClient: isClient, id: profile.id ?? '')
          : await _repo.addFriend(isClient: isClient, id: profile.id ?? '');
      if (!res.success) {
        _update(state.copyWith(
          profile: profile.copyWith(isFriend: wasFriend, friendsCount: count),
        ));
      }
    } catch (_) {
      _update(state.copyWith(
        profile: profile.copyWith(isFriend: wasFriend, friendsCount: count),
      ));
    } finally {
      friendLoading.value = false;
    }
  }

  void _update(CompanionState s) => _state.value = s;
}
