import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_color.dart';
import '../../constants/app_routes.dart';
import '../../l10n/app_localizations.dart';
import '../../models/call_models.dart';
import '../../repository/call_repo.dart';
import '../../repository/wallet_repo.dart' as wallet;
import 'call_room_page.dart';
import 'call_ui.dart';

/// "Call her" — the confirmation before a per-minute call starts.
///
/// The app's version of the website's `/customer/call-model/:id`: the
/// price, what the wallet covers, and Voice / Video. Whether she can be
/// called at all comes from `GET calls/rate`, which is re-read every time
/// this screen comes back into view because "online" is perishable.
class CallConfirmPage extends StatefulWidget {
  final String modelId;
  final String modelName;
  final String? modelPhoto;

  const CallConfirmPage({
    super.key,
    required this.modelId,
    required this.modelName,
    this.modelPhoto,
  });

  @override
  State<CallConfirmPage> createState() => _CallConfirmPageState();
}

class _CallConfirmPageState extends State<CallConfirmPage>
    with WidgetsBindingObserver {
  final _repo = CallRepo();

  bool _loading = true;
  CallRate? _rate;
  int _available = 0;

  bool _starting = false;
  String? _error;

  bool _notifying = false;
  bool _notified = false;

  AppLocalizations get _l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load(quiet: true);
  }

  Future<void> _load({bool quiet = false}) async {
    if (!quiet) setState(() => _loading = true);
    final rateFuture = _repo.rate(widget.modelId);
    final walletFuture = wallet.PackageRepo().customerWallet();
    final rateRes = await rateFuture;
    final walletRes = await walletFuture;
    if (!mounted) return;
    setState(() {
      _rate = rateRes.data;
      _available = walletRes.data?.availableBalance ?? 0;
      _loading = false;
    });
  }

  Future<void> _place(String callType) async {
    if (_starting) return;
    setState(() {
      _starting = true;
      _error = null;
    });
    final res = await _repo.start(modelId: widget.modelId, callType: callType);
    if (!mounted) return;
    final join = res.data;
    if (join == null || join.token.isEmpty) {
      setState(() {
        _starting = false;
        _error = CallUi.errorText(_l10n, res.message);
      });
      // She went offline between loading and the tap: show the offline
      // state rather than leaving the call buttons up.
      if ((res.message ?? '').contains('not online')) _load(quiet: true);
      return;
    }
    setState(() => _starting = false);
    await Get.to(
      () => CallRoomPage(
        args: CallRoomArgs(
          join: join,
          isCustomer: true,
          peerName: widget.modelName,
          peerPhoto: widget.modelPhoto,
        ),
      ),
      fullscreenDialog: true,
      preventDuplicates: false,
    );
    // Back from the call: the wallet changed.
    if (mounted) _load(quiet: true);
  }

  Future<void> _letHerKnow() async {
    setState(() => _notifying = true);
    final res = await _repo.notify(widget.modelId);
    if (!mounted) return;
    final notice = res.data;
    setState(() {
      _notifying = false;
      _notified = notice != null && (notice.sent || notice.throttled);
      if (notice == null) _error = CallUi.errorText(_l10n, res.message);
    });
    // She came online in the meantime — show the call buttons.
    if (notice?.alreadyOnline == true) _load(quiet: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(_l10n.callName(widget.modelName),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _load(quiet: true),
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [_header(), SizedBox(height: 16.h), ..._body()],
              ),
            ),
    );
  }

  Widget _header() {
    final rate = _rate;
    final online = rate?.reachable == true;
    final photo = widget.modelPhoto;
    return Column(
      children: [
        SizedBox(height: 8.h),
        Stack(
          children: [
            CircleAvatar(
              radius: 44.r,
              backgroundColor: const Color(0xFFEDE7F6),
              backgroundImage: photo != null && photo.isNotEmpty
                  ? NetworkImage(photo)
                  : null,
            ),
            if (rate?.callable == true)
              Positioned(
                right: 4.r,
                bottom: 4.r,
                child: Container(
                  width: 16.r,
                  height: 16.r,
                  decoration: BoxDecoration(
                    color: online
                        ? const Color(0xFF22C55E)
                        : const Color(0xFF9CA3AF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(widget.modelName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
      ],
    );
  }

  List<Widget> _body() {
    final rate = _rate;
    if (rate == null || !rate.callable) {
      return [_card(child: _message(Icons.phone_disabled, _l10n.callNotAvailable))];
    }
    if (!rate.reachable) return _offline();

    final perMinute = rate.ratePerMinute;
    final minutes = perMinute > 0 ? _available ~/ perMinute : 0;
    final affordable = minutes >= 2;

    return [
      _card(
        child: Column(
          children: [
            _line(_l10n.callPerMinute, CallUi.kip(perMinute), bold: true),
            Divider(height: 20.h),
            _line(_l10n.callYourBalance, CallUi.kip(_available)),
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                affordable
                    ? _l10n.callCoversMinutes(minutes.clamp(0, 60).toString())
                    : _l10n.callNeedTwoMinutes(
                        CallUi.kip(perMinute * 2).replaceAll(' ₭', '')),
                style: TextStyle(
                  fontSize: 13.sp,
                  color: affordable
                      ? AppColors.textSecondary
                      : const Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16.h),
      if (_error != null) ...[
        _errorBox(_error!),
        SizedBox(height: 12.h),
      ],
      if (affordable)
        Row(
          children: [
            Expanded(
              child: _bigButton(
                icon: Icons.call,
                label: _l10n.callVoice,
                onTap: _starting ? null : () => _place('audio'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _bigButton(
                icon: Icons.videocam,
                label: _l10n.callVideo,
                onTap: _starting ? null : () => _place('video'),
              ),
            ),
          ],
        )
      else
        _bigButton(
          icon: Icons.account_balance_wallet,
          label: _l10n.callTopUp,
          onTap: () async {
            await Get.toNamed(
              AppRoutes.topupAmount,
              arguments: {
                'initialAmount':
                    (perMinute * 10 - _available).clamp(0, 1 << 31),
              },
            );
            if (mounted) _load(quiet: true);
          },
        ),
      if (_starting) ...[
        SizedBox(height: 16.h),
        const Center(child: CircularProgressIndicator()),
      ],
      SizedBox(height: 16.h),
      Text(
        _l10n.callBillingNote,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
      ),
    ];
  }

  List<Widget> _offline() => [
        _card(
          child: Column(
            children: [
              Icon(Icons.nightlight_round,
                  size: 32.r, color: AppColors.textHint),
              SizedBox(height: 10.h),
              Text(
                _l10n.callOfflineTitle(widget.modelName),
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 6.h),
              Text(
                _notified
                    ? _l10n.callOfflineNotified(widget.modelName)
                    : _l10n.callOfflineBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (_error != null) ...[_errorBox(_error!), SizedBox(height: 12.h)],
        _bigButton(
          icon: _notified ? Icons.check : Icons.notifications_active,
          label: _notified ? _l10n.callNoticeSent : _l10n.callNotifyHer,
          onTap: _notified || _notifying ? null : _letHerKnow,
        ),
      ];

  Widget _card({required Widget child}) => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: child,
      );

  Widget _line(String label, String value, {bool bold = false}) => Row(
        children: [
          Text(label,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textHint)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                fontSize: bold ? 18.sp : 15.sp,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
                color: AppColors.textPrimary,
              )),
        ],
      );

  Widget _message(IconData icon, String text) => Column(
        children: [
          Icon(icon, size: 32.r, color: AppColors.textHint),
          SizedBox(height: 10.h),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
        ],
      );

  Widget _errorBox(String text) => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(text,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFFB91C1C))),
      );

  Widget _bigButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
  }) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(colors: AppColors.pinkGradient)
              : null,
          color: enabled ? null : const Color(0xFFE5E5EF),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: enabled ? Colors.white : AppColors.textHint, size: 20.r),
            SizedBox(width: 8.w),
            Text(label,
                style: TextStyle(
                  color: enabled ? Colors.white : AppColors.textHint,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                )),
          ],
        ),
      ),
    );
  }
}
