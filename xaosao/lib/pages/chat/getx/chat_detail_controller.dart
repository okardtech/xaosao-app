import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/chat/getx/chat_state.dart';

class ChatDetailController extends GetxController {
  final String conversationId;
  final ConversationModel conv;

  ChatDetailController({required this.conversationId, required this.conv});

  final _chatLogic = Get.find<ChatLogic>();

  final inputCtrl = TextEditingController();
  final scrollCtrl = ScrollController();
  final focusNode = FocusNode();

  final canSend = false.obs;
  final showEmoji = false.obs;
  final isSending = false.obs;
  final pendingImage = Rx<File?>(null);

  int _prevMessageCount = 0;

  // ── Gradient derived from conversationId ──────────────────
  static const _gradients = [
    [Color(0xFF5C6BC0), Color(0xFF1A1A2E)],
    [Color(0xFFf093fb), Color(0xFFc2185b)],
    [Color(0xFF43e97b), Color(0xFF1A5276)],
    [Color(0xFFfa709a), Color(0xFF7B1FA2)],
    [Color(0xFF4facfe), Color(0xFF1A237E)],
  ];

  List<Color> get gradient {
    final idx =
        conversationId.codeUnits.fold(0, (a, b) => a + b) % _gradients.length;
    return _gradients[idx].cast<Color>();
  }

  // ── Partner info ──────────────────────────────────────────
  String get myRole => _chatLogic.myRole;
  ConversationParticipant? get partner => conv.otherParticipant(myRole);
  String get partnerName => partner?.displayName ?? 'Unknown';
  String? get partnerImage => partner?.profileImage;
  bool get isOnline => partner?.isOnline ?? false;
  bool isMe(String? senderType) => _chatLogic.isMe(senderType);

  // Reactive message state — reads from RxMap so Obx rebuilds on change
  MsgState get msgState => _chatLogic.msgStateOf(conversationId);

  // ─────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    inputCtrl.addListener(_onInputChanged);
    focusNode.addListener(_onFocusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatLogic.enterConversation(conversationId);
      scrollToBottom(animate: false);
    });
  }

  @override
  void onClose() {
    _chatLogic.leaveConversation(conversationId);
    inputCtrl.dispose();
    scrollCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void _onInputChanged() {
    canSend.value =
        inputCtrl.text.trim().isNotEmpty || pendingImage.value != null;
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus && showEmoji.value) {
      showEmoji.value = false;
    }
  }

  // ── Emoji toggle ──────────────────────────────────────────
  void toggleEmoji() {
    if (showEmoji.value) {
      showEmoji.value = false;
      focusNode.requestFocus();
    } else {
      focusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 80), () {
        showEmoji.value = true;
      });
    }
  }

  // ── Scroll ────────────────────────────────────────────────
  void scrollToBottom({bool animate = true}) {
    if (!scrollCtrl.hasClients) return;
    if (animate) {
      scrollCtrl.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      scrollCtrl.jumpTo(0);
    }
  }

  // Auto-scroll to bottom only when new messages arrive and user is near bottom
  void checkAutoScroll(int newCount) {
    if (newCount > _prevMessageCount) {
      _prevMessageCount = newCount;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollCtrl.hasClients && scrollCtrl.offset < 200) {
          scrollCtrl.jumpTo(0);
        }
      });
    }
  }

  // ── Image picker ──────────────────────────────────────────
  Future<void> pickImage() async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (xFile == null) return;
    pendingImage.value = File(xFile.path);
    canSend.value = true;
  }

  void removePendingImage() {
    pendingImage.value = null;
    canSend.value = inputCtrl.text.trim().isNotEmpty;
  }

  // ── Send message ──────────────────────────────────────────
  Future<bool> sendMessage() async {
    if (isSending.value) return false;
    final text = inputCtrl.text.trim();
    final imageToSend = pendingImage.value;
    if (text.isEmpty && imageToSend == null) return false;

    isSending.value = true;
    pendingImage.value = null;
    canSend.value = false;
    inputCtrl.clear();

    final ok = await _chatLogic.sendMessage(
      conversationId,
      text,
      imageFile: imageToSend,
    );
    isSending.value = false;
    return ok;
  }

  // ── Typing indicator ──────────────────────────────────────
  void onTyping() => _chatLogic.onTyping(conversationId);

  // ── Delete message ────────────────────────────────────────
  Future<void> deleteMessage(String messageId) =>
      _chatLogic.deleteMessage(conversationId, messageId);

  // ── Load more (pagination) ────────────────────────────────
  void loadMore() => _chatLogic.loadMoreMessages(conversationId);
}
