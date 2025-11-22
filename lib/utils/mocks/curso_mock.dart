import 'package:best_practices/domain/models/curso_model.dart';
import 'package:best_practices/exceptions/app_exception.dart';
import 'package:best_practices/utils/result.dart';

/// Classe utilitária para criar dados fictícios de Cursos
class CursoMock {
  static List<Cursos> _cursos = [];

  /// Inicializa dados fictícios se a lista estiver vazia
  static void _initializeIfEmpty() {
    if (_cursos.isEmpty) {
      _cursos = [
        Cursos(
          cursoID: 1,
          nomeCurso: "Engenharia de Software",
          codigoCursoEMEC: 123456,
          numeroProcesso: "23000.000123/2020-01",
          tipoProcesso: "Autorização",
          dataCadastro: DateTime.parse("2020-01-15"),
          dataProtocolo: DateTime.parse("2020-01-10"),
          modalidade: "Presencial",
          tituloConferido: "Bacharel em Engenharia de Software",
          grauConferido: "Bacharel",
          logradouro: "Rua das Palmeiras, 123",
          bairro: "Centro",
          codigoMunicipio: 3550308,
          nomeMunicipio: "São Paulo",
          uf: "SP",
          cep: "01234-567",
          autorizacaoTipo: "Portaria MEC",
          autorizacaoNumero: "123/2020",
          autorizacaoData: DateTime.parse("2020-02-01"),
          reconhecimentoTipo: "Portaria MEC",
          reconhecimentoNumero: "456/2023",
          reconhecimentoData: DateTime.parse("2023-03-15"),
        ),
        Cursos(
          cursoID: 2,
          nomeCurso: "Administração",
          codigoCursoEMEC: 789012,
          modalidade: "EaD",
          tituloConferido: "Bacharel em Administração",
          grauConferido: "Bacharel",
          logradouro: "Av. Paulista, 1500",
          bairro: "Bela Vista",
          codigoMunicipio: 3550308,
          nomeMunicipio: "São Paulo",
          uf: "SP",
          cep: "01310-100",
          autorizacaoTipo: "Portaria MEC",
          autorizacaoNumero: "789/2019",
          autorizacaoData: DateTime.parse("2019-08-15"),
          reconhecimentoTipo: "Portaria MEC",
          reconhecimentoNumero: "012/2022",
          reconhecimentoData: DateTime.parse("2022-11-20"),
        ),
        Cursos(
          cursoID: 3,
          nomeCurso: "Análise e Desenvolvimento de Sistemas",
          modalidade: "Híbrido",
          tituloConferido: "Tecnólogo em Análise e Desenvolvimento de Sistemas",
          grauConferido: "Tecnólogo",
          logradouro: "Rua da Consolação, 930",
          bairro: "Consolação",
          codigoMunicipio: 3550308,
          nomeMunicipio: "São Paulo",
          uf: "SP",
          cep: "01302-907",
          autorizacaoTipo: "Portaria MEC",
          autorizacaoNumero: "345/2021",
          autorizacaoData: DateTime.parse("2021-05-10"),
          reconhecimentoTipo: "Portaria MEC",
          reconhecimentoNumero: "678/2024",
          reconhecimentoData: DateTime.parse("2024-01-25"),
        ),
        Cursos(
          cursoID: 4,
          nomeCurso: "Direito",
          codigoCursoEMEC: 456789,
          numeroProcesso: "23000.000456/2019-01",
          tipoProcesso: "Reconhecimento",
          dataCadastro: DateTime.parse("2019-03-20"),
          dataProtocolo: DateTime.parse("2019-03-15"),
          modalidade: "Presencial",
          tituloConferido: "Bacharel em Direito",
          grauConferido: "Bacharel",
          logradouro: "Rua Líbero Badaró, 425",
          bairro: "Centro",
          codigoMunicipio: 3550308,
          nomeMunicipio: "São Paulo",
          uf: "SP",
          cep: "01009-000",
          autorizacaoTipo: "Decreto",
          autorizacaoNumero: "234/2018",
          autorizacaoData: DateTime.parse("2018-12-10"),
          reconhecimentoTipo: "Portaria MEC",
          reconhecimentoNumero: "789/2022",
          reconhecimentoData: DateTime.parse("2022-06-30"),
        ),
        Cursos(
          cursoID: 5,
          nomeCurso: "Medicina",
          codigoCursoEMEC: 654321,
          numeroProcesso: "23000.000789/2017-01",
          tipoProcesso: "Autorização",
          dataCadastro: DateTime.parse("2017-08-10"),
          dataProtocolo: DateTime.parse("2017-08-05"),
          modalidade: "Presencial",
          tituloConferido: "Médico",
          grauConferido: "Bacharel",
          logradouro: "Av. Dr. Arnaldo, 455",
          bairro: "Cerqueira César",
          codigoMunicipio: 3550308,
          nomeMunicipio: "São Paulo",
          uf: "SP",
          cep: "01246-903",
          autorizacaoTipo: "Portaria MEC",
          autorizacaoNumero: "567/2017",
          autorizacaoData: DateTime.parse("2017-12-15"),
          reconhecimentoTipo: "Portaria MEC",
          reconhecimentoNumero: "890/2023",
          reconhecimentoData: DateTime.parse("2023-09-20"),
        ),
      ];
    }
  }

