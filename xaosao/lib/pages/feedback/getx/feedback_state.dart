import '../../../models/my_feedback_model.dart';

enum FeedbackStatus { initial, loading, success, failure }

class FeedbackState {
  final FeedbackStatus status;
  final List<MyFeedbackModel> feedbacks;

  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.feedbacks = const [],
  });

  FeedbackState copyWith({
    FeedbackStatus? status,
    List<MyFeedbackModel>? feedbacks,
  }) =>
      FeedbackState(
        status: status ?? this.status,
        feedbacks: feedbacks ?? this.feedbacks,
      );
}
