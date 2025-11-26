import 'package:flutter/material.dart';
import '../../../../domain/models/file_model.dart';
import '../../../core/extensions/build_context_extension.dart';

class FileTableRow extends TableRow {
  final FileModel file;
  final bool isSelected;
  final ValueChanged<bool?> onSelected;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isLastRow;

  FileTableRow({
    required this.file,
    required this.isSelected,
    required this.onSelected,
    required this.onEdit,
    required this.onDelete,
    this.isLastRow = false,
  }) : super(decoration: const BoxDecoration(), children: []);

  static TableRow build(
    BuildContext context,
    FileModel file,
    bool isSelected,
    ValueChanged<bool?> onSelected,
    VoidCallback onEdit,
    VoidCallback onDelete,
    bool isLastRow,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        color: context.customColorTheme.background,
        border: isLastRow
            ? null
            : Border(
                bottom: BorderSide(color: context.customColorTheme.border),
              ),
      ),
      children: [
        // Checkbox
        _buildCell(
          context,
          Checkbox(
            value: isSelected,
            onChanged: onSelected,
            activeColor: context.customColorTheme.primary,
            side: BorderSide(color: context.customColorTheme.border),
          ),
          isLastRow,
        ),

        // File name with icon
        _buildCell(
          context,
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  file.iconUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: context.customColorTheme.muted,
                      child: Icon(
                        Icons.insert_drive_file,
                        color: context.customColorTheme.mutedForeground,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      file.fileName,
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.foreground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      file.fileSize,
                      style: context.customTextTheme.textSm.copyWith(
                        color: context.customColorTheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isLastRow,
        ),

        // File size
        _buildCell(
          context,
          Text(
            file.fileSize,
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),
          isLastRow,
        ),

        // Date uploaded
        _buildCell(
          context,
          Text(
            file.dateUploaded,
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),
          isLastRow,
        ),

        // Last updated
        _buildCell(
          context,
          Text(
            file.lastUpdated,
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),
          isLastRow,
        ),

        // Uploaded by
        _buildCell(
          context,
          Row(
            children: [
              // Avatar or initials
              if (file.uploadedBy.avatarUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    file.uploadedBy.avatarUrl!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildInitialsAvatar(context, file.uploadedBy);
                    },
                  ),
                )
              else
                _buildInitialsAvatar(context, file.uploadedBy),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      file.uploadedBy.name,
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.foreground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      file.uploadedBy.email,
                      style: context.customTextTheme.textSm.copyWith(
                        color: context.customColorTheme.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          isLastRow,
        ),

        // Actions
        _buildCell(
          context,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onDelete,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Delete',
                  style: context.customTextTheme.textSmMedium.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Edit',
                  style: context.customTextTheme.textSmMedium.copyWith(
                    color: context.customColorTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          isLastRow,
        ),
      ],
    );
  }

  static Widget _buildCell(BuildContext context, Widget child, bool isLastRow) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: isLastRow ? 16 : 16,
      ),
      child: child,
    );
  }

  static Widget _buildInitialsAvatar(BuildContext context, UserInfo user) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.customColorTheme.muted,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
      ),
    );
  }
}
