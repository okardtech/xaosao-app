import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/pages/login/getx/login_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_logic.dart';
import 'package:xaosao/pages/services_manage/getx/service_state.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_button.dart';
import 'package:xaosao/widgets/confirm_sheet.dart';

import '../../widgets/gradient_app_bar.dart';

// ═══════════════════════════════════════════════════════════════
//  ServiceManagementPage — Companion service management
// ═══════════════════════════════════════════════════════════════
class ServiceManagementPage extends StatelessWidget {
  const ServiceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ServiceLogic>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: "ບໍລິການຂອງຂ້ອຍ",
        subtitle: "ຈັດການ ແລະ ຕັ້ງລາຄາບໍລິການ",
      ),
      body: Obx(() {
        // Watch both controllers so cards rebuild after profile refresh
        Get.find<LoginLogic>().getXController.value;
        final st = logic.state;

        if (st.status == ServiceStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (st.status == ServiceStatus.failure) {
          return _ErrorView(onRetry: logic.fetchAvailable);
        }

        if (st.available.isEmpty) {
          return const _EmptyView();
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 40.h),
          child: Column(
            children: [
              _InfoBanner(),
              SizedBox(height: 16.h),
              for (final svc in st.available) ...[
                _ServiceCard(
                  service: svc,
                  profileService: logic.getProfileService(svc.id),
                  onAdd: () => _handleAdd(context, logic, svc),
                  onUpdate: (profileSvc) =>
                      _handleUpdate(context, logic, svc, profileSvc),
                  onDelete: (profileSvc) =>
                      _handleDelete(context, logic, svc, profileSvc),
                ),
                SizedBox(height: 12.h),
              ],
            ],
          ),
        );
      }),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────

  // ── Actions ────────────────────────────────────────────────
  Future<void> _handleAdd(
    BuildContext context,
    ServiceLogic logic,
    ServiceModel svc,
  ) async {
    final rate = await _showRateSheet(
      context,
      serviceName: svc.name,
      billingLabel: _billingLabel(svc.billingType),
      baseRate: svc.baseRate,
    );
    if (rate == null) return;
    await logic.addService(serviceId: svc.id, customHourlyRate: rate);
  }

  Future<void> _handleUpdate(
    BuildContext context,
    ServiceLogic logic,
    ServiceModel svc,
    ModelService profileSvc,
  ) async {
    final rate = await _showRateSheet(
      context,
      serviceName: svc.name,
      billingLabel: _billingLabel(svc.billingType),
      initialRate: profileSvc.customHourlyRate,
      baseRate: svc.baseRate,
    );
    if (rate == null) return;
    await logic.updateService(
      modelServiceId: profileSvc.modelServiceId!,
      customHourlyRate: rate,
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    ServiceLogic logic,
    ServiceModel svc,
    ModelService profileSvc,
  ) async {
    final confirmed = await ConfirmSheet.show(
      context,
      title: 'ລຶບ ${svc.name}',
      message: 'ທ່ານຕ້ອງການລຶບບໍລິການນີ້ອອກຈາກໂປຣໄຟຂອງທ່ານແທ້ບໍ່?',
      confirmLabel: 'ລຶບ',
      icon: Icons.delete_outline_rounded,
      isDanger: true,
    );
    if (confirmed != true) return;
    await logic.deleteService(modelServiceId: profileSvc.modelServiceId!);
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ServiceCard — renders owned or unowned layout
// ═══════════════════════════════════════════════════════════════
class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final ModelService? profileService;
  final VoidCallback onAdd;
  final void Function(ModelService) onUpdate;
  final void Function(ModelService) onDelete;

  const _ServiceCard({
    required this.service,
    required this.profileService,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  bool get _owned => profileService != null;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.07),
          width: _owned ? 1.2 : 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: _owned
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: _owned ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────
          _CardHeader(service: service, owned: _owned),

          // ── Body ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: _owned
                ? _OwnedBody(
                    service: service,
                    profileService: profileService!,
                    onUpdate: () => onUpdate(profileService!),
                    onDelete: () => onDelete(profileService!),
                  )
                : _UnownedBody(service: service, onAdd: onAdd),
          ),
        ],
      ),
    );
  }
}

// ── Card header ────────────────────────────────────────────────
class _CardHeader extends StatelessWidget {
  final ServiceModel service;
  final bool owned;

  const _CardHeader({required this.service, required this.owned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: owned ? AppColors.primary.withValues(alpha: 0.04) : AppColors.bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(17.r)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: owned
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              _iconFor(service.name),
              size: 22.r,
              color: owned ? AppColors.primary : AppColors.textHint,
            ),
          ),
          SizedBox(width: 12.w),

