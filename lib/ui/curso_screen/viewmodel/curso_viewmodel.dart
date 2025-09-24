import 'package:flutter/foundation.dart';
import 'package:mastering_tests/data/repositories/curso/curso_repository.dart';
import 'package:mastering_tests/data/repositories/curso/curso_repository_impl.dart';
import 'package:mastering_tests/domain/models/curso_model.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/result.dart';

/// ViewModel para gerenciar estado e operações da tela de Cursos
/// Implementa Command pattern para todas as operações CRUD
class CursoViewModel extends ChangeNotifier {
  final CursoRepository _repository = CursoRepositoryImpl();

  // Lista de cursos carregados
  List<Cursos> _cursos = [];
  List<Cursos> get cursos => _cursos;

  // Curso selecionado/editando
  Cursos? _cursoSelecionado;
  Cursos? get cursoSelecionado => _cursoSelecionado;

  // Estados de filtro e busca
  String _termoBusca = '';
  String get termoBusca => _termoBusca;

  String? _filtroModalidade;
  String? get filtroModalidade => _filtroModalidade;

  String? _filtroGrau;
  String? get filtroGrau => _filtroGrau;

  String? _filtroEstado;
  String? get filtroEstado => _filtroEstado;

  // Commands para operações CRUD
  late final Command0<List<Cursos>> _loadCursosCommand;
  late final Command1<Cursos, int> _loadCursoByIdCommand;
  late final Command1<Cursos, Cursos> _addCursoCommand;
  late final Command1<Cursos, Cursos> _updateCursoCommand;
  late final Command1<bool, int> _deleteCursoCommand;

  // Getters para os commands
  Command0<List<Cursos>> get loadCursosCommand => _loadCursosCommand;
  Command1<Cursos, int> get loadCursoByIdCommand => _loadCursoByIdCommand;
  Command1<Cursos, Cursos> get addCursoCommand => _addCursoCommand;
  Command1<Cursos, Cursos> get updateCursoCommand => _updateCursoCommand;
  Command1<bool, int> get deleteCursoCommand => _deleteCursoCommand;

  CursoViewModel() {
    _initCommands();
    loadCursos();
  }

  void _initCommands() {
    _loadCursosCommand = Command0<List<Cursos>>(_loadCursos);
    _loadCursoByIdCommand = Command1<Cursos, int>(_loadCursoById);
    _addCursoCommand = Command1<Cursos, Cursos>(_addCurso);
    _updateCursoCommand = Command1<Cursos, Cursos>(_updateCurso);
    _deleteCursoCommand = Command1<bool, int>(_deleteCurso);

    // Escuta mudanças nos commands para atualizar a lista quando necessário
    _addCursoCommand.addListener(_onCrudCommandComplete);
    _updateCursoCommand.addListener(_onCrudCommandComplete);
    _deleteCursoCommand.addListener(_onCrudCommandComplete);
  }

  void _onCrudCommandComplete() {
    // Recarrega lista após operações de modificação
    if (_addCursoCommand.completed || 
        _updateCursoCommand.completed || 
        _deleteCursoCommand.completed) {
      loadCursos();
    }
  }

  // Implementações das operações de repository
  Future<Result<List<Cursos>>> _loadCursos() async {
    final result = await _repository.getCursos();
    if (result is Ok<List<Cursos>>) {
      _cursos = result.value;
      notifyListeners();
    }
    return result;
  }

  Future<Result<Cursos>> _loadCursoById(int cursoId) async {
    return await _repository.getCursoById(cursoId);
  }

  Future<Result<Cursos>> _addCurso(Cursos curso) async {
    return await _repository.addCurso(curso);
  }

  Future<Result<Cursos>> _updateCurso(Cursos curso) async {
    return await _repository.updateCurso(curso);
  }

  Future<Result<bool>> _deleteCurso(int cursoId) async {
    return await _repository.deleteCurso(cursoId);
  }

  // Métodos públicos para controle da tela
  
  /// Carrega lista de cursos
  Future<void> loadCursos() async {
    await _loadCursosCommand.execute();
  }

  /// Carrega curso específico por ID
  Future<void> loadCursoById(int cursoId) async {
    await _loadCursoByIdCommand.execute(cursoId);
    if (_loadCursoByIdCommand.completed) {
      _cursoSelecionado = _loadCursoByIdCommand.value;
      notifyListeners();
    }
  }

  /// Adiciona novo curso
  Future<void> addCurso(Cursos curso) async {
    await _addCursoCommand.execute(curso);
  }

