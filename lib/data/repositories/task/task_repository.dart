import 'package:best_practices/domain/models/task_model.dart';

import '../../../utils/result.dart';


abstract interface class TaskRepository {

  Future<Result<List<TaskModel>>> getAllTasks();
  Future<Result<TaskModel>> getTaskBy({required String taskId});
  Future<Result<TaskModel>> createTask({required TaskModel task});
  Future<Result<TaskModel>> updateTask({required TaskModel task});
  Future<Result<dynamic>> deleteTask({required String taskId});
}
