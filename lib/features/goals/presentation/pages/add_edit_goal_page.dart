import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/features/goals/presentation/providers/goal_provider.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/frequency_selector.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/duration_picker.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/color_picker.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/icon_selector.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/milestone_editor.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';
import 'package:goal_tracker/core/constants/constants.dart';
import 'package:goal_tracker/core/services/database_service.dart';

class AddEditGoalPage extends ConsumerStatefulWidget {
  final int? goalId;

  const AddEditGoalPage({super.key, this.goalId});

  @override
  ConsumerState<AddEditGoalPage> createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends ConsumerState<AddEditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  List<int> _selectedDays = [];
  int _durationMinutes = AppConstants.defaultDurationMinutes;
  Color _selectedColor = AppConstants.defaultGoalColor;
  String _selectedIconName = AppConstants.defaultIconName;
  List<Milestone> _milestones = [];

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    if (widget.goalId != null) {
      final repository = ref.read(goalRepositoryProvider);
      final goal = await repository.getGoal(widget.goalId!);

      if (goal != null && mounted) {
        setState(() {
          _titleController.text = goal.title;
          _selectedDays = List.from(goal.frequency);
          _durationMinutes = goal.targetDuration;
          _selectedColor = Color(
            int.parse(goal.colorHex.replaceFirst('#', '0xFF')),
          );
          _selectedIconName = goal.iconName;
        });

        final milestoneRepo = ref.read(milestoneRepositoryProvider);
        final milestones = await milestoneRepo.getMilestonesForGoal(goal.id);
        if (mounted) {
          setState(() {
            _milestones = milestones;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final goalNotifier = ref.read(goalNotifierProvider.notifier);
      final goalRepo = ref.read(goalRepositoryProvider);
      final milestoneRepo = ref.read(milestoneRepositoryProvider);

      final colorHex =
          '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

      if (widget.goalId == null) {
        final goal = Goal()
          ..title = _titleController.text.trim()
          ..frequency = _selectedDays
          ..targetDuration = _durationMinutes
          ..priorityIndex = await goalRepo.getGoalCount()
          ..colorHex = colorHex
          ..iconName = _selectedIconName
          ..createdAt = DateTime.now()
          ..isActive = true;

        await goalNotifier.createGoal(goal);
        final goals = await goalRepo.getAllGoals();
        final createdGoal = goals.last;

        for (final milestone in _milestones) {
          await milestoneRepo.createMilestone(milestone, createdGoal.id);
        }
      } else {
        final goal = await goalRepo.getGoal(widget.goalId!);
        if (goal != null) {
          goal
            ..title = _titleController.text.trim()
            ..frequency = _selectedDays
            ..targetDuration = _durationMinutes
            ..colorHex = colorHex
            ..iconName = _selectedIconName;

          await goalNotifier.updateGoal(goal);

          final existingMilestones = await milestoneRepo.getMilestonesForGoal(
            goal.id,
          );
          for (final milestone in existingMilestones) {
            await milestoneRepo.deleteMilestone(milestone.id);
          }
          for (final milestone in _milestones) {
            await milestoneRepo.createMilestone(milestone, goal.id);
          }
        }
      }

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving goal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.goalId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(isEdit ? 'Edit Goal' : 'New Goal'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveGoal,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(24),
                cacheExtent: 500, // Pre-render off-screen content
                physics: const BouncingScrollPhysics(), // Smoother scrolling
                children: [
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Goal Title',
                      labelStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      hintText: 'e.g., Learn Flutter',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a goal title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: FrequencySelector(
                      selectedDays: _selectedDays,
                      onChanged: (days) => setState(() => _selectedDays = days),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: DurationPicker(
                      durationMinutes: _durationMinutes,
                      onChanged: (minutes) =>
                          setState(() => _durationMinutes = minutes),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: ColorPicker(
                      selectedColor: _selectedColor,
                      onChanged: (color) =>
                          setState(() => _selectedColor = color),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: IconSelector(
                      selectedIconName: _selectedIconName,
                      onChanged: (iconName) =>
                          setState(() => _selectedIconName = iconName),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RepaintBoundary(
                    child: MilestoneEditor(
                      milestones: _milestones,
                      onChanged: (milestones) =>
                          setState(() => _milestones = milestones),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
