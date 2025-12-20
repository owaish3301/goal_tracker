import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/features/onboarding/presentation/widgets/onboarding_widgets.dart';

/// Sleep schedule selection screen
class SleepScheduleScreen extends StatefulWidget {
  final int wakeUpHour;
  final int sleepHour;
  final void Function(int wakeUp, int sleep) onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SleepScheduleScreen({
    super.key,
    required this.wakeUpHour,
    required this.sleepHour,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late int _wakeUpHour;
  late int _sleepHour;

  /// Check if the selected time window is valid (4-20 hours)
  bool get _isValidTimeWindow {
    // If wake-up and sleep times are the same, the awake window is 0 hours (invalid).
    if (_sleepHour == _wakeUpHour) {
      return false;
    }

    int awakeHours;
    if (_sleepHour > _wakeUpHour) {
      awakeHours = _sleepHour - _wakeUpHour;
    } else {
      awakeHours = (24 - _wakeUpHour) + _sleepHour;
    }
    return awakeHours >= 4 && awakeHours <= 20;
  }

  @override
  void initState() {
    super.initState();
    _wakeUpHour = widget.wakeUpHour;
    _sleepHour = widget.sleepHour;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Header
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your sleep schedule',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We\'ll only schedule tasks during your waking hours',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Time pickers
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Visual representation
                    _buildDayVisual(),

                    const SizedBox(height: 32),

                    // Wake up picker
                    _buildTimeSelector(
                      icon: Icons.wb_sunny_rounded,
                      iconColor: const Color(0xFFFFB347),
                      label: 'Wake up',
                      hour: _wakeUpHour,
                      onChanged: (hour) {
                        setState(() => _wakeUpHour = hour);
                        widget.onChanged(_wakeUpHour, _sleepHour);
                      },
                    ),

                    const SizedBox(height: 24),

                    // Sleep picker
                    _buildTimeSelector(
                      icon: Icons.bedtime_rounded,
                      iconColor: const Color(0xFF7B68EE),
                      label: 'Sleep',
                      hour: _sleepHour,
                      onChanged: (hour) {
                        setState(() => _sleepHour = hour);
                        widget.onChanged(_wakeUpHour, _sleepHour);
                      },
                    ),

                    const Spacer(),

                    // Hours summary
                    _buildHoursSummary(),
                  ],
                ),
              ),
            ),
          ),

          // Navigation
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: AppColors.textSecondary,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceDark,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OnboardingButton(
                    label: 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _isValidTimeWindow ? widget.onNext : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayVisual() {
    // Calculate awake hours
    int awakeHours;
    if (_sleepHour > _wakeUpHour) {
      awakeHours = _sleepHour - _wakeUpHour;
    } else {
      awakeHours = (24 - _wakeUpHour) + _sleepHour;
    }

    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.surfaceDark,
      ),
      child: Row(
        children: [
          // Night section (before wake)
          Expanded(
            flex: _wakeUpHour,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  bottomLeft: const Radius.circular(20),
                  topRight: _wakeUpHour >= 12 ? const Radius.circular(20) : Radius.zero,
                  bottomRight: _wakeUpHour >= 12 ? const Radius.circular(20) : Radius.zero,
                ),
              ),
              child: const Center(
                child: Text('😴', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
          // Day section (awake)
          Expanded(
            flex: awakeHours,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.primary.withValues(alpha: 0.15),
                  ],
                ),
              ),
              child: const Center(
                child: Text('⚡', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
          // Night section (after sleep)
          if (_sleepHour < _wakeUpHour || _sleepHour < 24)
            Expanded(
              flex: _sleepHour > _wakeUpHour ? 24 - _sleepHour : 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: _sleepHour > _wakeUpHour && 24 - _sleepHour > 2
                    ? const Center(
                        child: Text('😴', style: TextStyle(fontSize: 24)),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int hour,
    required ValueChanged<int> onChanged,
  }) {
    // Check if this is the sleep time and it's past midnight
    final bool isSleep = label == 'Sleep';
    final bool isPastMidnight = isSleep && _sleepHour <= _wakeUpHour;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          // Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isPastMidnight) ...[
                  const SizedBox(height: 2),
                  Text(
                    '(next day)',
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Time selector
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _showTimePicker(label, hour, onChanged);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _formatHour(hour),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursSummary() {
    int awakeHours;
    if (_sleepHour > _wakeUpHour) {
      awakeHours = _sleepHour - _wakeUpHour;
    } else {
      awakeHours = (24 - _wakeUpHour) + _sleepHour;
    }

    // Validate time window (must be 4-20 hours)
    final bool isValid = awakeHours >= 4 && awakeHours <= 20;
    final Color containerColor = isValid
        ? AppColors.primary.withValues(alpha: 0.1)
        : Colors.red.withValues(alpha: 0.1);
    final Color borderColor = isValid
        ? AppColors.primary.withValues(alpha: 0.2)
        : Colors.red.withValues(alpha: 0.3);
    final Color iconColor = isValid
        ? AppColors.primary.withValues(alpha: 0.8)
        : Colors.red.withValues(alpha: 0.8);
    final Color textColor = isValid
        ? AppColors.textSecondary.withValues(alpha: 0.9)
        : Colors.red.withValues(alpha: 0.9);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isValid ? Icons.check_circle_rounded : Icons.error_rounded,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isValid
                    ? '$awakeHours hours available for scheduling'
                    : 'Invalid: Need 4-20 hours',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: isValid ? FontWeight.normal : FontWeight.w600,
                ),
              ),
            ],
          ),
          if (!isValid) ...[
            const SizedBox(height: 8),
            Text(
              awakeHours < 4
                  ? 'Please select at least 4 hours between wake and sleep times'
                  : 'Please select no more than 20 hours between wake and sleep times',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showTimePicker(String label, int currentHour, ValueChanged<int> onChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        int selectedHour = currentHour;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 320,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: OnboardingTimePicker(
                      label: '',
                      selectedHour: selectedHour,
                      onChanged: (hour) {
                        setModalState(() => selectedHour = hour);
                      },
                    ),
                  ),
                  OnboardingButton(
                    label: 'Done',
                    onPressed: () {
                      onChanged(selectedHour);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12:00 AM';
    if (hour == 12) return '12:00 PM';
    if (hour < 12) return '$hour:00 AM';
    return '${hour - 12}:00 PM';
  }
}
