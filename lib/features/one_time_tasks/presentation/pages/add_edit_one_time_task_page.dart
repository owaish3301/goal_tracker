import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/one_time_task.dart';
import '../../../../core/services/database_service.dart';
import '../../../../data/repositories/one_time_task_repository.dart';
import '../../../goals/presentation/widgets/duration_picker.dart';
import '../../../goals/presentation/widgets/color_picker.dart';

class AddEditOneTimeTaskPage extends StatefulWidget {
  final int? taskId;
  final DateTime? initialDate;

  const AddEditOneTimeTaskPage({super.key, this.taskId, this.initialDate});

  @override
  State<AddEditOneTimeTaskPage> createState() => _AddEditOneTimeTaskPageState();
}

class _AddEditOneTimeTaskPageState extends State<AddEditOneTimeTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;
  int _durationMinutes = 60; // Default 1 hour
  Color _selectedColor = AppColors.primary; // Default lime green

  bool _isLoading = false;
  OneTimeTask? _existingTask;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();

    if (widget.taskId != null) {
      _loadTask();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadTask() async {
    setState(() => _isLoading = true);

    try {
      final isar = DatabaseService.instance;
      final repository = OneTimeTaskRepository(isar);
      final task = await repository.getOneTimeTask(widget.taskId!);

      if (task != null && mounted) {
        setState(() {
          _existingTask = task;
          _titleController.text = task.title;
          _notesController.text = task.notes ?? '';
          _selectedDate = task.scheduledDate;
          _selectedTime = TimeOfDay(
            hour: task.scheduledStartTime.hour,
            minute: task.scheduledStartTime.minute,
          );
          _durationMinutes = task.duration;
          _selectedColor = task.colorHex != null
              ? Color(int.parse(task.colorHex!, radix: 16))
              : AppColors.primary;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading task: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(today) ? today : _selectedDate,
      firstDate: today, // Only allow today and future dates
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textInversePrimary,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: AppColors.textInversePrimary,
              surface: AppColors.surfaceDark,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a time')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isar = DatabaseService.instance;
      final repository = OneTimeTaskRepository(isar);

      // Combine date and time
      final scheduledDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      final task = _existingTask ?? OneTimeTask();
      task.title = _titleController.text.trim();
      task.scheduledDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
      task.scheduledStartTime = scheduledDateTime;
      task.duration = _durationMinutes;
      task.notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      task.colorHex = _selectedColor.toARGB32().toRadixString(16).toUpperCase();
      task.isCompleted = _existingTask?.isCompleted ?? false;
      task.createdAt = _existingTask?.createdAt ?? DateTime.now();

      if (_existingTask == null) {
        await repository.createOneTimeTask(task);
      } else {
        await repository.updateOneTimeTask(task);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _existingTask == null
                  ? 'Task created successfully'
                  : 'Task updated successfully',
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving task: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteTask() async {
    if (_existingTask == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Delete Task',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);

      try {
        final isar = DatabaseService.instance;
        final repository = OneTimeTaskRepository(isar);
        await repository.deleteOneTimeTask(_existingTask!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task deleted successfully')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting task: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_existingTask == null ? 'Add Event' : 'Edit Event'),
        actions: [
          if (_existingTask != null)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: _isLoading ? null : _deleteTask,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Title',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'e.g., Doctor Appointment, Laundry',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Date
                    Text(
                      'Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat(
                                'EEEE, MMMM d, yyyy',
                              ).format(_selectedDate),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time
                    Text(
                      'Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'Select time',
                              style: TextStyle(
                                color: _selectedTime != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Duration
                    DurationPicker(
                      durationMinutes: _durationMinutes,
                      onChanged: (value) {
                        setState(() {
                          _durationMinutes = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Color
                    ColorPicker(
                      selectedColor: _selectedColor,
                      onChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Notes (Optional)
                    Text(
                      'Notes (Optional)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _notesController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add any additional details...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textInversePrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _existingTask == null ? 'Create Task' : 'Update Task',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
