class CursoModel {
  final int id;
  final String nome;

  CursoModel({
    required this.id,
    required this.nome,
  });

  // Factory constructor para criar instância a partir de JSON
  factory CursoModel.fromJson(Map<String, dynamic> json) {
    return CursoModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
    );
  }

  // Método para converter instância para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  // Método toString para debug
  @override
  String toString() {
    return 'CursoModel(id: $id, nome: $nome)';
  }

  // Método copyWith para criar cópias com modificações
  CursoModel copyWith({
    int? id,
    String? nome,
  }) {
    return CursoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }

  // Implementação de equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CursoModel &&
        other.id == id &&
        other.nome == nome;
  }

  @override
  int get hashCode {
    return Object.hash(id, nome);
  }
}
