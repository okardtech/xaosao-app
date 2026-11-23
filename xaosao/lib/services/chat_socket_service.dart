import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:xaosao/constants/api_constants.dart';
import 'package:xaosao/services/storage_service.dart';

typedef SocketEventCallback = void Function(dynamic data);

class ChatSocketService extends GetxService {
  IO.Socket? _socket;

  /// The token the current socket authenticated with.
  String? _authToken;

  final RxBool isConnected = false.obs;
  final RxString connectedUserId = ''.obs;

  // Callbacks wired up by ChatLogic
  SocketEventCallback? onNewMessage;
  SocketEventCallback? onMessagesRead;
  SocketEventCallback? onUserTyping;
  SocketEventCallback? onMessageNotification;
  VoidCallback? onReconnect;

  /// Extra listeners for events the chat screens don't own (calls).
  ///
  /// Static so a service can subscribe before this one has finished its
  /// async registration, and so subscriptions survive the socket being
  /// recreated on reconnect or on a change of account.
  static final Map<String, List<SocketEventCallback>> _extraHandlers = {};

  static void addHandler(String event, SocketEventCallback handler) {
    (_extraHandlers[event] ??= []).add(handler);
  }

  static void removeHandler(String event, SocketEventCallback handler) {
    _extraHandlers[event]?.remove(handler);
  }

  Future<ChatSocketService> init() async => this;

  // ── Connect ────────────────────────────────────────────────
  void connect() {
    final token = Get.find<StorageService>().read<String>('token') ?? '';

    // The socket is how the backend knows who is online — a model counts
    // as callable only while she holds one. It must therefore always be
    // signed in as the account that is logged in now. This service is
    // permanent, so after a logout and a login as someone else the old
    // socket (still authenticated as the previous account) would
    // otherwise be reused, and the new account would look offline.
    if (_socket != null && _socket!.connected && token == _authToken) {
      // debugPrint('[Socket] Already connected, skipping');
      return;
    }

    // A socket for another account, or one stuck reconnecting: drop it
    // before opening a fresh one so it can't keep retrying in the
    // background with stale credentials.
    if (_socket != null) disconnect();

    if (token.isEmpty) return;
    _authToken = token;
    // debugPrint('[Socket] Connecting to ${ApiConstants.chatSocketUrl} ...');

    _socket = IO.io(
      ApiConstants.chatSocketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..onConnect((_) {
        // debugPrint('[Socket] ✅ Connected — id: ${_socket?.id}');
        isConnected.value = true;
        onReconnect?.call();
      })
      ..onDisconnect((reason) {
        // debugPrint('[Socket] ❌ Disconnected — reason: $reason');
        isConnected.value = false;
      })
      ..onConnectError((err) {
        // debugPrint('[Socket] ⚠️ Connect error — $err');
        isConnected.value = false;
      })
      ..on('connected', (data) {
        // debugPrint('[Socket] 👤 Server confirmed: $data');
        if (data is Map && data['userId'] != null) {
          connectedUserId.value = data['userId'].toString();
        }
      })
      ..on('new_message', (data) {
        // debugPrint('[Socket] 💬 new_message: $data');
        onNewMessage?.call(data);
      })
      ..on('messages_read', (data) {
        // debugPrint('[Socket] 👁️ messages_read: $data');
        onMessagesRead?.call(data);
      })
      ..on('user_typing', (data) => onUserTyping?.call(data))
      ..on('message_notification', (data) {
        // debugPrint('[Socket] 🔔 message_notification: $data');
        onMessageNotification?.call(data);
      })
      ..onAny((event, data) {
        final handlers = _extraHandlers[event];
        if (handlers != null) {
          for (final h in List.of(handlers)) {
            h(data);
          }
        }
        // Log every event to surface unexpected event names from the server
        // if (event != 'user_typing') {
        //   // debugPrint('[Socket] ← event "$event": $data');
        // }
      });

    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _authToken = null;
    isConnected.value = false;
  }

  // ── Room management ────────────────────────────────────────
  void joinConversation(String conversationId) {
    if (_socket == null || !_socket!.connected) {
      // debugPrint('[Socket] ⚠️ join_conversation "$conversationId" dropped — not connected');
      return;
    }
    // debugPrint('[Socket] → join_conversation: $conversationId');
    _socket!.emitWithAck(
      'join_conversation',
      {'conversation_id': conversationId},
      ack: (ack) => debugPrint('[Socket] ✓ join_conversation ack: $ack'),
    );
  }

  void leaveConversation(String conversationId) {
    _emit('leave_conversation', {'conversation_id': conversationId});
  }

  // ── Messaging ──────────────────────────────────────────────
  void sendMessage({
    required String conversationId,
    required String content,
    String type = 'text',
  }) {
    _emit('send_message', {
      'conversation_id': conversationId,
      'type': type,
      'content': content,
    });
  }

  // ── Typing ──────────────────────────────────────────────────
  void typing(String conversationId, {required bool isTyping}) {
    _emit('typing', {
      'conversation_id': conversationId,
      'is_typing': isTyping,
    });
  }

  // ── Mark read ───────────────────────────────────────────────
  void markRead(String conversationId, {String? lastReadMessageId}) {
    _emit('mark_read', {
      'conversation_id': conversationId,
      if (lastReadMessageId != null)
        'last_read_message_id': lastReadMessageId,
    });
  }

  // ── Online check ────────────────────────────────────────────
  void checkOnline(List<String> userIds, void Function(Set<String>) callback) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emitWithAck('check_online', {'user_ids': userIds}, ack: (ack) {
      if (ack is Map) {
        final online = (ack['online_users'] as List? ?? [])
            .cast<String>()
            .toSet();
        callback(online);
      }
    });
  }

  // ── Internal ───────────────────────────────────────────────
  void _emit(String event, Map<String, dynamic> data) {
    if (_socket != null && _socket!.connected) {
      // debugPrint('[Socket] → emit "$event": $data');
      _socket!.emit(event, data);
    } else {
      // debugPrint('[Socket] ⚠️ emit "$event" dropped — not connected');
    }
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
