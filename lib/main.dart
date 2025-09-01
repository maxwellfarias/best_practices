import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mastering_tests/data/repositories/supabase_task_repository.dart';
import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/data/services/api/api_service.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/ui/tasks/widgets/todo_list_screen.dart';
import 'package:mastering_tests/utils/result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Spline Sans',
        useMaterial3: true,
      ),
      home: Center(
        child: ElevatedButton(
          onPressed: () async {
            final repo = TaskRepositoryImpl(apiService: ApiClientImpl(dio: Dio(), baseUrl: "baseUrl"));
            final responseTasks = await repo.getTasks()
            .then((result) => result.when(
              onOk: (tasks) => tasks,
              onError: (error) {
                log('Error fetching tasks: $error');
              },
            ));
          },
          child: const Text('Open Todo List'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}