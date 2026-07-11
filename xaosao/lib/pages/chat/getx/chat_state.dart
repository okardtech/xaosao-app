import 'package:xaosao/models/chat_message_model.dart';
import 'package:xaosao/models/conversation_model.dart';

enum ConvListStatus { initial, loading, success, failure }

enum MsgLoadStatus { initial, loading, success, failure }

// ── Per-conversation message state ────────────────────────────
class MsgState {
  final MsgLoadStatus status;
  final List<ChatMessageModel> messages;
  final bool hasMore;
  final int page;
  final bool isPartnerTyping;

  const MsgState({
    this.status = MsgLoadStatus.initial,
    this.messages = const [],
    this.hasMore = true,
    this.page = 1,
    this.isPartnerTyping = false,
  });

  MsgState copyWith({
    MsgLoadStatus? status,
    List<ChatMessageModel>? messages,
    bool? hasMore,
    int? page,
    bool? isPartnerTyping,
  }) =>
      MsgState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        isPartnerTyping: isPartnerTyping ?? this.isPartnerTyping,
      );
}

// ── Conversation list state ────────────────────────────────────
class ChatState {
  final ConvListStatus status;
  final List<ConversationModel> conversations;
  final String? error;

  const ChatState({
    this.status = ConvListStatus.initial,
    this.conversations = const [],
    this.error,
  });

  ChatState copyWith({
    ConvListStatus? status,
    List<ConversationModel>? conversations,
    String? error,
  }) =>
      ChatState(
        status: status ?? this.status,
        conversations: conversations ?? this.conversations,
        error: error ?? this.error,
      );
}