  /// Atualiza curso existente
  Future<void> updateCurso(Cursos curso) async {
    await _updateCursoCommand.execute(curso);
  }

  /// Remove curso
  Future<void> deleteCurso(int cursoId) async {
    await _deleteCursoCommand.execute(cursoId);
  }

  // Métodos para controle de estado da UI

  /// Define curso selecionado
  void setCursoSelecionado(Cursos? curso) {
    _cursoSelecionado = curso;
    notifyListeners();
  }

  /// Limpa curso selecionado
  void clearCursoSelecionado() {
    _cursoSelecionado = null;
    notifyListeners();
  }

  /// Atualiza termo de busca e filtra cursos
  void setBusca(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }

  /// Define filtro por modalidade
  void setFiltroModalidade(String? modalidade) {
    _filtroModalidade = modalidade;
    notifyListeners();
  }

  /// Define filtro por grau conferido
  void setFiltroGrau(String? grau) {
    _filtroGrau = grau;
    notifyListeners();
  }

  /// Define filtro por estado
  void setFiltroEstado(String? estado) {
    _filtroEstado = estado;
    notifyListeners();
  }

  /// Limpa todos os filtros
  void clearFiltros() {
    _termoBusca = '';
    _filtroModalidade = null;
    _filtroGrau = null;
    _filtroEstado = null;
    notifyListeners();
  }

  /// Obtém lista filtrada de cursos baseada nos filtros ativos
  List<Cursos> get cursosFiltrados {
    var cursosFiltrados = List<Cursos>.from(_cursos);

    // Filtro por termo de busca
    if (_termoBusca.isNotEmpty) {
      cursosFiltrados = cursosFiltrados.where((curso) {
        final termo = _termoBusca.toLowerCase();
        return curso.nomeCurso.toLowerCase().contains(termo) ||
               (curso.codigoCursoEMEC?.toString().contains(termo) ?? false) ||
               curso.modalidade.toLowerCase().contains(termo) ||
               curso.grauConferido.toLowerCase().contains(termo) ||
               curso.nomeMunicipio.toLowerCase().contains(termo) ||
               curso.uf.toLowerCase().contains(termo);
      }).toList();
    }

    // Filtro por modalidade
    if (_filtroModalidade != null && _filtroModalidade!.isNotEmpty) {
      cursosFiltrados = cursosFiltrados.where((curso) => 
          curso.modalidade == _filtroModalidade
      ).toList();
    }

    // Filtro por grau
    if (_filtroGrau != null && _filtroGrau!.isNotEmpty) {
      cursosFiltrados = cursosFiltrados.where((curso) => 
          curso.grauConferido == _filtroGrau
      ).toList();
    }

    // Filtro por estado
    if (_filtroEstado != null && _filtroEstado!.isNotEmpty) {
      cursosFiltrados = cursosFiltrados.where((curso) => 
          curso.uf == _filtroEstado
      ).toList();
    }

    return cursosFiltrados;
  }

  /// Verifica se há algum command em execução
  bool get isAnyCommandRunning {
    return _loadCursosCommand.running ||
           _loadCursoByIdCommand.running ||
           _addCursoCommand.running ||
           _updateCursoCommand.running ||
           _deleteCursoCommand.running;
  }

  /// Verifica se há erro em algum command
  bool get hasAnyCommandError {
    return _loadCursosCommand.error ||
           _loadCursoByIdCommand.error ||
           _addCursoCommand.error ||
           _updateCursoCommand.error ||
           _deleteCursoCommand.error;
  }

  /// Obtém mensagem de erro de qualquer command
  String? get anyCommandErrorMessage {
    if (_loadCursosCommand.error) return _loadCursosCommand.errorMessage;
    if (_loadCursoByIdCommand.error) return _loadCursoByIdCommand.errorMessage;
    if (_addCursoCommand.error) return _addCursoCommand.errorMessage;
    if (_updateCursoCommand.error) return _updateCursoCommand.errorMessage;
    if (_deleteCursoCommand.error) return _deleteCursoCommand.errorMessage;
    return null;
  }

  /// Limpa todos os resultados de commands
  void clearAllCommandResults() {
    _loadCursosCommand.clearResult();
    _loadCursoByIdCommand.clearResult();
    _addCursoCommand.clearResult();
    _updateCursoCommand.clearResult();
    _deleteCursoCommand.clearResult();
  }

  @override
  void dispose() {
    _addCursoCommand.removeListener(_onCrudCommandComplete);
    _updateCursoCommand.removeListener(_onCrudCommandComplete);
    _deleteCursoCommand.removeListener(_onCrudCommandComplete);
    super.dispose();
  }
}