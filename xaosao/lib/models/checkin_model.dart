/// Daily check-in, as xs_backend reports it.
///
/// Every rule — which weekdays pay, how much, whether today is still
/// open, whether this model already took it — is decided by the server.
/// Nothing here judges anything; these classes only carry the answer.
///
/// See `GET /rewards/checkin` in xs_backend's rewards module.
library;

/// Where one day of the week stands.
enum CheckinDayStatus {
  /// Taken already.
  claimed,

  /// Today, still open.
  today,

  /// Gone — the day passed without a check-in.
  missed,

  /// Still to come this week.
  upcoming,
}

CheckinDayStatus _statusFrom(String? raw) {
  switch (raw) {
    case 'claimed':
      return CheckinDayStatus.claimed;
    case 'today':
      return CheckinDayStatus.today;
    case 'missed':
      return CheckinDayStatus.missed;
    default:
      return CheckinDayStatus.upcoming;
  }
}

/// One cell of the week strip.
class CheckinDay {
  /// 1 = Monday … 7 = Sunday, matching the server's ISO weekday.
  final int weekday;

  /// The Lao calendar date this cell stands for, "YYYY-MM-DD".
  final String date;

  /// Kip this day pays. 0 when the weekday is switched off.
  final int amount;

  final CheckinDayStatus status;

  /// True once this weekday's cap is used up (today's cell only).
  final bool soldOut;

  const CheckinDay({
    required this.weekday,
    required this.date,
    required this.amount,
    required this.status,
    required this.soldOut,
  });

  factory CheckinDay.fromJson(Map<String, dynamic> json) => CheckinDay(
    weekday: (json['weekday'] as num?)?.toInt() ?? 0,
    date: json['date']?.toString() ?? '',
    amount: (json['amount'] as num?)?.toInt() ?? 0,
    status: _statusFrom(json['status']?.toString()),
    soldOut: json['soldOut'] == true,
  );
}

/// The whole card: the week, the streak, and what today is worth.
class CheckinInfo {
  final List<CheckinDay> days;

  /// Consecutive days up to and including today, if today is taken.
  final int streak;

  /// What checking in today pays. 0 when the weekday is switched off.
  final int todayAmount;

  final bool canClaim;
  final bool alreadyClaimed;

  /// Today's payouts are all gone — not the same as "already claimed".
  final bool capReached;

  /// Next Lao midnight, epoch milliseconds, for the countdown.
  ///
  /// The server sends this as a number on purpose: its response
  /// interceptor rewrites every Date into "dd-MM-yyyy HH:mm:ss", which
  /// `DateTime.parse` reads as a US month-first date, or not at all.
  final int nextAtMs;

  /// Anything the server wants said out loud, or null.
  final String? message;

  const CheckinInfo({
    required this.days,
    required this.streak,
    required this.todayAmount,
    required this.canClaim,
    required this.alreadyClaimed,
    required this.capReached,
    required this.nextAtMs,
    this.message,
  });

  /// Nothing configured: the card should not be drawn at all rather
  /// than promise a reward that does not exist.
  bool get isEmpty => days.isEmpty;

  factory CheckinInfo.fromJson(Map<String, dynamic> json) => CheckinInfo(
    days: (json['days'] as List?)
            ?.map((d) => CheckinDay.fromJson(d as Map<String, dynamic>))
            .toList() ??
        const [],
    streak: (json['streak'] as num?)?.toInt() ?? 0,
    todayAmount: (json['today_amount'] as num?)?.toInt() ?? 0,
    canClaim: json['can_claim'] == true,
    alreadyClaimed: json['already_claimed'] == true,
    capReached: json['cap_reached'] == true,
    nextAtMs: (json['next_at_ms'] as num?)?.toInt() ?? 0,
    message: json['message']?.toString(),
  );
}

/// What a successful claim paid.
class CheckinClaim {
  final int amount;
  final int streak;
  final int newBalance;

  const CheckinClaim({
    required this.amount,
    required this.streak,
    required this.newBalance,
  });

  factory CheckinClaim.fromJson(Map<String, dynamic> json) => CheckinClaim(
    amount: (json['amount'] as num?)?.toInt() ?? 0,
    streak: (json['streak'] as num?)?.toInt() ?? 0,
    newBalance: (json['newBalance'] as num?)?.toInt() ?? 0,
  );
}
