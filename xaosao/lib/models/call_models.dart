// Per-minute calling — the shapes xs_backend's CallsController returns.
//
// Every money figure is decided by the backend; the app only displays
// them. See xs_backend `src/docs/calls/calls.docs.ts` for the contract.

int _int(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

String? _str(dynamic v) => v?.toString();

/// `GET calls/rate/:modelId` — can she be called, and for how much.
class CallRate {
  /// She sells an active per-minute service with a rate above 0.
  final bool callable;

  /// She holds an open socket right now, so a ring can land.
  final bool reachable;
  final int ratePerMinute;
  final String? modelServiceId;

  const CallRate({
    required this.callable,
    required this.reachable,
    required this.ratePerMinute,
    this.modelServiceId,
  });

  factory CallRate.fromJson(Map<String, dynamic> json) => CallRate(
        callable: json['callable'] == true,
        reachable: json['reachable'] == true,
        ratePerMinute: _int(json['rate_per_minute']),
        modelServiceId: _str(json['model_service_id']),
      );
}

/// `POST calls/notify/:modelId` — asking an offline model to come online.
class CallNotice {
  final bool sent;
  final bool throttled;
  final bool alreadyOnline;

  const CallNotice({
    required this.sent,
    required this.throttled,
    required this.alreadyOnline,
  });

  factory CallNotice.fromJson(Map<String, dynamic> json) => CallNotice(
        sent: json['sent'] == true,
        throttled: json['throttled'] == true,
        alreadyOnline: json['already_online'] == true,
      );
}

/// What either side needs to join the LiveKit room. Returned by
/// `POST calls` (customer), `POST calls/:id/answer` (model) and
/// `GET calls/:id/token` (reconnect).
class CallJoin {
  final String sessionId;
  final String serverUrl;
  final String token;
  final String callType; // audio | video
  final int ratePerMinute;
  final int maxMinutes;

  const CallJoin({
    required this.sessionId,
    required this.serverUrl,
    required this.token,
    required this.callType,
    required this.ratePerMinute,
    required this.maxMinutes,
  });

  bool get isVideo => callType == 'video';

  factory CallJoin.fromJson(
    Map<String, dynamic> json, {
    String fallbackType = 'audio',
  }) =>
      CallJoin(
        sessionId: _str(json['session_id']) ?? '',
        serverUrl: _str(json['server_url']) ?? '',
        token: _str(json['token']) ?? '',
        callType: _str(json['call_type']) ?? fallbackType,
        ratePerMinute: _int(json['rate_per_minute']),
        maxMinutes: _int(json['max_minutes']),
      );
}

/// `GET calls/:id` — live state; also carries the settlement once ended.
class CallState {
  final String sessionId;
  final String status; // ringing | connecting | active | ended
  final String? reason;
  final String callType;
  final int ratePerMinute;
  final int elapsedSeconds;
  final int remainingSeconds;
  final int spentSoFar;
  final int billedMinutes;
  final int billedAmount;
  final int refunded;
  final int commissionRate;

  const CallState({
    required this.sessionId,
    required this.status,
    this.reason,
    required this.callType,
    required this.ratePerMinute,
    required this.elapsedSeconds,
    required this.remainingSeconds,
    required this.spentSoFar,
    required this.billedMinutes,
    required this.billedAmount,
    required this.refunded,
    required this.commissionRate,
  });

  bool get isEnded => status == 'ended';

  factory CallState.fromJson(Map<String, dynamic> json) => CallState(
        sessionId: _str(json['session_id']) ?? '',
        status: _str(json['status']) ?? 'ringing',
        reason: _str(json['reason']),
        callType: _str(json['call_type']) ?? 'audio',
        ratePerMinute: _int(json['rate_per_minute']),
        elapsedSeconds: _int(json['elapsed_seconds']),
        remainingSeconds: _int(json['remaining_seconds']),
        spentSoFar: _int(json['spent_so_far']),
        billedMinutes: _int(json['billed_minutes']),
        billedAmount: _int(json['billed_amount']),
        refunded: _int(json['refunded']),
        commissionRate: _int(json['commission_rate']),
      );
}

/// How a call finished — from `POST calls/:id/hangup`, the `call_ended`
/// socket event, or a final `GET calls/:id`.
class CallSummary {
  final String? reason;
  final int billedMinutes;
  final int billedAmount;
  final int modelEarning;
  final int refunded;

  const CallSummary({
    this.reason,
    required this.billedMinutes,
    required this.billedAmount,
    required this.modelEarning,
    required this.refunded,
  });

  factory CallSummary.fromJson(Map<String, dynamic> json) => CallSummary(
        reason: _str(json['reason']),
        billedMinutes: _int(json['billed_minutes']),
        billedAmount: _int(json['billed_amount']),
        modelEarning: _int(json['model_earning']),
        refunded: _int(json['refunded']),
      );

  factory CallSummary.fromState(CallState s) => CallSummary(
        reason: s.reason,
        billedMinutes: s.billedMinutes,
        billedAmount: s.billedAmount,
        modelEarning: s.billedAmount -
            (s.billedAmount * s.commissionRate / 100).round(),
        refunded: s.refunded,
      );
}

/// The ring a model receives — the `incoming_call` socket event or the
/// push with the same payload. Push data values arrive as strings.
class IncomingCall {
  final String sessionId;
  final String callType;
  final String callerName;
  final String? callerId;
  final int ratePerMinute;
  final int expiresIn;

  const IncomingCall({
    required this.sessionId,
    required this.callType,
    required this.callerName,
    this.callerId,
    required this.ratePerMinute,
    required this.expiresIn,
  });

  bool get isVideo => callType == 'video';

  static IncomingCall? tryParse(dynamic data) {
    if (data is! Map) return null;
    final id = _str(data['session_id']);
    if (id == null || id.isEmpty) return null;
    final expires = _int(data['expires_in']);
    return IncomingCall(
      sessionId: id,
      callType: _str(data['call_type']) ?? 'audio',
      callerName: _str(data['caller_name']) ?? '',
      callerId: _str(data['caller_id']),
      ratePerMinute: _int(data['rate_per_minute']),
      expiresIn: expires > 0 ? expires : 45,
    );
  }
}
