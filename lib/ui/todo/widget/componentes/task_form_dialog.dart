import 'package:flutter/material.dart';
import 'package:best_practices/domain/models/task_model.dart';
import 'package:best_practices/ui/core/extensions/build_context_extension.dart';

/// Dialog for creating and editing tasks
///
/// Has two modes:
/// - Creation: task == null
/// - Edition: task != null
class TaskFormDialog extends StatefulWidget {
  final TaskModel? task;
  final Function(String title, String description) onSave;

  const TaskFormDialog({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.task?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Dialog(
      backgroundColor: context.customColorTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dialog title
              Text(
                isEditing ? 'Edit Task' : 'New Task',
                style: context.customTextTheme.text2xlBold.copyWith(
                  color: context.customColorTheme.cardForeground,
                ),
              ),

              const SizedBox(height: 24),

              // Title field
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  labelStyle: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                  hintText: 'Enter task title',
                  hintStyle: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                  filled: true,
                  fillColor: context.customColorTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.destructive,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.destructive,
                      width: 2,
                    ),
                  ),
                ),
                style: context.customTextTheme.textBase.copyWith(
                  color: context.customColorTheme.cardForeground,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  labelText: 'Description',
                  labelStyle: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                  hintText: 'Enter task description (optional)',
                  hintStyle: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                  filled: true,
                  fillColor: context.customColorTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: context.customColorTheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                style: context.customTextTheme.textBase.copyWith(
                  color: context.customColorTheme.cardForeground,
                ),
              ),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel button
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.customColorTheme.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: context.customColorTheme.border,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Fechar',
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.mutedForeground,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Save button
                  ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.customColorTheme.primary,
                      foregroundColor: context.customColorTheme.primaryForeground,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Save' : 'Create',
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.primaryForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
