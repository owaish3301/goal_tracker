import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';

/// Completion screen with celebration
class CompletionScreen extends StatefulWidget {
  final Future<void> Function() onComplete;
  final bool isLoading;

  const CompletionScreen({
    super.key,
    required this.onComplete,
    this.isLoading = false,
  });

  @override
  State<CompletionScreen> createState() => _CompletionScreenState();
}

class _CompletionScreenState extends State<CompletionScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final List<_ConfettiParticle> _confetti = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Main animations
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );

    // Confetti animation
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Pulse animation for glow
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Generate confetti particles
    for (int i = 0; i < 50; i++) {
      _confetti.add(_ConfettiParticle(
        x: _random.nextDouble(),
        y: -0.1 - _random.nextDouble() * 0.3,
        rotation: _random.nextDouble() * 360,
        rotationSpeed: _random.nextDouble() * 360 - 180,
        fallSpeed: 0.3 + _random.nextDouble() * 0.4,
        size: 8 + _random.nextDouble() * 8,
        color: [
          AppColors.primary,
          const Color(0xFFFF6B6B),
          const Color(0xFF64D2FF),
          const Color(0xFFFF9F0A),
          const Color(0xFFBF5AF2),
        ][_random.nextInt(5)],
      ));
    }

    _mainController.forward();
    _confettiController.repeat();
    _pulseController.repeat(reverse: true);
    
    // Play success haptic
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti layer
        AnimatedBuilder(
          animation: _confettiController,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: _ConfettiPainter(
                particles: _confetti,
                progress: _confettiController.value,
              ),
            );
          },
        ),

        // Main content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Success badge
              ScaleTransition(
                scale: _scaleAnimation,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final pulse = 1.0 + (_pulseController.value * 0.05);
                    return Transform.scale(
                      scale: pulse,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                            stops: const [0.3, 0.6, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primary.withValues(alpha: 0.3 + _pulseController.value * 0.2),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.primary,
                                  AppColors.primary.withValues(alpha: 0.8),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: AppColors.background,
                              size: 64,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 48),

              // Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: child,
                    );
                  },
                  child: const Text(
                    'You\'re all set!',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 1.2),
                      child: child,
                    );
                  },
                  child: Text(
                    'We\'ve personalized your experience\nbased on your preferences',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Feature highlights
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildFeatureHighlights(),
              ),

              const Spacer(flex: 3),

              // Get started button
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.isLoading ? null : () {
                            HapticFeedback.heavyImpact();
                            widget.onComplete();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.background,
                            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 0,
                          ),
                          child: widget.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.background),
                                  ),
                                )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start tracking goals',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureHighlights() {
    final features = [
      ('⚡', 'Smart scheduling based on your energy'),
      ('🎯', 'Optimal time slots for goals'),
      ('📊', 'Track your progress effortlessly'),
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(feature.$1, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  feature.$2,
                  style: TextStyle(
                    color: AppColors.textSecondary.withValues(alpha: 0.9),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ConfettiParticle {
  double x;
  double y;
  double rotation;
  final double rotationSpeed;
  final double fallSpeed;
  final double size;
  final Color color;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.rotation,
    required this.rotationSpeed,
    required this.fallSpeed,
    required this.size,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = particle.y + (progress * particle.fallSpeed * 1.5);
      if (y > 1.1) continue;

      final x = particle.x + math.sin(progress * 2 * math.pi + particle.rotation) * 0.02;
      final rotation = particle.rotation + (progress * particle.rotationSpeed);

      final paint = Paint()..color = particle.color.withValues(alpha: (1 - progress) * 0.8);

      canvas.save();
      canvas.translate(x * size.width, y * size.height);
      canvas.rotate(rotation * math.pi / 180);

      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 0.6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}
