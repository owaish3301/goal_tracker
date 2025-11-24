import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goal_tracker/core/theme/app_colors.dart';

class DurationPicker extends StatelessWidget {
  final int durationMinutes;
  final ValueChanged<int> onChanged;

  const DurationPicker({
    super.key,
    required this.durationMinutes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target Duration',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Hours
            Expanded(
              child: _DurationInput(
                label: 'Hours',
                value: hours,
                onChanged: (newHours) {
                  onChanged(newHours * 60 + minutes);
                },
              ),
            ),
            const SizedBox(width: 16),
            // Minutes
            Expanded(
              child: _DurationInput(
                label: 'Minutes',
                value: minutes,
                maxValue: 59,
                onChanged: (newMinutes) {
                  onChanged(hours * 60 + newMinutes);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _formatDuration(durationMinutes),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) {
      return 'Total: ${h}h ${m}m';
    } else if (h > 0) {
      return 'Total: ${h}h';
    } else {
      return 'Total: ${m}m';
    }
  }
}

class _DurationInput extends StatefulWidget {
  final String label;
  final int value;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const _DurationInput({
    required this.label,
    required this.value,
    this.maxValue = 99,
    required this.onChanged,
  });

  @override
  State<_DurationInput> createState() => _DurationInputState();
}

class _DurationInputState extends State<_DurationInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(_DurationInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text only if value changed externally (e.g., from buttons)
    if (widget.value != oldWidget.value &&
        _controller.text != widget.value.toString()) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Decrement button
            IconButton(
              onPressed: widget.value > 0
                  ? () => widget.onChanged(widget.value - 1)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.primary,
            ),
            // Input field
            Expanded(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (text) {
                  if (text.isEmpty) {
                    widget.onChanged(0);
                    return;
                  }
                  final newValue = int.tryParse(text) ?? 0;
                  if (newValue <= widget.maxValue) {
                    widget.onChanged(newValue);
                  } else {
                    // Reset to max value if exceeded
                    _controller.text = widget.maxValue.toString();
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length),
                    );
                    widget.onChanged(widget.maxValue);
                  }
                },
              ),
            ),
            // Increment button
            IconButton(
              onPressed: widget.value < widget.maxValue
                  ? () => widget.onChanged(widget.value + 1)
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
