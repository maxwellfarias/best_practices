import 'package:flutter/material.dart';
import 'package:best_practices/config/dependencies.dart';
import 'package:best_practices/routing/router.dart';
import 'package:best_practices/ui/core/themes/theme.dart';
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
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router(),
    );
  }
}