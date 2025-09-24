import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mastering_tests/domain/models/turma_model.dart';
import 'package:mastering_tests/ui/turma_screen/viewmodel/turma_viewmodel.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/mocks/turma_mock.dart';
import 'package:mastering_tests/utils/result.dart';

/// Tela de gerenciamento de Turmas
/// Implementa CRUD completo com arquitetura de 6 camadas
final class TurmaScreen extends StatefulWidget {
  final TurmaViewModel viewModel;

  const TurmaScreen({super.key, required this.viewModel});

  @override
  State<TurmaScreen> createState() => _TurmaScreenState();
}

class _TurmaScreenState extends State<TurmaScreen> {
  // Controllers para formulários e filtros
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _codigoController = TextEditingController();
  
  // Estados de filtros (baseado na funcionalidade React)
  String _statusFilter = 'all';
  int _cursoFilter = 0;
  String _turnoSelecionado = 'Manhã';
  int _cursoSelecionado = 1;
  bool _ativaSelecionada = true;
  DateTime? _dataInicioSelecionada;
  
  // Lista de cursos e turnos (baseado no React)
  List<CursoMock> _cursos = [];
  final List<String> _turnos = ['Manhã', 'Tarde', 'Noite', 'Integral'];
  
  TurmaModel? _editingTurma;

  @override
  void initState() {
    super.initState();
    
    // LISTENERS OBRIGATÓRIOS PARA 3 COMMANDS
    widget.viewModel.updateTurma.addListener(() => _onResult(
      command: widget.viewModel.updateTurma, 
      successMessage: 'Turma atualizada com sucesso!'
    ));
    widget.viewModel.deleteTurma.addListener(() => _onResult(
      command: widget.viewModel.deleteTurma, 
      successMessage: 'Turma excluída com sucesso!'
    ));
    widget.viewModel.createTurma.addListener(() => _onResult(
      command: widget.viewModel.createTurma, 
      successMessage: 'Turma criada com sucesso!'
    ));
    
    // Carregar dados iniciais
    widget.viewModel.getAllTurmas.execute();
    _loadCursos();
  }

