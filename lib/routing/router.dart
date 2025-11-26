import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:best_practices/routing/routes.dart';
import 'package:best_practices/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:best_practices/ui/todo/widget/task_screen.dart';
import 'package:best_practices/ui/attached_files/widget/attached_files_screen.dart';
import 'package:provider/provider.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.attachedFiles,
  routes: [
    // Home Route - Dashboard principal
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return TaskScreen(
          viewModel: TaskViewModel(taskRepository: context.read()),
        );
      },
    ),

    // Attached Files Route
    GoRoute(
      path: Routes.attachedFiles,
      builder: (context, state) {
        return const AttachedFilesScreen();
      },
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page not found: ${state.uri}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(Routes.home),
            child: const Text('Go to Home'),
          ),
        ],
      ),
    ),
  ),
);
