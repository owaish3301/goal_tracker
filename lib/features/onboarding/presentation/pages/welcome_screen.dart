import 'package:flutter/material.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/features/onboarding/presentation/widgets/onboarding_widgets.dart';

/// Welcome screen - First impression with animated logo
class WelcomeScreen extends StatefulWidget {
  final VoidCallback onNext;

  const WelcomeScreen({super.key, required this.onNext});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _textOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Text animations
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0, 0.6, curve: Curves.easeOutCubic),
    ));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0, 0.5, curve: Curves.easeOut),
      ),
    );
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    ));

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 2),

          // Animated logo
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: child,
                ),
              );
            },
            child: _buildLogo(),
          ),

          const SizedBox(height: 48),

          // Title
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value,
                child: SlideTransition(
                  position: _titleSlide,
                  child: child,
                ),
              );
            },
            child: const Text(
              'Goal Tracker',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value,
                child: SlideTransition(
                  position: _subtitleSlide,
                  child: child,
                ),
              );
            },
            child: Text(
              'Your intelligent daily scheduler that\nlearns and adapts to you',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.9),
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ),

          const Spacer(flex: 2),

          // Features preview
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value,
                child: SlideTransition(
                  position: _subtitleSlide,
                  child: child,
                ),
              );
            },
            child: _buildFeaturesList(),
          ),

          const Spacer(),

          // Get started button
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value,
                child: SlideTransition(
                  position: _buttonSlide,
                  child: child,
                ),
              );
            },
            child: OnboardingButton(
              label: 'Get Started',
              icon: Icons.arrow_forward_rounded,
              onPressed: widget.onNext,
            ),
          ),

          const SizedBox(height: 16),

          // Personalization hint
          AnimatedBuilder(
            animation: _textController,
            builder: (context, child) {
              return Opacity(
                opacity: _textOpacity.value * 0.7,
                child: child,
              );
            },
            child: Text(
              '3 quick questions to personalize your experience',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color(0xFFB8E625),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.track_changes_rounded,
          size: 56,
          color: AppColors.textInversePrimary,
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.psychology_rounded,
          text: 'Learns your productivity patterns',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.schedule_rounded,
          text: 'Auto-schedules your daily tasks',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.trending_up_rounded,
          text: 'Optimizes for peak performance',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 220,
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
