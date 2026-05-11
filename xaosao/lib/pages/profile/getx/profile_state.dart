import 'package:xaosao/models/gallerys_model.dart';

class ProfileState {
  final bool hidden;
  final List<GallerysModel> photos;
  final int uploadingIndex;
  final int deletingIndex;
  final bool profileImageUploading;

  const ProfileState({
    this.hidden = false,
    this.photos = const [],
    this.uploadingIndex = -1,
    this.deletingIndex = -1,
    this.profileImageUploading = false,
  });

  ProfileState copyWith({
    bool? hidden,
    List<GallerysModel>? photos,
    int? uploadingIndex,
    int? deletingIndex,
    bool? profileImageUploading,
  }) =>
      ProfileState(
        hidden: hidden ?? this.hidden,
        photos: photos ?? this.photos,
        uploadingIndex: uploadingIndex ?? this.uploadingIndex,
        deletingIndex: deletingIndex ?? this.deletingIndex,
        profileImageUploading:
            profileImageUploading ?? this.profileImageUploading,
      );
}
