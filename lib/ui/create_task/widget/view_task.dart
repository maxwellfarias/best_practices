import 'package:flutter/material.dart';
import 'package:mastering_tests/routing/navigation_extensions.dart';

class ViewTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const ViewTaskScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.task['completed'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF6E6E73),
          ),
        ),
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF6E6E73),
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _navigateToEdit();
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              } else if (value == 'duplicate') {
                _duplicateTask();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, color: Color(0xFF007AFF), size: 20),
                    SizedBox(width: 8),
                    Text('Edit Task'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.content_copy, color: Color(0xFF6E6E73), size: 20),
                    SizedBox(width: 8),
                    Text('Duplicate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.task['category'] == 'Personal' 
                                ? const Color(0xFFFFE5E5) 
                                : const Color(0xFFFFF3CD),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.task['category'] == 'Personal' ? '👤' : '🎯',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.task['title'],
                                style: const TextStyle(
                                  color: Color(0xFF1D1D1F),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.task['category'],
                                style: const TextStyle(
                                  color: Color(0xFF6E6E73),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleTaskStatus,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isCompleted 
                                  ? const Color(0xFF007AFF) 
                                  : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              _isCompleted ? Icons.check : Icons.radio_button_unchecked,
                              color: _isCompleted ? Colors.white : const Color(0xFF6E6E73),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Status Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isCompleted 
                                ? const Color(0xFFE8F5E8) 
                                : const Color(0xFFFFF3CD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isCompleted ? '✅ Completed' : '🔄 In Progress',
                            style: TextStyle(
                              color: _isCompleted 
                                  ? const Color(0xFF4CAF50) 
                                  : const Color(0xFFF57C00),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (widget.task['progress'] != null)
                          Text(
                            '${(widget.task['progress'] * 100).toInt()}%',
                            style: const TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Task Details Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task Details',
                      style: TextStyle(
                        color: Color(0xFF1D1D1F),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildDetailItem(
                      icon: Icons.description_outlined,
                      title: 'Description',
                      content: widget.task['description'] ?? 'No description provided',
                      isDescription: true,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Date & Time Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Date',
                            content: widget.task['date'] != null 
                                ? _formatDate(DateTime.parse(widget.task['date']))
                                : 'Not set',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDetailItem(
                            icon: Icons.access_time_outlined,
                            title: 'Time',
                            content: widget.task['time'] ?? 'Not set',
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Creation Date
                    _buildDetailItem(
                      icon: Icons.schedule_outlined,
                      title: 'Created',
                      content: _formatDateTime(DateTime.parse(widget.task['createdAt'])),
                    ),
                    
                    if (widget.task['updatedAt'] != null) ...[
                      const SizedBox(height: 20),
                      _buildDetailItem(
                        icon: Icons.update_outlined,
                        title: 'Last Updated',
                        content: _formatDateTime(DateTime.parse(widget.task['updatedAt'])),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Progress Section (if applicable)
              if (widget.task['progress'] != null && !_isCompleted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              color: Color(0xFF1D1D1F),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(widget.task['progress'] * 100).toInt()}%',
                            style: const TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      LinearProgressIndicator(
                        value: widget.task['progress'],
                        backgroundColor: const Color(0xFFF0F0F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _navigateToEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit Task'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF007AFF)),
                        foregroundColor: const Color(0xFF007AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleTaskStatus,
                      icon: Icon(
                        _isCompleted ? Icons.refresh : Icons.check,
                        size: 18,
                      ),
                      label: Text(_isCompleted ? 'Mark Pending' : 'Mark Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCompleted 
                            ? const Color(0xFF6E6E73) 
                            : const Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String content,
    bool isDescription = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF007AFF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6E6E73),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: const Color(0xFF1D1D1F),
                    fontSize: isDescription ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    height: isDescription ? 1.4 : 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleTaskStatus() {
    setState(() {
      _isCompleted = !_isCompleted;
      widget.task['completed'] = _isCompleted;
      widget.task['updatedAt'] = DateTime.now().toIso8601String();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCompleted 
              ? 'Task marked as completed! 🎉' 
              : 'Task marked as pending',
        ),
        backgroundColor: _isCompleted 
            ? const Color(0xFF4CAF50) 
            : const Color(0xFF007AFF),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToEdit() {
    // Navegar para EditTaskScreen usando GoRouter
    context.goToEditTask(widget.task['id'], widget.task);
  }

  void _duplicateTask() {
    final duplicatedTask = {
      ...widget.task,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': '${widget.task['title']} (Copy)',
      'completed': false,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': null,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task duplicated successfully!'),
        backgroundColor: Color(0xFF007AFF),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, {'action': 'duplicate', 'task': duplicatedTask});
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Task',
          style: TextStyle(
            color: Color(0xFF1D1D1F),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.task['title']}"? This action cannot be undone.',
          style: const TextStyle(color: Color(0xFF6E6E73)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6E6E73)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, {'action': 'delete', 'task': widget.task}); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Mock data for testing the ViewTaskScreen
final Map<String, dynamic> mockTask = {
  'id': '1',
  'title': 'Complete Flutter Project',
  'description': 'Finish the task management app with all features including create, edit, delete, and view functionality. Make sure to implement proper state management and user interface.',
  'category': 'Personal',
  'completed': false,
  'progress': 0.75,
  'date': '2024-01-15T00:00:00.000Z',
  'time': '14:30',
  'createdAt': '2024-01-10T09:30:00.000Z',
  'updatedAt': '2024-01-14T16:45:00.000Z',
};

// Additional mock tasks for testing different scenarios
final Map<String, dynamic> mockCompletedTask = {
  'id': '2',
  'title': 'Review Code Documentation',
  'description': 'Review and update all code documentation for the project',
  'category': 'Work',
  'completed': true,
  'progress': 1.0,
  'date': '2024-01-12T00:00:00.000Z',
  'time': '10:00',
  'createdAt': '2024-01-08T08:15:00.000Z',
  'updatedAt': '2024-01-12T10:30:00.000Z',
};

final Map<String, dynamic> mockTaskMinimal = {
  'id': '3',
  'title': 'Quick Meeting',
  'category': 'Work',
  'completed': false,
  'createdAt': '2024-01-15T11:00:00.000Z',
  // Optional fields are null/missing
  'description': null,
  'progress': null,
  'date': null,
  'time': null,
  'updatedAt': null,
};
