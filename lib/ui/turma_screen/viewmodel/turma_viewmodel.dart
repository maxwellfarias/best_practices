import 'package:flutter/widgets.dart';
import 'package:mastering_tests/data/repositories/turma/turma_repository.dart';
import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/result.dart';

/// ViewModel para gerenciar estado e operações de Turma
/// Implementa Command Pattern para operações assíncronas
final class TurmaViewModel extends ChangeNotifier {
  TurmaViewModel({required TurmaRepository turmaRepository}) : _turmaRepository = turmaRepository {
    // Inicialização dos 5 Commands obrigatórios
    getAllTurmas = Command0<List<TurmaModel>>(_getAllTurmas);
    getTurmaById = Command1<TurmaModel, String>(_getTurmaById);
    createTurma = Command1<TurmaModel, TurmaModel>(_createTurma);
    updateTurma = Command1<TurmaModel, TurmaModel>(_updateTurma);
    deleteTurma = Command1<dynamic, String>(_deleteTurma);
  }

  final TurmaRepository _turmaRepository;

  // Lista privada de turmas em memória
  final List<TurmaModel> _turmas = [];
  List<TurmaModel> get turmas => _turmas;

  /// 5 COMMANDS OBRIGATÓRIOS para operações assíncronas
  late final Command0<List<TurmaModel>> getAllTurmas;
  late final Command1<TurmaModel, String> getTurmaById;
  late final Command1<TurmaModel, TurmaModel> createTurma;
  late final Command1<TurmaModel, TurmaModel> updateTurma;
  late final Command1<dynamic, String> deleteTurma;

  /// 1. Implementação para buscar todas as turmas
  Future<Result<List<TurmaModel>>> _getAllTurmas() async {
    return await _turmaRepository.getAllTurmas(databaseId: 'default')
    .map((turmas) {
      _turmas
      ..clear()
      ..addAll(turmas);
      notifyListeners();
      return turmas;
    });
  }

  /// 2. Implementação para buscar turma por ID
  Future<Result<TurmaModel>> _getTurmaById(String turmaId) async {
    return await _turmaRepository.getTurmaById(databaseId: 'default', turmaId: turmaId);
  }

  /// 3. Implementação para criar nova turma
  Future<Result<TurmaModel>> _createTurma(TurmaModel turma) async {
    return await _turmaRepository.createTurma(databaseId: 'default', turma: turma)
    .map((createdTurma) {
      _turmas.add(createdTurma);
      notifyListeners();
      return createdTurma;
    });
  }

  /// 4. Implementação para atualizar turma existente
  Future<Result<TurmaModel>> _updateTurma(TurmaModel turma) async {
    return await _turmaRepository.updateTurma(databaseId: 'default', turma: turma)
    .map((updatedTurma) {
      final index = _turmas.indexWhere((t) => t.turmaID == updatedTurma.turmaID);
      if (index != -1) {
        _turmas[index] = updatedTurma;
        notifyListeners();
      }
      return updatedTurma;
    });
  }

  /// 5. Implementação para deletar turma
  Future<Result<dynamic>> _deleteTurma(String turmaId) async {
    return await _turmaRepository.deleteTurma(databaseId: 'default', turmaId: turmaId)
    .map((_) {
      _turmas.removeWhere((turma) => turma.turmaID.toString() == turmaId);
      notifyListeners();
      return Result.ok(null);
    });
  }

  /// Filtros para busca (baseado na funcionalidade React)
  List<TurmaModel> filterTurmas({
    String searchTerm = '',
    String statusFilter = 'all',
    int cursoFilter = 0,
  }) {
    return _turmas.where((turma) {
      // Filtro de busca (nome da turma, código ou curso)
      final matchesSearch = searchTerm.isEmpty ||
          turma.turmaNome.toLowerCase().contains(searchTerm.toLowerCase()) ||
          (turma.codigo?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false) ||
          (turma.cursoNome?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false);

      // Filtro de status
      final matchesStatus = statusFilter == 'all' ||
          (statusFilter == 'active' && turma.ativa) ||
          (statusFilter == 'inactive' && !turma.ativa);

      // Filtro de curso
      final matchesCurso = cursoFilter == 0 || turma.cursoID == cursoFilter;

      return matchesSearch && matchesStatus && matchesCurso;
    }).toList();
  }

  /// Limpar dados locais
  void clearLocalData() {
    _turmas.clear();
    notifyListeners();
  }
}