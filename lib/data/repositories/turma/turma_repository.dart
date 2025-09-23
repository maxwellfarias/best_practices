import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/domain/models/curso_model.dart';
import 'package:mastering_tests/utils/result.dart';

abstract class TurmaRepository {
  /// Busca todas as turmas
  Future<Result<List<TurmaModel>>> getTurmas();

  /// Busca turma por ID
  Future<Result<TurmaModel>> getTurmaById(int id);

  /// Cria uma nova turma
  Future<Result<TurmaModel>> createTurma(TurmaModel turma);

  /// Atualiza uma turma existente
  Future<Result<TurmaModel>> updateTurma(TurmaModel turma);

  /// Exclui uma turma
  Future<Result<void>> deleteTurma(int id);

  /// Busca todos os cursos disponíveis
  Future<Result<List<CursoModel>>> getCursos();

  /// Busca todos os turnos disponíveis
  Future<Result<List<String>>> getTurnos();
}
