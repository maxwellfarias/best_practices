import 'package:equatable/equatable.dart';

/// Modelo de domínio para uma tarefa
/// 
/// Representa uma tarefa no sistema com todos os dados necessários
/// para a lógica de negócio. Usa Equatable para facilitar comparações
/// em testes.
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  /// Cria uma cópia da tarefa com alguns campos atualizados
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        completedAt,
      ];

  @override
  String toString() {
    return 'Task('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'isCompleted: $isCompleted, '
        'createdAt: $createdAt, '
        'completedAt: $completedAt'
        ')';
  }
}

/// Dados para criar uma nova tarefa
class CreateTaskData extends Equatable {
  final String title;
  final String description;

  const CreateTaskData({
    required this.title,
    required this.description,
  });

  @override
  List<Object> get props => [title, description];
}

/// Dados para atualizar uma tarefa existente
class UpdateTaskData extends Equatable {
  final String? title;
  final String? description;
  final bool? isCompleted;

  const UpdateTaskData({
    this.title,
    this.description,
    this.isCompleted,
  });

  @override
  List<Object?> get props => [title, description, isCompleted];
}
