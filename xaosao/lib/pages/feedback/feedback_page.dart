import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/my_feedback_model.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/app_text_field.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import 'getx/feedback_logic.dart';
import 'getx/feedback_state.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late final FeedbackLogic _logic;
  final _subjectCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _subjectFocus = FocusNode();
  final _descFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _logic = Get.find<FeedbackLogic>();
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _descCtrl.dispose();
    _subjectFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final subject = _subjectCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    if (subject.isEmpty || desc.isEmpty) return;
    final ok = await _logic.submitFeedback(subject: subject, desc: desc);
    if (ok && mounted) {
      _subjectCtrl.clear();
      _descCtrl.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: 'ຄຳຕິຊົມ',
        subtitle: 'ສົ່ງຄຳຄິດເຫັນ ຫຼື ລາຍງານບັນຫາ',
        expandedHeight: 80,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    icon: Icons.edit_note_rounded,
                    label: 'ສົ່ງຄຳຕິຊົມໃໝ່',
                  ),
                  SizedBox(height: 12.h),
                  _InputCard(
                    subjectCtrl: _subjectCtrl,
                    descCtrl: _descCtrl,
                    subjectFocus: _subjectFocus,
                    descFocus: _descFocus,
                    onSubmit: _submit,
                  ),
                  SizedBox(height: 24.h),
                  _SectionHeader(
                    icon: Icons.forum_rounded,
                    label: 'ຄຳຕິຊົມຂອງຂ້ອຍ',
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
          Obx(() {
            final st = _logic.state;
            if (st.status == FeedbackStatus.loading &&
                st.feedbacks.isEmpty) {
              return SliverToBoxAdapter(child: _LoadingPlaceholder());
            }
            if (st.feedbacks.isEmpty) {
              return SliverToBoxAdapter(child: _EmptyState());
            }
            return SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _FeedbackCard(item: st.feedbacks[i]),
                  ),
                  childCount: st.feedbacks.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26.r,
          height: 26.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 14.r, color: AppColors.primary),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Input card ─────────────────────────────────────────────────
class _InputCard extends StatelessWidget {
  final TextEditingController subjectCtrl;
  final TextEditingController descCtrl;
  final FocusNode subjectFocus;
  final FocusNode descFocus;
  final VoidCallback onSubmit;

  const _InputCard({
    required this.subjectCtrl,
    required this.descCtrl,
    required this.subjectFocus,
    required this.descFocus,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppFieldLabel('ຫົວຂໍ້', required: false),
          SizedBox(height: 6.h),
          AppTextField(
            controller: subjectCtrl,
            focusNode: subjectFocus,
            nextFocusNode: descFocus,
            hint: 'ໃສ່ຫົວຂໍ້ຄຳຕິຊົມ...',
            accent: AppColors.primary,
            prefixIcon: Icons.edit_outlined,
            action: TextInputAction.next,
          ),
          SizedBox(height: 14.h),
          AppFieldLabel('ລາຍລະອຽດ', required: false),
          SizedBox(height: 6.h),
          AppTextField(
            controller: descCtrl,
            focusNode: descFocus,
            hint: 'ອະທິບາຍລາຍລະອຽດເພີ່ມເຕີມ...',
            accent: AppColors.primary,
            prefixIcon: Icons.notes_rounded,
            keyboardType: TextInputType.multiline,
            action: TextInputAction.newline,
            maxLines: 5,
          ),
          SizedBox(height: 16.h),
          AppPrimaryButton(
            label: 'ສົ່ງຄຳຕິຊົມ',
            leadingIcon: Icons.send_rounded,
            onTap: onSubmit,
          ),
        ],
      ),
    );
  }
}

// ── Feedback item card ─────────────────────────────────────────
class _FeedbackCard extends StatelessWidget {
  final MyFeedbackModel item;
  const _FeedbackCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final chip = _statusChip(item.status);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.subject ?? '—',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              _StatusBadge(label: chip.label, fg: chip.fg, bg: chip.bg),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            item.description ?? '—',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          Divider(
            height: 0,
            thickness: 0.5,
            color: Colors.black.withValues(alpha: 0.05),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 11.r, color: AppColors.textHint),
              SizedBox(width: 4.w),
              Text(
                item.createdAt != null
                    ? DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt!)
                    : '—',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color fg;
  final Color bg;
  const _StatusBadge({required this.label, required this.fg, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

_StatusChipData _statusChip(String? status) {
  switch ((status ?? '').toLowerCase()) {
    case 'resolved':
    case 'completed':
      return _StatusChipData(
        label: 'ແກ້ໄຂແລ້ວ',
        fg: const Color(0xFF15803D),
        bg: const Color(0xFFEDFAF3),
      );
    case 'inprogress':
    case 'in_progress':
      return _StatusChipData(
        label: 'ກຳລັງດຳເນີນ',
        fg: const Color(0xFF3B82F6),
        bg: const Color(0xFFEFF6FF),
      );
    case 'rejected':
      return _StatusChipData(
        label: 'ປະຕິເສດ',
        fg: const Color(0xFFDC2626),
        bg: const Color(0xFFFEF2F2),
      );
    default:
      return _StatusChipData(
        label: 'ລໍຖ້າ',
        fg: const Color(0xFF92400E),
        bg: const Color(0xFFFFFBEB),
      );
  }
}

class _StatusChipData {
  final String label;
  final Color fg;
  final Color bg;
  const _StatusChipData({required this.label, required this.fg, required this.bg});
}

// ── Empty / Loading states ─────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 28.r,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'ຍັງບໍ່ມີຄຳຕິຊົມ',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'ສົ່ງຄຳຕິຊົມຂອງທ່ານດ້ານເທິງ',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              height: 110.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
