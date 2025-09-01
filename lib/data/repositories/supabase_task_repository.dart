import 'dart:async';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/routing/routes.dart';
import '../../domain/models/task.dart';
import '../../utils/result.dart';
import '../services/api/api_service.dart';
import 'task_repository.dart';

/// Implementação do repositório usando Supabase
/// 
/// Esta implementação converte entre modelos de API e domínio,
/// trata erros e implementa o padrão Result para comunicação
/// segura com as camadas superiores.
/// 
/// 
/// 


const apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxc2Jwc2lmZHl1amJidmJ6amRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3MDI0MDUsImV4cCI6MjA3MjI3ODQwNX0.lW-mzhw2eB5CbT_hNFNeYAVNOcEqOGiibgeNR4L4Pck";

class TaskRepositoryImpl implements TaskRepository {
  final ApiClient _apiService;
  final StreamController<List<Task>> _taskStreamController;

  TaskRepositoryImpl({required ApiClient apiService})
      : _apiService = apiService,
        _taskStreamController = StreamController<List<Task>>.broadcast();

  @override
  Stream<List<Task>> get taskStream => _taskStreamController.stream;

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      return await _apiService.request(url: Routes.getTasks, metodo: MetodoHttp.get, headers: { 'apikey': apiKey, 'Authorization': 'Bearer $apiKey'})
          .then(
            (response) => response.map(
              (jsonList) => (jsonList as List)
                  .map((json) => Task.fromJson(json))
                  .toList(),
            ),
          );
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<Task>> getTask(String id) async {
    try {
      final apiTask = await _apiService.getTask(id);
      final task = apiTask.toDomain();
      
      return Result.ok(task);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<Task>> createTask(Task data) async {
    try {
      final apiTask = await _apiService.createTask(data);
      final task = apiTask.toDomain();
      
      // Recarrega a lista para atualizar o stream
      _refreshTaskStream();
      
      return Result.ok(task);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<Task>> updateTask(String id, Task data) async {
    try {
      final apiTask = await _apiService.updateTask(id, data);
      final task = apiTask.toDomain();
      
      // Recarrega a lista para atualizar o stream
      _refreshTaskStream();
      
      return Result.ok(task);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<void>> deleteTask(String id) async {
    try {
      await _apiService.deleteTask(id);
      
      // Recarrega a lista para atualizar o stream
      _refreshTaskStream();
      
      return Result.ok(null);
    } catch (e) {
      return Result.error(UnknownErrorException());
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
      // _taskStreamController.addError(_handleError(e));
    }
  }

 

  /// Dispose do stream controller
  void dispose() {
    _taskStreamController.close();
  }
}
