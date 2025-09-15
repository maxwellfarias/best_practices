import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mastering_tests/routing/routes.dart';
import 'package:mastering_tests/domain/models/task.dart';

/// Extension methods para facilitar a navegação entre telas
extension NavigationExtensions on BuildContext {
  
  // Navigation to home
  void goToHome() => go(Routes.home);
  
  // Navigation to task management screens
  void goToCreateTask() => go(Routes.createTask);
  
  void goToEditTask(String taskId, Map<String, dynamic> taskData) {
    go('${Routes.editTask}/$taskId', extra: taskData);
  }
  
  void goToViewTask(String taskId, Map<String, dynamic> taskData) {
    go('${Routes.viewTask}/$taskId', extra: taskData);
  }
  
  void goToTaskDetail(String taskId, Task task, dynamic viewModel) {
    go('${Routes.taskDetail}/$taskId', extra: {
      'task': task,
      'viewModel': viewModel,
    });
  }
  
  // Push methods (for navigation stack)
  void pushCreateTask() => push(Routes.createTask);
  
  void pushEditTask(String taskId, Map<String, dynamic> taskData) {
    push('${Routes.editTask}/$taskId', extra: taskData);
  }
  
  void pushViewTask(String taskId, Map<String, dynamic> taskData) {
    push('${Routes.viewTask}/$taskId', extra: taskData);
  }
  
  void pushTaskDetail(String taskId, Task task, dynamic viewModel) {
    push('${Routes.taskDetail}/$taskId', extra: {
      'task': task,
      'viewModel': viewModel,
    });
  }
}

/// Helper class para converter entre diferentes formatos de Task
class TaskNavigationHelper {
  
  /// Converte Task domain para Map (para telas antigas)
  static Map<String, dynamic> taskToMap(Task task) {
    return {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'completed': task.isCompleted,
      'date': task.date.toIso8601String(),
      'time': '${task.date.hour.toString().padLeft(2, '0')}:${task.date.minute.toString().padLeft(2, '0')}',
      'category': 'Personal', // Default category since domain Task doesn't have this
    };
  }
  
  /// Converte Map (das telas antigas) para Task domain
  static Task mapToTask(Map<String, dynamic> taskMap) {
    return Task(
      id: taskMap['id'] ?? '',
      title: taskMap['title'] ?? '',
      description: taskMap['description'] ?? '',
      isCompleted: taskMap['completed'] ?? false,
      date: taskMap['date'] != null 
        ? DateTime.parse(taskMap['date'])
        : DateTime.now(),
      completedAt: taskMap['completed'] == true 
        ? (taskMap['date'] != null ? DateTime.parse(taskMap['date']) : DateTime.now())
        : null,
    );
  }
}