  /// 1. Buscar todos os cursos
  static Future<Result<List<Cursos>>> getAllCursos() async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      return Result.ok(List.from(_cursos));
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// 2. Buscar curso por ID
  static Future<Result<Cursos>> getCursoById({required int cursoId}) async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      final curso = _cursos.firstWhere(
        (c) => c.cursoID == cursoId,
        orElse: () => throw RecursoNaoEncontradoException(),
      );
      
      return Result.ok(curso);
    } catch (e) {
      if (e is AppException) {
        return Result.error(e);
      }
      return Result.error(RecursoNaoEncontradoException());
    }
  }

  /// 3. Criar novo curso
  static Future<Result<Cursos>> createCurso({required Cursos curso}) async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      // Gera novo ID
      final newId = _cursos.isEmpty ? 1 : _cursos.map((c) => c.cursoID).reduce((a, b) => a > b ? a : b) + 1;
      
      final novoCurso = curso.copyWith(cursoID: newId);
      
      _cursos.add(novoCurso);
      return Result.ok(novoCurso);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// 4. Atualizar curso existente
  static Future<Result<Cursos>> updateCurso({required Cursos curso}) async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      final index = _cursos.indexWhere((c) => c.cursoID == curso.cursoID);
      if (index == -1) {
        return Result.error(RecursoNaoEncontradoException());
      }
      
      _cursos[index] = curso;
      return Result.ok(curso);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// 5. Deletar curso
  static Future<Result<bool>> deleteCurso({required int cursoId}) async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      final initialLength = _cursos.length;
      _cursos.removeWhere((curso) => curso.cursoID == cursoId);
      
      if (_cursos.length == initialLength) {
        return Result.error(RecursoNaoEncontradoException());
      }
      
      return Result.ok(true);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// Métodos utilitários adicionais

  /// Limpar todos os dados (útil para testes)
  static void clearAll() {
    _cursos.clear();
  }

  /// Contar total de cursos
  static int count() {
    _initializeIfEmpty();
    return _cursos.length;
  }

  /// Resetar para estado inicial
  static void reset() {
    _cursos.clear();
    _initializeIfEmpty();
  }

  /// Buscar cursos por modalidade
  static Future<Result<List<Cursos>>> getCursosByModalidade({required String modalidade}) async {
    await Future.delayed(const Duration(seconds: 1));
    _initializeIfEmpty();
    
    try {
      final cursosFiltrados = _cursos.where((curso) => 
          curso.modalidade.toLowerCase() == modalidade.toLowerCase()
      ).toList();
      
      return Result.ok(cursosFiltrados);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// Buscar cursos por grau
  static Future<Result<List<Cursos>>> getCursosByGrau({required String grauConferido}) async {
    await Future.delayed(const Duration(seconds: 1));
    _initializeIfEmpty();
    
    try {
      final cursosFiltrados = _cursos.where((curso) => 
          curso.grauConferido.toLowerCase() == grauConferido.toLowerCase()
      ).toList();
      
      return Result.ok(cursosFiltrados);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }
}