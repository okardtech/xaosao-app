import 'dart:io';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/models/sign_up_model.dart';
import '../../login/getx/login_state.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterModel {
  final RegisterRole role;
  final String phone;
  const RegisterModel({required this.role, required this.phone});
}

class RegisterState {
  final RegisterStatus status;
  final RegisterStatus servicesStatus;
  final RegisterRole role;
  final Map<String, dynamic> gender;
  final DateTime? dob;
  final File? avatarFile;
  final List<ServiceModel> services;
  final SignUpModel? signUpModel;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.servicesStatus = RegisterStatus.initial,
    this.role = RegisterRole.customer,
    this.gender = const {"id": 1, "name": "ຊາຍ", "value": "male"},
    this.dob,
    this.avatarFile,
    this.services = const [],
    this.signUpModel,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    RegisterStatus? servicesStatus,
    RegisterRole? role,
    Map<String, dynamic>? gender,
    DateTime? dob,
    File? avatarFile,
    List<ServiceModel>? services,
    SignUpModel? signUpModel,
  }) {
    return RegisterState(
      status: status ?? this.status,
      servicesStatus: servicesStatus ?? this.servicesStatus,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      avatarFile: avatarFile ?? this.avatarFile,
      services: services ?? this.services,
      signUpModel: signUpModel ?? this.signUpModel,
    );
  }
}
