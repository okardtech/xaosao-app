import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/pages/chat/components/chat_bubbles.dart';
import 'package:xaosao/pages/chat/getx/chat_detail_controller.dart';
import 'package:xaosao/pages/chat/getx/chat_state.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

// reverse:true → index 0 = visual bottom (newest messages).
// Layout order: [0] TypingBubble? | [1..N] messages newest→oldest | [last] DateDivider
class ChatMessageList extends StatelessWidget {
  final ChatDetailController ctrl;
  const ChatMessageList({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ms = ctrl.msgState;

      if (ms.status == MsgLoadStatus.loading && ms.messages.isEmpty) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      ctrl.checkAutoScroll(ms.messages.length);

      final msgCount = ms.messages.length;
      final isTyping = ms.isPartnerTyping;
      final totalCount = msgCount + (isTyping ? 1 : 0) + 1;

      return ListView.builder(
        controller: ctrl.scrollCtrl,
        reverse: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        itemCount: totalCount,
        itemBuilder: (ctx, i) {
          if (isTyping && i == 0) {
            return ChatTypingBubble(gradient: ctrl.gradient);
          }

          final msgListIdx = isTyping ? i - 1 : i;

          if (msgListIdx == msgCount) {
            return const ChatDateDivider(label: 'ມື້ນີ້');
          }

          final msg = ms.messages[msgCount - 1 - msgListIdx];
          final isMe = ctrl.isMe(msg.senderType);

          return Padding(
            padding: EdgeInsets.only(bottom: 4.h),
            child: ChatTextBubble(
              msg: msg,
              isMe: isMe,
              gradient: ctrl.gradient,
              partnerImage: ctrl.partnerImage,
              onLongPress: () => _confirmDelete(ctx, msg.id),
            ),
          );
        },
      );
    });
  }

  Future<void> _confirmDelete(BuildContext context, String messageId) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບຂໍ້ຄວາມ',
      message:
          'ຂໍ້ຄວາມຈະຖືກລຶບອອກຈາກຝ່າຍຂອງທ່ານເທົ່ານັ້ນ\nອີກຝ່າຍຍັງສາມາດເຫັນຂໍ້ຄວາມໄດ້',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed == true) {
      ctrl.deleteMessage(messageId);
    }
  }
}
