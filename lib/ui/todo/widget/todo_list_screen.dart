// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/utils/command.dart';

final class TodoListScreen extends StatefulWidget {
  final TaskViewModel viewModel;

  const TodoListScreen({super.key, required this.viewModel});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.updateTask.addListener(() => _onResult(command: widget.viewModel.updateTask, successMessage: 'Tarefa atualizada com sucesso!'));
    widget.viewModel.deleteTask.addListener(() => _onResult(command: widget.viewModel.deleteTask, successMessage: 'Tarefa excluída com sucesso!'));
    widget.viewModel.createTask.addListener(() => _onResult(command: widget.viewModel.createTask, successMessage: 'Tarefa criada com sucesso!'));
    widget.viewModel.getAllTasks.execute();
  }

  @override
  void dispose() {
    widget.viewModel.updateTask.removeListener(() => _onResult(command: widget.viewModel.updateTask, successMessage: 'Tarefa atualizada com sucesso!'));
    widget.viewModel.deleteTask.removeListener(() => _onResult(command: widget.viewModel.deleteTask, successMessage: 'Tarefa excluída com sucesso!'));
    widget.viewModel.createTask.removeListener(() => _onResult(command: widget.viewModel.createTask, successMessage: 'Tarefa criada com sucesso!'));
    super.dispose();
  }

  void _onResult({required Command command, required String successMessage}) {
    if(command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.viewModel.getAllTasks.execute(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.getAllTasks,
        ]),
        builder: (context, _) {
          if (widget.viewModel.getAllTasks.running) {
            return const LinearProgressIndicator();
          }

          if (widget.viewModel.getAllTasks.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Erro ao carregar tarefas: ${widget.viewModel.getAllTasks.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return Column(
            children: [
              // Lista de tarefas
              Expanded(
                child: widget.viewModel.tasks.isEmpty
                    ? const Center(child: Text('Nenhuma tarefa encontrada'))
                    : ListView.builder(
                        itemCount: widget.viewModel.tasks.length,
                        itemBuilder: (context, index) {
                          final task = widget.viewModel.tasks[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: Checkbox(
                                value: task.isCompleted,
                                onChanged: (value) =>
                                    _toggleTaskCompletion(task),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              subtitle: Text(task.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editTask(task),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteTask(task.id),
                                  ),
                                ],
                              ),
                              onTap: () => _showTaskDetails(task),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createNewTask() {
    showDialog(
      context: context,
      builder: (context) => _TaskDialog(
        onSave: (title, description) {
          final newTask = TaskModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title,
            description: description,
            isCompleted: false,
            createdAt: DateTime.now(),
          );
          widget.viewModel.createTask.execute(newTask);
        },
      ),
    );
  }

  void _editTask(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => _TaskDialog(
        initialTitle: task.title,
        initialDescription: task.description,
        onSave: (title, description) {
          final updatedTask = task.copyWith(
            title: title,
            description: description,
          );
          widget.viewModel.updateTask.execute(updatedTask);
        },
      ),
    );
  }

  void _toggleTaskCompletion(TaskModel task) {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    widget.viewModel.updateTask.execute(updatedTask);
  }

  void _deleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Tarefa'),
        content: const Text('Tem certeza que deseja deletar esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.viewModel.deleteTask.execute(taskId);
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(TaskModel task) {
    widget.viewModel.getTaskBy.execute(task.id);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${task.description}'),
            const SizedBox(height: 8),
            Text('Status: ${task.isCompleted ? 'Concluída' : 'Pendente'}'),
            const SizedBox(height: 8),
            Text('Criada em: ${_formatDate(task.createdAt)}'),
            if (task.completedAt != null) ...[
              const SizedBox(height: 8),
              Text('Concluída em: ${_formatDate(task.completedAt!)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _TaskDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final Function(String title, String description) onSave;

  const _TaskDialog({
    this.initialTitle,
    this.initialDescription,
    required this.onSave,
  });

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();    //Controllers
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialTitle != null ? 'Editar Tarefa' : 'Nova Tarefa',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira um título';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira uma descrição';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _titleController.text.trim(),
                _descriptionController.text.trim(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
