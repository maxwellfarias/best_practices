import 'dart:async';
import 'package:best_practices/data/services/api/api_serivce.dart';
import 'package:best_practices/domain/models/task_model.dart';
import 'package:best_practices/exceptions/app_exception.dart';
import 'package:best_practices/utils/logger/custom_logger.dart';
import '../../../utils/result.dart';
import 'task_repository.dart';

/// Real API implementation of TaskRepository.
/// Makes actual HTTP requests to the backend API.
/// Use this implementation when you need real data from the server.
/// To use this implementation, inject it in the dependencies configuration.
class TaskRepositoryImpl implements TaskRepository {
  final ApiClient _apiService;
  final String _baseUrl;
  final CustomLogger _logger;

  TaskRepositoryImpl({
    required ApiClient apiService,
    required String baseUrl,
    required CustomLogger logger,
  })  : _apiService = apiService,
        _baseUrl = baseUrl,
        _logger = logger;

  @override
  Future<Result<TaskModel>> createTask({required TaskModel task}) async {
    try {
      final response = await _apiService
          .request(
            url: '$_baseUrl/tasks',
            metodo: MetodoHttp.post,
            body: task.toJson(),
          )
          .map(TaskModel.fromJson);
      return response;
    } catch (e, stackTrace) {
      _logger.error('Error in createTask: $e', stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<dynamic>> deleteTask({required String taskId}) async {
    try {
      final response = await _apiService.request(
        url: '$_baseUrl/tasks/$taskId',
        metodo: MetodoHttp.delete,
      );
      return response;
    } catch (e, stackTrace) {
      _logger.error('Error in deleteTask: $e', stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<List<TaskModel>>> getAllTasks() async {
    try {
      final response =
          await _apiService.request(url: '$_baseUrl/tasks', metodo: MetodoHttp.get).map((data) {
        final List<dynamic> dataList = data as List<dynamic>;
        return dataList.map((item) => TaskModel.fromJson(item)).toList();
      });
      return response;
    } catch (e, stackTrace) {
      _logger.error('Error in getAllTasks: $e', stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<TaskModel>> getTaskBy({required String taskId}) async {
    try {
      final response = await _apiService
          .request(url: '$_baseUrl/tasks/$taskId', metodo: MetodoHttp.get)
          .map(TaskModel.fromJson);
      return response;
    } catch (e, stackTrace) {
      _logger.error('Error in getTaskBy: $e', stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }

  @override
  Future<Result<TaskModel>> updateTask({required TaskModel task}) async {
    try {
      final response = await _apiService
          .request(
            url: '$_baseUrl/tasks/${task.id}',
            metodo: MetodoHttp.put,
            body: task.toJson(),
          )
          .map(TaskModel.fromJson);
      return response;
    } catch (e, stackTrace) {
      _logger.error('Error in updateTask: $e', stackTrace: stackTrace);
      return Result.error(UnknownErrorException());
    }
  }
}

