import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/result.dart';

final class TaskViewModel {
  final TaskRepository _taskRepository;

  TaskViewModel(this._taskRepository){
      getTasks = Command0<List<Task>>(_getTasks)..execute();
      addTask = Command1<void, Task>(_addTask);
      updateTask = Command1<void, Task>(_updateTask);
      deleteTask = Command1<void, String>(_deleteTask);
  }

  late final Command0<List<Task>> getTasks;
  late final Command1<void, Task> addTask;
  late final Command1<void, Task> updateTask;
  late final Command1<void, String> deleteTask;

  Future<Result<List<Task>>> _getTasks() async => await _taskRepository.getTasks();
  
  Future<Result<void>> _addTask(Task task) async => await _taskRepository.createTask(task);

  Future<Result<void>> _updateTask(Task task) async => await _taskRepository.updateTask(task);

  Future<Result<void>> _deleteTask(String id) async => await _taskRepository.deleteTask(id);
}