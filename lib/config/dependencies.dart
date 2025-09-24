

import 'package:dio/dio.dart';
import 'package:mastering_tests/data/repositories/task/task_repository.dart';
import 'package:mastering_tests/data/repositories/task/task_repository_impl.dart';
import 'package:mastering_tests/data/repositories/turma/turma_repository.dart';
import 'package:mastering_tests/data/repositories/turma/turma_repository_impl.dart';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/data/services/api/api_service_impl.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (_) => Dio()),
    Provider(create: (context) => ApiClientImpl(dio: context.read<Dio>()) as ApiClient),

    //Repositories
    Provider(create: (context) => TurmaRepositoryImpl() as TurmaRepository),
    Provider(create: (context) => TaskRepositoryImpl(apiService: context.read<ApiClient>()) as TaskRepository),
    Provider(create: (context) => TaskViewModel(taskRepository: context.read<TaskRepository>())),
  ];
}