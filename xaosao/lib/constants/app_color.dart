import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevent instantiation
  static const Color primary = Color(0xFFF43F5E);
  static const Color secondary = Color(0xFFE11D48);
  // static const Color primary = Color(0xFF1A1A2E);

  /// Soft purple dark — gradient pair ຂອງ primary
  static const Color primaryVariant = Color(0xFF2E1A3A);

  // /// Hot pink — CTA, like icon, active states, badges
  // static const Color pink = Color(0xFFF06292);

  // /// Coral pink — gradient pair ຂອງ pink (buttons, shadows)
  // static const Color pinkLight = Color(0xFFFF8A80);

  // ──────────────────────────────────────────────────────────
  //  BACKGROUND
  // ──────────────────────────────────────────────────────────

  /// Page background — ໃຊ້ທົ່ວ app
  static const Color bg = Color(0xFFF8F8FC);

  /// Card / surface background
  static const Color surface = Color(0xFFFFFFFF);

  /// Input / secondary surface
  static const Color surfaceSecondary = Color(0xFFF8F8FC);

  // ──────────────────────────────────────────────────────────
  //  TEXT
  // ──────────────────────────────────────────────────────────

  /// Primary text — headings, names
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Secondary text — subtitles, meta
  static const Color textSecondary = Color(0xFF555570);

  /// Hint / disabled text
  static const Color textHint = Color(0xFF9B9BAD);

  /// Inactive nav / placeholder
  static const Color textDisabled = Color(0xFFBBBBCC);

  // ──────────────────────────────────────────────────────────
  //  BORDER / DIVIDER
  // ──────────────────────────────────────────────────────────

  /// Default card border
  static const Color border = Color(0xFFF8F8FC); // black 6%

  /// Stronger border / divider
  static const Color borderMedium = Color(0x1A000000); // black 10%

  // ──────────────────────────────────────────────────────────
  //  STATUS — online · vip · new · rating
  // ──────────────────────────────────────────────────────────

  /// Online green dot
  static const Color online = Color(0xFF22C55E);

  /// Online bg (badge)
  static const Color onlineBg = Color(0xFF4CAF50);

  /// VIP gold text
  static const Color vipGold = Color(0xFFF9C846);

  /// Rating star
  static const Color star = Color(0xFFFFB800);

  // ──────────────────────────────────────────────────────────
  //  SERVICE CHIP COLORS
  //  ໃຊ້ກັບ ServiceType: social · massage · travel
  // ──────────────────────────────────────────────────────────

  // Social (ເພື່ອນສັງຄົມ) — pink family
  static const Color socialFg = Color(0xFFF06292);
  static const Color socialBg = Color(0xFFFFF0F6);
  static const Color socialBd = Color(0x33F06292); // 20%

  // Massage (ນວດ) — blue family
  static const Color massageFg = Color(0xFF42A5F5);
  static const Color massageBg = Color(0xFFF0F7FF);
  static const Color massageBd = Color(0x3342A5F5);

  // Travel (ທ່ອງທ່ຽວ) — purple family
  static const Color travelFg = Color(0xFFAB47BC);
  static const Color travelBg = Color(0xFFF3F0FF);
  static const Color travelBd = Color(0x33AB47BC);

  // ──────────────────────────────────────────────────────────
  //  OVERLAY CHIP (on-photo chips — dark bg)
  //  ໃຊ້ໃນ card ທີ່ chip ຢູ່ເທິງຮູບ
  // ──────────────────────────────────────────────────────────

  // Social on-photo
  static const Color socialOverlayFg = Color(0xFFFFB3CB);
  static const Color socialOverlayBg = Color(0x38F06292); // 22%
  static const Color socialOverlayBd = Color(0x47F06292); // 28%

  // Massage on-photo
  static const Color massageOverlayFg = Color(0xFF90CAF9);
  static const Color massageOverlayBg = Color(0x3842A5F5);
  static const Color massageOverlayBd = Color(0x4742A5F5);

  // Travel on-photo
  static const Color travelOverlayFg = Color(0xFFCE93D8);
  static const Color travelOverlayBg = Color(0x38AB47BC);
  static const Color travelOverlayBd = Color(0x47AB47BC);

  // ──────────────────────────────────────────────────────────
  //  PARTNER BENEFITS SECTION
  // ──────────────────────────────────────────────────────────

  /// Commission — amber/gold
  static const Color commissionFg = Color(0xFFFFB800);
  static const Color commissionBg = Color(0xFFFFFBF0);

  /// Safety — green
  static const Color safetyFg = Color(0xFF4CAF50);
  static const Color safetyBg = Color(0xFFF1FBF2);

  /// Flexible — blue
  static const Color flexFg = Color(0xFF42A5F5);
  static const Color flexBg = Color(0xFFF0F7FF);

  // ──────────────────────────────────────────────────────────
  //  GRADIENT HELPERS
  //  ໃຊ້ໃນ LinearGradient ສຳລັບ CTA buttons ແລະ hero sections
  // ──────────────────────────────────────────────────────────

  /// Pink CTA gradient  [begin, end]
  static const List<Color> pinkGradient = [secondary, primary];

  /// Dark hero gradient (home banner)
  static const List<Color> heroGradient = [primary, primaryVariant];

}
