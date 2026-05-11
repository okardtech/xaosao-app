import 'package:xaosao/models/otp_model.dart';

class ForgotState {
  final OtpModel? forgotPhone;
  final bool isCustomer;

  const ForgotState({this.forgotPhone, this.isCustomer = true});

  ForgotState copyWith({OtpModel? forgotPhone, bool? isCustomer}) {
    return ForgotState(
      forgotPhone: forgotPhone ?? this.forgotPhone,
      isCustomer: isCustomer ?? this.isCustomer,
    );
  }
}
