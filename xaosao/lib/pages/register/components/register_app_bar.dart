import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/app_color.dart';
import '../../login/getx/login_state.dart';

class RegisterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RegisterRole role;
  final int currentStep; // 1-based
  final String title;
  final String subtitle;
  final VoidCallback? onBack;

  const RegisterAppBar({
    super.key,
    required this.role,
    required this.currentStep,
    required this.title,
    required this.subtitle,
    this.onBack,
  });

  // ── Step definitions ────────────────────────────────────────────────────────

  List<StepItem> get _steps {
    if (role == RegisterRole.customer) {
      return const [StepItem(label: 'ຂໍ້ມູນ'), StepItem(label: 'OTP')];
    } else {
      return const [
        StepItem(label: 'ຂໍ້ມູນ'),
        StepItem(label: 'ບໍລິການ'),
        StepItem(label: 'OTP'),
      ];
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final steps = _steps;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.pinkGradient, // [secondary, primary]
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Row 1: back button + title/subtitle ────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.maybePop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title + subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.80),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── Row 2: step indicators ──────────────────────────────────────
              StepIndicatorRow(steps: steps, currentStep: currentStep),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Internal step data ────────────────────────────────────────────────────────

class StepItem {
  final String label;
  const StepItem({required this.label});
}

// ── Step indicator row ────────────────────────────────────────────────────────

class StepIndicatorRow extends StatelessWidget {
  final List<StepItem> steps;
  final int currentStep; // 1-based

  const StepIndicatorRow({required this.steps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _StepDot(
            index: i + 1,
            label: steps[i].label,
            state: _stateFor(i + 1),
          ),
          if (i < steps.length - 1)
            _StepConnector(completed: currentStep > i + 1),
        ],
      ],
    );
  }

  _DotState _stateFor(int step) {
    if (step < currentStep) return _DotState.done;
    if (step == currentStep) return _DotState.active;
    return _DotState.upcoming;
  }
}

enum _DotState { done, active, upcoming }

// ── Single step dot + label ───────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final int index;
  final String label;
  final _DotState state;

  const _StepDot({
    required this.index,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = state == _DotState.done;
    final isActive = state == _DotState.active;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 26 : 22,
          height: isActive ? 26 : 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors.white
                : isDone
                ? Colors.white.withOpacity(0.30)
                : Colors.white.withOpacity(0.15),
            border: isActive
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(isDone ? 0.60 : 0.35),
                    width: 1.5,
                  ),
          ),
          child: Center(
            child: isDone
                ? Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: Colors.white.withOpacity(0.90),
                  )
                : Text(
                    '$index',
                    style: TextStyle(
                      color: isActive
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.80),
                      fontSize: isActive ? 13 : 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 5),

        // Label
        Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.white.withOpacity(isDone ? 0.70 : 0.50),
            fontSize: isActive ? 13.sp : 12.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ── Connector line between steps ──────────────────────────────────────────────

class _StepConnector extends StatelessWidget {
  final bool completed;
  const _StepConnector({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          height: 1.5,
          decoration: BoxDecoration(
            color: completed
                ? Colors.white.withOpacity(0.60)
                : Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
