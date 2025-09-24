import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/utils/result.dart';

/// Classe utilitária para criar dados fictícios de TurmaModel
/// Simula operações CRUD com dados mockados para desenvolvimento
class TurmaMock {
  static List<TurmaModel> _turmas = [];
  static List<CursoMock> _cursos = [];

  /// Inicializa dados fictícios se a lista estiver vazia
  static void _initializeIfEmpty() {
    if (_turmas.isEmpty) {
      _cursos = [
        CursoMock(id: 1, nome: "Engenharia Civil"),
        CursoMock(id: 2, nome: "Administração"),
        CursoMock(id: 3, nome: "Direito"),
        CursoMock(id: 4, nome: "Medicina"),
      ];

      _turmas = [
        TurmaModel(
          turmaID: 1,
          cursoID: 1,
          turmaNome: "Turma A",
          codigo: "ENG001",
          ativa: true,
          dataInicio: DateTime.parse("2024-02-05"),
          turno: "Manhã",
          dataInsercao: DateTime.parse("2024-01-15T10:00:00Z"),
        ),
        TurmaModel(
          turmaID: 2,
          cursoID: 2,
          turmaNome: "Turma B",
          codigo: "ADM001",
          ativa: true,
          dataInicio: DateTime.parse("2024-02-10"),
          turno: "Noite",
          dataInsercao: DateTime.parse("2024-01-20T14:30:00Z"),
        ),
        TurmaModel(
          turmaID: 3,
          cursoID: 3,
          turmaNome: "Turma C",
          codigo: "DIR001",
          ativa: false,
          dataInicio: DateTime.parse("2024-01-15"),
          turno: "Tarde",
          dataInsercao: DateTime.parse("2024-01-05T09:15:00Z"),
        ),
      ];
    }
  }

  /// Simula busca de todas as turmas com delay de rede
  static Future<Result<List<TurmaModel>>> getMockTurmas() async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      // Adiciona informação do curso para cada turma
      final turmasComCurso = _turmas.map((turma) {
        final curso = _cursos.firstWhere(
          (c) => c.id == turma.cursoID,
          orElse: () => CursoMock(id: turma.cursoID, nome: "Curso Desconhecido"),
        );
        return turma.copyWith(cursoNome: curso.nome);
      }).toList();
      
      return Result.ok(turmasComCurso);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// Simula busca de turma por ID
  static Future<Result<TurmaModel>> getMockTurmaById(int turmaId) async {
    await Future.delayed(const Duration(seconds: 1));
    _initializeIfEmpty();
    
    try {
      final turma = _turmas.firstWhere(
        (t) => t.turmaID == turmaId,
        orElse: () => throw RecursoNaoEncontradoException(),
      );
      
      final curso = _cursos.firstWhere(
        (c) => c.id == turma.cursoID,
        orElse: () => CursoMock(id: turma.cursoID, nome: "Curso Desconhecido"),
      );
      
      return Result.ok(turma.copyWith(cursoNome: curso.nome));
    } catch (e) {
      if (e is AppException) {
        return Result.error(e);
      }
      return Result.error(RecursoNaoEncontradoException());
    }
  }

  /// Simula criação de nova turma
  static Future<Result<TurmaModel>> addTurma(TurmaModel turma) async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      // Verifica se o curso existe
      if (!_cursos.any((c) => c.id == turma.cursoID)) {
        return Result.error(RecursoNaoEncontradoException());
      }
      
      // Gera novo ID
      final newId = _turmas.isEmpty ? 1 : _turmas.map((t) => t.turmaID).reduce((a, b) => a > b ? a : b) + 1;
      
      final novaTurma = turma.copyWith(
        turmaID: newId,
        dataInsercao: DateTime.now(),
      );
      
      _turmas.add(novaTurma);
      
      final curso = _cursos.firstWhere((c) => c.id == novaTurma.cursoID);
      return Result.ok(novaTurma.copyWith(cursoNome: curso.nome));
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// Simula atualização de turma existente
  static Future<Result<TurmaModel>> updateTurma(TurmaModel turma) async {
    await Future.delayed(const Duration(seconds: 2));
    _initializeIfEmpty();
    
    try {
      final index = _turmas.indexWhere((t) => t.turmaID == turma.turmaID);
      if (index == -1) {
        return Result.error(RecursoNaoEncontradoException());
      }
      
      // Verifica se o curso existe
      if (!_cursos.any((c) => c.id == turma.cursoID)) {
        return Result.error(RecursoNaoEncontradoException());
      }
      
      _turmas[index] = turma;
      
      final curso = _cursos.firstWhere((c) => c.id == turma.cursoID);
      return Result.ok(turma.copyWith(cursoNome: curso.nome));
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// Simula exclusão de turma
  static Future<Result<bool>> deleteTurma(int turmaId) async {
    await Future.delayed(const Duration(seconds: 1));
    _initializeIfEmpty();
    
    try {
      final initialLength = _turmas.length;
      _turmas.removeWhere((turma) => turma.turmaID == turmaId);
      
      if (_turmas.length == initialLength) {
        return Result.error(RecursoNaoEncontradoException());
      }
      
      return Result.ok(true);
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }

  /// Limpa todos os dados (útil para testes)
  static void clearAllTurmas() {
    _turmas.clear();
  }

  /// Restaura dados iniciais
  static void resetToInitialState() {
    _turmas.clear();
    _cursos.clear();
    _initializeIfEmpty();
  }

  /// Simula busca de todos os cursos
  static Future<Result<List<CursoMock>>> getMockCursos() async {
    await Future.delayed(const Duration(seconds: 1));
    _initializeIfEmpty();
    
    try {
      return Result.ok(List.from(_cursos));
    } catch (e) {
      return Result.error(UnknownErrorException());
    }
  }
}

/// Classe auxiliar para representar cursos
class CursoMock {
  final int id;
  final String nome;

  const CursoMock({
    required this.id,
    required this.nome,
  });

  @override
  String toString() => 'CursoMock(id: $id, nome: $nome)';
}