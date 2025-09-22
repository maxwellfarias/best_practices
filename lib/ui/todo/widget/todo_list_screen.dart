import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';

final class TodoListScreen extends StatefulWidget {
  final TaskViewModel viewModel;

  const TodoListScreen({super.key, required this.viewModel});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Center(
        child: Text('Number of tasks: ${widget.viewModel.tasks.length}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add a new task
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}