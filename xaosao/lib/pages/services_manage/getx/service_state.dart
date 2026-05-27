import 'package:xaosao/models/service_model.dart';

enum ServiceStatus { initial, loading, success, failure }

class ServiceState {
  final ServiceStatus status;
  final List<ServiceModel> available;

  const ServiceState({
    this.status = ServiceStatus.initial,
    this.available = const [],
  });

  ServiceState copyWith({
    ServiceStatus? status,
    List<ServiceModel>? available,
  }) => ServiceState(
    status: status ?? this.status,
    available: available ?? this.available,
  );
}
