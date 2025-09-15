import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/routing/navigation_extensions.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';
import 'package:mastering_tests/utils/extensions/datetime.dart';

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
      backgroundColor: context.customColorTheme.bgPrimary,
      appBar: AppBar(
        title: Text('Home'),
        titleTextStyle: context.customTextTheme.textXlSemibold.copyWith(color: context.customColorTheme.textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para CreateTaskScreen
          context.goToCreateTask();
        },
        backgroundColor: context.customColorTheme.fgBrandPrimary,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              // On Progress Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Em andamento (${onProgressTasks.length})',
                    style: context.customTextTheme.textLgSemibold
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver mais',
                      style: context.customTextTheme.textSmSemibold.copyWith(color: context.customColorTheme.fgBrandSecondary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // On Progress Tasks
              SizedBox(
                height: 226,
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
                  Text(
                    'Concluído (${completedTasks.length})',
                    style: context.customTextTheme.textLgSemibold,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Ver mais',
                      style: context.customTextTheme.textSmSemibold.copyWith(color: context.customColorTheme.fgBrandSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Completed Tasks List
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    return _buildCompletedTaskItem(completedTasks[index]);
                  },
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
        color: context.customColorTheme.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.customColorTheme.borderSecondary,
          width: 1,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: context.customTextTheme.textLgSemibold,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),
          
          Text(
            task.date.toBrString(),
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.textTertiary,
            ),
          ),

            const SizedBox(height: 4),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Alta",
                style: context.customTextTheme.textXsBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 16),

            Text(
            task.description,
            style: context.customTextTheme.textMd.copyWith(
              color: context.customColorTheme.textTertiary,
            ),
            maxLines: 3,
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
        color: context.customColorTheme.bgPrimary,
        borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: context.customColorTheme.borderSecondary,
        width: 1,
      ),
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
                  style: context.customTextTheme.textMdSemibold,
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.date.toBrString(),
                  style: context.customTextTheme.textXsBold.copyWith(
                    color: context.customColorTheme.textBrandSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),

            Checkbox.adaptive(value: true, onChanged: (_) {}),
        ],
      ),
    ),
    );
  }
}
