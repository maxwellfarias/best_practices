import 'package:mastering_tests/data/repositories/turma/turma_repository.dart';
import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/domain/models/curso_model.dart';
import 'package:mastering_tests/utils/mocks/turma_mock.dart';
import 'package:mastering_tests/utils/result.dart';

class TurmaRepositoryImpl implements TurmaRepository {
  @override
  Future<Result<List<TurmaModel>>> getTurmas() {
    return TurmaMock.getTurmas();
  }

  @override
  Future<Result<TurmaModel>> getTurmaById(int id) {
    return TurmaMock.getTurmaById(id);
  }

  @override
  Future<Result<TurmaModel>> createTurma(TurmaModel turma) {
    return TurmaMock.createTurma(turma);
  }

  @override
  Future<Result<TurmaModel>> updateTurma(TurmaModel turma) {
    return TurmaMock.updateTurma(turma);
  }

  @override
  Future<Result<void>> deleteTurma(int id) {
    return TurmaMock.deleteTurma(id);
  }

  @override
  Future<Result<List<CursoModel>>> getCursos() {
    return TurmaMock.getCursos();
  }

  @override
  Future<Result<List<String>>> getTurnos() {
    return TurmaMock.getTurnos();
  }
}
