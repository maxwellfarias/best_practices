
/// Modelo de domínio para uma tarefa
/// 
/// Representa uma tarefa no sistema com todos os dados necessários
/// para a lógica de negócio. Usa Equatable para facilitar comparações
/// em testes.
final class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime date;
  final DateTime? completedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
    this.completedAt,
  });

  factory Task.fromJson(dynamic json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      date: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'created_at': date.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

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
      date: createdAt ?? this.date,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'Task('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'isCompleted: $isCompleted, '
        'createdAt: $date, '
        'completedAt: $completedAt'
        ')';
  }


}