  @override
  void dispose() {
    // DISPOSE OBRIGATÓRIO - Remover todos os listeners
    widget.viewModel.updateTurma.removeListener(() {});
    widget.viewModel.deleteTurma.removeListener(() {});
    widget.viewModel.createTurma.removeListener(() {});
    
    _searchController.dispose();
    _nomeController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  /// Feedback visual obrigatório para operações CRUD
  void _onResult({required Command command, required String successMessage}) {
    if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            successMessage,
            style: context.customTextTheme.textBaseMedium.copyWith(
              color: context.customColorTheme.successForeground,
            ),
          ),
          backgroundColor: context.customColorTheme.success,
        ),
      );
    } else if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            command.errorMessage ?? 'Erro na operação',
            style: context.customTextTheme.textBaseMedium.copyWith(
              color: context.customColorTheme.destructiveForeground,
            ),
          ),
          backgroundColor: context.customColorTheme.destructive,
        ),
      );
    }
  }

  /// Carrega lista de cursos
  Future<void> _loadCursos() async {
    final result = await TurmaMock.getMockCursos();
    result.when(
      onOk: (cursos) {
        if (mounted) {
          setState(() {
            _cursos = cursos;
          });
        }
      },
      onError: (error) {
        // Handle error if needed
      },
    );
  }

  /// Filtrar turmas baseado nos critérios selecionados
  List<TurmaModel> get _filteredTurmas {
    return widget.viewModel.filterTurmas(
      searchTerm: _searchController.text,
      statusFilter: _statusFilter,
      cursoFilter: _cursoFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColorTheme.background,
      appBar: AppBar(
        title: Text(
          'Gerenciamento de Turmas',
          style: context.customTextTheme.textXlSemibold.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
        backgroundColor: context.customColorTheme.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => widget.viewModel.getAllTurmas.execute(),
            icon: Icon(
              Icons.refresh,
              color: context.customColorTheme.primary,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com título e botão de nova turma
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Turmas',
                        style: context.customTextTheme.text2xlBold.copyWith(
                          color: context.customColorTheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gerencie todas as turmas da instituição',
                        style: context.customTextTheme.textBaseMedium.copyWith(
                          color: context.customColorTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _openNewTurmaDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.customColorTheme.primary,
                    foregroundColor: context.customColorTheme.primaryForeground,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: context.customColorTheme.primaryForeground,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nova Turma',
                        style: context.customTextTheme.textSmSemibold.copyWith(
                          color: context.customColorTheme.primaryForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Filtros
            Card(
              color: context.customColorTheme.card,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtros',
                      style: context.customTextTheme.textLgSemibold.copyWith(
                        color: context.customColorTheme.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Campo de busca
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Buscar turmas...',
                              hintStyle: context.customTextTheme.textBase.copyWith(
                                color: context.customColorTheme.mutedForeground,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: context.customColorTheme.mutedForeground,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.customColorTheme.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.customColorTheme.ring,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Filtro de Status
                        DropdownButton<String>(
                          value: _statusFilter,
                          onChanged: (value) => setState(() {
                            _statusFilter = value ?? 'all';
                          }),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(
                                'Todos os Status',
                                style: context.customTextTheme.textBase,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'active',
                              child: Text(
                                'Ativas',
                                style: context.customTextTheme.textBase,
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'inactive',
                              child: Text(
                                'Inativas',
                                style: context.customTextTheme.textBase,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Filtro de Curso
                        DropdownButton<int>(
                          value: _cursoFilter,
                          onChanged: (value) => setState(() {
                            _cursoFilter = value ?? 0;
                          }),
                          items: [
                            DropdownMenuItem(
                              value: 0,
                              child: Text(
                                'Todos os Cursos',
                                style: context.customTextTheme.textBase,
                              ),
                            ),
                            ..._cursos.map((curso) => DropdownMenuItem(
                              value: curso.id,
                              child: Text(
                                curso.nome,
                                style: context.customTextTheme.textBase,
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de turmas com ListenableBuilder obrigatório
            Expanded(
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  widget.viewModel.getAllTurmas,
                  widget.viewModel.createTurma,
                  widget.viewModel.updateTurma,
                  widget.viewModel.deleteTurma,
                ]),
                builder: (context, _) {
                  /// ESTADO LOADING OBRIGATÓRIO
                  if (widget.viewModel.getAllTurmas.running) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CupertinoActivityIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            'Carregando turmas...',
                            style: context.customTextTheme.textBaseMedium.copyWith(
                              color: context.customColorTheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  /// ESTADO ERROR OBRIGATÓRIO
                  if (widget.viewModel.getAllTurmas.error) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: context.customColorTheme.destructive,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Erro ao carregar turmas',
                              style: context.customTextTheme.textLgSemibold.copyWith(
                                color: context.customColorTheme.destructive,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.viewModel.getAllTurmas.errorMessage ?? 'Erro desconhecido',
                              style: context.customTextTheme.textBase.copyWith(
                                color: context.customColorTheme.mutedForeground,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => widget.viewModel.getAllTurmas.execute(),
                              child: Text('Tentar Novamente'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final filteredTurmas = _filteredTurmas;

                  /// ESTADO EMPTY OBRIGATÓRIO
                  if (filteredTurmas.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            color: context.customColorTheme.mutedForeground,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhuma turma encontrada',
                            style: context.customTextTheme.textLgMedium.copyWith(
                              color: context.customColorTheme.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tente ajustar os filtros ou criar uma nova turma',
                            style: context.customTextTheme.textBase.copyWith(
                              color: context.customColorTheme.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  /// ESTADO SUCCESS - LISTA DE DADOS
                  return ListView.builder(
                    itemCount: filteredTurmas.length,
                    itemBuilder: (context, index) {
                      final turma = filteredTurmas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: context.customColorTheme.card,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: turma.ativa 
                                ? context.customColorTheme.success 
                                : context.customColorTheme.destructive,
                            child: Text(
                              turma.turmaNome[0].toUpperCase(),
                              style: context.customTextTheme.textBaseBold.copyWith(
                                color: turma.ativa 
                                    ? context.customColorTheme.successForeground
                                    : context.customColorTheme.destructiveForeground,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                turma.turmaNome,
                                style: context.customTextTheme.textBaseMedium.copyWith(
                                  color: context.customColorTheme.cardForeground,
                                ),
                              ),
                              if (turma.codigo != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8, 
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.customColorTheme.muted,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    turma.codigo!,
                                    style: context.customTextTheme.textXs.copyWith(
                                      color: context.customColorTheme.mutedForeground,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Curso: ${turma.cursoNome ?? "Não informado"}',
                                style: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                              ),
                              Text(
                                'Turno: ${turma.turno}',
                                style: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                              ),
                              if (turma.dataInicio != null)
                                Text(
                                  'Início: ${_formatDataInicio(turma.dataInicio)}',
                                  style: context.customTextTheme.textSm.copyWith(
                                    color: context.customColorTheme.mutedForeground,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, 
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: turma.ativa 
                                      ? context.customColorTheme.success 
                                      : context.customColorTheme.destructive,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  turma.ativa ? 'Ativa' : 'Inativa',
                                  style: context.customTextTheme.textXs.copyWith(
                                    color: turma.ativa 
                                        ? context.customColorTheme.successForeground
                                        : context.customColorTheme.destructiveForeground,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: context.customColorTheme.primary,
                                ),
                                onPressed: () => _editTurma(turma),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: context.customColorTheme.destructive,
                                ),
                                onPressed: () => _deleteTurma(turma),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Abre diálogo para criar nova turma
  void _openNewTurmaDialog() {
    _editingTurma = null;
    _resetForm();
    _showTurmaDialog();
  }

  /// Abre diálogo para editar turma existente
  void _editTurma(TurmaModel turma) {
    _editingTurma = turma;
    _nomeController.text = turma.turmaNome;
    _codigoController.text = turma.codigo ?? '';
    _cursoSelecionado = turma.cursoID;
    _turnoSelecionado = turma.turno;
    _ativaSelecionada = turma.ativa;
    _dataInicioSelecionada = turma.dataInicio;
    _showTurmaDialog();
  }

  /// Exclui turma com confirmação
  void _deleteTurma(TurmaModel turma) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.customColorTheme.card,
        title: Text(
          'Confirmar Exclusão',
          style: context.customTextTheme.textLgSemibold.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir a turma "${turma.turmaNome}"?',
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: context.customTextTheme.textBaseMedium.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.viewModel.deleteTurma.execute(turma.turmaID.toString());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customColorTheme.destructive,
              foregroundColor: context.customColorTheme.destructiveForeground,
            ),
            child: Text(
              'Excluir',
              style: context.customTextTheme.textBaseMedium.copyWith(
                color: context.customColorTheme.destructiveForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Exibe diálogo de formulário para criar/editar turma
  void _showTurmaDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.customColorTheme.card,
        title: Text(
          _editingTurma == null ? 'Nova Turma' : 'Editar Turma',
          style: context.customTextTheme.textLgSemibold.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nome da turma
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Turma',
                    labelStyle: context.customTextTheme.textBase.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.customColorTheme.border,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nome da turma é obrigatório';
                    }
                    if (value.length > 100) {
                      return 'Máximo 100 caracteres';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Código da turma
                TextFormField(
                  controller: _codigoController,
                  decoration: InputDecoration(
                    labelText: 'Código (Opcional)',
                    labelStyle: context.customTextTheme.textBase.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.customColorTheme.border,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Curso
                DropdownButtonFormField<int>(
                  value: _cursoSelecionado,
                  decoration: InputDecoration(
                    labelText: 'Curso',
                    labelStyle: context.customTextTheme.textBase.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.customColorTheme.border,
                      ),
                    ),
                  ),
                  items: _cursos.map((curso) => DropdownMenuItem(
                    value: curso.id,
                    child: Text(
                      curso.nome,
                      style: context.customTextTheme.textBase,
                    ),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _cursoSelecionado = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value <= 0) {
                      return 'Curso é obrigatório';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Turno
                DropdownButtonFormField<String>(
                  value: _turnoSelecionado,
                  decoration: InputDecoration(
                    labelText: 'Turno',
                    labelStyle: context.customTextTheme.textBase.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: context.customColorTheme.border,
                      ),
                    ),
                  ),
                  items: _turnos.map((turno) => DropdownMenuItem(
                    value: turno,
                    child: Text(
                      turno,
                      style: context.customTextTheme.textBase,
                    ),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _turnoSelecionado = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Turno é obrigatório';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Status
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: context.customTextTheme.textBase.copyWith(
                        color: context.customColorTheme.cardForeground,
                      ),
                    ),
                    Switch(
                      value: _ativaSelecionada,
                      onChanged: (value) {
                        setState(() {
                          _ativaSelecionada = value;
                        });
                      },
                    ),
                    Text(
                      _ativaSelecionada ? 'Ativa' : 'Inativa',
                      style: context.customTextTheme.textBase.copyWith(
                        color: _ativaSelecionada 
                            ? context.customColorTheme.success
                            : context.customColorTheme.destructive,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Data de início
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Data de Início (Opcional)',
                      labelStyle: context.customTextTheme.textBase.copyWith(
                        color: context.customColorTheme.mutedForeground,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: context.customColorTheme.border,
                        ),
                      ),
                    ),
                    child: Text(
                      _dataInicioSelecionada != null
                          ? '${_dataInicioSelecionada!.day.toString().padLeft(2, '0')}/${_dataInicioSelecionada!.month.toString().padLeft(2, '0')}/${_dataInicioSelecionada!.year}'
                          : 'Selecionar data',
                      style: context.customTextTheme.textBase.copyWith(
                        color: _dataInicioSelecionada != null
                            ? context.customColorTheme.cardForeground
                            : context.customColorTheme.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: context.customTextTheme.textBaseMedium.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customColorTheme.primary,
              foregroundColor: context.customColorTheme.primaryForeground,
            ),
            child: Text(
              _editingTurma == null ? 'Criar' : 'Atualizar',
              style: context.customTextTheme.textBaseMedium.copyWith(
                color: context.customColorTheme.primaryForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Seleciona data de início
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataInicioSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dataInicioSelecionada = picked;
      });
    }
  }

  /// Submete formulário de criação/edição
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final turma = TurmaModel(
        turmaID: _editingTurma?.turmaID ?? 0,
        cursoID: _cursoSelecionado,
        turmaNome: _nomeController.text.trim(),
        codigo: _codigoController.text.trim().isEmpty 
            ? null 
            : _codigoController.text.trim(),
        ativa: _ativaSelecionada,
        dataInicio: _dataInicioSelecionada,
        turno: _turnoSelecionado,
        dataInsercao: _editingTurma?.dataInsercao ?? DateTime.now(),
      );
      
      if (_editingTurma == null) {
        widget.viewModel.createTurma.execute(turma);
      } else {
        widget.viewModel.updateTurma.execute(turma);
      }
      
      Navigator.of(context).pop();
    }
  }

  /// Reseta formulário para estado inicial
  void _resetForm() {
    _nomeController.clear();
    _codigoController.clear();
    _cursoSelecionado = _cursos.isNotEmpty ? _cursos.first.id : 1;
    _turnoSelecionado = 'Manhã';
    _ativaSelecionada = true;
    _dataInicioSelecionada = null;
  }

  /// Formata data de início para exibição
  String _formatDataInicio(DateTime? dataInicio) {
    if (dataInicio == null) return 'Não informada';
    return '${dataInicio.day.toString().padLeft(2, '0')}/${dataInicio.month.toString().padLeft(2, '0')}/${dataInicio.year}';
  }
}