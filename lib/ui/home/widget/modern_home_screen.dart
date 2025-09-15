import 'package:flutter/material.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/ui/dashboard/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/routing/navigation_extensions.dart';
import 'package:provider/provider.dart';

/// HomeScreen moderna integrada com o sistema de navegação GoRouter
/// 
/// Esta tela serve como exemplo de como integrar nossa interface moderna
/// com o sistema de navegação baseado em GoRouter.
class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  late TaskViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    // O viewModel seria injetado via Provider em um app real
    viewModel = context.read<TaskViewmodel>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Tasks',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.goToCreateTask(),
            icon: const Icon(
              Icons.add,
              color: Color(0xFF6B73FF),
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel.fetchTasks,
        builder: (context, _) {
          if (viewModel.fetchTasks.running) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.fetchTasks.error) {
            return _buildErrorWidget();
          }

          final tasks = viewModel.fetchTasks.value ?? [];
          
          if (tasks.isEmpty) {
            return _buildEmptyState();
          }

          return _buildTaskList(tasks);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goToCreateTask(),
        backgroundColor: const Color(0xFF6B73FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New Task',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navegar para TaskDetailScreen (tela moderna)
          context.goToTaskDetail(task.id, task, viewModel);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted 
                          ? Colors.grey 
                          : const Color(0xFF1A1A1A),
                        decoration: task.isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                      ),
                    ),
                  ),
                  _buildTaskStatusChip(task),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: task.isCompleted 
                      ? Colors.grey 
                      : const Color(0xFF666666),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  _buildTaskActions(task),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskStatusChip(Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: task.isCompleted 
          ? Colors.green.withOpacity(0.1)
          : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        task.isCompleted ? 'Completed' : 'Pending',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: task.isCompleted ? Colors.green[700] : Colors.orange[700],
        ),
      ),
    );
  }

  Widget _buildTaskActions(Task task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _toggleTask(task),
          icon: Icon(
            task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : Colors.grey,
            size: 20,
          ),
        ),
        IconButton(
          onPressed: () {
            // Navegar para EditTaskScreen (tela antiga com Map)
            final taskMap = TaskNavigationHelper.taskToMap(task);
            context.goToEditTask(task.id, taskMap);
          },
          icon: const Icon(
            Icons.edit,
            color: Color(0xFF6B73FF),
            size: 20,
          ),
        ),
        IconButton(
          onPressed: () => _deleteTask(task),
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first task to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.goToCreateTask(),
            icon: const Icon(Icons.add),
            label: const Text('Create Task'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B73FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => viewModel.fetchTasks.execute(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _toggleTask(Task task) async {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    
    await viewModel.updateTask.execute(updatedTask);
    
    if (viewModel.updateTask.completed) {
      // Atualizar a lista
      viewModel.fetchTasks.execute();
    }
  }

  void _deleteTask(Task task) async {
    // Mostrar confirmação
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await viewModel.deleteTask.execute(task.id);
      
      if (viewModel.deleteTask.completed) {
        // Atualizar a lista
        viewModel.fetchTasks.execute();
        
        // Mostrar feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }
}
