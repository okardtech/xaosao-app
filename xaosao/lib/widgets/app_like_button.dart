import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:xaosao/constants/app_color.dart';

/// Reusable animated like/heart button — no setState, driven by GetX [RxBool].
///
/// Optimistically flips on tap, then calls [onToggle].
/// If [onToggle] returns `false` the button reverts.
/// Syncs with [initialLiked] via [didUpdateWidget] so parent-state reverts
/// (e.g. from a failed API call in a controller) propagate automatically.
class AppLikeButton extends StatefulWidget {
  final bool initialLiked;

  /// Logical size; `.r` is applied internally.
  final double size;

  /// Logical icon size; `.r` is applied internally.
  final double iconSize;

  /// Fill when liked — defaults to [AppColors.primary].
  final Color? likedColor;

  /// Fill when not liked — defaults to `black @ 28 %`.
  final Color? unlikedBg;

  /// Optional border (e.g. glass style for app-bar buttons).
  final Border? border;

  /// Optional outer margin.
  final EdgeInsets? margin;

  /// Called after the optimistic flip. Return `true` to confirm, `false` to revert.
  final Future<bool> Function()? onToggle;

  const AppLikeButton({
    super.key,
    this.initialLiked = false,
    this.size = 30.0,
    this.iconSize = 15.0,
    this.likedColor,
    this.unlikedBg,
    this.border,
    this.margin,
    this.onToggle,
  });

  @override
  State<AppLikeButton> createState() => _AppLikeButtonState();
}

class _AppLikeButtonState extends State<AppLikeButton>
    with SingleTickerProviderStateMixin {
  late final RxBool _liked;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _liked = widget.initialLiked.obs;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant AppLikeButton old) {
    super.didUpdateWidget(old);
    if (old.initialLiked != widget.initialLiked) {
      _liked.value = widget.initialLiked;
    }
  }

  @override
  void dispose() {
    _liked.close();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    final prev = _liked.value;
    _liked.value = !prev;
    _ctrl.forward().then((_) => _ctrl.reverse());
    if (widget.onToggle != null) {
      final success = await widget.onToggle!();
      if (!success && mounted) _liked.value = prev;
    }
  }

  @override
  Widget build(BuildContext context) {
    final likedColor = widget.likedColor ?? AppColors.primary;
    final unlikedBg =
        widget.unlikedBg ?? Colors.black.withValues(alpha: 0.28);
    return GestureDetector(
      onTap: _toggle,
      child: ScaleTransition(
        scale: _scale,
        child: Obx(
          () => Container(
            margin: widget.margin,
            width: widget.size.r,
            height: widget.size.r,
            decoration: BoxDecoration(
              color: _liked.value ? likedColor : unlikedBg,
              shape: BoxShape.circle,
              border: widget.border,
            ),
            child: Icon(
              _liked.value
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: widget.iconSize.r,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
