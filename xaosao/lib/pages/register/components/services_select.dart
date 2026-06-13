import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/models/service_model.dart';
import 'package:xaosao/utils/service_helper.dart';
import 'package:xaosao/pages/register/getx/register_logic.dart';
import 'package:xaosao/pages/register/getx/register_state.dart';
import '../../../widgets/gradient_app_bar.dart';

// ── Thousands comma formatter ──────────────────────────────────────────────────
class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    final formatted = _addCommas(digits);
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _addCommas(String s) {
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ── Format int with commas ─────────────────────────────────────────────────────
String _fmtInt(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

// ── Variant row for massage service ───────────────────────────────────────────
class _VariantRow {
  final TextEditingController nameCtrl;
  final TextEditingController priceCtrl;

  _VariantRow({String name = '', String price = ''})
    : nameCtrl = TextEditingController(text: name),
      priceCtrl = TextEditingController(text: price);

  bool get isFilled =>
      nameCtrl.text.trim().isNotEmpty && priceCtrl.text.isNotEmpty;

  bool get isPartiallyFilled {
    final nameEmpty = nameCtrl.text.trim().isEmpty;
    final priceEmpty = priceCtrl.text.trim().isEmpty;
    return nameEmpty != priceEmpty;
  }

  int? get parsedPrice {
    final raw = priceCtrl.text.replaceAll(',', '');
    return raw.isEmpty ? null : int.tryParse(raw);
  }

  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
  }
}

// ── Service entry (wraps ServiceModel with UI state) ──────────────────────────
class _ServiceEntry {
  final ServiceModel service;
  bool selected;
  final TextEditingController priceCtrl;         // non-massage only
  final TextEditingController serviceLocationCtrl; // massage only
  final List<_VariantRow> variants;              // massage only

  bool get isMassage => service.name?.toLowerCase() == 'massage';

  _ServiceEntry({required this.service})
    : selected = false,
      priceCtrl = TextEditingController(
        text: service.baseRate != null ? _fmtInt(service.baseRate!.toInt()) : '',
      ),
      serviceLocationCtrl = TextEditingController(),
      variants = service.name?.toLowerCase() == 'massage'
          ? (service.massageVariants?.isNotEmpty == true
                ? service.massageVariants!
                      .map((v) => _VariantRow(
                            name: v.name ?? '',
                            price: v.pricePerHour != null
                                ? _fmtInt(v.pricePerHour!.toInt())
                                : '',
                          ))
                      .toList()
                : [_VariantRow()])
          : [];

  double? get parsedPrice {
    final raw = priceCtrl.text.replaceAll(',', '');
    return raw.isEmpty ? null : double.tryParse(raw);
  }

  List<_VariantRow> get filledVariants =>
      variants.where((v) => v.isFilled).toList();

  bool get isValid {
    if (!selected) return false;
    if (isMassage) {
      if (serviceLocationCtrl.text.trim().isEmpty) return false;
      if (variants.isEmpty) return false;
      if (!variants.every((v) => v.isFilled)) return false;
      final base = service.baseRate ?? 0;
      return variants.every((v) {
        final p = v.parsedPrice;
        return p != null && p >= base;
      });
    }
    final p = parsedPrice;
    if (p == null) return false;
    return p >= (service.baseRate ?? 0);
  }

  String? get priceError {
    if (!selected || priceCtrl.text.isEmpty) return null;
    final p = parsedPrice;
    if (p == null) return 'ກະລຸນາໃສ່ລາຄາ';
    final base = service.baseRate ?? 0;
    if (p < base) return 'ລາຄາຕ່ຳສຸດ ${_fmtInt(base.toInt())} ກີບ';
    return null;
  }

  Map<String, dynamic> toApiPayload() {
    if (isMassage) {
      return {
        'serviceId': service.id,
        'serviceLocation': serviceLocationCtrl.text.trim(),
        'massageVariants': filledVariants
            .map((v) => {
                  'name': v.nameCtrl.text.trim(),
                  'pricePerHour': v.parsedPrice,
                })
            .toList(),
      };
    }
    return {'serviceId': service.id, 'customRate': parsedPrice!.toInt()};
  }

  void dispose() {
    priceCtrl.dispose();
    serviceLocationCtrl.dispose();
    for (final v in variants) {
      v.dispose();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  ServicesSelect page
// ═══════════════════════════════════════════════════════════════════════════════
class ServicesSelect extends StatefulWidget {
  final RegisterModel model;
  const ServicesSelect({super.key, required this.model});

  @override
  State<ServicesSelect> createState() => _ServicesSelectState();
}

class _ServicesSelectState extends State<ServicesSelect> {
  final _entries = <_ServiceEntry>[].obs;

  bool get _canContinue {
    final selected = _entries.where((e) => e.selected).toList();
    if (selected.isEmpty) return false;
    return selected.every((e) => e.isValid);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final logic = Get.find<RegisterLogic>();
      if (logic.state.services.isEmpty) {
        logic.fetchServices().then((_) {
          if (mounted) _buildEntries();
        });
      } else {
        _buildEntries();
      }
    });
  }

  void _buildEntries() {
    final logic = Get.find<RegisterLogic>();
    for (final e in _entries) e.dispose();
    _entries.assignAll(
      logic.state.services.map((s) => _ServiceEntry(service: s)).toList(),
    );
    _restoreSelections(logic);
  }

  void _restoreSelections(RegisterLogic logic) {
    final saved = logic.savedServiceSelections;
    if (saved.isEmpty) return;
    for (final entry in _entries) {
      final match = saved
          .where((m) => m['serviceId'] == entry.service.id)
          .firstOrNull;
      if (match == null) continue;
      entry.selected = match['selected'] as bool? ?? false;
      if (entry.isMassage) {
        entry.serviceLocationCtrl.text =
            match['serviceLocation'] as String? ?? '';
        final vList = match['variants'] as List<dynamic>? ?? [];
        if (vList.isNotEmpty) {
          for (final v in entry.variants) v.dispose();
          entry.variants
            ..clear()
            ..addAll(
              vList.map(
                (v) => _VariantRow(
                  name: v['name'] as String? ?? '',
                  price: v['price'] as String? ?? '',
                ),
              ),
            );
        }
      } else {
        entry.priceCtrl.text = match['price'] as String? ?? '';
      }
    }
  }

  void _saveSelections() {
    if (_entries.isEmpty) return;
    final logic = Get.find<RegisterLogic>();
    logic.saveServiceSelections(
      _entries.map((e) => {
        'serviceId': e.service.id,
        'selected': e.selected,
        'price': e.priceCtrl.text,
        'serviceLocation': e.serviceLocationCtrl.text,
        'variants': e.variants
            .map((v) => {'name': v.nameCtrl.text, 'price': v.priceCtrl.text})
            .toList(),
      }).toList(),
    );
  }

  Future<void> _continue() async {
    if (!_canContinue) return;
    FocusScope.of(context).unfocus();
    final selectedServices = _entries
        .where((e) => e.selected)
        .map((e) => e.toApiPayload())
        .toList();
    await Get.find<RegisterLogic>().registerModel(
      selectedServices: selectedServices,
    );
  }

  @override
  void dispose() {
    _saveSelections();
    for (final e in _entries) e.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<RegisterLogic>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: GradientAppBar(
          title: "ເລືອກບໍລິການ",
          subtitle: 'ກຳນົດປະເພດ ແລະ ລາຄາບໍລິການຂອງທ່ານ',
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const _InfoBanner(),
              ),
              SizedBox(height: 14.h),
              Expanded(
                child: Obx(() {
                  final st = logic.getXController.value;
                  if (st.servicesStatus == RegisterStatus.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    );
                  }
                  if (_entries.isEmpty) {
                    return Center(
                      child: Text(
                        'ບໍ່ມີບໍລິການ',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
                    child: Column(
                      children: [
                        ..._entries.asMap().entries.map((mapEntry) {
                          final idx = mapEntry.key;
                          final entry = mapEntry.value;
                          print(
                            'Rendering service card for ${entry.service.name}, selected: ${entry.selected}, price: ${entry.priceCtrl.text}, variants: ${entry.variants.length}',
                          );
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: idx < _entries.length - 1 ? 12.h : 0,
                            ),
                            child: entry.isMassage
                                ? _MassageServiceCard(
                                    entry: entry,
                                    onToggle: () {
                                      entry.selected = !entry.selected;
                                      if (!entry.selected) {
                                        for (final v in entry.variants) {
                                          v.dispose();
                                        }
                                        entry.variants.clear();
                                        entry.variants.add(_VariantRow());
                                      }
                                      _entries.refresh();
                                    },
                                    onAddVariant: () {
                                      entry.variants.add(_VariantRow());
                                      _entries.refresh();
                                    },
                                    onRemoveVariant: (i) {
                                      entry.variants[i].dispose();
                                      entry.variants.removeAt(i);
                                      if (entry.variants.isEmpty) {
                                        entry.variants.add(_VariantRow());
                                      }
                                      _entries.refresh();
                                    },
                                    onChanged: () => _entries.refresh(),
                                  )
                                : _ServiceCard(
                                    selected: entry.selected,
                                    isValid: entry.isValid,
                                    onToggle: () {
                                      entry.selected = !entry.selected;
                                      if (!entry.selected) {
                                        final base = entry.service.baseRate;
                                        entry.priceCtrl.text = base != null
                                            ? _fmtInt(base.toInt())
                                            : '';
                                      }
                                      _entries.refresh();
                                    },
                                    label: ServiceHelper.serviceOriginalName(
                                      entry.service.name,
                                    ),
                                    description: entry.service.description,
                                    priceCtrl: entry.priceCtrl,
                                    baseRate: entry.service.baseRate,
                                    priceError: entry.priceError,
                                    onChanged: () => _entries.refresh(),
                                  ),
                          );
                        }),
                        SizedBox(height: 28.h),
                        _ContinueButton(
                          enabled: _canContinue,
                          onTap: _continue,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _InfoBanner
// ═══════════════════════════════════════════════════════════════════════════════
class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                children: const [
                  TextSpan(text: 'ກະລຸນາດຳເນີນການ'),
                  TextSpan(
                    text: 'ເລືອກບໍລິການ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(text: ' ທີ່ທ່ານຕ້ອງການ ແລະ '),
                  TextSpan(
                    text: 'ຕັ້ງລາຄາ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _ServiceCard — single price card for non-massage services
// ═══════════════════════════════════════════════════════════════════════════════
class _ServiceCard extends StatelessWidget {
  final bool selected;
  final bool isValid;
  final VoidCallback onToggle;
  final String label;
  final String? description;
  final TextEditingController priceCtrl;
  final double? baseRate;
  final String? priceError;
  final VoidCallback onChanged;

  const _ServiceCard({
    required this.selected,
    required this.isValid,
    required this.onToggle,
    required this.label,
    required this.priceCtrl,
    required this.onChanged,
    this.description,
    this.baseRate,
    this.priceError,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.35)
              : const Color(0x1A000000),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textDisabled,
                        width: 2,
                      ),
                    ),
                    child: selected
                        ? Icon(
                            Icons.check_rounded,
                            size: 14.r,
                            color: Colors.white,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                SizedBox(width: 10.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.10)
                        : AppColors.bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.miscellaneous_services_outlined,
                    size: 20.r,
                    color: selected ? AppColors.primary : AppColors.textHint,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (description != null && description!.isNotEmpty)
                        Text(
                          description!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (isValid)
                  Icon(Icons.check, size: 20.r, color: Colors.green.shade400),
              ],
            ),
          ),
          // ── Price input ──────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: selected
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1, color: Color(0x0F000000)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ລາຄາ (ກີບ/ຊົ່ວໂມງ) *',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (baseRate != null) ...[
                                  SizedBox(width: 6.w),
                                  Text(
                                    'ຕ່ຳສຸດ ${_fmtInt(baseRate!.toInt())} ກີບ',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 8.h),
                            _PriceSuffixField(
                              ctrl: priceCtrl,
                              hasError: priceError != null,
                              isValid: isValid,
                              onChanged: onChanged,
                            ),
                            if (priceError != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                priceError!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _MassageServiceCard — multi-variant card for massage (name == 'message')
// ═══════════════════════════════════════════════════════════════════════════════
class _MassageServiceCard extends StatelessWidget {
  final _ServiceEntry entry;
  final VoidCallback onToggle;
  final VoidCallback onAddVariant;
  final void Function(int index) onRemoveVariant;
  final VoidCallback onChanged;

  const _MassageServiceCard({
    required this.entry,
    required this.onToggle,
    required this.onAddVariant,
    required this.onRemoveVariant,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = entry.selected;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.35)
              : const Color(0x1A000000),
          width: selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24.r,
                    height: 24.r,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.textDisabled,
                        width: 2,
                      ),
                    ),
                    child: selected
                        ? Icon(
                            Icons.check_rounded,
                            size: 14.r,
                            color: Colors.white,
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                SizedBox(width: 10.w),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.10)
                        : AppColors.bg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.spa_outlined,
                    size: 20.r,
                    color: selected ? AppColors.primary : AppColors.textHint,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ServiceHelper.serviceOriginalName(entry.service.name),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'ເພີ່ມໄດ້ທຸກປະເພດ',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                if (entry.isValid)
                  Icon(Icons.check, size: 20.r, color: Colors.green.shade400),
              ],
            ),
          ),
          // ── Variants section ─────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: selected
                ? _MassageVariantsSection(
                    variants: entry.variants,
                    locationCtrl: entry.serviceLocationCtrl,
                    baseRate: entry.service.baseRate,
                    onAdd: onAddVariant,
                    onRemove: onRemoveVariant,
                    onChanged: onChanged,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _MassageVariantsSection
// ═══════════════════════════════════════════════════════════════════════════════
class _MassageVariantsSection extends StatelessWidget {
  final List<_VariantRow> variants;
  final TextEditingController locationCtrl;
  final double? baseRate;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback onChanged;

  const _MassageVariantsSection({
    required this.variants,
    required this.locationCtrl,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
    this.baseRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: Color(0x0F000000)),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Service location input ───────────────────────
              Text(
                'ສະຖານທີ່ໃຫ້ບໍລິການ *',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              _MiniTextField(
                ctrl: locationCtrl,
                hint: 'ເຊັ່ນ: ເຮືອນ, ໂຮງແຮມ, ສະຖານທີ່ລູກຄ້າ',
                hasError: false,
                isNumber: false,
                onChanged: onChanged,
              ),
              SizedBox(height: 14.h),
              // ── Variants ─────────────────────────────────────
              Row(
                children: [
                  Text(
                    'ປະເພດ ແລະ ລາຄາ (ກີບ/ຊົ່ວໂມງ) *',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (baseRate != null) ...[
                    SizedBox(width: 6.w),
                    Text(
                      'ຕ່ຳສຸດ ${_fmtInt(baseRate!.toInt())} ກີບ',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 10.h),
              ...variants.asMap().entries.map(
                (e) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _VariantRowWidget(
                    row: e.value,
                    canRemove: variants.length > 1,
                    onRemove: () => onRemove(e.key),
                    onChanged: onChanged,
                    baseRate: baseRate,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: onAdd,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 16.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'ເພີ່ມປະເພດ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _VariantRowWidget — one name+price row inside the massage card
// ═══════════════════════════════════════════════════════════════════════════════
class _VariantRowWidget extends StatelessWidget {
  final _VariantRow row;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final double? baseRate;

  const _VariantRowWidget({
    required this.row,
    required this.canRemove,
    required this.onRemove,
    required this.onChanged,
    this.baseRate,
  });

  bool get _priceHasError {
    if (row.priceCtrl.text.isEmpty) return false;
    final p = row.parsedPrice;
    final base = (baseRate ?? 0).toInt();
    return p == null || p < base;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _MiniTextField(
            ctrl: row.nameCtrl,
            hint: 'ຊື່ປະເພດ',
            hasError: false,
            isNumber: false,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          flex: 5,
          child: _MiniTextField(
            ctrl: row.priceCtrl,
            hint: '0',
            hasError: _priceHasError,
            isNumber: true,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 6.w),
        GestureDetector(
          onTap: canRemove ? onRemove : null,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: canRemove ? Colors.red.shade50 : AppColors.bg,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.close_rounded,
              size: 16.r,
              color: canRemove ? Colors.red.shade400 : AppColors.textDisabled,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _MiniTextField — focus-aware input for variant rows
// ═══════════════════════════════════════════════════════════════════════════════
class _MiniTextField extends StatefulWidget {
  final TextEditingController ctrl;
  final String hint;
  final bool hasError;
  final bool isNumber;
  final VoidCallback onChanged;

  const _MiniTextField({
    required this.ctrl,
    required this.hint,
    required this.hasError,
    required this.isNumber,
    required this.onChanged,
  });

  @override
  State<_MiniTextField> createState() => _MiniTextFieldState();
}

class _MiniTextFieldState extends State<_MiniTextField> {
  late final FocusNode _focus;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode();
    _focus.addListener(() {
      if (mounted) setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.hasError
        ? Colors.red.shade300
        : _focused
        ? AppColors.primary
        : const Color(0x1A000000);
    final borderWidth = (_focused && !widget.hasError) ? 1.5 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: TextField(
        controller: widget.ctrl,
        focusNode: _focus,
        keyboardType: widget.isNumber
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: widget.isNumber ? [_ThousandsFormatter()] : [],
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        onChanged: (_) => widget.onChanged(),
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: widget.hasError ? Colors.red.shade400 : AppColors.textPrimary,
        ),

        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textDisabled),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 12.h,
          ),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _PriceSuffixField
// ═══════════════════════════════════════════════════════════════════════════════
class _PriceSuffixField extends StatelessWidget {
  final TextEditingController ctrl;
  final bool hasError;
  final bool isValid;
  final VoidCallback onChanged;

  const _PriceSuffixField({
    required this.ctrl,
    required this.onChanged,
    this.hasError = false,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: hasError
              ? Colors.red.shade300
              : isValid
              ? AppColors.textSecondary.withAlpha(50)
              : const Color(0x1A000000),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [_ThousandsFormatter()],
              onChanged: (_) => onChanged(),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textDisabled,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: hasError ? Colors.red.shade400 : AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Center(
              child: Text(
                'ກີບ/ຊມ',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  _ContinueButton
// ═══════════════════════════════════════════════════════════════════════════════
class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ContinueButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 46.h,
        decoration: BoxDecoration(
          color: enabled ? null : AppColors.textDisabled,
          borderRadius: BorderRadius.circular(13.r),
          gradient: enabled
              ? const LinearGradient(colors: AppColors.pinkGradient)
              : null,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ດຳເນີນການຕໍ່',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: enabled ? Colors.white : AppColors.textHint,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16.r,
                color: enabled ? Colors.white : AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
