import 'package:xaosao/models/customer_public_profile.dart';

enum CustomerDetailStatus { initial, loading, success, failure }

class CustomerDetailState {
  final CustomerDetailStatus status;
  final CustomerPublicProfile? profile;
  final String? error;

  const CustomerDetailState({
    this.status = CustomerDetailStatus.initial,
    this.profile,
    this.error,
  });

  CustomerDetailState copyWith({
    CustomerDetailStatus? status,
    CustomerPublicProfile? profile,
    String? error,
  }) =>
      CustomerDetailState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        error: error ?? this.error,
      );
}
