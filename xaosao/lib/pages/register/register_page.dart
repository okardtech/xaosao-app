import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/refferal_validate_model.dart';
import 'package:xaosao/pages/register/components/register_widget.dart';
import 'package:xaosao/widgets/app_network_image.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';
import '../login/getx/login_state.dart';
import 'components/avatar_picker.dart';
import 'getx/register_logic.dart';

class RegisterPage extends StatefulWidget {
  final RegisterRole role;

  /// Referral code to seed the referrer banner with, without a
  /// storage lookup. Populated by [DeepLinkService] when the page
  /// is opened from an AppsFlyer referral link; null when the user
  /// navigated here manually (e.g. from login → sign up).
  final String? referralCode;

  const RegisterPage({super.key, required this.role, this.referralCode});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ── controllers ───────────────────────────────────────────
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _password = TextEditingController();

  // ── focus nodes ───────────────────────────────────────────
  final _fnFocus = FocusNode();
  final _lnFocus = FocusNode();
  final _phFocus = FocusNode();
  final _htFocus = FocusNode();
  final _adFocus = FocusNode();
  final _paFocus = FocusNode();

  bool _termsAccepted = false;

  // ── derived ───────────────────────────────────────────────
  bool get _isCompanion => widget.role == RegisterRole.companion;

  bool get _canSubmit {
    final base =
        _firstName.text.trim().isNotEmpty &&
        _lastName.text.trim().isNotEmpty &&
        _phone.text.trim().length >= 8 &&
        _termsAccepted;
    if (!_isCompanion) return base;
    return base && _address.text.trim().isNotEmpty;
  }

