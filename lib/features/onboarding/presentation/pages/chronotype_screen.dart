import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/data/models/user_profile.dart';
import 'package:goal_tracker/features/onboarding/presentation/widgets/onboarding_widgets.dart';

/// Chronotype selection screen
class ChronotypeScreen extends StatefulWidget {
  final ChronoType? selectedType;
  final ValueChanged<ChronoType> onSelect;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ChronotypeScreen({
    super.key,
    required this.selectedType,
    required this.onSelect,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ChronotypeScreen> createState() => _ChronotypeScreenState();
}

class _ChronotypeScreenState extends State<ChronotypeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  late Animation<double> _fadeAnimation;

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

    // Staggered animations for cards
    _slideAnimations = List.generate(4, (index) {
      final start = index * 0.1;
      final end = start + 0.5;
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start.clamp(0, 1), end.clamp(0, 1),
            curve: Curves.easeOutCubic),
      ));
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
                  'When are you most\nproductive?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'ll schedule your important tasks during your peak hours',
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Options
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildAnimatedOption(
                  0,
                  emoji: '🌅',
                  title: 'Early Bird',
                  subtitle: 'Peak energy: 6 AM - 10 AM',
                  type: ChronoType.earlyBird,
                  color: const Color(0xFFFFB347),
                ),
                const SizedBox(height: 12),
                _buildAnimatedOption(
                  1,
                  emoji: '☀️',
                  title: 'Normal',
                  subtitle: 'Peak energy: 9 AM - 12 PM',
                  type: ChronoType.normal,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                _buildAnimatedOption(
                  2,
                  emoji: '🌙',
                  title: 'Night Owl',
                  subtitle: 'Peak energy: 8 PM - 12 AM',
                  type: ChronoType.nightOwl,
                  color: const Color(0xFF7B68EE),
                ),
                const SizedBox(height: 12),
                _buildAnimatedOption(
                  3,
                  emoji: '🔄',
                  title: 'Flexible',
                  subtitle: 'No strong preference',
                  type: ChronoType.flexible,
                  color: const Color(0xFF20B2AA),
                ),
              ],
            ),
          ),

          // Navigation
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              children: [
                // Back button
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
                // Continue button
                Expanded(
                  child: OnboardingButton(
                    label: 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    onPressed:
                        widget.selectedType != null ? widget.onNext : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOption(
    int index, {
    required String emoji,
    required String title,
    required String subtitle,
    required ChronoType type,
    required Color color,
  }) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: OnboardingOptionCard(
          emoji: emoji,
          title: title,
          subtitle: subtitle,
          isSelected: widget.selectedType == type,
          accentColor: color,
          onTap: () => widget.onSelect(type),
        ),
      ),
    );
  }
}
