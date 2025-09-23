class TurmaModel {
  int turmaID;
  int cursoID;
  String turmaNome;
  String? codigo;
  bool ativa;
  DateTime? dataInicio;
  String turno;
  DateTime dataInsercao;
  String? cursoNome;

  TurmaModel({
    required this.turmaID,
    required this.cursoID,
    required this.turmaNome,
    this.codigo,
    required this.ativa,
    this.dataInicio,
    required this.turno,
    required this.dataInsercao,
    this.cursoNome,
  });

  // Factory constructor para criar instância a partir de JSON
  factory TurmaModel.fromJson(Map<String, dynamic> json) {
    return TurmaModel(
      turmaID: json['turmaID'] as int,
      cursoID: json['cursoID'] as int,
      turmaNome: json['turmaNome'] as String,
      codigo: json['codigo'] as String?,
      ativa: json['ativa'] as bool,
      dataInicio: json['dataInicio'] != null 
          ? DateTime.parse(json['dataInicio'] as String)
          : null,
      turno: json['turno'] as String,
      dataInsercao: DateTime.parse(json['dataInsercao'] as String),
      cursoNome: json['cursoNome'] as String?,
    );
  }

  // Método para converter instância para JSON
  Map<String, dynamic> toJson() {
    return {
      'turmaID': turmaID,
      'cursoID': cursoID,
      'turmaNome': turmaNome,
      'codigo': codigo,
      'ativa': ativa,
      'dataInicio': dataInicio?.toIso8601String(),
      'turno': turno,
      'dataInsercao': dataInsercao.toIso8601String(),
      'cursoNome': cursoNome,
    };
  }

  // Método toString para debug
  @override
  String toString() {
    return 'TurmaModel(turmaID: $turmaID, cursoID: $cursoID, turmaNome: $turmaNome, codigo: $codigo, ativa: $ativa, dataInicio: $dataInicio, turno: $turno, dataInsercao: $dataInsercao, cursoNome: $cursoNome)';
  }

  // Método copyWith para criar cópias com modificações
  TurmaModel copyWith({
    int? turmaID,
    int? cursoID,
    String? turmaNome,
    String? codigo,
    bool? ativa,
    DateTime? dataInicio,
    String? turno,
    DateTime? dataInsercao,
    String? cursoNome,
  }) {
    return TurmaModel(
      turmaID: turmaID ?? this.turmaID,
      cursoID: cursoID ?? this.cursoID,
      turmaNome: turmaNome ?? this.turmaNome,
      codigo: codigo ?? this.codigo,
      ativa: ativa ?? this.ativa,
      dataInicio: dataInicio ?? this.dataInicio,
      turno: turno ?? this.turno,
      dataInsercao: dataInsercao ?? this.dataInsercao,
      cursoNome: cursoNome ?? this.cursoNome,
    );
  }

  // Implementação de equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TurmaModel &&
        other.turmaID == turmaID &&
        other.cursoID == cursoID &&
        other.turmaNome == turmaNome &&
        other.codigo == codigo &&
        other.ativa == ativa &&
        other.dataInicio == dataInicio &&
        other.turno == turno &&
        other.dataInsercao == dataInsercao &&
        other.cursoNome == cursoNome;
  }

  @override
  int get hashCode {
    return Object.hash(
      turmaID,
      cursoID,
      turmaNome,
      codigo,
      ativa,
      dataInicio,
      turno,
      dataInsercao,
      cursoNome,
    );
  }
}