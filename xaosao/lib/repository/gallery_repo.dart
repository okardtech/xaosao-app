import 'package:dio/dio.dart';
import 'package:xaosao/models/gallerys_model.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../services/base_repo.dart';

class GalleryRepo extends BaseRepository {
  Future<ApiResponse<GallerysModel>> addPhoto({
    required bool isClient,
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.upload(
        isClient ? '${ApiConstants.clientPhoto}' : '${ApiConstants.modelPhoto}',
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => GallerysModel.fromJson(json),
    );
  }

  Future<ApiResponse<GallerysModel>> updatePhoto({
    required bool isClient,
    required String photoId,
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.patchUpload(
        isClient
            ? '${ApiConstants.clientPhoto}/$photoId'
            : '${ApiConstants.modelPhoto}/$photoId',
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => GallerysModel.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deletePhoto({
    required bool isClient,
    required String photoId,
  }) async {
    return safeCall(
      () => api.delete(
        isClient
            ? '${ApiConstants.clientPhoto}/$photoId'
            : '${ApiConstants.modelPhoto}/$photoId',
      ),
      fromJson: (_) => true,
    );
  }

  Future<ApiResponse<bool>> visibility({required bool hidden}) async {
    return safeCall(
      () => api.patch(
        '${ApiConstants.modelVisibility}',
        data: {"isProfileHidden": hidden},
      ),
      fromJson: (_) => true,
    );
  }

  Future<ApiResponse<GallerysModel>> updateProfileImage({
    required bool isClient,
    required String filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return safeCall(
      () => api.patchUpload(
        isClient
            ? '${ApiConstants.clientUpdateImage}'
            : '${ApiConstants.modelUpdateImage}',
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => GallerysModel.fromJson(json),
    );
  }
}
