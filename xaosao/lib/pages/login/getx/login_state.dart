import 'package:xaosao/models/profile_model.dart';

enum LoginStatus { initial, loading, success, failure }

enum RegisterRole { customer, companion }

class LoginState {
  final LoginStatus status;
  final LoginStatus profileStatus;
  final RegisterRole role;
  final CustomerProfileModel? customerProfile;
  final ModelProfileModel? modelProfile;

  const LoginState({
    this.status = LoginStatus.initial,
    this.profileStatus = LoginStatus.initial,
    this.role = RegisterRole.customer,
    this.customerProfile,
    this.modelProfile,
  });

  LoginState copyWith({
    LoginStatus? status,
    LoginStatus? profileStatus,
    RegisterRole? role,
    CustomerProfileModel? customerProfile,
    ModelProfileModel? modelProfile,
  }) {
    return LoginState(
      status: status ?? this.status,
      profileStatus: profileStatus ?? this.profileStatus,
      role: role ?? this.role,
      customerProfile: customerProfile ?? this.customerProfile,
      modelProfile: modelProfile ?? this.modelProfile,
    );
  }

  // Convenience getter — whichever profile is loaded
  String get displayName {
    if (customerProfile != null) return customerProfile!.fullName;
    if (modelProfile != null) return modelProfile!.fullName;
    return '';
  }

  String? get profileImageUrl {
    if (customerProfile != null) return customerProfile!.profile;
    if (modelProfile != null) return modelProfile!.profile;
    return null;
  }
}
