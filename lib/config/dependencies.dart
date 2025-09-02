

import 'package:dio/dio.dart';
import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/data/repositories/task_repository_impl.dart';
import 'package:mastering_tests/data/services/api/api_service.dart';
import 'package:mastering_tests/ui/tasks/view_model/task_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (_) => Dio()),
    Provider(create: (context) => ApiClientImpl(dio: context.read<Dio>()) as ApiClient),
    Provider(create: (context) => TaskRepositoryImpl(apiService: context.read<ApiClient>()) as TaskRepository),
    Provider(create: (context) => TaskViewModel(context.read<TaskRepository>())),
  ];
}