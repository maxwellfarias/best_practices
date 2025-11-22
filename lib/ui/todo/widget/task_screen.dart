import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:best_practices/domain/models/task_model.dart';
import 'package:best_practices/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:best_practices/ui/core/extensions/build_context_extension.dart';
import 'package:best_practices/utils/command.dart';
import 'componentes/task_card.dart';
import 'componentes/task_form_dialog.dart';
import 'componentes/task_empty_state.dart';

/// Main task management screen
///
/// Design 100% faithful to HTML in design.html with:
/// - Header "Today" + sort/menu buttons
/// - List of task cards
/// - FAB to create new task
/// - States: loading, error, empty, success
final class TaskScreen extends StatefulWidget {
  final TaskViewModel viewModel;

  const TaskScreen({super.key, required this.viewModel});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();

    // REQUIRED LISTENERS FOR 3 COMMANDS
    widget.viewModel.updateTask.addListener(_onUpdateResult);
    widget.viewModel.deleteTask.addListener(_onDeleteResult);
    widget.viewModel.createTask.addListener(_onCreateResult);

    // REQUIRED EXECUTE GET ALL
    widget.viewModel.getAllTasks.execute();
  }

  @override
  void dispose() {
    // DISPOSE DE TODOS OS LISTENERS OBRIGATÓRIO
    widget.viewModel.updateTask.removeListener(_onUpdateResult);
    widget.viewModel.deleteTask.removeListener(_onDeleteResult);
    widget.viewModel.createTask.removeListener(_onCreateResult);
    super.dispose();
  }

  /// Feedback para atualização de tarefa
  void _onUpdateResult() {
    _onResult(
      command: widget.viewModel.updateTask,
      successMessage: 'Tarefa atualizada com sucesso!',
    );
  }

  /// Feedback para exclusão de tarefa
  void _onDeleteResult() {
    _onResult(
      command: widget.viewModel.deleteTask,
      successMessage: 'Tarefa excluída com sucesso!',
    );
  }

  /// Feedback para criação de tarefa
  void _onCreateResult() {
    _onResult(
      command: widget.viewModel.createTask,
      successMessage: 'Tarefa criada com sucesso!',
    );
  }

  /// MÉTODO _onResult OBRIGATÓRIO PARA FEEDBACK VISUAL
  void _onResult({
    required Command command,
    required String successMessage,
  }) {
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}',
          ),
          backgroundColor: context.customColorTheme.destructive,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: context.customColorTheme.success,
        ),
      );
    }
  }

  /// Abre o dialog para criar nova tarefa
  void _createNewTask() {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
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

  /// Abre o dialog para editar tarefa existente
  void _editTask(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => TaskFormDialog(
        task: task,
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

  /// Alterna o estado de conclusão da tarefa
  void _toggleTaskCompletion(TaskModel task) {
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: !task.isCompleted ? DateTime.now() : null,
    );
    widget.viewModel.updateTask.execute(updatedTask);
  }

  /// Deleta a tarefa após confirmação
  void _deleteTask(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.customColorTheme.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Excluir Tarefa',
          style: context.customTextTheme.textXlSemibold.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir a tarefa "${task.title}"?',
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.viewModel.deleteTask.execute(task.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customColorTheme.destructive,
              foregroundColor: context.customColorTheme.destructiveForeground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Excluir',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.destructiveForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra detalhes da tarefa
  void _showTaskDetails(TaskModel task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.customColorTheme.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          task.title,
          style: context.customTextTheme.textXlSemibold.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              Text(
                'Descrição:',
                style: context.customTextTheme.textSmSemibold.copyWith(
                  color: context.customColorTheme.mutedForeground,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                task.description,
                style: context.customTextTheme.textBase.copyWith(
                  color: context.customColorTheme.cardForeground,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Status:',
              style: context.customTextTheme.textSmSemibold.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  size: 20,
                  color: task.isCompleted
                      ? context.customColorTheme.success
                      : context.customColorTheme.mutedForeground,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isCompleted ? 'Concluída' : 'Pendente',
                  style: context.customTextTheme.textBase.copyWith(
                    color: task.isCompleted
                        ? context.customColorTheme.success
                        : context.customColorTheme.cardForeground,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: context.customColorTheme.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: context.customColorTheme.border,
                  width: 1,
                )
              ),
            ),
            child: Text(
              'Fechar',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _editTask(task);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customColorTheme.primary,
              foregroundColor: context.customColorTheme.primaryForeground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Editar',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.primaryForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColorTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header com título e botões
            _buildHeader(),

            // Conteúdo principal (lista de tarefas)
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      // FAB para criar nova tarefa
      floatingActionButton: _buildFAB(),
    );
  }

  /// Header "Today" com botões de sort e menu
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24), // p-6 do HTML
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Título "Today"
          Text(
            'Today',
            style: context.customTextTheme.text4xlBold.copyWith(
              color: context.customColorTheme.foreground,
            ),
          ),

          // Botões de ação (sort e menu)
          Row(
            children: [
              // Botão Sort
              _buildHeaderButton(Icons.sort),
              const SizedBox(width: 8), // space-x-2 do HTML
              // Botão More
              _buildHeaderButton(Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }

  /// Botão do header (sort/menu)
  Widget _buildHeaderButton(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColorTheme.card,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.customColorTheme.shadowCard.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        color: context.customColorTheme.mutedForeground,
        onPressed: () {
          // Ação dos botões (pode implementar sort/filtros depois)
          if (icon == Icons.sort) {
            // Implementar ordenação
          } else {
            // Implementar menu de opções
          }
        },
      ),
    );
  }

  /// Conteúdo principal com estados
  Widget _buildContent() {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewModel,
        widget.viewModel.getAllTasks,
      ]),
      builder: (context, _) {
        /// ESTADO LOADING OBRIGATÓRIO
        if (widget.viewModel.getAllTasks.running) {
          return const Center(child: CupertinoActivityIndicator());
        }

        /// ESTADO ERROR OBRIGATÓRIO
        if (widget.viewModel.getAllTasks.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.customColorTheme.destructive,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar tarefas',
                    style: context.customTextTheme.textLgSemibold.copyWith(
                      color: context.customColorTheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.viewModel.getAllTasks.errorMessage ??
                        'Ocorreu um erro desconhecido',
                    style: context.customTextTheme.textBase.copyWith(
                      color: context.customColorTheme.destructive,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => widget.viewModel.getAllTasks.execute(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.customColorTheme.primary,
                      foregroundColor: context.customColorTheme.primaryForeground,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      'Tentar Novamente',
                      style: context.customTextTheme.textBaseMedium.copyWith(
                        color: context.customColorTheme.primaryForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        /// ESTADO EMPTY OBRIGATÓRIO
        if (widget.viewModel.tasks.isEmpty) {
          return const TaskEmptyState();
        }

        /// ESTADO SUCCESS - LISTA DE DADOS
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: widget.viewModel.tasks.length,
          itemBuilder: (context, index) {
            final task = widget.viewModel.tasks[index];
            return TaskCard(
              task: task,
              index: index,
              onTap: () => _showTaskDetails(task),
              onToggleComplete: () => _toggleTaskCompletion(task),
              onDelete: () => _deleteTask(task),
            );
          },
        );
      },
    );
  }

  /// FAB para criar nova tarefa (fiel ao design HTML)
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _createNewTask,
      backgroundColor: context.customColorTheme.primary,
      foregroundColor: context.customColorTheme.primaryForeground,
      elevation: 8,
      child: const Icon(Icons.add),
    );
  }
}
