import 'package:mastering_tests/data/repositories/curso/curso_repository.dart';
import 'package:mastering_tests/domain/models/curso_model.dart';
import 'package:mastering_tests/utils/mocks/curso_mock.dart';
import 'package:mastering_tests/utils/result.dart';

/// Implementação concreta do CursoRepository
/// Conecta-se à camada de dados mockados para simular operações de persistência
class CursoRepositoryImpl implements CursoRepository {
  
  @override
  Future<Result<List<Cursos>>> getCursos() async {
    return await CursoMock.getMockCursos();
  }

  @override
  Future<Result<Cursos>> getCursoById(int cursoId) async {
    return await CursoMock.getMockCursoById(cursoId);
  }

  @override
  Future<Result<Cursos>> addCurso(Cursos curso) async {
    return await CursoMock.addCurso(curso);
  }

  @override
  Future<Result<Cursos>> updateCurso(Cursos curso) async {
    return await CursoMock.updateCurso(curso);
  }

  @override
  Future<Result<bool>> deleteCurso(int cursoId) async {
    return await CursoMock.deleteCurso(cursoId);
  }
}