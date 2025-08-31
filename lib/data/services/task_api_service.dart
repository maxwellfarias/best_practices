import 'package:dio/dio.dart';
import '../../domain/models/task.dart';
import '../models/task_api_model.dart';

/// Interface para o serviço de API de tarefas
/// 
/// Define o contrato para comunicação com a API REST.
/// Separado do repositório para permitir diferentes implementações
/// (Supabase, Firebase, REST API customizada, etc.)
abstract interface class TaskApiService {
  /// Busca todas as tarefas da API
  Future<List<TaskApiModel>> getTasks();

  /// Busca uma tarefa específica por ID
  Future<TaskApiModel> getTask(String id);

  /// Cria uma nova tarefa na API
  Future<TaskApiModel> createTask(CreateTaskData data);

  /// Atualiza uma tarefa existente na API
  Future<TaskApiModel> updateTask(String id, UpdateTaskData data);

  /// Remove uma tarefa da API
  Future<void> deleteTask(String id);
}

/// Implementação do serviço usando Supabase REST API
class SupabaseTaskApiService implements TaskApiService {
  final Dio _dio;
  final String _baseUrl;

  SupabaseTaskApiService({
    required Dio dio,
    required String baseUrl,
  })  : _dio = dio,
        _baseUrl = baseUrl;

  @override
  Future<List<TaskApiModel>> getTasks() async {
    try {
      final response = await _dio.get('$_baseUrl/tasks');
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch tasks: ${response.statusCode}',
        );
      }

      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => TaskApiModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<TaskApiModel> getTask(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/tasks/$id');
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to fetch task: ${response.statusCode}',
        );
      }

      return TaskApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks/$id'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<TaskApiModel> createTask(CreateTaskData data) async {
    try {
      final requestData = {
        'title': data.title,
        'description': data.description,
        'is_completed': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post(
        '$_baseUrl/tasks',
        data: requestData,
      );
      
      if (response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to create task: ${response.statusCode}',
        );
      }

      return TaskApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<TaskApiModel> updateTask(String id, UpdateTaskData data) async {
    try {
      final requestData = <String, dynamic>{};
      
      if (data.title != null) requestData['title'] = data.title;
      if (data.description != null) requestData['description'] = data.description;
      if (data.isCompleted != null) {
        requestData['is_completed'] = data.isCompleted;
        if (data.isCompleted == true) {
          requestData['completed_at'] = DateTime.now().toIso8601String();
        } else {
          requestData['completed_at'] = null;
        }
      }

      final response = await _dio.patch(
        '$_baseUrl/tasks/$id',
        data: requestData,
      );
      
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to update task: ${response.statusCode}',
        );
      }

      return TaskApiModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks/$id'),
        message: 'Unexpected error: $e',
      );
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      final response = await _dio.delete('$_baseUrl/tasks/$id');
      
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: 'Failed to delete task: ${response.statusCode}',
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_baseUrl/tasks/$id'),
        message: 'Unexpected error: $e',
      );
    }
  }
}
