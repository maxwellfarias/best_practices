import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mastering_tests/routing/routes.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/ui/todo/widget/todo_list_screen.dart';
import 'package:mastering_tests/ui/turma_screen/widget/turma_screen.dart';
import 'package:provider/provider.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    // Home Route - Dashboard principal
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return Container();
      },
    ),
    
    // Turmas Route - Gestão de Turmas
    GoRoute(
      path: Routes.turmas,
      builder: (context, state) {
        return Container();
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
