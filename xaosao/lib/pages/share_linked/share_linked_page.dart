import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_icons.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/comission_model.dart';
import 'package:xaosao/models/profile_model.dart';
import 'package:xaosao/models/referral_mdoel.dart';
import 'package:xaosao/pages/referral_analytics/getx/referral_analytics_logic.dart';
import 'package:xaosao/pages/referral_analytics/getx/referral_analytics_state.dart';
import 'package:xaosao/pages/share_linked/components/share_qr_dialog.dart';
import 'package:xaosao/pages/share_linked/getx/commissions_logic.dart';
import 'package:xaosao/pages/share_linked/getx/commissions_state.dart';
import 'package:xaosao/utils/app_snackbar.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/utils/share_utils.dart';
import 'package:xaosao/widgets/app_svg_icon.dart';
import 'package:xaosao/widgets/gradient_app_bar.dart';

// ═══════════════════════════════════════════════════════════════
//  ShareLinkedPage — tier-aware referral hub
//
//  Layout (top → bottom):
//    1. Hero card       — avatar, name, tier badge, current earnings
//    2. Progress card   — animated bar toward next tier
//    3. Link section    — 1 card (Tier 1) or tabbed 2-card switcher
//    4. Stats grid      — 4 counters, animated 0 → target
//    5. Commissions     — paginated list from referralCommissions()
//    6. Learn more btn  — opens ReferralTiersPage
//
//  Data comes from ReferralAnalyticsLogic (getReferral) +
//  CommissionsLogic (referralCommissions). Both are put here so the
//  page owns its lifecycle without extra binding wiring.
// ═══════════════════════════════════════════════════════════════

enum _ShareTier { general, special, partner }

_ShareTier _tierFromWire(String? raw) {
  switch (raw) {
    case 'special':
      return _ShareTier.special;
    case 'partner':
      return _ShareTier.partner;
    default:
      return _ShareTier.general;
  }
}

List<Color> _tierGradient(_ShareTier tier) {
  switch (tier) {
    case _ShareTier.general:
      return const [Color(0xFF64748B), Color(0xFF334155)];
    case _ShareTier.special:
      return AppColors.pinkGradient;
    case _ShareTier.partner:
      return const [Color(0xFFFFB300), Color(0xFFE65100)];
  }
}

String _tierLabel(AppLocalizations l10n, _ShareTier tier) {
  switch (tier) {
    case _ShareTier.general:
      return l10n.shareTierGeneral;
    case _ShareTier.special:
      return l10n.shareTierSpecial;
    case _ShareTier.partner:
      return l10n.shareTierPartner;
  }
}

class ShareLinkedPage extends StatefulWidget {
  final ModelProfileModel model;
  const ShareLinkedPage({super.key, required this.model});

  @override
  State<ShareLinkedPage> createState() => _ShareLinkedPageState();
}

class _ShareLinkedPageState extends State<ShareLinkedPage> {
  late final ReferralAnalyticsLogic _referralLogic;
  late final CommissionsLogic _commissionsLogic;
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    // Reuse if already registered (analytics page also uses it), otherwise
    // create a fresh instance. `fenix: true` in InitialBinding keeps it alive.
    _referralLogic = Get.isRegistered<ReferralAnalyticsLogic>()
        ? Get.find<ReferralAnalyticsLogic>()
        : Get.put(ReferralAnalyticsLogic());
    _referralLogic.fetch();

