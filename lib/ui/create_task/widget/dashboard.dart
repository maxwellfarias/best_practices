import 'package:flutter/material.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/routing/navigation_extensions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data - substituir pela lógica real
  final List<Task> onProgressTasks = [
    Task(
      id: "1",
      title: "Design UI ToDo APP",
      description: "Design a simple home pages with clean layout and color based on the guidelines.",
      date: DateTime(2012, 7, 8),
      isCompleted: false,
      completedAt: DateTime(2012, 7, 10)
    ),
    Task(
      id: "2",
      title: "Design UI ToDo APP",
      description: "Design a simple home pages with clean layout and color based on the guidelines.",
      date: DateTime(2012, 7, 8),
      isCompleted: false,
      completedAt: DateTime(2012, 7, 10)
    ),
    Task(
      id: "3",
      title: "Design UI ToDo APP",
      description: "Design a simple home pages with clean layout and color based on the guidelines.",
      date: DateTime(2012, 7, 8),
      isCompleted: false,
      completedAt: DateTime(2012, 7, 10)
    ),
  ];

  final List<Task> completedTasks = [
    Task(
      id: "2",
      title: "Meeting with Clients",
      description: "Meeting with clients to discuss the project requirements and deliverables.",
      date: DateTime(2012, 7, 8),
      isCompleted: true,
      completedAt: DateTime(2012, 7, 10)
    ),
    Task(
      id: "3",
      title: "Create Wireframe",
      description: "Create wireframe for the new mobile application.",
      date: DateTime(2012, 7, 8),
      isCompleted: true,
      completedAt: DateTime(2012, 7, 10)
    ),
    Task(
      id: "4",
      title: "Fix Bugs",
      description: "Fix bugs in the existing codebase and improve performance.",
      date: DateTime(2012, 7, 8),
      isCompleted: true,
      completedAt: DateTime(2012, 7, 10)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/50'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: TextStyle(
                            color: Color(0xFF6E6E73),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Joko Husein',
                          style: TextStyle(
                            color: Color(0xFF1D1D1F),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today_outlined),
                    color: const Color(0xFF6E6E73),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                    color: const Color(0xFF6E6E73),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // On Progress Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'On Progress (${onProgressTasks.length})',
                    style: const TextStyle(
                      color: Color(0xFF1D1D1F),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View More',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // On Progress Tasks
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: onProgressTasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(onProgressTasks[index], false);
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Completed Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Completed',
                    style: TextStyle(
                      color: Color(0xFF1D1D1F),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View More',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Completed Tasks List
              Expanded(
                child: ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    return _buildCompletedTaskItem(completedTasks[index]);
                  },
                ),
              ),

              // Create New Button
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegar para tela de criar tarefa
                    context.goToCreateTask();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Create New',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, bool isCompleted) {
    return GestureDetector(
      onTap: () {
        // Navegar para ViewTaskScreen para ver detalhes
        final taskMap = {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'date': task.date.toIso8601String(),
        };
        context.goToViewTask(task.id, taskMap);
      },
      child: Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    color: Color(0xFF1D1D1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '🎯',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            task.date.toIso8601String(),
            style: const TextStyle(
              color: Color(0xFF6E6E73),
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            task.description,
            style: const TextStyle(
              color: Color(0xFF6E6E73),
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildCompletedTaskItem(Task task) {
    return GestureDetector(
      onTap: () {
        // Navegar para ViewTaskScreen para ver detalhes
        final taskMap = {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'date': task.date,
        };
        context.goToViewTask(task.id, taskMap);
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
             Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: true ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Color(0xFF1D1D1F),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: const TextStyle(
                    color: Color(0xFF6E6E73),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.date.toIso8601String(),
                  style: const TextStyle(
                    color: Color(0xFF6E6E73),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
