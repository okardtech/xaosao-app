import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/chat_message_model.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/pages/chat/getx/chat_state.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/repository/chat_repo.dart';
import 'package:xaosao/services/chat_socket_service.dart';
import 'package:xaosao/services/storage_service.dart';

class ChatLogic extends GetxController {
  final _repo = ChatRepo();
  late final ChatSocketService _socket;

  static const int _msgLimit = 30;

  // ── Conversation list state ────────────────────────────────
  final Rx<ChatState> _state = const ChatState().obs;
  ChatState get state => _state.value;
  void _updateState(ChatState s) => _state.value = s;

  // ── Per-conversation message state ─────────────────────────
  final RxMap<String, MsgState> _convStates = <String, MsgState>{}.obs;
  MsgState msgStateOf(String convId) =>
      _convStates[convId] ?? const MsgState();
  void _updateMsgState(String convId, MsgState s) {
    _convStates[convId] = s;
    _convStates.refresh();
  }

  // ── Active conversation (currently open) ───────────────────
  final RxString activeConversationId = ''.obs;

  // ── Typing debounce ────────────────────────────────────────
  Timer? _typingTimer;

  // ── My role: 'customer' | 'model' ─────────────────────────
  String get myRole {
    try {
      return Get.find<StorageService>().read<String>('role') ?? 'customer';
    } catch (_) {
      return 'customer';
    }
  }

  // ── My user ID (used for socket read-receipt tracking) ────
  String get myUserId => _myUserId;

  String get _myUserId {
    final uid = _socket.connectedUserId.value;
    if (uid.isNotEmpty) return uid;
    try {
      final s = Get.find<LoginLogic>().state;
      return s.customerProfile?.id ?? s.modelProfile?.id ?? '';
    } catch (_) {
      return '';
    }
  }

  // ─────────────────────────────────────────────────────────
  @override
  void onReady() {
    super.onReady();
    _socket = Get.find<ChatSocketService>();
    _wireSocketCallbacks();
    _socket.connect();
    fetchConversations();
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    _clearSocketCallbacks();
    super.onClose();
  }

  // ── Socket wiring ──────────────────────────────────────────

  void _wireSocketCallbacks() {
    _socket.onNewMessage = _handleNewMessage;
    _socket.onMessagesRead = _handleMessagesRead;
    _socket.onUserTyping = _handleUserTyping;
    _socket.onMessageNotification = _handleMessageNotification;
    _socket.onReconnect = _handleReconnect;
  }

  void _clearSocketCallbacks() {
    _socket.onNewMessage = null;
    _socket.onMessagesRead = null;
    _socket.onUserTyping = null;
    _socket.onMessageNotification = null;
    _socket.onReconnect = null;
  }

  void _handleReconnect() {
    final convId = activeConversationId.value;
    if (convId.isNotEmpty) {
      _socket.joinConversation(convId);
      _backfillMessages(convId);
    }
    fetchConversations();
  }

  // ── new_message: { conversation_id, message } ─────────────
  void _handleNewMessage(dynamic data) {
    if (data is! Map) return;
    final convId = data['conversation_id']?.toString();
    final rawMsg = data['message'];
    if (convId == null || rawMsg is! Map) return;

    final msg = ChatMessageModel.fromJson(Map<String, dynamic>.from(rawMsg));

    final current = msgStateOf(convId);
    // Skip if we already added this message from the API response
    if (current.messages.any((m) => m.id == msg.id)) return;
    _updateMsgState(
      convId,
      current.copyWith(messages: [...current.messages, msg]),
    );

    _patchConversationPreview(
      convId: convId,
      lastMessageText: msg.messageText,
      lastMessageType: msg.messageType,
      lastMessageSenderId: msg.sender,
      lastMessageAt: msg.displayTime,
      incrementUnread:
          msg.senderType != myRole && activeConversationId.value != convId,
    );
  }

  // ── messages_read: { conversation_id, reader_id, last_read_message_id? } ──
  void _handleMessagesRead(dynamic data) {
    if (data is! Map) return;
    final convId = data['conversation_id']?.toString();
    final readerId = data['reader_id']?.toString();
    if (convId == null || readerId == _myUserId) return;

    final current = msgStateOf(convId);
    final updated = current.messages.map((m) {
      if (m.sender == _myUserId && !m.isRead) {
        return m.copyWith(isRead: true);
      }
      return m;
    }).toList();
    _updateMsgState(convId, current.copyWith(messages: updated));
  }

