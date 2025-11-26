import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goal_tracker/data/models/goal.dart';
import 'package:goal_tracker/data/models/goal_category.dart';
import 'package:goal_tracker/data/models/milestone.dart';
import 'package:goal_tracker/features/goals/presentation/providers/goal_provider.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/frequency_selector.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/duration_picker.dart';
import 'package:goal_tracker/features/goals/presentation/widgets/category_selector.dart';
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
  final _scrollController = ScrollController();

  List<int> _selectedDays = [];
  int _durationMinutes = AppConstants.defaultDurationMinutes;
  GoalCategory _selectedCategory = GoalCategory.other;
  List<Milestone> _milestones = [];
  
  // Auto-assigned based on category and existing goals
  Color _assignedColor = AppConstants.defaultGoalColor;
  String _assignedIconName = AppConstants.defaultIconName;
  
  // For edit mode - preserve original values

  bool _isLoading = true;
  bool _isSaving = false;
  
  // Cache existing goals data for auto-assignment
  List<String> _usedIcons = [];
  List<Color> _usedColors = [];

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    // First load existing goals to know what icons/colors are used
    final repository = ref.read(goalRepositoryProvider);
    final allGoals = await repository.getAllGoals();
    
    _usedIcons = allGoals.map((g) => g.iconName).toList();
    _usedColors = allGoals.map((g) => 
      Color(int.parse(g.colorHex.replaceFirst('#', '0xFF')))
    ).toList();

    if (widget.goalId != null) {
      // Edit mode - load existing goal
      final goal = await repository.getGoal(widget.goalId!);

      if (goal != null && mounted) {
        // Remove this goal's icon/color from used lists for edit
        _usedIcons.remove(goal.iconName);
        final goalColor = Color(int.parse(goal.colorHex.replaceFirst('#', '0xFF')));
        _usedColors.remove(goalColor);
        
        setState(() {
          _titleController.text = goal.title;
          _selectedDays = List.from(goal.frequency);
          _durationMinutes = goal.targetDuration;
          _selectedCategory = goal.category;
          // Preserve original values for edit mode
          _assignedColor = goalColor;
          _assignedIconName = goal.iconName;
        });

        final milestoneRepo = ref.read(milestoneRepositoryProvider);
        final milestones = await milestoneRepo.getMilestonesForGoal(goal.id);
        if (mounted) {
          setState(() {
            _milestones = milestones;
          });
        }
      }
    } else {
      // New goal - auto-assign color and icon for default category
      _autoAssignColorAndIcon();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _autoAssignColorAndIcon() {
    _assignedIconName = AppConstants.getNextIconForCategory(
      _selectedCategory,
      _usedIcons,
    );
    _assignedColor = AppConstants.getNextColorForCategory(
      _selectedCategory,
      _usedColors,
    );
  }
  
  void _onCategoryChanged(GoalCategory category) {
    setState(() {
      _selectedCategory = category;
      // Only auto-assign for new goals, preserve for edits unless category changed
      if (widget.goalId == null || _selectedCategory != category) {
        _autoAssignColorAndIcon();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scrollController.dispose();
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
          '#${_assignedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

      if (widget.goalId == null) {
        final goal = Goal()
          ..title = _titleController.text.trim()
          ..frequency = _selectedDays
          ..targetDuration = _durationMinutes
          ..priorityIndex = await goalRepo.getGoalCount()
          ..colorHex = colorHex
          ..iconName = _assignedIconName
          ..category = _selectedCategory
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
            ..iconName = _assignedIconName
            ..category = _selectedCategory;

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
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                cacheExtent: 1000, // Pre-render more off-screen content
                addAutomaticKeepAlives: false, // Reduce memory overhead
                children: [
                  // Goal preview card showing auto-assigned color/icon
                  RepaintBoundary(
                    child: _GoalPreviewCard(
                      title: _titleController.text.isEmpty 
                          ? 'Your Goal' 
                          : _titleController.text,
                      color: _assignedColor,
                      iconName: _assignedIconName,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: AppColors.textPrimary),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}), // Update preview
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
                    child: CategorySelector(
                      selectedCategory: _selectedCategory,
                      onChanged: _onCategoryChanged,
                    ),
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

/// Preview card showing how the goal will look with auto-assigned color/icon
class _GoalPreviewCard extends StatelessWidget {
  final String title;
  final Color color;
  final String iconName;

  const _GoalPreviewCard({
    required this.title,
    required this.color,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    final icon = AppConstants.getIconFromName(iconName);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preview',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
