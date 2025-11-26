import 'package:flutter/material.dart';
import '../../../domain/models/file_model.dart';
import '../../../utils/mocks/file_mock.dart';
import '../../core/extensions/build_context_extension.dart';
import 'components/file_table.dart';

class AttachedFilesScreen extends StatefulWidget {
  const AttachedFilesScreen({super.key});

  @override
  State<AttachedFilesScreen> createState() => _AttachedFilesScreenState();
}

class _AttachedFilesScreenState extends State<AttachedFilesScreen> {
  int _selectedTabIndex = 1; // 0 = View all, 1 = Your files, 2 = Shared files
  final TextEditingController _searchController = TextEditingController();
  final List<FileModel> _files = FileMock.getFiles();
  final Set<int> _selectedFiles = {};
  bool _selectAll = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        _selectedFiles.addAll(List.generate(_files.length, (index) => index));
      } else {
        _selectedFiles.clear();
      }
    });
  }

  void _toggleFileSelection(int index, bool? value) {
    setState(() {
      if (value ?? false) {
        _selectedFiles.add(index);
      } else {
        _selectedFiles.remove(index);
      }
      _selectAll = _selectedFiles.length == _files.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColorTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attached files',
                        style: context.customTextTheme.text3xlBold.copyWith(
                          color: context.customColorTheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Files and assets that have been attached to this project.',
                        style: context.customTextTheme.textBase.copyWith(
                          color: context.customColorTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tabs and Search/Filter Row
              Row(
                children: [
                  // Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.customColorTheme.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildTab('View all', 0),
                        _buildTab('Your files', 1),
                        _buildTab('Shared files', 2),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Search bar
                  Container(
                    width: 256,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.customColorTheme.card,
                      border: Border.all(
                        color: context.customColorTheme.border,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: context.customTextTheme.textSm.copyWith(
                        color: context.customColorTheme.foreground,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search for trades',
                        hintStyle: context.customTextTheme.textSm.copyWith(
                          color: context.customColorTheme.mutedForeground,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: context.customColorTheme.mutedForeground,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.customColorTheme.muted,
                              border: Border.all(
                                color: context.customColorTheme.border,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '⌘K',
                              style: context.customTextTheme.textXs.copyWith(
                                color: context.customColorTheme.mutedForeground,
                              ),
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Filters button
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.filter_list,
                      size: 20,
                      color: context.customColorTheme.foreground,
                    ),
                    label: Text(
                      'Filters',
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.foreground,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: context.customColorTheme.card,
                      side: BorderSide(color: context.customColorTheme.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Table
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.customColorTheme.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FileTable(
                    files: _files,
                    selectedFiles: _selectedFiles,
                    selectAll: _selectAll,
                    onSelectAll: _toggleSelectAll,
                    onFileSelected: _toggleFileSelection,
                    onEdit: (index) {
                      // Handle edit
                    },
                    onDelete: (index) {
                      // Handle delete
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? context.customColorTheme.card
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: context.customTextTheme.textSmMedium.copyWith(
            color: isSelected
                ? context.customColorTheme.foreground
                : context.customColorTheme.mutedForeground,
          ),
        ),
      ),
    );
  }
}
