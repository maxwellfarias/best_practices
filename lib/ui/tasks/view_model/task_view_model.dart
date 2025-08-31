import 'package:flutter/foundation.dart';
import '../../../domain/models/task.dart';
import '../../../data/repositories/task_repository.dart';
import 'task_commands.dart';

/// ViewModel para gerenciar estado e lógica da lista de tarefas
/// 
/// Usa ChangeNotifier para notificar a UI sobre mudanças de estado.
/// Implementa o padrão Command para operações assíncronas.
class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;
  
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  TaskViewModel(this._repository);

  // Getters para acesso ao estado
  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Getters derivados
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  int get totalTasks => _tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;

  /// Carrega todas as tarefas
  Future<void> loadTasks() async {
    _setLoading(true);
    _setError(null);

    final result = await _repository.getTasks();
    
    result.when(
      success: (tasks) => _setTasks(tasks),
      failure: (error) => _setError(error),
    );
    
    _setLoading(false);
  }

  /// Cria uma nova tarefa
  Future<void> createTask(CreateTaskData data) async {
    final command = CreateTaskCommand(
      _repository,
      data,
      onSuccess: loadTasks, // Recarrega a lista após sucesso
      onError: (error) => _setError(error),
    );
    
    await command.execute();
  }

  /// Atualiza uma tarefa existente
  Future<void> updateTask(String id, UpdateTaskData data) async {
    final command = UpdateTaskCommand(
      _repository,
      id,
      data,
      onSuccess: loadTasks, // Recarrega a lista após sucesso
      onError: (error) => _setError(error),
    );
    
    await command.execute();
  }

  /// Exclui uma tarefa
  Future<void> deleteTask(String id) async {
    final command = DeleteTaskCommand(
      _repository,
      id,
      onSuccess: loadTasks, // Recarrega a lista após sucesso
      onError: (error) => _setError(error),
    );
    
    await command.execute();
  }

  /// Marca uma tarefa como concluída
  Future<void> completeTask(String id) async {
    final command = CompleteTaskCommand(
      _repository,
      id,
      onSuccess: loadTasks, // Recarrega a lista após sucesso
      onError: (error) => _setError(error),
    );
    
    await command.execute();
  }

  /// Marca uma tarefa como não concluída
  Future<void> uncompleteTask(String id) async {
    final command = UncompleteTaskCommand(
      _repository,
      id,
      onSuccess: loadTasks, // Recarrega a lista após sucesso
      onError: (error) => _setError(error),
    );
    
    await command.execute();
  }

  /// Alterna o status de conclusão de uma tarefa
  Future<void> toggleTaskCompletion(String id) async {
    final task = _tasks.firstWhere((t) => t.id == id);
    
    if (task.isCompleted) {
      await uncompleteTask(id);
    } else {
      await completeTask(id);
    }
  }

  /// Limpa o erro atual
  void clearError() {
    if (_error != null) {
      _setError(null);
    }
  }

  /// Busca uma tarefa por ID
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filtra tarefas por status
  List<Task> getTasksByStatus(bool isCompleted) {
    return _tasks.where((task) => task.isCompleted == isCompleted).toList();
  }

  // Métodos privados para gerenciar estado

  void _setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  @override
  void dispose() {
    // Cleanup se necessário
    super.dispose();
  }
}
