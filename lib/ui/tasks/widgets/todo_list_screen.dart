import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  String selectedFilter = 'All';
  List<TaskItem> tasks = [
    TaskItem(
      title: 'Grocery Shopping',
      description: 'Buy groceries for the week.',
      createdAt: '2024-01-15 10:00 AM',
      isCompleted: false,
      accentColor: const Color(0xFFF0FBF4), // mint-green
    ),
    TaskItem(
      title: 'Project Meeting',
      description: 'Discuss project milestones with the team.',
      createdAt: '2024-01-15 11:30 AM',
      isCompleted: true,
      accentColor: const Color(0xFFF2F0FB), // lavender
    ),
    TaskItem(
      title: 'Gym Workout',
      description: 'Leg day workout.',
      createdAt: '2024-01-15 02:00 PM',
      isCompleted: false,
      accentColor: const Color(0xFFFFF0E6), // peach
    ),
    TaskItem(
      title: 'Read a Book',
      description: 'Read \'The Great Gatsby\'.',
      createdAt: '2024-01-15 04:30 PM',
      isCompleted: true,
      accentColor: const Color(0xFFE6F7FF), // sky-blue
    ),
    TaskItem(
      title: 'Dinner with Friends',
      description: 'Meet friends at a restaurant.',
      createdAt: '2024-01-15 07:00 PM',
      isCompleted: true,
      accentColor: const Color(0xFFFFF0F3), // soft-pink
    ),
  ];

  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  List<TaskItem> get filteredTasks {
    switch (selectedFilter) {
      case 'Active':
        return tasks.where((task) => !task.isCompleted).toList();
      case 'Completed':
        return tasks.where((task) => task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // bg-gray-50
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)), // border-gray-200
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 768 ? 40 : 16,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FBF4), // mint-green
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.task_alt,
                      color: Color(0xFF059669), // green-600
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'My Todo List',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937), // text-gray-800
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6), // bg-gray-100
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$totalTasks',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Tasks',
                      style: TextStyle(
                        color: Color(0xFF6B7280), // text-gray-500
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 1,
                      height: 16,
                      color: const Color(0xFFD1D5DB), // bg-gray-300
                    ),
                    Text(
                      '$completedTasks',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Completed',
                      style: TextStyle(
                        color: Color(0xFF6B7280), // text-gray-500
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 1024 ? 96.0 : screenWidth > 768 ? 40.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            _buildFilterButtons(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildTaskGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6), // bg-gray-100
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: ['All', 'Active', 'Completed'].map((filter) {
            final isSelected = selectedFilter == filter;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF1F2937)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTaskGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth > 1024) {
      crossAxisCount = 3;
    } else if (screenWidth > 640) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.5,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(filteredTasks[index]);
      },
    );
  }

  Widget _buildTaskCard(TaskItem task) {
    return MouseRegion(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF10B981),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: task.isCompleted
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF1F2937),
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF6B7280),
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Created: ${task.createdAt}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(Icons.edit, () {}),
                        const SizedBox(width: 8),
                        _buildActionButton(Icons.delete, () {}, isDelete: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 4,
              color: task.accentColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, {bool isDelete = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDelete ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Adicionar nova tarefa
      },
      backgroundColor: const Color(0xFF10B981),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

class TaskItem {
  String title;
  String description;
  String createdAt;
  bool isCompleted;
  Color accentColor;

  TaskItem({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isCompleted,
    required this.accentColor,
  });
}