import 'dart:async';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/config/constants.dart';
import '../../domain/models/task.dart';
import '../../utils/result.dart';
import 'task_repository.dart';


const apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRxc2Jwc2lmZHl1amJidmJ6amRxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3MDI0MDUsImV4cCI6MjA3MjI3ODQwNX0.lW-mzhw2eB5CbT_hNFNeYAVNOcEqOGiibgeNR4L4Pck";

class TaskRepositoryImpl implements TaskRepository {
  final ApiClient _apiService;

  TaskRepositoryImpl({required ApiClient apiService})
      : _apiService = apiService;

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      return await _apiService.request(url: Urls.getTasks, metodo: MetodoHttp.get, headers: { 'apikey': apiKey, 'Authorization': 'Bearer $apiKey'})
      .map((jsonList) => (jsonList as List).map((json) => Task.fromJson(json)).toList());
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }
  
  @override
  Future<Result<void>> createTask(Task data) async {
      return await _apiService.request(url: Urls.createTask, metodo: MetodoHttp.post, body: data.toJson(), headers: { 'apikey': apiKey, 'Authorization': 'Bearer $apiKey'})
        .map((_) => Result.ok(null));
  }
  
  @override
  Future<Result<void>> deleteTask(String id) async {
      return await _apiService.request(url: Urls.deleteTaskUrl(id), metodo: MetodoHttp.delete, headers: {'apikey': apiKey, 'Authorization': 'Bearer $apiKey'})
        .map((_) => Result.ok(null));
  }
  
  @override
  Future<Result<void>> updateTask(Task data) async {
      return await _apiService.request(
        url: Urls.updateTaskUrl(data.id), metodo: MetodoHttp.put, headers: {'apikey': apiKey, 'Authorization': 'Bearer $apiKey'},body: data.toJson())
          .map((_) => Result.ok(null));
  }
}
