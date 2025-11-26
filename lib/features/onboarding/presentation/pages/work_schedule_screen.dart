import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/features/onboarding/presentation/widgets/onboarding_widgets.dart';

/// Work schedule preference screen
class WorkScheduleScreen extends StatefulWidget {
  final int? workStartHour;
  final int? workEndHour;
  final ValueChanged<int> onWorkStartChanged;
  final ValueChanged<int> onWorkEndChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const WorkScheduleScreen({
    super.key,
    required this.workStartHour,
    required this.workEndHour,
    required this.onWorkStartChanged,
    required this.onWorkEndChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends State<WorkScheduleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _hasWorkSchedule = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatHour(int? hour) {
    if (hour == null) return '--:--';
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:00 $period';
  }

  int _getWorkDuration() {
    if (widget.workStartHour == null || widget.workEndHour == null) return 0;
    final duration = widget.workEndHour! - widget.workStartHour!;
    return duration < 0 ? duration + 24 : duration;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Do you have\nwork hours?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'ll avoid scheduling personal goals during work',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Toggle switch
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _hasWorkSchedule = !_hasWorkSchedule;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _hasWorkSchedule
                              ? Icons.business_center_rounded
                              : Icons.beach_access_rounded,
                          color: _hasWorkSchedule
                              ? AppColors.primary
                              : const Color(0xFF64D2FF),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hasWorkSchedule
                                  ? 'I have work hours'
                                  : 'I\'m flexible',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _hasWorkSchedule
                                  ? 'Set your work schedule below'
                                  : 'No fixed work schedule',
                              style: TextStyle(
                                color:
                                    AppColors.textSecondary.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _hasWorkSchedule,
                        onChanged: (value) {
                          setState(() {
                            _hasWorkSchedule = value;
                          });
                        },
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                        inactiveThumbColor: AppColors.textSecondary,
                        inactiveTrackColor:
                            AppColors.textSecondary.withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Time pickers (conditional)
          if (_hasWorkSchedule) ...[
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildTimePicker(
                        label: 'Work starts',
                        emoji: '💼',
                        hour: widget.workStartHour,
                        onChanged: widget.onWorkStartChanged,
                        color: const Color(0xFFFF9F0A),
                      ),
                      const SizedBox(height: 16),
                      _buildTimePicker(
                        label: 'Work ends',
                        emoji: '🏠',
                        hour: widget.workEndHour,
                        onChanged: widget.onWorkEndChanged,
                        color: const Color(0xFF30D158),
                      ),
                      const SizedBox(height: 20),
                      // Work duration display
                      if (widget.workStartHour != null && widget.workEndHour != null)
                        _buildDurationDisplay(),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            // Flexible schedule illustration
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF64D2FF).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🌴', style: TextStyle(fontSize: 56)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No problem!',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Goals will be scheduled throughout\nyour waking hours',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],

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
                    onPressed: _canContinue() ? widget.onNext : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _canContinue() {
    if (!_hasWorkSchedule) return true;
    return widget.workStartHour != null && widget.workEndHour != null;
  }

  Widget _buildTimePicker({
    required String label,
    required String emoji,
    required int? hour,
    required ValueChanged<int> onChanged,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showTimePicker(hour ?? 9, onChanged, color);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: hour != null ? color.withValues(alpha: 0.3) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatHour(hour),
                    style: TextStyle(
                      color: hour != null ? color : AppColors.textSecondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.access_time_rounded,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationDisplay() {
    final duration = _getWorkDuration();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_rounded,
            color: AppColors.primary.withValues(alpha: 0.8),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '$duration hour${duration == 1 ? '' : 's'} of work',
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.9),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(int initialHour, ValueChanged<int> onChanged, Color color) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 350,
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Time',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                perspective: 0.005,
                diameterRatio: 1.5,
                physics: const FixedExtentScrollPhysics(),
                controller: FixedExtentScrollController(initialItem: initialHour),
                onSelectedItemChanged: (index) => onChanged(index),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 24,
                  builder: (context, index) {
                    final period = index >= 12 ? 'PM' : 'AM';
                    final displayHour = index == 0
                        ? 12
                        : (index > 12 ? index - 12 : index);
                    return Center(
                      child: Text(
                        '$displayHour:00 $period',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
