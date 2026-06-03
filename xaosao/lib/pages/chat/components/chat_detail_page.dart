import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/conversation_model.dart';
import 'package:xaosao/pages/chat/components/chat_bubbles.dart';
import 'package:xaosao/pages/chat/components/chat_input_bar.dart';
import 'package:xaosao/pages/chat/components/chat_message_list.dart';
import 'package:xaosao/pages/chat/getx/chat_detail_controller.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

class ChatDetailPage extends StatefulWidget {
  final String conversationId;
  final ConversationModel conv;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
    required this.conv,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

// StatefulWidget is only used for controller lifecycle (no setState calls).
class _ChatDetailPageState extends State<ChatDetailPage> {
  late final ChatDetailController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.put(ChatDetailController(
      conversationId: widget.conversationId,
      conv: widget.conv,
    ));
  }

  @override
  void dispose() {
    Get.delete<ChatDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: !_ctrl.showEmoji.value,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && _ctrl.showEmoji.value) {
              _ctrl.showEmoji.value = false;
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.bg,
            appBar: GradientAppBar(
              title: _ctrl.partnerName,
              titleWidget: _ChatAppBarTitle(ctrl: _ctrl),
              expandedHeight: 62,
            ),
            body: Column(children: [
              Expanded(child: ChatMessageList(ctrl: _ctrl)),
              SafeArea(top: false, child: ChatInputBar(ctrl: _ctrl)),
              Offstage(
                offstage: !_ctrl.showEmoji.value,
                child: _ChatEmojiPicker(ctrl: _ctrl),
              ),
            ]),
          ),
        ));
  }
}

// ── App bar title: avatar + name + typing status ───────────────
class _ChatAppBarTitle extends StatelessWidget {
  final ChatDetailController ctrl;
  const _ChatAppBarTitle({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Stack(children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: ctrl.gradient,
            ),
          ),
          child: ctrl.partnerImage != null && ctrl.partnerImage!.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    ctrl.partnerImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        ChatInitials(name: ctrl.partnerName, size: 13.sp),
                  ),
                )
              : ChatInitials(name: ctrl.partnerName, size: 13.sp),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(
              color: ctrl.isOnline ? AppColors.online : Colors.white38,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ]),
      SizedBox(width: 10.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ctrl.partnerName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            Obx(() {
              final ms = ctrl.msgState;
              final label = ms.isPartnerTyping
                  ? 'ກຳລັງພິມ...'
                  : (ctrl.isOnline ? 'ອອນລາຍ' : 'ອອຟລາຍ');
              return Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              );
            }),
          ],
        ),
      ),
    ]);
  }
}

// ── Emoji picker panel ─────────────────────────────────────────
class _ChatEmojiPicker extends StatelessWidget {
  final ChatDetailController ctrl;
  const _ChatEmojiPicker({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256.h,
      child: EmojiPicker(
        textEditingController: ctrl.inputCtrl,
        onEmojiSelected: (_, __) {
          ctrl.canSend.value = ctrl.inputCtrl.text.trim().isNotEmpty;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => ctrl.scrollToBottom());
        },
        config: Config(
          height: 256.h,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28 * (Platform.isIOS ? 1.2 : 1.0),
            backgroundColor: AppColors.surface,
          ),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primary,
            iconColorSelected: AppColors.primary,
            iconColor: AppColors.textDisabled,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: AppColors.surface,
            buttonColor: AppColors.primary,
          ),
          searchViewConfig: SearchViewConfig(
            backgroundColor: AppColors.surface,
          ),
        ),
      ),
    );
  }
}
