/// Modelo de domínio para um curso acadêmico
///
/// Representa um curso no sistema com todos os dados necessários
/// para a lógica de negócio conforme padrões do MEC.
final class Cursos {
  final int cursoID;
  final String nomeCurso;
  final int? codigoCursoEMEC;
  final String? numeroProcesso;
  final String? tipoProcesso;
  final DateTime? dataCadastro;
  final DateTime? dataProtocolo;
  final String modalidade;
  final String tituloConferido;
  final String grauConferido;
  final String logradouro;
  final String bairro;
  final int codigoMunicipio;
  final String nomeMunicipio;
  final String uf;
  final String cep;
  final String autorizacaoTipo;
  final String autorizacaoNumero;
  final DateTime autorizacaoData;
  final String reconhecimentoTipo;
  final String reconhecimentoNumero;
  final DateTime reconhecimentoData;

  /// Construtor
  const Cursos({
    required this.cursoID,
    required this.nomeCurso,
    this.codigoCursoEMEC,
    this.numeroProcesso,
    this.tipoProcesso,
    this.dataCadastro,
    this.dataProtocolo,
    required this.modalidade,
    required this.tituloConferido,
    required this.grauConferido,
    required this.logradouro,
    required this.bairro,
    required this.codigoMunicipio,
    required this.nomeMunicipio,
    required this.uf,
    required this.cep,
    required this.autorizacaoTipo,
    required this.autorizacaoNumero,
    required this.autorizacaoData,
    required this.reconhecimentoTipo,
    required this.reconhecimentoNumero,
    required this.reconhecimentoData,
  });

  // Factory constructor para criar instância a partir de JSON
  factory Cursos.fromJson(Map<String, dynamic> json) {
    return Cursos(
      cursoID: json['cursoID'] as int,
      nomeCurso: json['nomeCurso'] as String,
      codigoCursoEMEC: json['codigoCursoEMEC'] as int?,
      numeroProcesso: json['numeroProcesso'] as String?,
      tipoProcesso: json['tipoProcesso'] as String?,
      dataCadastro: json['dataCadastro'] != null 
          ? DateTime.parse(json['dataCadastro'] as String) 
          : null,
      dataProtocolo: json['dataProtocolo'] != null 
          ? DateTime.parse(json['dataProtocolo'] as String) 
          : null,
      modalidade: json['modalidade'] as String,
      tituloConferido: json['tituloConferido'] as String,
      grauConferido: json['grauConferido'] as String,
      logradouro: json['logradouro'] as String,
      bairro: json['bairro'] as String,
      codigoMunicipio: json['codigoMunicipio'] as int,
      nomeMunicipio: json['nomeMunicipio'] as String,
      uf: json['uf'] as String,
      cep: json['cep'] as String,
      autorizacaoTipo: json['autorizacaoTipo'] as String,
      autorizacaoNumero: json['autorizacaoNumero'] as String,
      autorizacaoData: DateTime.parse(json['autorizacaoData'] as String),
      reconhecimentoTipo: json['reconhecimentoTipo'] as String,
      reconhecimentoNumero: json['reconhecimentoNumero'] as String,
      reconhecimentoData: DateTime.parse(json['reconhecimentoData'] as String),
    );
  }

  // Método para converter instância para JSON
  Map<String, dynamic> toJson() {
    return {
      'cursoID': cursoID,
      'nomeCurso': nomeCurso,
      'codigoCursoEMEC': codigoCursoEMEC,
      'numeroProcesso': numeroProcesso,
      'tipoProcesso': tipoProcesso,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataProtocolo': dataProtocolo?.toIso8601String(),
      'modalidade': modalidade,
      'tituloConferido': tituloConferido,
      'grauConferido': grauConferido,
      'logradouro': logradouro,
      'bairro': bairro,
      'codigoMunicipio': codigoMunicipio,
      'nomeMunicipio': nomeMunicipio,
      'uf': uf,
      'cep': cep,
      'autorizacaoTipo': autorizacaoTipo,
      'autorizacaoNumero': autorizacaoNumero,
      'autorizacaoData': autorizacaoData.toIso8601String(),
      'reconhecimentoTipo': reconhecimentoTipo,
      'reconhecimentoNumero': reconhecimentoNumero,
      'reconhecimentoData': reconhecimentoData.toIso8601String(),
    };
  }

  // Método toString para debug
  @override
  String toString() {
    return 'Cursos{cursoID: $cursoID, nomeCurso: $nomeCurso, modalidade: $modalidade}';
  }

  // Método copyWith para criar cópias modificadas
  Cursos copyWith({
    int? cursoID,
    String? nomeCurso,
    int? codigoCursoEMEC,
    String? numeroProcesso,
    String? tipoProcesso,
    DateTime? dataCadastro,
    DateTime? dataProtocolo,
    String? modalidade,
    String? tituloConferido,
    String? grauConferido,
    String? logradouro,
    String? bairro,
    int? codigoMunicipio,
    String? nomeMunicipio,
    String? uf,
    String? cep,
    String? autorizacaoTipo,
    String? autorizacaoNumero,
    DateTime? autorizacaoData,
    String? reconhecimentoTipo,
    String? reconhecimentoNumero,
    DateTime? reconhecimentoData,
  }) {
    return Cursos(
      cursoID: cursoID ?? this.cursoID,
      nomeCurso: nomeCurso ?? this.nomeCurso,
      codigoCursoEMEC: codigoCursoEMEC ?? this.codigoCursoEMEC,
      numeroProcesso: numeroProcesso ?? this.numeroProcesso,
      tipoProcesso: tipoProcesso ?? this.tipoProcesso,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      dataProtocolo: dataProtocolo ?? this.dataProtocolo,
      modalidade: modalidade ?? this.modalidade,
      tituloConferido: tituloConferido ?? this.tituloConferido,
      grauConferido: grauConferido ?? this.grauConferido,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      codigoMunicipio: codigoMunicipio ?? this.codigoMunicipio,
      nomeMunicipio: nomeMunicipio ?? this.nomeMunicipio,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      autorizacaoTipo: autorizacaoTipo ?? this.autorizacaoTipo,
      autorizacaoNumero: autorizacaoNumero ?? this.autorizacaoNumero,
      autorizacaoData: autorizacaoData ?? this.autorizacaoData,
      reconhecimentoTipo: reconhecimentoTipo ?? this.reconhecimentoTipo,
      reconhecimentoNumero: reconhecimentoNumero ?? this.reconhecimentoNumero,
      reconhecimentoData: reconhecimentoData ?? this.reconhecimentoData,
    );
  }
}