          // Name + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (service.description != null &&
                    service.description!.isNotEmpty)
                  Text(
                    service.description!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Badge
          if (owned)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'ສະໝັກເເລ້ວ',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _OwnedBody — rate info + delete / update buttons
// ═══════════════════════════════════════════════════════════════
class _OwnedBody extends StatelessWidget {
  final ServiceModel service;
  final ModelService profileService;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const _OwnedBody({
    required this.service,
    required this.profileService,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rate = profileService.customHourlyRate ?? 0;
    final commission = service.commission ?? 0;
    final net = rate * (1 - commission / 100);
    final suffix = _billingLabel(service.billingType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Container(height: 0.5, color: Colors.black.withValues(alpha: 0.06)),
        SizedBox(height: 14.h),

        // Rate rows
        _DetailRow(
          label: 'ລາຄາທ່ານກຳນົດ',
          value: '${CurrFormatter.format(rate)} ກີບ$suffix',
          valueColor: AppColors.primary,
          bold: true,
        ),
        SizedBox(height: 6.h),
        _DetailRow(
          label: 'ຄ່າບໍລິການ/ຄັ້ງ',
          value: '${commission.toStringAsFixed(commission % 1 == 0 ? 0 : 1)}%',
        ),

        // Dashed divider
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: List.generate(
              32,
              (i) => Expanded(
                child: Container(
                  height: 1,
                  color: i.isEven
                      ? Colors.black.withValues(alpha: 0.08)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ),

        // Net earnings
        _DetailRow(
          label: 'ເງິນທີ່ໄດ້ຮັບຕົວຈິງ',
          value: '${CurrFormatter.format(net)} ກີບ$suffix',
          valueColor: AppColors.primary,
          bold: true,
          labelBold: true,
        ),

        SizedBox(height: 14.h),

        // Buttons
        Row(
          children: [
            Expanded(
              child: AppOutlineButton(
                label: 'ລຶບ',
                leadingIcon: Icons.delete_outline_rounded,
                borderColor: const Color(0xFFEF4444).withValues(alpha: 0.5),
                textColor: const Color(0xFFEF4444),
                height: 42,
                onTap: onDelete,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AppPrimaryButton(
                label: 'ອັບເດດ',
                leadingIcon: Icons.edit_outlined,
                height: 42,
                onTap: onUpdate,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _UnownedBody — commission info + add button
// ═══════════════════════════════════════════════════════════════
class _UnownedBody extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onAdd;

  const _UnownedBody({required this.service, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final commission = service.commission;
    final baseRate = service.displayPrice;
    final suffix = _billingLabel(service.billingType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 0.5, color: Colors.black.withValues(alpha: 0.06)),
        SizedBox(height: 14.h),

        if (commission != null)
          _DetailRow(
            label: 'ຄ່ານາຍໜ້າ',
            value:
                '${commission.toStringAsFixed(commission % 1 == 0 ? 0 : 1)}%',
          ),

        if (baseRate != null) ...[
          SizedBox(height: 6.h),
          _DetailRow(
            label: 'ລາຄາພື້ນຖານ',
            value: '${CurrFormatter.format(baseRate)} ກີບ$suffix',
          ),
        ],

        SizedBox(height: 14.h),

        AppPrimaryButton(label: '+ ເພີ່ມບໍລິການ', height: 42, onTap: onAdd),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _DetailRow — label / value pair
// ═══════════════════════════════════════════════════════════════
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final bool labelBold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
    this.labelBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: labelBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _InfoBanner
// ═══════════════════════════════════════════════════════════════
class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 0.6,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 15.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Text(
              'ເລືອກເພີ່ມບໍລິການທີ່ທ່ານສາມາດໃຫ້ໄດ້ ແລະ ຕັ້ງລາຄາຂອງທ່ານເອງ. '
              'ລູກຄ້າຈະເຫັນລາຍການທີ່ທ່ານເປີດໃຊ້ເທົ່ານັ້ນ.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ErrorView / _EmptyView
// ═══════════════════════════════════════════════════════════════
class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, size: 48.r, color: AppColors.textHint),
          SizedBox(height: 12.h),
          Text(
            'ໂຫຼດຂໍ້ມູນບໍ່ສຳເລັດ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 140.w,
            child: AppPrimaryButton(
              label: 'ລອງໃໝ່',
              height: 42,
              onTap: onRetry,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ບໍ່ມີຂໍ້ມູນບໍລິການ',
        style: TextStyle(fontSize: 14.sp, color: AppColors.textHint),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _RateInputSheet — bottom sheet to enter / update custom rate
// ═══════════════════════════════════════════════════════════════
Future<double?> _showRateSheet(
  BuildContext context, {
  required String serviceName,
  required String billingLabel,
  double? initialRate,
  double? baseRate,
}) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => _RateInputSheet(
      serviceName: serviceName,
      billingLabel: billingLabel,
      initialRate: initialRate,
      baseRate: baseRate,
    ),
  );
}

class _RateInputSheet extends StatefulWidget {
  final String serviceName;
  final String billingLabel;
  final double? initialRate;
  final double? baseRate;

  const _RateInputSheet({
    required this.serviceName,
    required this.billingLabel,
    this.initialRate,
    this.baseRate,
  });

  @override
  State<_RateInputSheet> createState() => _RateInputSheetState();
}

class _RateInputSheetState extends State<_RateInputSheet> {
  late final TextEditingController _ctrl;
  String? _errorMsg;

  static String _fmt(String digits) {
    if (digits.isEmpty) return '';
    final n = int.tryParse(digits);
    if (n == null) return digits;
    return NumberFormat('#,###').format(n);
  }

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.initialRate != null
          ? _fmt(widget.initialRate!.toStringAsFixed(0))
          : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    HapticFeedback.lightImpact();
    final raw = _ctrl.text.replaceAll(',', '').trim();
    final val = double.tryParse(raw);
    if (val == null || val <= 0) {
      setState(() => _errorMsg = 'ກະລຸນາໃສ່ລາຄາທີ່ຖືກຕ້ອງ');
      return;
    }
    if (widget.baseRate != null && val < widget.baseRate!) {
      setState(
        () => _errorMsg =
            'ລາຄາຕ່ຳສຸດ: ${CurrFormatter.format(widget.baseRate!)} ກີບ',
      );
      return;
    }
    Navigator.pop(context, val);
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.initialRate != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),

              // Icon + Title
              Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      isUpdate
                          ? Icons.edit_outlined
                          : Icons.add_circle_outline_rounded,
                      size: 20.r,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUpdate ? 'ອັບເດດລາຄາ' : 'ເພີ່ມບໍລິການ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.serviceName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Rate label
              Text(
                'ລາຄາ${widget.billingLabel} (ກີບ)',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),

              // TextField
              TextField(
                controller: _ctrl,
                keyboardType: TextInputType.number,
                inputFormatters: [_ThousandsSeparatorFormatter()],
                autofocus: true,
                onChanged: (_) {
                  if (_errorMsg != null) setState(() => _errorMsg = null);
                },
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    color: AppColors.textDisabled,
                    fontSize: 16.sp,
                  ),
                  suffixText: 'ກີບ',
                  suffixStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHint,
                  ),
                  errorText: _errorMsg,
                  filled: true,
                  fillColor: AppColors.bg,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 0.8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: Colors.black.withValues(alpha: 0.08),
                      width: 0.8,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.4,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFEF4444),
                      width: 1.2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFEF4444),
                      width: 1.4,
                    ),
                  ),
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),

              // Submit
              AppPrimaryButton(
                label: isUpdate ? 'ອັບເດດ' : 'ເພີ່ມ',
                height: 50,
                onTap: _submit,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ThousandsSeparatorFormatter — formats input as 1,000,000
// ═══════════════════════════════════════════════════════════════
class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');
    final n = int.tryParse(digits);
    if (n == null) return oldValue;
    final formatted = NumberFormat('#,###').format(n);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Helpers
// ═══════════════════════════════════════════════════════════════
IconData _iconFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('social') || n.contains('ສັງຄົມ') || n.contains('ເພື່ອນ')) {
    return Icons.people_outline_rounded;
  }
  if (n.contains('massage') || n.contains('ນວດ') || n.contains('spa')) {
    return Icons.spa_outlined;
  }
  if (n.contains('travel') || n.contains('ທ່ອງ') || n.contains('tour')) {
    return Icons.explore_outlined;
  }
  return Icons.miscellaneous_services_outlined;
}

String _billingLabel(String? type) {
  switch (type) {
    case 'per_hour':
      return '/ຊ.ມ';
    case 'per_day':
      return '/ມື້';
    case 'per_night':
      return '/ຄືນ';
    case 'one_time':
      return '/ຄັ້ງ';
    case 'per_minute':
      return '/ນາທີ';
    default:
      return '/ຊ.ມ';
  }
}
