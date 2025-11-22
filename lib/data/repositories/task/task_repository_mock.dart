import 'dart:async';
import 'package:best_practices/domain/models/task_model.dart';
import 'package:best_practices/templates/flutter_templates/simple_mock_template.dart';
import '../../../utils/result.dart';
import 'task_repository.dart';

/// Mock implementation of TaskRepository for development and testing.
/// Uses in-memory mock data from TaskMock template.
/// This is the default repository implementation used in the app.
class TaskRepositoryMock implements TaskRepository {
  TaskRepositoryMock();

  @override
  Future<Result<TaskModel>> createTask({required TaskModel task}) async {
    return TaskMock.addTask(task);
  }

  @override
  Future<Result<dynamic>> deleteTask({required String taskId}) async {
    return TaskMock.deleteTask(taskId);
  }

  @override
  Future<Result<List<TaskModel>>> getAllTasks() async {
    return TaskMock.getMockTasks();
  }

  @override
  Future<Result<TaskModel>> getTaskBy({required String taskId}) async {
    return TaskMock.getTaskById(taskId);
  }

  @override
  Future<Result<TaskModel>> updateTask({required TaskModel task}) async {
    return TaskMock.updateTask(task);
  }
}
