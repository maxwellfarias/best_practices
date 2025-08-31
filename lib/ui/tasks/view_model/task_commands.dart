import 'package:flutter/foundation.dart';
import '../../../domain/models/task.dart';
import '../../../data/repositories/task_repository.dart';

/// Interface base para todos os comandos de tarefa
/// 
/// Implementa o Command Pattern para encapsular operações
/// e permitir execução assíncrona com callbacks.
abstract interface class TaskCommand {
  Future<void> execute();
}

/// Comando para criar uma nova tarefa
class CreateTaskCommand implements TaskCommand {
  final TaskRepository _repository;
  final CreateTaskData _data;
  final Future<void> Function()? _onSuccess;
  final ValueChanged<String>? _onError;

  CreateTaskCommand(
    this._repository,
    this._data, {
    Future<void> Function()? onSuccess,
    ValueChanged<String>? onError,
  })  : _onSuccess = onSuccess,
        _onError = onError;

  @override
  Future<void> execute() async {
    final result = await _repository.createTask(_data);
    
    await result.when(
      success: (_) async => await _onSuccess?.call(),
      failure: (error) async => _onError?.call(error),
    );
  }
}

/// Comando para atualizar uma tarefa existente
class UpdateTaskCommand implements TaskCommand {
  final TaskRepository _repository;
  final String _taskId;
  final UpdateTaskData _data;
  final Future<void> Function()? _onSuccess;
  final ValueChanged<String>? _onError;

  UpdateTaskCommand(
    this._repository,
    this._taskId,
    this._data, {
    Future<void> Function()? onSuccess,
    ValueChanged<String>? onError,
  })  : _onSuccess = onSuccess,
        _onError = onError;

  @override
  Future<void> execute() async {
    final result = await _repository.updateTask(_taskId, _data);
    
    await result.when(
      success: (_) async => await _onSuccess?.call(),
      failure: (error) async => _onError?.call(error),
    );
  }
}

/// Comando para excluir uma tarefa
class DeleteTaskCommand implements TaskCommand {
  final TaskRepository _repository;
  final String _taskId;
  final Future<void> Function()? _onSuccess;
  final ValueChanged<String>? _onError;

  DeleteTaskCommand(
    this._repository,
    this._taskId, {
    Future<void> Function()? onSuccess,
    ValueChanged<String>? onError,
  })  : _onSuccess = onSuccess,
        _onError = onError;

  @override
  Future<void> execute() async {
    final result = await _repository.deleteTask(_taskId);
    
    await result.when(
      success: (_) async => await _onSuccess?.call(),
      failure: (error) async => _onError?.call(error),
    );
  }
}

/// Comando para marcar uma tarefa como concluída
class CompleteTaskCommand implements TaskCommand {
  final TaskRepository _repository;
  final String _taskId;
  final Future<void> Function()? _onSuccess;
  final ValueChanged<String>? _onError;

  CompleteTaskCommand(
    this._repository,
    this._taskId, {
    Future<void> Function()? onSuccess,
    ValueChanged<String>? onError,
  })  : _onSuccess = onSuccess,
        _onError = onError;

  @override
  Future<void> execute() async {
    final updateData = UpdateTaskData(isCompleted: true);
    final result = await _repository.updateTask(_taskId, updateData);
    
    await result.when(
      success: (_) async => await _onSuccess?.call(),
      failure: (error) async => _onError?.call(error),
    );
  }
}

/// Comando para marcar uma tarefa como não concluída
class UncompleteTaskCommand implements TaskCommand {
  final TaskRepository _repository;
  final String _taskId;
  final Future<void> Function()? _onSuccess;
  final ValueChanged<String>? _onError;

  UncompleteTaskCommand(
    this._repository,
    this._taskId, {
    Future<void> Function()? onSuccess,
    ValueChanged<String>? onError,
  })  : _onSuccess = onSuccess,
        _onError = onError;

  @override
  Future<void> execute() async {
    final updateData = UpdateTaskData(isCompleted: false);
    final result = await _repository.updateTask(_taskId, updateData);
    
    await result.when(
      success: (_) async => await _onSuccess?.call(),
      failure: (error) async => _onError?.call(error),
    );
  }
}