  // ── user_typing: { conversation_id, user_id, is_typing } ──
  void _handleUserTyping(dynamic data) {
    if (data is! Map) return;
    final convId = data['conversation_id']?.toString();
    final userId = data['user_id']?.toString();
    final isTyping = data['is_typing'] == true;
    if (convId == null || userId == _myUserId) return;

    final current = msgStateOf(convId);
    _updateMsgState(convId, current.copyWith(isPartnerTyping: isTyping));
  }

  // ── message_notification: global badge / toast ────────────
  void _handleMessageNotification(dynamic data) {
    if (data is! Map) return;
    final convId = data['conversation_id']?.toString();
    if (convId == null) return;
    if (convId == activeConversationId.value) return;
    _patchConversationPreview(convId: convId, incrementUnread: true);
  }

  // ── Conversation list ──────────────────────────────────────

  Future<void> fetchConversations() async {
    _updateState(state.copyWith(status: ConvListStatus.loading));
    try {
      final res = await _repo.getConversations();
      if (res.success && res.data != null) {
        _updateState(ChatState(
          status: ConvListStatus.success,
          conversations: res.data!,
        ));
      } else {
        _updateState(state.copyWith(
          status: ConvListStatus.failure,
          error: res.laMessage ?? res.message,
        ));
      }
    } catch (_) {
      _updateState(state.copyWith(status: ConvListStatus.failure));
    }
  }

  // ── Enter / leave conversation ─────────────────────────────

  void enterConversation(String conversationId) {
    activeConversationId.value = conversationId;
    _socket.joinConversation(conversationId);

    final current = msgStateOf(conversationId);
    if (current.status == MsgLoadStatus.initial) {
      fetchMessages(conversationId, refresh: true);
    }

    _patchConversationPreview(convId: conversationId, unreadCount: 0);
    _socket.markRead(conversationId);
  }

  void leaveConversation(String conversationId) {
    activeConversationId.value = '';
    _socket.leaveConversation(conversationId);
    _typingTimer?.cancel();
    _socket.typing(conversationId, isTyping: false);
  }

  // ── Fetch messages ─────────────────────────────────────────

  Future<void> fetchMessages(String convId, {bool refresh = false}) async {
    final current = msgStateOf(convId);
    if (!refresh && !current.hasMore) return;
    if (current.status == MsgLoadStatus.loading) return;

    final page = refresh ? 1 : current.page;

    _updateMsgState(
      convId,
      current.copyWith(
        status: MsgLoadStatus.loading,
        messages: refresh ? [] : null,
        hasMore: refresh ? true : null,
        page: refresh ? 1 : null,
      ),
    );

    try {
      final res =
          await _repo.getMessages(convId, page: page, limit: _msgLimit);
      if (res.success && res.data != null) {
        final incoming = res.data!;
        final prev = refresh ? <ChatMessageModel>[] : current.messages;
        _updateMsgState(
          convId,
          MsgState(
            status: MsgLoadStatus.success,
            messages: [...incoming.reversed.toList(), ...prev],
            hasMore: incoming.length >= _msgLimit,
            page: page + 1,
          ),
        );
      } else {
        _updateMsgState(
          convId,
          msgStateOf(convId).copyWith(status: MsgLoadStatus.failure),
        );
      }
    } catch (_) {
      _updateMsgState(
        convId,
        msgStateOf(convId).copyWith(status: MsgLoadStatus.failure),
      );
    }
  }

  Future<void> loadMoreMessages(String convId) =>
      fetchMessages(convId, refresh: false);

  Future<void> _backfillMessages(String convId) =>
      fetchMessages(convId, refresh: true);

  // ── Send message ───────────────────────────────────────────

