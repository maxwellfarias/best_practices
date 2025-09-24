import 'package:mastering_tests/domain/models/curso_model.dart';
import 'package:mastering_tests/utils/result.dart';

/// Repository abstrato para operações com CursoModel
/// Define o contrato que deve ser implementado por todas as implementações concretas
abstract class CursoRepository {
  /// Obtém lista de todos os cursos
  /// Retorna [Result<List<Cursos>>] com lista de cursos ou erro
  Future<Result<List<Cursos>>> getCursos();

  /// Obtém curso por ID específico
  /// Parâmetro [cursoId]: ID único do curso
  /// Retorna [Result<Cursos>] com curso encontrado ou erro
  Future<Result<Cursos>> getCursoById(int cursoId);

  /// Adiciona novo curso ao sistema
  /// Parâmetro [curso]: Dados do novo curso a ser criado
  /// Retorna [Result<Cursos>] com curso criado (incluindo ID gerado) ou erro
  Future<Result<Cursos>> addCurso(Cursos curso);

  /// Atualiza curso existente
  /// Parâmetro [curso]: Dados atualizados do curso (deve conter ID válido)
  /// Retorna [Result<Cursos>] com curso atualizado ou erro
  Future<Result<Cursos>> updateCurso(Cursos curso);

  /// Remove curso do sistema
  /// Parâmetro [cursoId]: ID do curso a ser removido
  /// Retorna [Result<bool>] indicando sucesso da operação ou erro
  Future<Result<bool>> deleteCurso(int cursoId);
}