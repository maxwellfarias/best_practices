import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/result.dart';

final class TaskViewmodel {
  final TaskRepository _repository;

  TaskViewmodel({required TaskRepository repository}) : _repository = repository {
    fetchTasks = Command0<List<Task>>(_fetchTasks)..execute();
    createTask = Command1(_createTask);
    updateTask = Command1(_updateTask);
    deleteTask = Command1(_deleteTask);
  }

  late final Command0<List<Task>> fetchTasks;
  late final Command1<void, Task> createTask;
  late final Command1<void, Task> updateTask;
  late final Command1<void, String> deleteTask;

  Future<Result<List<Task>>> _fetchTasks() async => _repository.getTasks();
  Future<Result<void>> _createTask(Task task) async => _repository.createTask(task: task);
  Future<Result<void>> _updateTask(Task task) async => _repository.updateTask(task: task);
  Future<Result<void>> _deleteTask(String taskId) async => _repository.deleteTask(id: taskId);
}