    _commissionsLogic = Get.isRegistered<CommissionsLogic>()
        ? Get.find<CommissionsLogic>()
        : Get.put(CommissionsLogic());

    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
      _commissionsLogic.loadMore();
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.wait([_referralLogic.fetch(), _commissionsLogic.refresh()]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: GradientAppBar(
        title: l10n.shareTitle,
        subtitle: l10n.shareAppbarSubtitle,
        actions: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.referralAnalytics),
            child: Container(
              width: 34.r,
              height: 34.r,
              margin: EdgeInsets.only(right: 6.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.bar_chart_rounded,
                size: 18.r,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final rst = _referralLogic.state;
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 40.h),
            child: _buildBody(l10n, rst),
          ),
        );
      }),
    );
  }

  Widget _buildBody(AppLocalizations l10n, ReferralAnalyticsState rst) {
    // While the first getReferral() is loading, show a minimal skeleton hero
    // so users don't stare at a blank screen. Fallback profile fields cover
    // the split-second before data arrives.
    if (rst.status == ReferralStatus.loading && rst.data == null) {
      return _LoadingSkeleton(name: widget.model.fullName);
    }

    final data = rst.data;
    final tier = _tierFromWire(data?.modelType);
    // Customer link unlocks once the user has referred 5+ models. Below the
    // threshold we only show the model link — the customer tab isn't rendered
    // and the URL is built locally from AppsFlyer OneLink (the API's
    // `customerReferralLink` field is ignored on purpose).
    const customerUnlockAt = 5;
    final referredModels = data?.stats?.totalReferredModels ?? 0;
    final hasCustomerCode = data?.customerReferralCode?.isNotEmpty ?? false;
    final showCustomerTab =
        hasCustomerCode && referredModels >= customerUnlockAt;

    return Column(
      children: [
        _TierHero(tier: tier, stats: data?.stats),
        SizedBox(height: 14.h),
        if (data?.upgradeProgress != null)
          _ProgressCard(progress: data!.upgradeProgress!, tier: tier),
        if (data?.upgradeProgress != null) SizedBox(height: 14.h),
        _LinkSection(
          model: data,
          fallbackModelCode: widget.model.referralCode ?? '',
          modelName: data?.modelName ?? widget.model.fullName,
          profileUrl: data?.modelProfile ?? widget.model.profile,
          showCustomerTab: showCustomerTab,
        ),
        SizedBox(height: 14.h),
        _StatsGrid(stats: data?.stats),
        SizedBox(height: 20.h),
        _LearnMoreButton(onTap: () => Get.toNamed(AppRoutes.referralTiers)),
        SizedBox(height: 20.h),
        _CommissionsSection(logic: _commissionsLogic),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Loading skeleton (first paint only)
// ═══════════════════════════════════════════════════════════════
class _LoadingSkeleton extends StatelessWidget {
  final String name;
  const _LoadingSkeleton({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          height: 220.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  _TierHero
//  Flat, card-less hero. Just a 🎁 emoji next to a text column
//  (tier label + earnings). The only colour cue is the small tier
//  accent used on the label and thin separator — everything else
//  is neutral typography for a clean, calm look.
// ═══════════════════════════════════════════════════════════════
class _TierHero extends StatelessWidget {
  final _ShareTier tier;
  final Stats? stats;
  const _TierHero({required this.tier, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _tierGradient(tier).last;
    final total = stats?.totalEarnings ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🎁 emoji — explicit color-emoji fallbacks so it renders in
        // native colours instead of inheriting a text tint.
        Text(
          '\u{1F381}',
          style: TextStyle(
            fontSize: 44.sp,
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
        SizedBox(width: 14.w),

        // Text column ────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tier label
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    size: 13.r,
                    color: accent,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    l10n.shareTierBadge(_tierLabel(l10n, tier)),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),

              // Total earnings
              Text(
                '${CurrFormatter.format(total)} ${l10n.commonCurrencyKip}',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 4.h),

              // Tagline
              Text(
                tier == _ShareTier.general
                    ? l10n.shareSubtitleGeneral
                    : l10n.shareSubtitleCommission,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Progress-to-next-tier card
// ═══════════════════════════════════════════════════════════════
class _ProgressCard extends StatelessWidget {
  final UpgradeProgress progress;
  final _ShareTier tier;
  const _ProgressCard({required this.progress, required this.tier});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Decide message + fraction based on current tier.
    String message;
    double fraction;
    switch (tier) {
      case _ShareTier.general:
        final remaining = progress.modelsUntilSpecial ?? 0;
        message = remaining > 0
            ? l10n.shareUpgradeToSpecialRemaining(remaining)
            : l10n.shareTierMaxed;
        fraction = ((progress.specialProgress ?? 0) / 100).clamp(0.0, 1.0);
        break;
      case _ShareTier.special:
        final rmodels = progress.modelsUntilPartner ?? 0;
        final rEarnings = progress.earningsUntilPartner ?? 0;
        if (rmodels > 0) {
          message = l10n.shareUpgradeToPartnerRemainingModels(rmodels);
        } else if (rEarnings > 0) {
          message = l10n.shareUpgradeToPartnerRemainingEarnings(
            CurrFormatter.format(rEarnings),
          );
        } else {
          message = l10n.shareTierMaxed;
        }
        final modelPct = (progress.partnerModelProgress ?? 0) / 100;
        final earnPct = (progress.partnerEarningsProgress ?? 0) / 100;
        // Show the lower of the two — the more limiting condition.
        fraction = (modelPct < earnPct ? modelPct : earnPct).clamp(0.0, 1.0);
        break;
      case _ShareTier.partner:
        message = l10n.shareTierMaxed;
        fraction = 1.0;
        break;
    }

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  Icons.trending_up_rounded,
                  size: 16.r,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  l10n.shareProgressToNext,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${(fraction * 100).round()}%',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: fraction),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, __) => ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: LinearProgressIndicator(
                value: v,
                minHeight: 8.h,
                backgroundColor: AppColors.bg,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textHint,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Link section (1 card for Tier 1 · tabbed 2 for Tier 2/3)
// ═══════════════════════════════════════════════════════════════
class _LinkSection extends StatefulWidget {
  final ReferralModel? model;
  final String fallbackModelCode;
  final String modelName;
  final String? profileUrl;
  final bool showCustomerTab;

  const _LinkSection({
    required this.model,
    required this.fallbackModelCode,
    required this.modelName,
    required this.profileUrl,
    required this.showCustomerTab,
  });

  @override
  State<_LinkSection> createState() => _LinkSectionState();
}

class _LinkSectionState extends State<_LinkSection> {
  int _selectedTab = 0; // 0 = model, 1 = customer

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Share/copy/QR always use an AppsFlyer OneLink built locally from the
    // referral *code*. The API's `referralLink` / `customerReferralLink`
    // fields are intentionally ignored so the URL scheme stays under our
    // control (and OneLink's `?code=` routing keeps opening the app).
    final modelCode = widget.model?.referralCode ?? widget.fallbackModelCode;
    final modelLink = ShareUtils.buildModelReferralLink(modelCode);

    final customerCode = widget.model?.customerReferralCode ?? '';

    if (!widget.showCustomerTab) {
      return _LinkCard(
        title: l10n.shareTabModel,
        description: l10n.shareLinkModelDesc,
        link: modelLink,
        modelName: widget.modelName,
        profileUrl: widget.profileUrl,
        accent: AppColors.pinkGradient,
      );
    }

    return Column(
      children: [
        _TabsSwitcher(
          items: [l10n.shareTabModel, l10n.shareTabCustomer],
          index: _selectedTab,
          onTap: (i) => setState(() => _selectedTab = i),
        ),
        SizedBox(height: 12.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: _selectedTab == 0
              ? _LinkCard(
                  key: const ValueKey('model'),
                  title: l10n.shareTabModel,
                  description: l10n.shareLinkModelDesc,
                  link: modelLink,
                  modelName: widget.modelName,
                  profileUrl: widget.profileUrl,
                  accent: AppColors.pinkGradient,
                )
              : _LinkCard(
                  key: const ValueKey('customer'),
                  title: l10n.shareTabCustomer,
                  description: l10n.shareLinkCustomerDesc,
                  link: ShareUtils.buildCustomerReferralLink(customerCode),
                  modelName: widget.modelName,
                  profileUrl: widget.profileUrl,
                  accent: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                ),
        ),
      ],
    );
  }
}

class _TabsSwitcher extends StatelessWidget {
  final List<String> items;
  final int index;
  final ValueChanged<int> onTap;
  const _TabsSwitcher({
    required this.items,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.6,
        ),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: active
                      ? const LinearGradient(colors: AppColors.pinkGradient)
                      : null,
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Center(
                  child: Text(
                    items[i],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: active ? Colors.white : AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final String modelName;
  final String? profileUrl;
  final List<Color> accent;
  const _LinkCard({
    super.key,
    required this.title,
    required this.description,
    required this.link,
    required this.modelName,
    required this.profileUrl,
    required this.accent,
  });

  Future<void> _copy(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await ShareUtils.copyToClipboard(link);
    AppSnackbar.success(l10n.shareCopied);
  }

  Future<void> _share(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await ShareUtils.shareLink(
      link: link,
      message: l10n.shareInviteMessage,
      subject: l10n.shareInviteSubject,
    );
  }

  void _qr(BuildContext context) {
    ShareQrDialog.show(
      context,
      modelName: modelName,
      profileUrl: profileUrl,
      link: link,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.last.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: accent,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(
                  Icons.link_rounded,
                  size: 16.r,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.04),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    link,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                _IconBtn(
                  icon: Icons.copy_rounded,
                  onTap: () => _copy(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  icon: Icons.share_rounded,
                  label: AppLocalizations.of(context)!.shareShareLink,
                  gradient: accent,
                  onTap: () => _share(context),
                ),
              ),
              SizedBox(width: 8.w),
              ActionBtnOutlined(
                icon: Icons.qr_code_rounded,
                onTap: () => _qr(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Small icon-only secondary action (e.g. copy button inside the URL row).
// Uses a neutral slate palette on purpose — this button should never
// compete visually with the primary "Share Link" CTA below it.
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9), // slate-100
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 16.r, color: const Color(0xFF475569)),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.22),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15.r, color: Colors.white),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Compact secondary action (e.g. QR icon next to "Share Link").
// Neutral slate palette so the primary gradient CTA stays the only
// coloured element in the CTA row.
class ActionBtnOutlined extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  const ActionBtnOutlined({
    super.key,
    required this.icon,
    this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF1F5F9); // slate-100
    const fg = Color(0xFF475569); // slate-600
    const border = Color(0xFFE2E8F0); // slate-200
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: border, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.r, color: fg),
            if (label != null) ...[
              SizedBox(width: 6.w),
              Text(
                label!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Stats grid — 4 counters (animated 0 → value)
// ═══════════════════════════════════════════════════════════════
class _StatsGrid extends StatelessWidget {
  final Stats? stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = stats;
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            iconAsset: AppIcons.user,
            label: l10n.shareStatsModels,
            value: (s?.totalReferredModels ?? 0).toDouble(),
            valueBuilder: (v) => v.round().toString(),
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatTile(
            iconAsset: AppIcons.userGroup,
            label: l10n.shareStatsCustomers,
            value: (s?.totalReferredCustomers ?? 0).toDouble(),
            valueBuilder: (v) => v.round().toString(),
            color: const Color(0xFF3B82F6),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _StatTile(
            // No dedicated "money" asset in AppIcons — wallet is the
            // closest match and is already used elsewhere for finance.
            iconAsset: AppIcons.wallet,
            label: l10n.shareStatsCommission,
            value: (s?.totalCommissionEarnings ?? 0).toDouble(),
            valueBuilder: (v) => CurrFormatter.format(v.round()),
            color: const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String iconAsset;
  final String label;
  final double value;
  final String Function(double) valueBuilder;
  final Color color;
  const _StatTile({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.valueBuilder,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26.r,
            height: 26.r,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AppSvgIcon(
              assetName: iconAsset,
              width: 14.r,
              height: 14.r,
              color: color,
            ),
          ),
          SizedBox(height: 10.h),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (_, v, _) => Text(
              valueBuilder(v),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Learn more button
// ═══════════════════════════════════════════════════════════════
class _LearnMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LearnMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9.r),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                size: 16.r,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                l10n.shareLearnMore,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.r,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Commissions section
// ═══════════════════════════════════════════════════════════════
class _CommissionsSection extends StatelessWidget {
  final CommissionsLogic logic;
  const _CommissionsSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: 16.r,
              color: AppColors.textPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              l10n.shareCommissionsTitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Obx(() {
          final st = logic.state;
          if (st.status == CommissionsStatus.loading && st.items.isEmpty) {
            return const _CommissionsShimmer();
          }
          if (st.items.isEmpty) {
            return _CommissionsEmpty(
              title: l10n.shareCommissionsEmpty,
              subtitle: l10n.shareCommissionsEmptySub,
            );
          }
          return Column(
            children: [
              ...List.generate(st.items.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _CommissionRow(item: st.items[i], index: i),
                );
              }),
              if (st.loadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _CommissionRow extends StatefulWidget {
  final ComissionModel item;
  final int index;
  const _CommissionRow({required this.item, required this.index});

  @override
  State<_CommissionRow> createState() => _CommissionRowState();
}

class _CommissionRowState extends State<_CommissionRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    // Stagger only first-page rows; anything past index 15 renders straight.
    if (widget.index < 15) {
      Future.delayed(Duration(milliseconds: widget.index * 40), () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.value = 1;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = widget.item;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.05),
              width: 0.6,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                padding: EdgeInsets.all(9.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: AppSvgIcon(
                  assetName: AppIcons.wallet,
                  width: 16.r,
                  height: 16.r,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.shareCommissionReferral,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _formatDate(item.createdAt),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${CurrFormatter.format(item.amount ?? 0)} ${l10n.commonCurrencyKip}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _StatusChip(status: item.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      final d = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy · HH:mm').format(d);
    } catch (_) {
      return raw;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    late String label;
    late Color fg;
    late Color bg;
    switch ((status ?? '').toLowerCase()) {
      case 'completed':
      case 'approved':
      case 'released':
        label = l10n.walletTxStatusCompleted;
        fg = const Color(0xFF15803D);
        bg = const Color(0xFFEDFAF3);
        break;
      case 'pending':
      case 'pending_release':
        label = l10n.walletTxStatusPending;
        fg = const Color(0xFF92400E);
        bg = const Color(0xFFFFFBEB);
        break;
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        label = l10n.walletTxStatusCancelled;
        fg = const Color(0xFFDC2626);
        bg = const Color(0xFFFEF2F2);
        break;
      default:
        label = status ?? '—';
        fg = AppColors.textHint;
        bg = AppColors.bg;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

class _CommissionsShimmer extends StatelessWidget {
  const _CommissionsShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (_) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Container(
            height: 62.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
        );
      }),
    );
  }
}

class _CommissionsEmpty extends StatelessWidget {
  final String title;
  final String subtitle;
  const _CommissionsEmpty({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 0.6,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 24.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textHint,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
