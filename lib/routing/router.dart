import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mastering_tests/routing/routes.dart';
import 'package:mastering_tests/ui/create_task/widget/create_task.dart';
import 'package:mastering_tests/ui/create_task/widget/edit_task.dart';
import 'package:mastering_tests/ui/create_task/widget/view_task.dart';
import 'package:mastering_tests/ui/create_task/widget/dashboard.dart';
import 'package:mastering_tests/ui/sign_in/widget/signin_screen.dart';
import 'package:mastering_tests/ui/signup/widget/signup_screen.dart';
import 'package:mastering_tests/ui/tasks/task_detail_screen.dart';
import 'package:mastering_tests/domain/models/task.dart' as domain;

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    // Home Route - Dashboard principal
    GoRoute(
      path: Routes.home,
      name: 'home',
      builder: (context, state) => const DashboardScreen(),
    ),
    
    // Authentication Routes
    GoRoute(
      path: Routes.signIn,
      name: 'signIn',
      builder: (context, state) => const LoginScreen(),
    ),
    
    GoRoute(
      path: Routes.signUp,
      name: 'signUp',
      builder: (context, state) => const SignUpScreen(),
    ),
    
    // Task Management Routes
    GoRoute(
      path: Routes.createTask,
      name: 'createTask',
      builder: (context, state) => const CreateTaskScreen(),
    ),
    
    GoRoute(
      path: '${Routes.editTask}/:taskId',
      name: 'editTask',
      builder: (context, state) {
        final task = state.extra as Map<String, dynamic>?;
        
        if (task != null) {
          return EditTaskScreen(task: task);
        } else {
          // Se não recebeu o task, redireciona para home
          return const DashboardScreen();
        }
      },
    ),
    
    GoRoute(
      path: '${Routes.viewTask}/:taskId',
      name: 'viewTask',
      builder: (context, state) {
        final task = state.extra as Map<String, dynamic>?;
        
        if (task != null) {
          return ViewTaskScreen(task: task);
        } else {
          // Se não recebeu o task, redireciona para home
          return const DashboardScreen();
        }
      },
    ),
    
    // Task Detail Route (modern screen we created)
    GoRoute(
      path: '${Routes.taskDetail}/:taskId',
      name: 'taskDetail',
      builder: (context, state) {
        final taskData = state.extra as Map<String, dynamic>?;
        final task = taskData?['task'] as domain.Task?;
        final viewModel = taskData?['viewModel'];
        
        if (task != null && viewModel != null) {
          return TaskDetailScreen(
            task: task,
            viewModel: viewModel,
          );
        } else {
          // Se não recebeu o task, redireciona para home
          return const DashboardScreen();
        }
      },
    ),
  ],
  
  // Error handling
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Page Not Found'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
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
