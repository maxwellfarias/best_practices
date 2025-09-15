import 'package:flutter/material.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/ui/dashboard/viewmodel/task_viewmodel.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final TaskViewmodel viewModel;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.viewModel,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    widget.viewModel.fetchTasks.addListener(_onTasksUpdated);
  }

  @override
  void dispose() {
    widget.viewModel.fetchTasks.removeListener(_onTasksUpdated);
    super.dispose();
  }

  void _onTasksUpdated() {
    // Atualizar a tarefa atual com dados mais recentes da lista
    final updatedTasks = widget.viewModel.fetchTasks.value;
    if (updatedTasks != null) {
      final updatedTask = updatedTasks.firstWhere(
        (task) => task.id == _currentTask.id,
        orElse: () => _currentTask,
      );
      if (mounted && updatedTask != _currentTask) {
        setState(() {
          _currentTask = updatedTask;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
      ),
      title: Text(
        'Detalhes da Tarefa',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _editTask,
          icon: const Icon(Icons.edit_rounded, color: Colors.black54),
          tooltip: 'Editar',
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    _currentTask.isCompleted 
                        ? Icons.undo_rounded 
                        : Icons.check_circle_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(_currentTask.isCompleted 
                      ? 'Marcar como pendente' 
                      : 'Marcar como concluída'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_rounded, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert_rounded, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Card
          _buildStatusCard(),
          
          const SizedBox(height: 24),
          
          // Informações principais
          _buildInfoCard(),
          
          const SizedBox(height: 24),
          
          // Datas
          _buildDatesCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _currentTask.isCompleted
              ? [Colors.green, Colors.green.shade400]
              : [Colors.blue, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (_currentTask.isCompleted ? Colors.green : Colors.blue)
                .withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _currentTask.isCompleted 
                ? Icons.check_circle_rounded 
                : Icons.schedule_rounded,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          Text(
            _currentTask.isCompleted ? 'Tarefa Concluída' : 'Tarefa Pendente',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_currentTask.isCompleted && _currentTask.completedAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Concluída em ${_formatDateTime(_currentTask.completedAt!)}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Text(
            'Título',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentTask.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              decoration: _currentTask.isCompleted 
                  ? TextDecoration.lineThrough 
                  : null,
            ),
          ),
          
          if (_currentTask.description.isNotEmpty) ...[
            const SizedBox(height: 20),
            
            // Descrição
            const Text(
              'Descrição',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _currentTask.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
                decoration: _currentTask.isCompleted 
                    ? TextDecoration.lineThrough 
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDatesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações de Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Data de criação
          _buildDateRow(
            'Criada em',
            _formatDateTime(_currentTask.date),
            Icons.add_circle_outline_rounded,
            Colors.blue,
          ),
          
          if (_currentTask.isCompleted && _currentTask.completedAt != null) ...[
            const SizedBox(height: 16),
            _buildDateRow(
              'Concluída em',
              _formatDateTime(_currentTask.completedAt!),
              Icons.check_circle_outline_rounded,
              Colors.green,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, String date, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botão de toggle status
            Expanded(
              child: FilledButton.icon(
                onPressed: widget.viewModel.updateTask.running 
                    ? null 
                    : _toggleTaskComplete,
                icon: widget.viewModel.updateTask.running
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(_currentTask.isCompleted 
                        ? Icons.undo_rounded 
                        : Icons.check_circle_rounded),
                label: Text(
                  _currentTask.isCompleted 
                      ? 'Marcar como pendente' 
                      : 'Marcar como concluída',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _currentTask.isCompleted 
                      ? Colors.orange 
                      : Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Botão de delete
            FilledButton(
              onPressed: widget.viewModel.deleteTask.running 
                  ? null 
                  : _deleteTask,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.viewModel.deleteTask.running
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.delete_rounded),
            ),
          ],
        ),
      ),
    );
  }

  // Ações
  void _handleMenuAction(String action) {
    switch (action) {
      case 'toggle':
        _toggleTaskComplete();
        break;
      case 'delete':
        _deleteTask();
        break;
    }
  }

  Future<void> _toggleTaskComplete() async {
    final updatedTask = _currentTask.copyWith(
      isCompleted: !_currentTask.isCompleted,
      completedAt: !_currentTask.isCompleted ? DateTime.now() : null,
    );

    await widget.viewModel.updateTask.execute(updatedTask);

    if (widget.viewModel.updateTask.error) {
      _showErrorSnackBar(
        widget.viewModel.updateTask.errorMessage ?? 'Erro ao atualizar tarefa',
      );
    } else {
      setState(() {
        _currentTask = updatedTask;
      });
      _showSuccessSnackBar(
        _currentTask.isCompleted 
            ? 'Tarefa marcada como concluída!' 
            : 'Tarefa marcada como pendente',
      );
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await _showDeleteConfirmation();
    if (!confirmed) return;

    await widget.viewModel.deleteTask.execute(_currentTask.id);

    if (widget.viewModel.deleteTask.error) {
      _showErrorSnackBar(
        widget.viewModel.deleteTask.errorMessage ?? 'Erro ao excluir tarefa',
      );
    } else {
      _showSuccessSnackBar('Tarefa excluída com sucesso');
      Navigator.of(context).pop();
    }
  }

  void _editTask() {
    // TODO: Implementar edição de tarefa
    _showSuccessSnackBar('Funcionalidade de edição em desenvolvimento');
  }

  // Diálogos e SnackBars
  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Excluir Tarefa',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Tem certeza que deseja excluir a tarefa "${_currentTask.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeString = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (taskDate == today) {
      return 'Hoje, $timeString';
    } else if (taskDate == yesterday) {
      return 'Ontem, $timeString';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}, $timeString';
    }
  }
}
