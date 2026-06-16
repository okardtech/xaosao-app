import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/comment_model.dart';
import '../models/fee_model.dart';
import '../models/interest_model.dart';
import '../models/my_post_model.dart';
import '../models/post_detail_model.dart';
import '../services/base_repo.dart';

class MyPost extends BaseRepository {
  Future<ApiResponse<List<MyPostModel>>> getMyPost({
    required int page,
    required int limit,
  }) {
    return safeCall(
      () => api.get('${ApiConstants.myPost}/my?page=$page&limit=$limit'),
      fromJson: (json) => (json['data'] as List)
          .map((item) => MyPostModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<List<FeeModel>>> getFee({
    required bool isClient,
    required int page,
    required int limit,
  }) {
    String url = isClient
        ? "${ApiConstants.myPost}/feed/models?page=$page&limit=$limit"
        : "${ApiConstants.myPost}/feed/customers?page=$page&limit=$limit";
    return safeCall(
      () => api.get(url),
      fromJson: (json) => (json['data'] as List)
          .map((item) => FeeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<PostDetailModel>> getPostDetail({required String postId}) {
    return safeCall(
      () => api.get('${ApiConstants.myPost}/$postId'),
      fromJson: (json) =>
          PostDetailModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<bool>> createCustomerPost({
    required String content,
    String? serviceId,
    String? targetGender,
    String? location,
    bool hasTip = false,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'content': content,
      'serviceId': serviceId,
      'targetGender': targetGender,
      'location': location,
      'hasTip': hasTip,
    });
    return safeCall(
      () => api.upload(
        '${ApiConstants.myPost}',
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> createModelPost({
    required String content,
    String? filePath,
    void Function(int sent, int total)? onProgress,
  }) async {
    final map = <String, dynamic>{'content': content};
    if (filePath != null)
      map['images'] = await MultipartFile.fromFile(filePath);
    final formData = FormData.fromMap(map);
    return safeCall(
      () => api.upload(
        '${ApiConstants.myPost}/model',
        formData: formData,
        onSendProgress: onProgress,
      ),
      fromJson: (json) => true,
    );
  }

  // ── Comments ────────────────────────────────────────────────

  /// Creates a top-level comment (no [parentId]) or a single-level reply
  /// ([parentId] = the top-level comment id being replied to).
  /// The API rejects [parentId] values that are themselves replies
  /// (no multi-level threading).
  Future<ApiResponse<CommentModel>> createComment({
    required String postId,
    required String content,
    String? parentId, // null → top-level; non-null → reply
  }) {
    final body = <String, dynamic>{'content': content};
    if (parentId != null) body['parentId'] = parentId;

    return safeCall(
      () => api.post('${ApiConstants.myPost}/$postId/comments', data: body),
      fromJson: (json) => CommentModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<List<CommentModel>>> getComments({
    required String postId,
    required int limit,
    required int page,
  }) {
    return safeCall(
      () => api.get(
        '${ApiConstants.myPost}/$postId/comments?page=$page&limit=$limit',
      ),
      fromJson: (json) => (json['data'] as List)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<List<CommentModel>>> getReplies({
    required String postId,
    required String commentId,
    required int limit,
    required int page,
  }) {
    return safeCall(
      () => api.get(
        '${ApiConstants.myPost}/$postId/comments/$commentId/replies?page=$page&limit=$limit',
      ),
      fromJson: (json) => (json['data'] as List)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<bool>> deletePost({required String postId}) {
    return safeCall(
      () => api.delete('${ApiConstants.myPost}/$postId'),
      fromJson: (json) => true,
    );
  }

  Future<ApiResponse<bool>> hidePost({required String postId}) {
    return safeCall(
      () => api.post('${ApiConstants.myPost}/$postId/fulfill'),
      fromJson: (json) => true,
    );
  }

  // ── Interest toggle ──────────────────────────────────────────
  Future<ApiResponse<({bool isInterested, int interestedCount})>>
  toggleInterest({required String postId}) {
    return safeCall(
      () => api.post('${ApiConstants.myPost}/$postId/interest'),
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return (
          isInterested: data['isInterested'] as bool? ?? false,
          interestedCount: data['interestedCount'] as int? ?? 0,
        );
      },
    );
  }

  Future<ApiResponse<List<InterestModel>>> getInterests({
    required String postId,
    required int limit,
    required int page,
  }) {
    return safeCall(
      () => api.get(
        '${ApiConstants.myPost}/$postId/interest?page=$page&limit=$limit',
      ),
      fromJson: (json) => (json['data'] as List)
          .map((e) => InterestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