  Future<bool> sendMessage(
    String conversationId,
    String text, {
    File? imageFile,
  }) async {
    final content = text.trim();
    if (content.isEmpty && imageFile == null) return false;

    _typingTimer?.cancel();
    _socket.typing(conversationId, isTyping: false);

    try {
      final res = await _repo.sendMessage(
        conversationId,
        content: content,
        file: imageFile,
      );
      if (res.success && res.data != null) {
        final msg = res.data!;
        final current = msgStateOf(conversationId);
        // Add immediately; socket event will be deduplicated
        if (!current.messages.any((m) => m.id == msg.id)) {
          _updateMsgState(
            conversationId,
            current.copyWith(messages: [...current.messages, msg]),
          );
        }
        _patchConversationPreview(
          convId: conversationId,
          lastMessageText:
              msg.messageType == 'image' ? '📷 ຮູບພາບ' : msg.messageText,
          lastMessageType: msg.messageType,
          lastMessageSenderId: msg.sender,
          lastMessageAt: msg.displayTime,
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Typing debounce ────────────────────────────────────────

  void onTyping(String conversationId) {
    _socket.typing(conversationId, isTyping: true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      _socket.typing(conversationId, isTyping: false);
    });
  }

  // ── Delete conversation ────────────────────────────────────

  Future<bool> deleteConversation(String conversationId) async {
    final res = await _repo.deleteConversation(conversationId);
    if (res.success) {
      final updated = state.conversations
          .where((c) => c.id != conversationId)
          .toList();
      _updateState(state.copyWith(conversations: updated));
      return true;
    }
    return false;
  }

  // ── Delete message (per-side soft delete) ──────────────────

  Future<bool> deleteMessage(String conversationId, String messageId) async {
    final res = await _repo.deleteMessage(messageId);
    if (res.success) {
      final current = msgStateOf(conversationId);
      final updated = current.messages
          .where((m) => m.id != messageId)
          .toList();
      _updateMsgState(conversationId, current.copyWith(messages: updated));
      return true;
    }
    return false;
  }

  // ── Start / get conversation ───────────────────────────────

  final RxBool isStarting = false.obs;

  Future<void> startConversation(
    String participantId, {
    ConversationParticipant? partnerHint,
  }) async {
    if (isStarting.value) return;

    final existing = state.conversations.firstWhereOrNull(
      (c) => c.customerId == participantId || c.modelId == participantId,
    );
    if (existing != null) {
      // Patch existing conv if its partner info is missing
      final patched = _applyPartnerHint(existing, partnerHint);
      Get.toNamed(
        AppRoutes.chatDetail,
        arguments: {'conversationId': patched.id, 'conv': patched},
      );
      return;
    }

    isStarting.value = true;
    try {
      final res = await _repo.startConversation(participantId);
      if (res.success && res.data != null) {
        final conv = _applyPartnerHint(res.data!, partnerHint);
        if (!state.conversations.any((c) => c.id == conv.id)) {
          _updateState(
              state.copyWith(conversations: [conv, ...state.conversations]));
        }
        Get.toNamed(
          AppRoutes.chatDetail,
          arguments: {'conversationId': conv.id, 'conv': conv},
        );
      }
    } finally {
      isStarting.value = false;
    }
  }

  /// Fills in missing partner profile data from [hint].
  ConversationModel _applyPartnerHint(
      ConversationModel conv, ConversationParticipant? hint) {
    if (hint == null) return conv;
    final role = myRole;
    if (role == 'customer') {
      // partner is the model side
      final m = conv.model;
      if (m == null || m.displayName == 'Unknown') {
        return conv.copyWith(model: hint);
      }
    } else {
      // partner is the customer side
      final c = conv.customer;
      if (c == null || c.displayName == 'Unknown') {
        return conv.copyWith(customer: hint);
      }
    }
    return conv;
  }

  // ── Internal helpers ───────────────────────────────────────

  void _patchConversationPreview({
    required String convId,
    String? lastMessageText,
    String? lastMessageType,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    bool incrementUnread = false,
    int? unreadCount,
  }) {
    final idx = state.conversations.indexWhere((c) => c.id == convId);
    if (idx == -1) return;

    final old = state.conversations[idx];
    final role = myRole;
    final currentUnread = old.unreadCountFor(role);
    final newUnread =
        unreadCount ?? (incrementUnread ? currentUnread + 1 : currentUnread);

    final patched = old.copyWith(
      lastMessageText: lastMessageText ?? old.lastMessageText,
      lastMessageType: lastMessageType ?? old.lastMessageType,
      lastMessageSenderId: lastMessageSenderId ?? old.lastMessageSenderId,
      lastMessageAt: lastMessageAt ?? old.lastMessageAt,
      customerUnreadCount:
          role == 'customer' ? newUnread : old.customerUnreadCount,
      modelUnreadCount:
          role == 'model' ? newUnread : old.modelUnreadCount,
    );

    final updated = List<ConversationModel>.from(state.conversations);
    updated.removeAt(idx);
    updated.insert(0, patched);
    _updateState(state.copyWith(conversations: updated));
  }

  // ── Computed helpers ───────────────────────────────────────

  int get totalUnread {
    final role = myRole;
    return state.conversations.fold(0, (sum, c) => sum + c.unreadCountFor(role));
  }

  /// Returns true when the message was sent by the logged-in user.
  /// Compares senderType ('customer'|'model') with the stored role.
  bool isMe(String? senderType) => senderType == myRole;
}
