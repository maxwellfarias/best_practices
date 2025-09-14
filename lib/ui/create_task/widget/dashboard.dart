import 'package:flutter/material.dart';
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
      date: "Friday, 08 July 2022",
      category: "Teams",
      progress: 0.78,
      teamMembers: ["👨‍💻", "👩‍💻", "👨‍🎨", "👩‍🎨"],
      completed: false,
    ),
    Task(
      id: "2", 
      title: "Weekly Report Meeting",
      description: "Meet with the team to discuss project progress.",
      date: "Friday, 08 July 2022",
      category: "Teams",
      progress: 0.45,
      teamMembers: ["👨‍💼", "👩‍💼"],
      completed: false,
    ),
  ];

  final List<Task> completedTasks = [
    Task(
      id: "3",
      title: "Meeting with Client",
      description: "Redesign motion graphic.",
      date: "Today 11:25 PM",
      category: "Personal",
      progress: 1.0,
      teamMembers: ["👨‍💻", "👩‍💻"],
      completed: true,
    ),
    Task(
      id: "4",
      title: "Task Explore NFT",
      description: "Explore design mobile UI.",
      date: "01 July 10:30 AM",
      category: "Personal", 
      progress: 1.0,
      teamMembers: ["👨‍🎨", "👩‍🎨"],
      completed: true,
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
          'date': task.date,
          'category': task.category,
          'completed': task.completed,
          'progress': task.progress,
          'teamMembers': task.teamMembers,
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
            task.date,
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
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              const Text(
                'Teams :',
                style: TextStyle(
                  color: Color(0xFF6E6E73),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              ...task.teamMembers.take(4).map(
                (member) => Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: Text(member, style: const TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progress :',
                      style: TextStyle(
                        color: Color(0xFF6E6E73),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: task.progress,
                      backgroundColor: const Color(0xFFF0F0F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(task.progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF1D1D1F),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
          'category': task.category,
          'completed': task.completed,
          'progress': task.progress,
          'teamMembers': task.teamMembers,
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
              color: task.category == "Personal" ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4),
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
                  task.date,
                  style: const TextStyle(
                    color: Color(0xFF6E6E73),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: task.teamMembers.take(2).map(
              (member) => Container(
                margin: const EdgeInsets.only(left: 4),
                child: Text(member, style: const TextStyle(fontSize: 20)),
              ),
            ).toList(),
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

// Model class
class Task {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category;
  final double progress;
  final List<String> teamMembers;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.progress,
    required this.teamMembers,
    required this.completed,
  });
}