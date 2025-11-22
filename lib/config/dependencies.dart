

import 'package:dio/dio.dart';
import 'package:logger/web.dart';
import 'package:mastering_tests/data/repositories/task/task_repository.dart';
// import 'package:mastering_tests/data/repositories/task/task_repository_impl.dart'; // Uncomment to use real API
import 'package:mastering_tests/data/repositories/task/task_repository_mock.dart';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/data/services/api/api_service_impl.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/utils/logger/custom_logger.dart';
import 'package:mastering_tests/utils/logger/custom_logger_impl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Returns the list of providers for dependency injection.
/// By default, uses TaskRepositoryMock for development.
/// To use the real API implementation, uncomment TaskRepositoryImpl import and provider below.
List<SingleChildWidget> get providers {
  return [
    Provider(create: (_) => Logger()),
    Provider(create: (_) => CustomLoggerImpl(logger: Logger()) as CustomLogger),
    Provider(create: (_) => Dio()),
    Provider(create: (context) => ApiClientImpl(dio: context.read<Dio>(), logger: context.read<CustomLogger>()) as ApiClient),

    // Default: Mock repository (no API calls, uses in-memory data)
    Provider(
      create: (context) => TaskRepositoryMock() as TaskRepository,
    ),

    // Alternative: Real API repository
    // To use: uncomment this block and the TaskRepositoryImpl import above
    // Provider(
    //   create: (context) =>
    //       TaskRepositoryImpl(
    //             apiService: context.read<ApiClient>(),
    //             baseUrl: "https://your-api-url.com/api",
    //             logger: context.read<CustomLogger>(),
    //           )
    //           as TaskRepository,
    // ),

    Provider(create: (context) => TaskViewModel(taskRepository: context.read<TaskRepository>())),
  ];
}