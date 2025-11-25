import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/features/onboarding/presentation/widgets/onboarding_widgets.dart';

/// Session length preference screen
class SessionLengthScreen extends StatefulWidget {
  final SessionLength? selectedLength;
  final ValueChanged<SessionLength> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const SessionLengthScreen({
    super.key,
    required this.selectedLength,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<SessionLengthScreen> createState() => _SessionLengthScreenState();
}

class _SessionLengthScreenState extends State<SessionLengthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Animation<double>> _scaleAnimations;

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
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Staggered scale animations for cards
    _scaleAnimations = List.generate(3, (index) {
      final start = index * 0.15;
      final end = start + 0.5;
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
              curve: Curves.elasticOut),
        ),
      );
    });

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How long do you\nlike to focus?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'ll split your goals into sessions of this length',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Session options as visual cards
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildSessionCard(
                    index: 0,
                    length: SessionLength.short,
                    title: 'Short Bursts',
                    duration: '15-30 minutes',
                    description: 'Quick, focused sprints',
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFFF6B6B),
                    bars: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildSessionCard(
                    index: 1,
                    length: SessionLength.medium,
                    title: 'Balanced',
                    duration: '30-60 minutes',
                    description: 'Standard productivity blocks',
                    icon: Icons.balance_rounded,
                    color: AppColors.primary,
                    bars: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildSessionCard(
                    index: 2,
                    length: SessionLength.long,
                    title: 'Deep Work',
                    duration: '60-90 minutes',
                    description: 'Extended concentration periods',
                    icon: Icons.psychology_rounded,
                    color: const Color(0xFF7B68EE),
                    bars: 6,
                  ),
                ],
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
                    onPressed:
                        widget.selectedLength != null ? widget.onNext : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required int index,
    required SessionLength length,
    required String title,
    required String duration,
    required String description,
    required IconData icon,
    required Color color,
    required int bars,
  }) {
    final isSelected = widget.selectedLength == length;

    return ScaleTransition(
      scale: _scaleAnimations[index],
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onSelect(length);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.15)
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.2)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: isSelected ? color : AppColors.textSecondary, size: 28),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? color : AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      duration,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textSecondary.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Duration bars
              _buildDurationBars(bars, color, isSelected),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationBars(int count, Color color, bool isSelected) {
    return Row(
      children: List.generate(6, (index) {
        final isActive = index < count;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(left: 3),
          width: 4,
          height: 24 + (index * 4),
          decoration: BoxDecoration(
            color: isActive
                ? (isSelected ? color : AppColors.textSecondary.withValues(alpha: 0.5))
                : AppColors.textSecondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
