import 'package:xaosao/models/models_hot.dart';

enum OnboardingStatus { initial, loading, success, failure }

class OnboardingState {
  final OnboardingStatus status;
  final List<ModelsHot> modelsHot;

  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.modelsHot = const [],
  });

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<ModelsHot>? modelsHot,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      modelsHot: modelsHot ?? this.modelsHot,
    );
  }
}
