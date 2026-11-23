import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';
import 'package:xaosao/constants/app_routes.dart';
import 'package:xaosao/l10n/app_localizations.dart';
import 'package:xaosao/models/assistant_model.dart';
import 'package:xaosao/pages/assistant/getx/assistant_logic.dart';
import 'package:xaosao/utils/currency_formatter.dart';
import 'package:xaosao/widgets/app_network_image.dart';

/// "ຖາມແອັດມີນ" — describe who you are looking for, in your own words.
///
/// The customer types a sentence; the server turns it into filters,
/// searches the catalogue and sends back a short reply plus up to eight
/// people. An admin can also drop a hand-picked suggestion into the
/// same thread, which arrives looking like any other answer — the
/// customer does not need to care which side chose it.
///
/// Mirrors xaosao-client's `AssistantSheet`, down to the copy, so the
/// app and the website behave the same way.
class AssistantSheet extends StatefulWidget {
  const AssistantSheet({super.key});

  /// Opens the sheet over whatever is on screen.
  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AssistantSheet(),
    );
  }

  @override
  State<AssistantSheet> createState() => _AssistantSheetState();
}

class _AssistantSheetState extends State<AssistantSheet> {
  late final AssistantLogic _logic;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _logic = Get.put(AssistantLogic());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    Get.delete<AssistantLogic>();
    super.dispose();
  }

  /// Keep the newest turn in view as the thread grows.
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    _input.clear();
    _logic.send(text);
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // The greeting has to come from the widget tree, so it is
    // translated; the logic itself holds no copy.
    if (!_started) {
      _started = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _logic.start(l10n.assistantGreeting),
      );
    }

    return Padding(
      // Lift the composer clear of the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            _handle(),
            _header(l10n),
            Expanded(
              child: Obx(() {
                final state = _logic.state;
                _scrollToEnd();
                return ListView(
                  controller: _scroll,
                  padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
                  children: [
                    for (final turn in state.turns) _turn(turn, l10n),
                    if (state.isFresh && !state.asking) _suggestions(l10n),
                    if (state.asking) _thinking(l10n),
                    if (state.error != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          state.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.red.shade600,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
            _composer(l10n),
          ],
        ),
      ),
    );
  }

  Widget _handle() => Container(
    width: 38.w,
    height: 4.h,
    margin: EdgeInsets.only(top: 9.h, bottom: 3.h),
    decoration: BoxDecoration(
      color: const Color(0xFFE5E7EB),
      borderRadius: BorderRadius.circular(2.r),
    ),
  );

  Widget _header(AppLocalizations l10n) => Container(
    padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 10.h),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5))),
    ),
    child: Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.support_agent_rounded,
            size: 18.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.assistantTitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                l10n.assistantHint,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close_rounded, size: 20.sp),
          color: AppColors.textSecondary,
        ),
      ],
    ),
  );

  // ── One turn, and whoever it found ────────────────────────────
  Widget _turn(AssistantTurn turn, AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment:
                turn.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.74,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: turn.isUser
                    ? AppColors.primary
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                turn.text,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.35,
                  color: turn.isUser ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          if (turn.matches.isNotEmpty) ...[
            SizedBox(height: 9.h),
            // Two to a row, as on the website — but a Wrap rather than
            // a GridView, because every card here is a different
            // height: some people have a price and a rating, some have
            // neither. A grid has to be told one height for all of
            // them, which either clips the tallest or leaves a dead
            // gap under the shortest. Wrap lets each card be as tall as
            // what it actually has to say.
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 8.w) / 2;
                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: turn.matches
                      .map(
                        (m) => SizedBox(
                          width: cardWidth,
                          child: _MatchCard(match: m, l10n: l10n),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _suggestions(AppLocalizations l10n) {
    final asks = [
      l10n.assistantQ1,
      l10n.assistantQ2,
      l10n.assistantQ3,
      l10n.assistantQ4,
    ];
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.assistantTryAsking,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 7.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: asks
                .map(
                  (ask) => InkWell(
                    onTap: () => _send(ask),
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        ask,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _thinking(AppLocalizations l10n) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 11.sp,
            height: 11.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            l10n.assistantThinking,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _composer(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 9.h, 12.w, 12.h),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF1F1F5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _input,
              textInputAction: TextInputAction.send,
              onSubmitted: _send,
              // The endpoint rejects anything longer, so stop it here
              // rather than letting the request fail.
              maxLength: 500,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                counterText: '',
                hintText: l10n.assistantPlaceholder,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F8FC),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Obx(
            () => GestureDetector(
              onTap: _logic.state.asking ? null : () => _send(_input.text),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: _logic.state.asking
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  size: 17.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One suggested person. Tapping opens their profile, which is where
/// booking, chatting and calling already live.
class _MatchCard extends StatelessWidget {
  final AssistantMatch match;
  final AppLocalizations l10n;

  const _MatchCard({required this.match, required this.l10n});

  String get _distance {
    final km = match.distanceKm;
    if (km == null) return '';
    return km < 1 ? '${(km * 1000).round()} m' : '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Get.toNamed(AppRoutes.companionProfile, arguments: match.id);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 92.h,
              width: double.infinity,
              child: (match.profile ?? '').isEmpty
                  ? Container(
                      color: const Color(0xFFF3F4F6),
                      child: Icon(
                        Icons.person_rounded,
                        size: 30.sp,
                        color: const Color(0xFFD1D5DB),
                      ),
                    )
                  : AppNetworkImage(
                      imageUrl: match.profile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 92.h,
                    ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 7.h, 8.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      if (match.age != null)
                        Text(
                          '${l10n.assistantAge} ${match.age}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      if (match.rating > 0) ...[
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.star_rounded,
                          size: 11.sp,
                          color: const Color(0xFFFBBF24),
                        ),
                        Text(
                          match.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Only shown when the server actually knows it: an
                  // absent distance beats a fabricated one.
                  if (_distance.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            _distance,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (match.fromPrice != null) ...[
                    SizedBox(height: 3.h),
                    Text(
                      '${CurrFormatter.format(match.fromPrice!)} ₭',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
