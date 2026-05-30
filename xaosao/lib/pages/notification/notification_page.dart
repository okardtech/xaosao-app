import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/models/notification_item_model.dart';
import 'package:xaosao/widgets/empty_state.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

import 'getx/notification_list_logic.dart';
import 'getx/notification_list_state.dart';

// ═══════════════════════════════════════════════════════════════
//  NotificationPage
// ═══════════════════════════════════════════════════════════════
class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late final NotifListLogic _logic;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _logic = Get.put(NotifListLogic());
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      _logic.loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    Get.delete<NotifListLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ການແຈ້ງເຕືອນ',
        subtitle: 'ລາຍການແຈ້ງເຕືອນທັງໝົດຂອງທ່ານ',
        expandedHeight: 88,
        actions: [
          // Unread count chip + mark-all-read button (reactive)
          Obx(() {
            final count = _logic.state.unreadCount;
            if (count == 0) return const SizedBox.shrink();
            return GestureDetector(
              onTap: _logic.markAllRead,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.45),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'ອ່ານທັງໝົດ',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(width: 6.w),
          // Settings icon
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.notificationSettings),
            child: Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.settings_outlined,
                size: 18.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final st = _logic.state;

        if (st.status == NotifListStatus.loading && st.items.isEmpty) {
          return _NotifShimmer();
        }

        if (st.status == NotifListStatus.failure && st.items.isEmpty) {
          return AppEmptyState(
            icon: Icons.wifi_off_rounded,
            title: 'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
            subtitle: 'ກະລຸນາລອງໃໝ່ອີກຄັ້ງ',
            iconColor: AppColors.primary,
            actionLabel: 'ລອງໃໝ່',
            onAction: () => _logic.fetchNotifications(refresh: true),
          );
        }

        if (st.status == NotifListStatus.success && st.items.isEmpty) {
          return AppEmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'ຍັງບໍ່ມີການແຈ້ງເຕືອນ',
            subtitle: 'ການແຈ້ງເຕືອນຈະສະແດງທີ່ນີ້',
            iconColor: AppColors.primary,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: Colors.white,
          strokeWidth: 2.5,
          onRefresh: () => _logic.fetchNotifications(refresh: true),
          child: ListView.builder(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(0, 6.h, 0, 90.h),
            itemCount: st.items.length + 1,
            itemBuilder: (_, i) {
              if (i < st.items.length) {
                return _NotifTile(
                  item: st.items[i],
                  onTap: () => _logic.handleTap(st.items[i]),
                );
              }
              if (st.status == NotifListStatus.loadingMore) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Center(
                    child: SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _NotifTile
// ═══════════════════════════════════════════════════════════════
class _NotifTile extends StatelessWidget {
  final NotificationItemModel item;
  final VoidCallback onTap;

  const _NotifTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final type = item.type ?? '';
    final read = item.isRead ?? false;
    final color = _colorForType(type);
    final icon = _iconForType(type);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: read
            ? Colors.transparent
            : AppColors.primary.withValues(alpha: 0.04),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Unread left border
              Container(
                width: 3.w,
                color: read ? Colors.transparent : AppColors.primary,
              ),

              SizedBox(width: 14.w),

              // Icon circle
              Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20.r, color: color),
                ),
              ),

              SizedBox(width: 12.w),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 14.h, 16.w, 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title ?? _labelForType(type),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: read
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _relativeTime(item.createdAt),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (!read) ...[
                                SizedBox(height: 4.h),
                                Container(
                                  width: 7.r,
                                  height: 7.r,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        Color(0xFFFF6B85),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                      if (item.message != null && item.message!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          item.message!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                            height: 1.45,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Shimmer skeleton
// ═══════════════════════════════════════════════════════════════
class _NotifShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 6.h, 0, 40.h),
        itemCount: 8,
        itemBuilder: (_, __) => IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3.w, color: Colors.white),
              SizedBox(width: 14.w),
              Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 14.h, 16.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 13.h,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 11.h,
                        width: 160.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Helpers
// ═══════════════════════════════════════════════════════════════

IconData _iconForType(String type) {
  switch (type) {
    case 'post_like':
      return Icons.favorite_rounded;
    case 'post_comment':
    case 'post_comment_reply':
      return Icons.chat_bubble_rounded;
    case 'post_gift_received':
    case 'gift_received':
      return Icons.card_giftcard_rounded;
    case 'booking_created':
    case 'booking_accepted':
    case 'booking_completed':
      return Icons.event_available_rounded;
    case 'booking_rejected':
    case 'booking_cancelled':
      return Icons.event_busy_rounded;
    case 'booking_payout_released':
      return Icons.payments_rounded;
    case 'topup_created':
    case 'topup_approved':
    case 'topup_rejected':
    case 'withdraw_approved':
    case 'withdraw_rejected':
      return Icons.account_balance_wallet_rounded;
    case 'welcome':
      return Icons.celebration_rounded;
    case 'new_model_registered':
      return Icons.person_add_rounded;
    case 'profile_liked':
      return Icons.favorite_border_rounded;
    case 'profile_viewed':
      return Icons.visibility_rounded;
    case 'friend_added':
      return Icons.people_rounded;
    case 'account_approved':
      return Icons.verified_rounded;
    case 'account_rejected':
    case 'account_banned':
    case 'account_deleted':
      return Icons.block_rounded;
    default:
      return Icons.notifications_rounded;
  }
}

Color _colorForType(String type) {
  switch (type) {
    case 'post_like':
    case 'profile_liked':
    case 'welcome':
    case 'account_approved':
      return AppColors.primary;
    case 'post_comment':
    case 'post_comment_reply':
    case 'profile_viewed':
      return const Color(0xFF3B82F6);
    case 'post_gift_received':
    case 'gift_received':
      return const Color(0xFFF59E0B);
    case 'booking_created':
    case 'booking_accepted':
    case 'booking_completed':
    case 'booking_payout_released':
    case 'topup_approved':
    case 'withdraw_approved':
      return const Color(0xFF22C55E);
    case 'booking_rejected':
    case 'booking_cancelled':
    case 'topup_rejected':
    case 'withdraw_rejected':
    case 'account_banned':
    case 'account_deleted':
    case 'account_rejected':
      return const Color(0xFFEF4444);
    case 'topup_created':
      return const Color(0xFF6366F1);
    case 'new_model_registered':
    case 'friend_added':
      return const Color(0xFF8B5CF6);
    default:
      return AppColors.textHint;
  }
}

String _labelForType(String type) {
  switch (type) {
    case 'post_like':
      return 'ກົດໄລ້ໂພສຂອງທ່ານ';
    case 'post_comment':
      return 'ຄອມເມັນໂພສຂອງທ່ານ';
    case 'post_comment_reply':
      return 'ຕອບຄອມເມັນຂອງທ່ານ';
    case 'post_gift_received':
      return 'ໄດ້ຮັບຂອງຂວັນໃນໂພສ';
    case 'gift_received':
      return 'ໄດ້ຮັບຂອງຂວັນ';
    case 'booking_created':
      return 'ມີການຈອງໃໝ່';
    case 'booking_accepted':
      return 'ການຈອງໄດ້ຮັບການຍອມຮັບ';
    case 'booking_rejected':
      return 'ການຈອງຖືກປະຕິເສດ';
    case 'booking_cancelled':
      return 'ການຈອງຖືກຍົກເລີກ';
    case 'booking_completed':
      return 'ການຈອງສຳເລັດ';
    case 'booking_payout_released':
      return 'ໂອນເງິນການຈອງ';
    case 'topup_created':
      return 'ສ້າງຄຳຂໍເຕີມເງິນ';
    case 'topup_approved':
      return 'ເຕີມເງິນສຳເລັດ';
    case 'topup_rejected':
      return 'ຄຳຂໍເຕີມເງິນຖືກປະຕິເສດ';
    case 'withdraw_approved':
      return 'ຖອນເງິນສຳເລັດ';
    case 'withdraw_rejected':
      return 'ຄຳຂໍຖອນເງິນຖືກປະຕິເສດ';
    case 'welcome':
      return 'ຍິນດີຕ້ອນຮັບ!';
    case 'account_approved':
      return 'ບັນຊີໄດ້ຮັບການຢືນຢັນ';
    case 'account_rejected':
      return 'ບັນຊີຖືກປະຕິເສດ';
    case 'account_banned':
      return 'ບັນຊີຖືກລະງັບ';
    case 'account_deleted':
      return 'ບັນຊີຖືກລຶບ';
    case 'new_model_registered':
      return 'Companion ໃໝ່ເຂົ້າຮ່ວມ';
    case 'profile_liked':
      return 'ກົດໄລ້ໂປຣໄຟລ໌ຂອງທ່ານ';
    case 'profile_viewed':
      return 'ເບິ່ງໂປຣໄຟລ໌ຂອງທ່ານ';
    case 'friend_added':
      return 'ເພີ່ມທ່ານເປັນເພື່ອນ';
    default:
      return 'ການແຈ້ງເຕືອນ';
  }
}

String _relativeTime(DateTime? dt) {
  if (dt == null) return '';
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return 'ຫາກໍ່ນີ້';
  if (diff.inMinutes < 60) return '${diff.inMinutes} ນາທີ';
  if (diff.inHours < 24) return '${diff.inHours} ຊົ່ວໂມງ';
  if (diff.inDays == 1) return 'ມື້ວານ';
  if (diff.inDays < 7) return '${diff.inDays} ມື້';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} ອາທິດຜ່ານມາ';
  return '${(diff.inDays / 30).floor()} ເດືອນ';
}