  // ── actions ───────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    await Get.find<RegisterLogic>().uploadAndRegister(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      phone: _phone.text.trim(),
      password: _password.text,
      address: _isCompanion ? _address.text.trim() : null,
    );
  }

  @override
  void initState() {
    super.initState();
    Get.find<RegisterLogic>().setRole(
      widget.role,
      referralCode: widget.referralCode,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _phone, _address, _password]) {
      c.dispose();
    }
    for (final f in [
      _fnFocus,
      _lnFocus,
      _phFocus,
      _htFocus,
      _adFocus,
      _paFocus,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<RegisterLogic>();
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: GradientAppBar(
          title: _isCompanion ? l10n.registerCompanionTitle : l10n.registerCustomerTitle,
          subtitle: l10n.registerFillInfo,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 28.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Referral banner (both roles) ──────────
                      // Sits above the avatar so users see the bonus first.
                      Obx(() {
                        final referrer = logic.state.referralInfo?.referrer;
                        if (referrer == null) return const SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: _ReferralBanner(referrer: referrer),
                        );
                      }),

                      _AvatarSection(logic: logic, accent: AppColors.primary),
                      SizedBox(height: 12.h),

                      Row(
                        children: [
                          Expanded(
                            child: _FieldCol(
                              label: l10n.registerFirstName,
                              child: RegField(
                                ctrl: _firstName,
                                focus: _fnFocus,
                                nextFocus: _lnFocus,
                                hint: l10n.registerFirstNameHint,
                                icon: Icons.person_outline_rounded,
                                role: widget.role,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: _FieldCol(
                              label: l10n.registerLastName,
                              child: RegField(
                                ctrl: _lastName,
                                focus: _lnFocus,
                                nextFocus: _phFocus,
                                hint: l10n.registerLastNameHint,
                                icon: Icons.person_outline_rounded,
                                role: widget.role,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // ── ເບີໂທ ──────────────────────────────
                      RegLabel(l10n.registerPhone),
                      SizedBox(height: 4.h),
                      PhoneRegField(
                        ctrl: _phone,
                        focus: _phFocus,
                        nextFocus: _paFocus,
                        role: widget.role,
                      ),
                      SizedBox(height: 12.h),
                      // ── ເພດ ─────────────────────────────────
                      RegLabel(l10n.registerSelectGender),
                      SizedBox(height: 4.h),
                      Obx(() {
                        final selected = logic.state.gender;
                        return GenderSelector(
                          selected: selected,
                          onSelect: (g) => logic.setGender(g),
                        );
                      }),
                      SizedBox(height: 12.h),

                      // ── ວັນເດືອນປີ & ຄວາມສູງ ────────────
                      Obx(() {
                        final dateTime = logic.state.dob;
                        return _FieldCol(
                          label: l10n.registerDob,
                          child: DatePickerField(
                            value: dateTime,
                            role: widget.role,
                            onPick: (d) {
                              logic.setDob(d);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _paFocus.requestFocus();
                              });
                            },
                          ),
                        );
                      }),
                      SizedBox(height: 12.h),
                      _FieldCol(
                        label: l10n.registerPassword,
                        child: RegField(
                          ctrl: _password,
                          focus: _paFocus,
                          nextFocus: _adFocus,
                          hint: l10n.registerPasswordHint,
                          icon: Icons.lock,
                          role: widget.role,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // ── ທີ່ຢູ່ (Companion only) ────────────
                      if (_isCompanion) ...[
                        RegLabel(l10n.registerAddress),
                        SizedBox(height: 4.h),
                        RegField(
                          ctrl: _address,
                          focus: _adFocus,
                          hint: l10n.registerAddressHint,
                          icon: Icons.location_on_outlined,
                          role: widget.role,
                          action: TextInputAction.done,
                        ),
                        SizedBox(height: 12.h),
                      ],

                      // ── Terms ───────────────────────────────
                      TermsCheckbox(
                        checked: _termsAccepted,
                        role: widget.role,
                        onToggle: () =>
                            setState(() => _termsAccepted = !_termsAccepted),
                      ),
                      SizedBox(height: 20.h),

                      // ── Submit ──────────────────────────────
                      RegButton(
                        role: widget.role,
                        enabled: _canSubmit,
                        onTap: _submit,
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

// ── Label + child column helper ────────────────────────────────
class _FieldCol extends StatelessWidget {
  final String label;
  final Widget child;
  const _FieldCol({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RegLabel(label),
        SizedBox(height: 4.h),
        child,
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final RegisterLogic logic;
  final Color accent;
  const _AvatarSection({required this.logic, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvatarPicker(logic: logic, accent: accent),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _ReferralBanner
//  Card-less announcement: circular avatar on the left, gradient-
//  shimmer name in the middle, bouncing 🎁 emoji on the right.
//  Slides down + fades in on first paint; keeps a subtle pink→
//  purple shimmer sweeping across the name and a gentle bounce on
//  the gift so the bonus feels alive without adding chrome.
// ═══════════════════════════════════════════════════════════════
class _ReferralBanner extends StatefulWidget {
  final Referrer referrer;
  const _ReferralBanner({required this.referrer});

  @override
  State<_ReferralBanner> createState() => _ReferralBannerState();
}

class _ReferralBannerState extends State<_ReferralBanner>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  late final AnimationController _shimmerCtrl;
  late final AnimationController _bounceCtrl;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _shimmerCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = (widget.referrer.firstName ?? '').trim();
    final hasImage = widget.referrer.profile != null &&
        widget.referrer.profile!.isNotEmpty;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Row(
          children: [
            // ── Circular avatar (image) with subtle gradient ring ──
            Container(
              padding: EdgeInsets.all(1.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    const Color(0xFF7C3AED),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: hasImage
                  ? AppNetworkImage(
                      imageUrl: widget.referrer.profile!,
                      width: 46.r,
                      height: 46.r,
                      borderRadius: BorderRadius.circular(23.r),
                    )
                  : CircleAvatar(
                      radius: 23.r,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.12),
                      child: Icon(
                        Icons.person_rounded,
                        size: 24.r,
                        color: AppColors.primary,
                      ),
                    ),
            ),
            SizedBox(width: 12.w),

            // ── Text column ────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.registerReferredBy,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _GradientShimmerText(
                    text: name.isEmpty ? '—' : name,
                    controller: _shimmerCtrl,
                    fontSize: 18.sp,
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            // ── 🎁 emoji (icon) with gentle bounce ─────────────
            _BounceEmoji(controller: _bounceCtrl),
          ],
        ),
      ),
    );
  }
}

// A pink→purple gradient text with a bright shimmer highlight
// sweeping across it on a continuous loop.
class _GradientShimmerText extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double fontSize;
  const _GradientShimmerText({
    required this.text,
    required this.controller,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        return ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            colors: const [
              Color(0xFFE91E63), // pink
              Color(0xFFFFFFFF), // shimmer highlight
              Color(0xFF7C3AED), // purple
              Color(0xFFE91E63), // pink again for seamless loop
            ],
            stops: [
              (t - 0.35).clamp(0.0, 1.0),
              t.clamp(0.0, 1.0),
              (t + 0.35).clamp(0.0, 1.0),
              1.0,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(rect),
          blendMode: BlendMode.srcATop,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
              color: Colors.white, // masked by the shader
            ),
          ),
        );
      },
    );
  }
}

// Slight bounce + scale on the 🎁 emoji.
//
// The explicit color-emoji font families are required — otherwise the
// parent DefaultTextStyle can tint the glyph (e.g. blue), and on some
// Android devices Flutter falls back to a monochrome font that inherits
// the text color. Listing platform-specific color emoji fonts as
// fallbacks makes the glyph render in its native colours everywhere.
class _BounceEmoji extends StatelessWidget {
  final AnimationController controller;
  const _BounceEmoji({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        final scale = 0.92 + t * 0.18;
        final dy = -6 * t;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.scale(
            scale: scale,
            child: Text(
              '\u{1F381}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.sp,
                color: Colors.black,
                fontFamily: 'Apple Color Emoji',
                fontFamilyFallback: const [
                  'Apple Color Emoji',
                  'Noto Color Emoji',
                  'NotoColorEmoji',
                  'Segoe UI Emoji',
                  'Twemoji Mozilla',
                  'EmojiOne Color',
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
