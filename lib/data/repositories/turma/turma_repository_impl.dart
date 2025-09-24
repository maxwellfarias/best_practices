import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/utils/mocks/turma_mock.dart';
import 'package:mastering_tests/utils/result.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'turma_repository.dart';

/// Implementação concreta do repositório de Turma
/// Conecta à camada de dados mockados para desenvolvimento
class TurmaRepositoryImpl implements TurmaRepository {
  TurmaRepositoryImpl();

  @override
  Future<Result<List<TurmaModel>>> getAllTurmas({required String databaseId}) async {
    return await TurmaMock.getMockTurmas();
  }

  @override
  Future<Result<TurmaModel>> getTurmaById({required String databaseId, required String turmaId}) async {
    final id = int.tryParse(turmaId);
    if (id == null) {
      return Result.error(RecursoNaoEncontradoException());
    }
    return await TurmaMock.getMockTurmaById(id);
  }

  @override
  Future<Result<TurmaModel>> createTurma({required String databaseId, required TurmaModel turma}) async {
    return await TurmaMock.addTurma(turma);
  }

  @override
  Future<Result<TurmaModel>> updateTurma({required String databaseId, required TurmaModel turma}) async {
    return await TurmaMock.updateTurma(turma);
  }

  @override
  Future<Result<dynamic>> deleteTurma({required String databaseId, required String turmaId}) async {
    final id = int.tryParse(turmaId);
    if (id == null) {
      return Result.error(RecursoNaoEncontradoException());
    }
    
    final result = await TurmaMock.deleteTurma(id);
    return result.map((_) => Result.ok(null));
  }
}