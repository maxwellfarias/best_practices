import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/utils/result.dart';

import '../../domain/models/task_model.dart';

/// Classe utilitária para criar dados fictícios de TaskModel
class TaskMock {
  static List<TaskModel> _tasks = [];
  
  /// Inicializa a lista com dados fictícios na primeira chamada
  static void _initializeIfEmpty() {
    if (_tasks.isEmpty) {
      _tasks = _generateInitialTasks();
    }
  }
  
  /// Retorna uma lista de dados fictícios de TaskModel
  static List<TaskModel> getMockTasks() {
    _initializeIfEmpty();
    return List.from(_tasks);
  }
  
  /// Gera os dados iniciais das tasks
  static List<TaskModel> _generateInitialTasks() {
    final now = DateTime.now();

    return [
      TaskModel(
        id: '1',
        title: 'Comprar ingredientes para o jantar',
        description:
            'Ir ao supermercado e comprar vegetais, carne e temperos para preparar o jantar da família',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TaskModel(
        id: '2',
        title: 'Estudar Flutter e Dart',
        description:
            'Revisar conceitos de widgets, estado e testes unitários para o projeto atual',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(hours: 3)),
      ),
      TaskModel(
        id: '3',
        title: 'Agendar consulta médica',
        description: 'Ligar para a clínica e marcar o exame de rotina anual',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      TaskModel(
        id: '4',
        title: 'Implementar testes unitários',
        description:
            'Criar testes para as classes TaskModel, TaskRepository e TaskViewModel',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 2)),
        completedAt: now.subtract(const Duration(days: 1, hours: 2)),
      ),
      TaskModel(
        id: '5',
        title: 'Organizar documentos pessoais',
        description:
            'Digitalizar e organizar documentos importantes em pastas no computador',
        isCompleted: false,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      TaskModel(
        id: '6',
        title: 'Fazer backup dos dados',
        description:
            'Realizar backup completo dos projetos e arquivos importantes para o cloud',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 4)),
        completedAt: now.subtract(const Duration(days: 3, hours: 1)),
      ),
      TaskModel(
        id: '7',
        title: 'Planejar viagem de férias',
        description:
            'Pesquisar destinos, hotéis e atividades para as próximas férias em família',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      TaskModel(
        id: '8',
        title: 'Configurar ambiente de desenvolvimento',
        description:
            'Instalar e configurar todas as ferramentas necessárias para o novo projeto',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 5)),
        completedAt: now.subtract(const Duration(days: 4, hours: 6)),
      ),
    ];
  }
  
  /// Adiciona uma nova task à lista
  static Result<TaskModel> addTask(TaskModel task) {
    _initializeIfEmpty();
    _tasks.add(task);
    return Result.ok(task);
  }
  
  /// Busca uma task específica pelo ID
  static Result<TaskModel> getTaskById(String id) {
    _initializeIfEmpty();
    try {
      final resposta = _tasks.firstWhere((task) => task.id == id);
      return Result.ok(resposta);
    } catch (e) {
      return Result.error(ErroInternoServidorException());
    }
  }
  
  /// Atualiza uma task existente
  static Result<TaskModel> updateTask(TaskModel updatedTask) {
    _initializeIfEmpty();
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      return Result.ok(updatedTask);
    }
    return Result.error(ErroInternoServidorException());
  }
  
  /// Remove uma task da lista pelo ID
  static Result<bool> deleteTask(String id) {
    _initializeIfEmpty();
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    return _tasks.length < initialLength ? Result.ok(true) : Result.error(ErroInternoServidorException());
  }
  
  /// Limpa todas as tasks (útil para testes)
  static void clearAllTasks() {
    _tasks.clear();
  }
  
  /// Redefine as tasks para o estado inicial
  static void resetToInitialState() {
    _tasks.clear();
    _initializeIfEmpty();
  }
}
