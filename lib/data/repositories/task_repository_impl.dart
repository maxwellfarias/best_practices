import 'dart:async';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/utils/mocks/task_mock.dart';
import '../../utils/result.dart';
import 'task_repository.dart';

const apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxc2Jwc2lmZHl1amJidmJ6amRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3MDI0MDUsImV4cCI6MjA3MjI3ODQwNX0.lW-mzhw2eB5CbT_hNFNeYAVNOcEqOGiibgeNR4L4Pck";

class TaskRepositoryImpl implements TaskRepository {
  final ApiClient _apiService;

  TaskRepositoryImpl({required ApiClient apiService})
    : _apiService = apiService;
    
      @override
      Future<Result<TaskModel>> createTask({required String databaseId, required TaskModel task}) async {
        return TaskMock.addTask(task);
      }
    
      @override
      Future<Result<dynamic>> deleteTask({required String databaseId, required String taskId}) async {
            return Result.ok(TaskMock.deleteTask(taskId));
      }
    
      @override
      Future<Result<List<TaskModel>>> getAllTasks({required String databaseId}) async {
        return Result.ok(TaskMock.getMockTasks());
      }
    
      @override
      Future<Result<TaskModel>> getTaskBy({required String databaseId, required String taskId}) async {
        return TaskMock.getTaskById(taskId);
      }
    
      @override
      Future<Result<TaskModel>> updateTask({required String databaseId, required TaskModel task}) async {
        return TaskMock.updateTask(task);
      }

}
