import 'package:flutter/material.dart';
import 'package:mastering_tests/config/dependencies.dart';
import 'package:mastering_tests/routing/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MultiProvider(providers: providers, child: TaskApp()));
}


final class TaskApp extends StatelessWidget {
  const TaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Task App',
      routerConfig: router(),
    );
  }
}