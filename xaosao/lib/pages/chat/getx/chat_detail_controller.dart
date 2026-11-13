import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xaosao/models/chat_location.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/services/location_manager.dart';
import 'package:xaosao/pages/chat/getx/chat_logic.dart';
import 'package:xaosao/pages/chat/getx/chat_state.dart';

import '../../../constants/app_routes.dart';
import '../../../services/storage_service.dart';

/// Why a location share did or didn't go through.
///
/// The controller returns one of these instead of touching a
/// `BuildContext`: deciding between a snackbar, a settings sheet and a
/// silent no-op is the widget's job, and keeping it out here is what makes
/// [ChatDetailController.sendCurrentLocation] testable.
enum LocationSendOutcome {
  ok,

  /// Another send is already running.
  busy,

  /// The OS location service (GPS toggle) is off — app permission is
  /// irrelevant until the user turns it on.
  serviceDisabled,

  /// User declined this time; the OS will ask again later.
  permissionDenied,

  /// Permanently denied — only the system settings screen can recover.
  permissionDeniedForever,

  /// Permission is fine but the hardware produced no fix in time.
  fixFailed,

  /// We had coordinates; the message itself failed to send.
  sendFailed,
}

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

  /// Separate from [isSending] so the location button can show its own
  /// spinner while the text/image send button stays usable.
  final isSendingLocation = false.obs;
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

  bool get _isClient =>
      Get.find<StorageService>().read<String>('role') == 'customer';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
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

  // ── Send current location ─────────────────────────────────
  /// Captures a fresh GPS fix and sends it as a message.
  ///
  /// Permission is requested here rather than deferred to
  /// `PermissionCoordinator`, because this is a user-initiated action: the
  /// user just tapped "send my location", so the OS prompt needs no primer
  /// and arrives with obvious context.
  ///
  /// Never throws — every failure mode comes back as a [LocationSendOutcome]
  /// for the caller to turn into UI.
  Future<LocationSendOutcome> sendCurrentLocation() async {
    if (isSending.value || isSendingLocation.value) {
      return LocationSendOutcome.busy;
    }

    // GPS toggle is OS-level and orthogonal to app permission — check it
    // first, or a granted app would still silently never get a fix.
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationSendOutcome.serviceDisabled;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) {
      return LocationSendOutcome.permissionDeniedForever;
    }
    if (perm != LocationPermission.whileInUse &&
        perm != LocationPermission.always) {
      return LocationSendOutcome.permissionDenied;
    }

    isSendingLocation.value = true;
    try {
      // currentFresh() — not getOrRefresh() — so a stale cached point is
      // never published as the user's current whereabouts.
      final pos = await Get.find<LocationManager>().currentFresh();
      if (pos == null) return LocationSendOutcome.fixFailed;

      final location = ChatLocation(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      final ok = await _chatLogic.sendMessage(
        conversationId,
        location.shareUrl,
      );
      return ok ? LocationSendOutcome.ok : LocationSendOutcome.sendFailed;
    } catch (_) {
      // LocationManager not registered yet, or GPS threw — treat as no fix.
      return LocationSendOutcome.fixFailed;
    } finally {
      isSendingLocation.value = false;
    }
  }

  // ── Open partner profile ──────────────────────────────────
  void openPartnerProfile() {
    final p = partner;
    if (p == null || p.id.isEmpty) return;
    if (_isClient) {
      Get.toNamed(AppRoutes.companionProfile, arguments: p.id);
    } else {
      Get.toNamed(AppRoutes.customerProfile, arguments: p.id);
    }
  }

  // ── Typing indicator ──────────────────────────────────────
  void onTyping() => _chatLogic.onTyping(conversationId);

  // ── Delete message ────────────────────────────────────────
  Future<void> deleteMessage(String messageId) =>
      _chatLogic.deleteMessage(conversationId, messageId);

  // ── Load more (pagination) ────────────────────────────────
  void loadMore() => _chatLogic.loadMoreMessages(conversationId);
}
