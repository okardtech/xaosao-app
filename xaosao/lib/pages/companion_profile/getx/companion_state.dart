import 'package:xaosao/models/review_model.dart';
import 'package:xaosao/models/service_model.dart';

import '../../../models/model_available.dart';

enum CompanionLoadStatus { initial, loading, success, failure }

enum ReviewLoadStatus { initial, loading, success, failure, loadingMore }

class CompanionState {
  final List<ModelAvailable> services;
  final String? selectedServiceId;
  final List<ReviewModel> reviews;
  final int reviewPage;
  final bool reviewHasMore;
  final CompanionLoadStatus servicesStatus;
  final ReviewLoadStatus reviewStatus;

  const CompanionState({
    this.services = const [],
    this.selectedServiceId,
    this.reviews = const [],
    this.reviewPage = 1,
    this.reviewHasMore = true,
    this.servicesStatus = CompanionLoadStatus.initial,
    this.reviewStatus = ReviewLoadStatus.initial,
  });

  CompanionState copyWith({
    List<ModelAvailable>? services,
    String? selectedServiceId,
    bool clearSelectedService = false,
    List<ReviewModel>? reviews,
    int? reviewPage,
    bool? reviewHasMore,
    CompanionLoadStatus? servicesStatus,
    ReviewLoadStatus? reviewStatus,
  }) =>
      CompanionState(
        services: services ?? this.services,
        selectedServiceId: clearSelectedService
            ? null
            : (selectedServiceId ?? this.selectedServiceId),
        reviews: reviews ?? this.reviews,
        reviewPage: reviewPage ?? this.reviewPage,
        reviewHasMore: reviewHasMore ?? this.reviewHasMore,
        servicesStatus: servicesStatus ?? this.servicesStatus,
        reviewStatus: reviewStatus ?? this.reviewStatus,
      );
}
