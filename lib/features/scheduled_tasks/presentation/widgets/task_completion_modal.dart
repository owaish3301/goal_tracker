import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/scheduled_task.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../goals/presentation/providers/milestone_provider.dart';

/// Modal for recording task completion with productivity feedback
class TaskCompletionModal extends ConsumerStatefulWidget {
  final ScheduledTask task;
  final Function(
    DateTime actualStartTime,
    int actualDurationMinutes,
    double productivityRating,
    String? notes,
    int? completedMilestoneId,
  )
  onComplete;

  const TaskCompletionModal({
    super.key,
    required this.task,
    required this.onComplete,
  });

  @override
  ConsumerState<TaskCompletionModal> createState() =>
      _TaskCompletionModalState();
}

class _TaskCompletionModalState extends ConsumerState<TaskCompletionModal> {
  late DateTime _actualStartTime;
  late int _actualDurationMinutes;
  double _productivityRating = 3.0;
  final _notesController = TextEditingController();
  bool _markMilestoneComplete = false;
  int? _milestoneToComplete;

  @override
  void initState() {
    super.initState();
    // Default to scheduled time and duration
    _actualStartTime = widget.task.scheduledStartTime;
    _actualDurationMinutes = widget.task.duration;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(
                        widget.task.colorHex?.replaceFirst('#', '0xFF') ??
                            '0xFFC6F432',
                      ),
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.task.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Productivity Rating
            const Text(
              'How productive were you?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildProductivityRating(),
            const SizedBox(height: 24),

            // Actual Start Time
            const Text(
              'When did you actually start?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTimePicker(),
            const SizedBox(height: 24),

            // Actual Duration
            const Text(
              'How long did it take?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildDurationPicker(),
            const SizedBox(height: 24),

            // Milestone completion (if available)
            _buildMilestoneSection(),
            
            // Notes (optional)
            const Text(
              'Notes (optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textPrimary),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Any thoughts about this session?',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityRating() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final rating = index + 1;
              final isSelected = _productivityRating.round() == rating;

              return GestureDetector(
                onTap: () =>
                    setState(() => _productivityRating = rating.toDouble()),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    size: 40,
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            _getRatingLabel(_productivityRating.round()),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Not productive at all';
      case 2:
        return 'Somewhat productive';
      case 3:
        return 'Moderately productive';
      case 4:
        return 'Very productive';
      case 5:
        return 'Extremely productive!';
      default:
        return '';
    }
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: _pickStartTime,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              '${_actualStartTime.hour.toString().padLeft(2, '0')}:${_actualStartTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.edit, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPicker() {
    final hours = _actualDurationMinutes ~/ 60;
    final minutes = _actualDurationMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColors.textSecondary,
            onPressed: () {
              if (_actualDurationMinutes > 5) {
                setState(() => _actualDurationMinutes -= 5);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
            onPressed: () {
              setState(() => _actualDurationMinutes += 5);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_actualStartTime),
    );

    if (time != null) {
      setState(() {
        _actualStartTime = DateTime(
          _actualStartTime.year,
          _actualStartTime.month,
          _actualStartTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _handleSubmit() async {
    // If user wants to mark milestone complete, pass the milestone ID
    final milestoneId = _markMilestoneComplete ? _milestoneToComplete : null;
    
    // If milestone was marked complete, update it first to ensure data consistency
    if (milestoneId != null) {
      try {
        await ref.read(milestoneNotifierProvider.notifier).toggleMilestoneCompletion(
              milestoneId,
              widget.task.goalId,
              true,
            );
      } catch (e) {
        // Log error but continue with task completion
        debugPrint('Error marking milestone complete: $e');
        // Show error to user if context is still available
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to mark milestone as complete: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
    
    widget.onComplete(
      _actualStartTime,
      _actualDurationMinutes,
      _productivityRating,
      _notesController.text.isEmpty ? null : _notesController.text,
      milestoneId,
    );
    
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildMilestoneSection() {
    final milestoneAsync = ref.watch(firstIncompleteMilestoneProvider(widget.task.goalId));

    return milestoneAsync.when(
      data: (milestone) {
        if (milestone == null) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Milestone Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _markMilestoneComplete,
                      onChanged: (value) {
                        setState(() {
                          _markMilestoneComplete = value ?? false;
                        });
                        if (value == true) {
                          HapticFeedback.lightImpact();
                        }
                      },
                      activeColor: Color(
                        int.parse(widget.task.colorHex?.replaceFirst('#', '0xFF') ?? '0xFFC6F432'),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mark milestone as complete?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.flag_outlined,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                milestone.title,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
