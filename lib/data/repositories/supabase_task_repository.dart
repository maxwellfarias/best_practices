import 'dart:async';
import 'package:dio/dio.dart';
import '../../domain/models/task.dart';
import '../../utils/result.dart';
import '../services/task_api_service.dart';
import 'task_repository.dart';

/// Implementação do repositório usando Supabase
/// 
/// Esta implementação converte entre modelos de API e domínio,
/// trata erros e implementa o padrão Result para comunicação
/// segura com as camadas superiores.
class SupabaseTaskRepository implements TaskRepository {
  final TaskApiService _apiService;
  final StreamController<List<Task>> _taskStreamController;

  SupabaseTaskRepository(this._apiService)
      : _taskStreamController = StreamController<List<Task>>.broadcast();

  @override
  Stream<List<Task>> get taskStream => _taskStreamController.stream;

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      final apiTasks = await _apiService.getTasks();
      final tasks = apiTasks.map((apiTask) => apiTask.toDomain()).toList();
      
      // Atualiza o stream para listeners
      _taskStreamController.add(tasks);
      
      return Result.success(tasks);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  @override
  Future<Result<Task>> getTask(String id) async {
    try {
      final apiTask = await _apiService.getTask(id);
      final task = apiTask.toDomain();
      
      return Result.success(task);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  @override
  Future<Result<Task>> createTask(CreateTaskData data) async {
    try {
      final apiTask = await _apiService.createTask(data);
      final task = apiTask.toDomain();
      
      // Recarrega a lista para atualizar o stream
      _refreshTaskStream();
      
      return Result.success(task);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  @override
  Future<Result<Task>> updateTask(String id, UpdateTaskData data) async {
    try {
      final apiTask = await _apiService.updateTask(id, data);
      final task = apiTask.toDomain();
      
      // Recarrega a lista para atualizar o stream
      _refreshTaskStream();
      
      return Result.success(task);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  @override
  Future<Result<void>> deleteTask(String id) async {
    try {
      await _apiService.deleteTask(id);
      
      // Recarrega a lista para atualizar o stream
      _refreshTaskStream();
      
      return Result.success(null);
    } catch (e) {
      return Result.failure(_handleError(e));
    }
  }

  /// Recarrega a lista de tarefas para atualizar o stream
  Future<void> _refreshTaskStream() async {
    try {
      final apiTasks = await _apiService.getTasks();
      final tasks = apiTasks.map((apiTask) => apiTask.toDomain()).toList();
      _taskStreamController.add(tasks);
    } catch (e) {
      // Se falhar ao recarregar, emite erro no stream
      _taskStreamController.addError(_handleError(e));
    }
  }

  /// Converte exceções em mensagens de erro amigáveis
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Tempo limite de conexão excedido. Verifique sua conexão.';
        
        case DioExceptionType.connectionError:
          return 'Erro de conexão. Verifique sua internet.';
        
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return 'Dados inválidos fornecidos.';
            case 401:
              return 'Não autorizado. Faça login novamente.';
            case 403:
              return 'Acesso negado.';
            case 404:
              return 'Tarefa não encontrada.';
            case 422:
              return 'Dados inválidos ou incompletos.';
            case 500:
              return 'Erro interno do servidor. Tente novamente.';
            default:
              return 'Erro no servidor (${statusCode}). Tente novamente.';
          }
        
        case DioExceptionType.cancel:
          return 'Operação cancelada.';
        
        default:
          return error.message ?? 'Erro desconhecido na comunicação.';
      }
    }
    
    return 'Erro inesperado: $error';
  }

  /// Dispose do stream controller
  void dispose() {
    _taskStreamController.close();
  }
}
