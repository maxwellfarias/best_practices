import '../../domain/models/task.dart';
import '../../utils/result.dart';

/// Interface do repositório de tarefas
/// 
/// Define o contrato para operações CRUD de tarefas.
/// Esta interface permite inversão de dependência e facilita testes
/// através de mocking.
abstract interface class TaskRepository {
  /// Busca todas as tarefas
  Future<Result<List<Task>>> getTasks();

  /// Busca uma tarefa específica por ID
  Future<Result<Task>> getTask(String id);

  /// Cria uma nova tarefa
  Future<Result<Task>> createTask(Task data);

  /// Atualiza uma tarefa existente
  Future<Result<Task>> updateTask(String id, Task data);

  /// Remove uma tarefa
  Future<Result<void>> deleteTask(String id);

  /// Stream de mudanças nas tarefas (para updates em tempo real)
  Stream<List<Task>> get taskStream;
}
