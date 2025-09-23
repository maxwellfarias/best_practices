import 'package:flutter/widgets.dart';
import 'package:mastering_tests/data/repositories/task/task_repository.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/result.dart';

final class TaskViewModel extends ChangeNotifier {
  TaskViewModel({required TaskRepository taskRepository}) : _taskRepository = taskRepository {
    getAllTasks = Command0(_getAllTasks);
    getTaskBy = Command1(_getTaskBy);
    createTask = Command1(_createTask);
    updateTask = Command1(_updateTask);
    deleteTask = Command1(_deleteTask);
  }
  final TaskRepository _taskRepository;

  final List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;
  late final Command0<List<TaskModel>> getAllTasks;
  late final Command1<TaskModel, String> getTaskBy;
  late final Command1<TaskModel, TaskModel> createTask;
  late final Command1<TaskModel, TaskModel> updateTask;
  late final Command1<dynamic, String> deleteTask;

  Future<Result<List<TaskModel>>> _getAllTasks() async {
    return await _taskRepository.getAllTasks(databaseId: 'default')
    .map((tasks) {
      _tasks
      ..clear()
      ..addAll(tasks);
      notifyListeners();
      return tasks;
    });
  }

  Future<Result<TaskModel>> _getTaskBy(String taskId) async {
    return await _taskRepository.getTaskBy(databaseId: 'default', taskId: taskId);
  }

  Future<Result<TaskModel>> _createTask(TaskModel task) async {
    return await _taskRepository.createTask(databaseId: 'default', task: task)
    .map((createdTask) {
      _tasks.add(createdTask);
      notifyListeners();
      return createdTask;
    });
  }

  Future<Result<TaskModel>> _updateTask(TaskModel task) async {
    return await _taskRepository.updateTask(databaseId: 'default', task: task)
    .map((updatedTask) {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      return updatedTask;
    });
  }

  Future<Result<dynamic>> _deleteTask(String taskId) async {
    return await _taskRepository.deleteTask(databaseId: 'default', taskId: taskId)
    .map((_) {
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
      return Result.ok(null);
    });
  }
}