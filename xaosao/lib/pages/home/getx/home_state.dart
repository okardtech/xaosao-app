import 'package:xaosao/models/Recommended_model.dart';

enum HomeStatus { initial, loading, loadingMore, success, failure }

class HomeState {
  final HomeStatus recommendedStatus;
  final List<RecommendedModel> recommended;
  final bool recommendedHasMore;

  final HomeStatus onlineStatus;
  final List<RecommendedModel> online;
  final bool onlineHasMore;

  final String gender;
  final double maxDistanceKm;

  const HomeState({
    this.recommendedStatus = HomeStatus.initial,
    this.recommended = const [],
    this.recommendedHasMore = true,
    this.onlineStatus = HomeStatus.initial,
    this.online = const [],
    this.onlineHasMore = true,
    this.gender = 'male',
    this.maxDistanceKm = 50.0,
  });

  HomeState copyWith({
    HomeStatus? recommendedStatus,
    List<RecommendedModel>? recommended,
    bool? recommendedHasMore,
    HomeStatus? onlineStatus,
    List<RecommendedModel>? online,
    bool? onlineHasMore,
    String? gender,
    double? maxDistanceKm,
  }) {
    return HomeState(
      recommendedStatus: recommendedStatus ?? this.recommendedStatus,
      recommended: recommended ?? this.recommended,
      recommendedHasMore: recommendedHasMore ?? this.recommendedHasMore,
      onlineStatus: onlineStatus ?? this.onlineStatus,
      online: online ?? this.online,
      onlineHasMore: onlineHasMore ?? this.onlineHasMore,
      gender: gender ?? this.gender,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }
}
