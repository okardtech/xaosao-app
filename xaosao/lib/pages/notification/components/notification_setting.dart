import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import '../getx/notification_setting_logic.dart';
import '../getx/notification_setting_state.dart';

class NotificationSettingPage extends StatelessWidget {
  const NotificationSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<NotifSettingLogic>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ຕັ້ງຄ່າລະບົບ',
        subtitle: 'ຈັດການການແຈ້ງເຕືອນຂອງທ່ານ',
        expandedHeight: 80,
      ),
      body: Obx(() {
        final st = logic.state;

        if (st.status == NotifSettingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          );
        }

        if (st.status == NotifSettingStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 26.r,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: logic.loadSettings,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'ລອງໃໝ່',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header info card ─────────────────────────
              _InfoBanner(),
              SizedBox(height: 20.h),

              // ── Section: ຊ່ອງທາງແຈ້ງເຕືອນ ─────────────
              _SectionLabel('ຊ່ອງທາງການແຈ້ງເຕືອນ'),
              SizedBox(height: 10.h),
              _NotifCard(
                children: [
                  _NotifRow(
                    icon: Icons.notifications_active_rounded,
                    iconBg: const Color(0xFFFFF0F6),
                    iconColor: AppColors.primary,
                    title: 'Push Notification',
                    subtitle: 'ແຈ້ງເຕືອນໂດຍກົງໃສ່ໂທລະສັບ',
                    value: st.pushEnabled,
                    onChanged: logic.togglePush,
                  ),
                  _Divider(),
                  _NotifRow(
                    icon: Icons.email_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF3B82F6),
                    title: 'ອີເມລ',
                    subtitle: 'ຮັບແຈ້ງເຕືອນຜ່ານອີເມລ',
                    value: st.emailEnabled,
                    onChanged: logic.toggleEmail,
                  ),
                  _Divider(),
                  _NotifRow(
                    icon: Icons.sms_outlined,
                    iconBg: const Color(0xFFEDFAF3),
                    iconColor: const Color(0xFF22C55E),
                    title: 'SMS',
                    subtitle: 'ຮັບຂໍ້ຄວາມສັ້ນໃສ່ເບີໂທ',
                    value: st.smsEnabled,
                    onChanged: logic.toggleSms,
                  ),
                  _Divider(),
                  _NotifRow(
                    icon: Icons.chat_outlined,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: const Color(0xFF4CAF50),
                    title: 'WhatsApp',
                    subtitle: 'ຮັບແຈ້ງເຕືອນຜ່ານ WhatsApp',
                    value: st.whatsappEnabled,
                    onChanged: logic.toggleWhatsapp,
                    isLast: true,
                  ),
                ],
              ),

              SizedBox(height: 16.h),
              _FooterNote(),
            ],
          ),
        );
      }),
    );
  }
}

// ── Info banner ───────────────────────────────────────────────
class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 20.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ການຕັ້ງຄ່າການແຈ້ງເຕືອນ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'ເລືອກຊ່ອງທາງທີ່ທ່ານຕ້ອງການຮັບຂໍ້ຄວາມ\nການປ່ຽນແປງຈະຖືກບັນທຶກໂດຍອັດຕະໂນມັດ',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textHint,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Notification card container ───────────────────────────────
class _NotifCard extends StatelessWidget {
  final List<Widget> children;
  const _NotifCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ── Single notification row ───────────────────────────────────
class _NotifRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _NotifRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(icon, size: 18.r, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.black.withValues(alpha: 0.10),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Thin divider ──────────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: EdgeInsets.only(left: 64.w),
      color: Colors.black.withValues(alpha: 0.05),
    );
  }
}

// ── Footer note ───────────────────────────────────────────────
class _FooterNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, size: 13.r, color: AppColors.textHint),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            'ການປ່ຽນແປງຈະຖືກບັນທຶກທັນທີ. ທ່ານສາມາດປ່ຽນການຕັ້ງຄ່າໄດ້ຕະຫຼອດເວລາ.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textHint,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}
