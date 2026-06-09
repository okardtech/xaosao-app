import 'dart:io' as io;
import 'package:dio/dio.dart' as dio_lib;
import 'package:path/path.dart' as p;
import 'package:xaosao/constants/api_constants.dart';
import 'package:xaosao/models/api_response.dart';
import 'package:xaosao/models/chat_message_model.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/services/base_repo.dart';

import '../models/bage_model.dart';
import '../models/gift_post_model.dart';

class ChatRepo extends BaseRepository {
  Future<ApiResponse<List<ConversationModel>>> getConversations() => safeCall(
    () => api.get(ApiConstants.chatConversations),
    fromJson: (data) => (data as List)
        .map(
          (e) => ConversationModel.fromJson(
            e is Map<String, dynamic> ? e : <String, dynamic>{},
          ),
        )
        .toList(),
    authRequired: true,
  );

  Future<ApiResponse<List<ChatMessageModel>>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 30,
  }) => safeCall(
    () => api.get(
      '${ApiConstants.chatConversations}/$conversationId/messages',
      queryParameters: {'page': page, 'limit': limit},
    ),
    fromJson: (data) => (data as List)
        .map(
          (e) => ChatMessageModel.fromJson(
            e is Map<String, dynamic> ? e : <String, dynamic>{},
          ),
        )
        .toList(),
    authRequired: true,
  );

  Future<ApiResponse<ConversationModel>> startConversation(
    String participantId,
  ) {
    return safeCall(
      () => api.post(
        ApiConstants.chatConversations,
        data: {'recipientId': participantId, "initialMessage": "Hi!"},
      ),
      fromJson: (data) => ConversationModel.fromJson(
        data is Map<String, dynamic> ? data : <String, dynamic>{},
      ),
      authRequired: true,
    );
  }

  Future<ApiResponse<ChatMessageModel>> sendMessage(
    String conversationId, {
    required String content,
    io.File? file,
  }) => safeCall(
    () async {
      dio_lib.MultipartFile? multipart;
      if (file != null) {
        multipart = await dio_lib.MultipartFile.fromFile(
          file.path,
          filename: p.basename(file.path),
        );
      }
      final formData = dio_lib.FormData.fromMap({
        'content': content,
        if (multipart != null) 'file': multipart,
      });
      return api.post(
        '${ApiConstants.chatConversations}/$conversationId/messages',
        data: formData,
      );
    },
    fromJson: (data) => ChatMessageModel.fromJson(
      data is Map<String, dynamic> ? data : <String, dynamic>{},
    ),
    authRequired: true,
  );

  Future<ApiResponse<bool>> markRead(String conversationId) => safeCall(
    () => api.post('${ApiConstants.chatConversations}/$conversationId/read'),
    fromJson: (_) => true,
    authRequired: true,
  );

  Future<ApiResponse<bool>> blockConversation(String id) => safeCall(
    () => api.post('${ApiConstants.chatConversations}/$id/block'),
    fromJson: (_) => true,
    authRequired: true,
  );

  Future<ApiResponse<ConversationModel>> unblockConversation(String id) =>
      safeCall(
        () => api.post('${ApiConstants.chatConversations}/$id/unblock'),
        fromJson: (data) => ConversationModel.fromJson(
          data is Map<String, dynamic> ? data : <String, dynamic>{},
        ),
        authRequired: true,
      );

  Future<ApiResponse<bool>> deleteConversation(String id) => safeCall(
    () => api.delete('${ApiConstants.chatConversations}/$id'),
    fromJson: (_) => true,
    authRequired: true,
  );

  Future<ApiResponse<bool>> deleteMessage(String messageId) => safeCall(
    () => api.delete('${ApiConstants.chatMessages}/$messageId'),
    fromJson: (_) => true,
    authRequired: true,
  );

  Future<ApiResponse<BadgeModel>> bageUnreadCount() {
    return safeCall(
      () => api.get(ApiConstants.bages),
      fromJson: (json) => BadgeModel.fromJson(json),
      authRequired: true,
    );
  }

  Future<ApiResponse<GiftPostModel>> getGiftPost({required String postId}) {
    return safeCall(
      () => api.get('${ApiConstants.giftPost}/$postId'),
      fromJson: (json) => GiftPostModel.fromJson(json),
    );
  }
}
