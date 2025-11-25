import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:goal_tracker/features/onboarding/presentation/widgets/onboarding_widgets.dart';
import 'welcome_screen.dart';
import 'chronotype_screen.dart';
import 'sleep_schedule_screen.dart';
import 'session_length_screen.dart';
import 'work_schedule_screen.dart';
import 'completion_screen.dart';

/// Main onboarding page with PageView
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: OnboardingBackground(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Top bar with skip and progress
                _buildTopBar(state, controller),

                // Page content
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      WelcomeScreen(
                        onNext: () => controller.nextPage(),
                      ),
                      ChronotypeScreen(
                        selectedType: state.data.chronoType,
                        onSelect: (type) {
                          controller.setChronoType(type);
                        },
                        onNext: () => controller.nextPage(),
                        onBack: () => controller.previousPage(),
                      ),
                      SleepScheduleScreen(
                        wakeUpHour: state.data.wakeUpHour ?? 7,
                        sleepHour: state.data.sleepHour ?? 23,
                        onChanged: (wake, sleep) {
                          controller.setSleepSchedule(wake, sleep);
                        },
                        onNext: () => controller.nextPage(),
                        onBack: () => controller.previousPage(),
                      ),
                      SessionLengthScreen(
                        selectedLength: state.data.sessionLength,
                        onSelect: (length) {
                          controller.setSessionLength(length);
                        },
                        onNext: () => controller.nextPage(),
                        onBack: () => controller.previousPage(),
                      ),
                      WorkScheduleScreen(
                        workStartHour: state.data.workStartHour,
                        workEndHour: state.data.workEndHour,
                        onWorkStartChanged: (hour) {
                          controller.setWorkSchedule(
                            hasWorkSchedule: true,
                            workStartHour: hour,
                            workEndHour: state.data.workEndHour,
                          );
                        },
                        onWorkEndChanged: (hour) {
                          controller.setWorkSchedule(
                            hasWorkSchedule: true,
                            workStartHour: state.data.workStartHour,
                            workEndHour: hour,
                          );
                        },
                        onNext: () => controller.nextPage(),
                        onBack: () => controller.previousPage(),
                      ),
                      CompletionScreen(
                        isLoading: state.isCompleting,
                        onComplete: () async {
                          final success = await controller.completeOnboarding();
                          if (success && context.mounted) {
                            context.go('/');
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Page indicator
                if (state.currentPage > 0 &&
                    state.currentPage < OnboardingState.totalPages - 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: OnboardingPageIndicator(
                      currentPage: state.currentPage,
                      totalPages: OnboardingState.totalPages,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(OnboardingState state, OnboardingController controller) {
    // Hide on welcome and completion screens
    if (state.currentPage == 0 ||
        state.currentPage == OnboardingState.totalPages - 1) {
      return const SizedBox(height: 16);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Progress text
          Text(
            'Step ${state.currentPage} of ${OnboardingState.totalPages - 2}',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
          // Skip button
          OnboardingSecondaryButton(
            label: 'Skip',
            onPressed: () => controller.skipToCompletion(),
          ),
        ],
      ),
    );
  }
}
