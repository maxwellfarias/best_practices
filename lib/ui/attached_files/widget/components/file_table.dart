import 'package:flutter/material.dart';
import '../../../../domain/models/file_model.dart';
import '../../../core/extensions/build_context_extension.dart';
import 'file_table_row.dart';

class FileTable extends StatelessWidget {
  final List<FileModel> files;
  final Set<int> selectedFiles;
  final bool selectAll;
  final ValueChanged<bool?> onSelectAll;
  final void Function(int index, bool? value) onFileSelected;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;

  const FileTable({
    super.key,
    required this.files,
    required this.selectedFiles,
    required this.selectAll,
    required this.onSelectAll,
    required this.onFileSelected,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(48),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1.5),
            5: FlexColumnWidth(2.5),
            6: FixedColumnWidth(150),
          },
          children: [
            // Header row
            TableRow(
              decoration: BoxDecoration(
                color: context.customColorTheme.muted.withOpacity(0.4),
              ),
              children: [
                _buildHeaderCell(
                  context,
                  Checkbox(
                    value: selectAll,
                    onChanged: onSelectAll,
                    activeColor: context.customColorTheme.primary,
                    side: BorderSide(color: context.customColorTheme.border),
                  ),
                ),
                _buildHeaderCell(
                  context,
                  Text(
                    'File name',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ),
                _buildHeaderCell(
                  context,
                  Text(
                    'File size',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ),
                _buildHeaderCell(
                  context,
                  Text(
                    'Date uploaded',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ),
                _buildHeaderCell(
                  context,
                  Text(
                    'Last updated',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ),
                _buildHeaderCell(
                  context,
                  Text(
                    'Uploaded by',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ),
                _buildHeaderCell(context, const SizedBox.shrink()),
              ],
            ),
            // Data rows
            ...List.generate(
              files.length,
              (index) => FileTableRow.build(
                context,
                files[index],
                selectedFiles.contains(index),
                (value) => onFileSelected(index, value),
                () => onEdit(index),
                () => onDelete(index),
                index == files.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: child,
    );
  }
}
