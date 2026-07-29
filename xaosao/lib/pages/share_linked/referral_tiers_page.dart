import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/pages/referral_analytics/getx/referral_analytics_logic.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

// ═══════════════════════════════════════════════════════════════
//  ReferralTiersPage
//  Static explainer for the 3-tier model-referral programme.
//  If the ReferralAnalyticsLogic already has data, we highlight
//  the user's current tier via a "Your current tier" badge.
// ═══════════════════════════════════════════════════════════════

enum _Tier { general, special, partner }

_Tier _tierFromWire(String? raw) {
  switch (raw) {
    case 'special':
      return _Tier.special;
    case 'partner':
      return _Tier.partner;
    default:
      return _Tier.general;
  }
}

class ReferralTiersPage extends StatelessWidget {
  const ReferralTiersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Best-effort: highlight the user's current tier if the analytics
    // controller happens to be alive. Falls back to General when the
    // controller isn't registered or the API hasn't returned yet.
    _Tier current = _Tier.general;
    try {
      final rx = Get.find<ReferralAnalyticsLogic>();
      current = _tierFromWire(rx.state.data?.modelType);
    } catch (_) {}

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.tiersTitle,
        subtitle: l10n.tiersSubtitle,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OverviewBanner(text: l10n.tiersOverview),
            SizedBox(height: 16.h),
            _TierCard(
              tier: _Tier.general,
              index: 1,
              title: l10n.tiersLevel1Title,
              gradient: const [Color(0xFF64748B), Color(0xFF334155)],
              description: l10n.tiersLevel1Desc,
              isCurrent: current == _Tier.general,
            ),
            SizedBox(height: 12.h),
            _TierCard(
              tier: _Tier.special,
              index: 2,
              title: l10n.tiersLevel2Title,
              gradient: AppColors.pinkGradient,
              condition: l10n.tiersLevel2Condition,
              links: l10n.tiersLevel2Links,
              benefit: l10n.tiersLevel2Benefit,
              isCurrent: current == _Tier.special,
            ),
            SizedBox(height: 12.h),
            _TierCard(
              tier: _Tier.partner,
              index: 3,
              title: l10n.tiersLevel3Title,
              gradient: const [Color(0xFFFFB300), Color(0xFFE65100)],
              condition: l10n.tiersLevel3Condition,
              links: l10n.tiersLevel3Links,
              benefit: l10n.tiersLevel3Benefit,
              isCurrent: current == _Tier.partner,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Overview banner
// ═══════════════════════════════════════════════════════════════
class _OverviewBanner extends StatelessWidget {
  final String text;
  const _OverviewBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18.r,
            color: AppColors.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Tier card
// ═══════════════════════════════════════════════════════════════
class _TierCard extends StatefulWidget {
  final _Tier tier;
  final int index;
  final String title;
  final List<Color> gradient;
  final String? description; // for tier 1 (single paragraph)
  final String? condition;
  final String? links;
  final String? benefit;
  final bool isCurrent;

  const _TierCard({
    required this.tier,
    required this.index,
    required this.title,
    required this.gradient,
    this.description,
    this.condition,
    this.links,
    this.benefit,
    required this.isCurrent,
  });

  @override
  State<_TierCard> createState() => _TierCardState();
}

class _TierCardState extends State<_TierCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 320 + widget.index * 80),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: widget.isCurrent
                  ? widget.gradient.last.withValues(alpha: 0.55)
                  : Colors.black.withValues(alpha: 0.06),
              width: 0.6,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.last.withValues(
                    alpha: widget.isCurrent ? 0.14 : 0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(l10n),
              Padding(
                padding: EdgeInsets.fromLTRB(16.r, 12.h, 16.r, 16.r),
                child: widget.description != null
                    ? Text(
                        widget.description!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.condition != null) ...[
                            _sectionRow(
                              l10n.tiersConditionLabel,
                              widget.condition!,
                              Icons.rule_rounded,
                            ),
                            SizedBox(height: 12.h),
                          ],
                          if (widget.links != null) ...[
                            _sectionRow(
                              l10n.tiersLinksLabel,
                              widget.links!,
                              Icons.link_rounded,
                            ),
                            SizedBox(height: 12.h),
                          ],
                          if (widget.benefit != null)
                            _sectionRow(
                              l10n.tiersBenefitLabel,
                              widget.benefit!,
                              Icons.card_giftcard_rounded,
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.r, 14.h, 12.r, 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.r),
          topRight: Radius.circular(18.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30.r,
            height: 30.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.24),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.index}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (widget.isCurrent)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 12.r, color: widget.gradient.last),
                  SizedBox(width: 4.w),
                  Text(
                    l10n.tiersCurrentBadge,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: widget.gradient.last,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionRow(String label, String body, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: widget.gradient.last.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 16.r, color: widget.gradient.last),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHint,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                body,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.55,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
