import '../../models/model_available.dart';

class BookingArgs {
  final ModelAvailable service;
  final String companionId;
  final String companionName;
  final String? companionPhoto;

  const BookingArgs({
    required this.service,
    required this.companionId,
    required this.companionName,
    this.companionPhoto,
  });
}
