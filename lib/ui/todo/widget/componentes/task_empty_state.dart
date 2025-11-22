import 'package:flutter/material.dart';
import 'package:best_practices/ui/core/extensions/build_context_extension.dart';

/// Widget for empty state (when there are no tasks)
class TaskEmptyState extends StatelessWidget {
  const TaskEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Checklist icon
          Icon(
            Icons.checklist_rounded,
            size: 80,
            color: context.customColorTheme.mutedForeground,
          ),

          const SizedBox(height: 16),

          // Message
          Text(
            'No tasks found',
            style: context.customTextTheme.textLgMedium.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),

          const SizedBox(height: 8),

          // Submessage
          Text(
            'Tap the + button to create a new task',
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
