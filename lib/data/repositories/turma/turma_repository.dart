import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/utils/result.dart';

/// Interface do repositório para operações CRUD de Turma
/// Define os contratos obrigatórios para persistência de dados
abstract interface class TurmaRepository {
  /// 1. Buscar todas as turmas do sistema
  /// 
  /// [databaseId] - Identificador do banco de dados/contexto
  /// Retorna lista completa de turmas ou erro caso falhe
  Future<Result<List<TurmaModel>>> getAllTurmas({required String databaseId});

  /// 2. Buscar turma específica por ID
  /// 
  /// [databaseId] - Identificador do banco de dados/contexto
  /// [turmaId] - ID único da turma a ser buscada
  /// Retorna turma encontrada ou erro de não encontrado
  Future<Result<TurmaModel>> getTurmaById({required String databaseId, required String turmaId});

  /// 3. Criar nova turma no sistema
  /// 
  /// [databaseId] - Identificador do banco de dados/contexto
  /// [turma] - Dados da nova turma a ser criada
  /// Retorna turma criada com ID gerado ou erro de criação
  Future<Result<TurmaModel>> createTurma({required String databaseId, required TurmaModel turma});

  /// 4. Atualizar turma existente
  /// 
  /// [databaseId] - Identificador do banco de dados/contexto
  /// [turma] - Dados atualizados da turma (deve conter ID válido)
  /// Retorna turma atualizada ou erro caso não encontre/falhe
  Future<Result<TurmaModel>> updateTurma({required String databaseId, required TurmaModel turma});

  /// 5. Excluir turma do sistema
  /// 
  /// [databaseId] - Identificador do banco de dados/contexto
  /// [turmaId] - ID único da turma a ser excluída
  /// Retorna true se excluída com sucesso ou erro caso falhe
  Future<Result<dynamic>> deleteTurma({required String databaseId, required String turmaId});
}