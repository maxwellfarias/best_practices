import 'package:flutter/material.dart';
import 'package:best_practices/domain/models/task_model.dart';
import 'package:best_practices/ui/core/extensions/build_context_extension.dart';

/// Task card following HTML design with 100% fidelity
///
/// Structure:
/// - Left: Circular checkbox with colored border
/// - Center: Task title + date/time with icons
/// - Right: Category tag
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final int index;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
    required this.index,
  });

  /// Returns checkbox border color based on index
  /// Alternates between blue, red and gray for visual variety
  Color _getBorderColor(BuildContext context) {
    if (task.isCompleted) {
      return context.customColorTheme.mutedForeground;
    }

    // Alternates colors to simulate different priorities
    switch (index % 3) {
      case 0:
        return context.customColorTheme.primary; // Blue
      case 1:
        return context.customColorTheme.destructive; // Red
      default:
        return context.customColorTheme.border; // Gray
    }
  }

  /// Returns date/time text color
  Color _getDateTimeColor(BuildContext context) {
    if (task.isCompleted) {
      return context.customColorTheme.mutedForeground;
    }
    return context.customColorTheme.success; // Green as in HTML
  }

  /// Formats creation date
  String _formatDateTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(
      task.createdAt.year,
      task.createdAt.month,
      task.createdAt.day,
    );

    if (taskDate == today) {
      // Shows time if today
      final hour = task.createdAt.hour.toString().padLeft(2, '0');
      final minute = task.createdAt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    } else {
      // Shows day of week if another day
      final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
      return weekdays[task.createdAt.weekday % 7];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), // space-y-2 do HTML
        padding: const EdgeInsets.all(16), // p-4 do HTML
        decoration: BoxDecoration(
          color: context.customColorTheme.card,
          borderRadius: BorderRadius.circular(12), // rounded-lg
          border: Border.all(
            color: context.customColorTheme.border,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular checkbox (left)
            _buildCheckbox(context),

            const SizedBox(width: 16), // space-x-4 from HTML

            // Main content (center)
            Expanded(
              child: _buildContent(context),
            ),

            const SizedBox(width: 8),

            // Category tag (right)
            _buildCategoryTag(context),
          ],
        ),
      ),
    );
  }

  /// Circular checkbox with colored border
  Widget _buildCheckbox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4), // pt-1 from HTML
      child: GestureDetector(
        onTap: onToggleComplete,
        child: Container(
          width: 24, // w-6 do HTML
          height: 24, // h-6 do HTML
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getBorderColor(context),
              width: 2,
            ),
            color: task.isCompleted
                ? _getBorderColor(context).withValues(alpha: 0.2)
                : Colors.transparent,
          ),
          child: task.isCompleted
              ? Icon(
                  Icons.check,
                  size: 16,
                  color: _getBorderColor(context),
                )
              : null,
        ),
      ),
    );
  }

  /// Main content: title + date/time
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Task title
        Text(
          task.title,
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.cardForeground,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),

        const SizedBox(height: 4), // mt-1 from HTML

        // Date/time with icons
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16, // text-base from HTML
              color: _getDateTimeColor(context),
            ),
            const SizedBox(width: 6), // mr-1.5 from HTML
            Text(
              _formatDateTime(),
              style: context.customTextTheme.textSm.copyWith(
                color: _getDateTimeColor(context),
              ),
            ),
            const SizedBox(width: 8), // ml-2 from HTML
            Icon(
              Icons.repeat,
              size: 16,
              color: _getDateTimeColor(context),
            ),
          ],
        ),
      ],
    );
  }

  /// Category tag (right)
  Widget _buildCategoryTag(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4), // pt-1 from HTML
      child: Text(
        'Tasks #',
        style: context.customTextTheme.textSm.copyWith(
          color: context.customColorTheme.mutedForeground,
        ),
      ),
    );
  }
}
