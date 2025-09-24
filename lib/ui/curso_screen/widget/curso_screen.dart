import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mastering_tests/domain/models/curso_model.dart';
import 'package:mastering_tests/ui/curso_screen/viewmodel/curso_viewmodel.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';

/// Tela principal de gerenciamento de cursos acadêmicos
/// Converte funcionalidade do React CoursesGrid para Flutter
class CursoScreen extends StatefulWidget {
  const CursoScreen({super.key});

  @override
  State<CursoScreen> createState() => _CursoScreenState();
}

class _CursoScreenState extends State<CursoScreen> {
  late CursoViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedModalidade;
  String? _selectedGrau;

  @override
  void initState() {
    super.initState();
    _viewModel = CursoViewModel();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _viewModel.setBusca(_searchController.text);
  }

  void _showCursoForm([Cursos? curso]) {
    showDialog(
      context: context,
      builder: (context) => CursoFormDialog(
        viewModel: _viewModel,
        curso: curso,
      ),
    );
  }

  void _confirmDelete(int cursoId, String nomeCurso) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirmar Exclusão',
          style: context.customTextTheme.textLgSemibold.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir o curso "$nomeCurso"? Esta ação não pode ser desfeita.',
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _viewModel.deleteCurso(cursoId);
              if (mounted && _viewModel.deleteCursoCommand.completed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Curso "$nomeCurso" excluído com sucesso!'),
                    backgroundColor: context.customColorTheme.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customColorTheme.destructive,
              foregroundColor: context.customColorTheme.destructiveForeground,
            ),
            child: Text(
              'Excluir',
              style: context.customTextTheme.textSmMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: context.customColorTheme.background,
        appBar: AppBar(
          title: Text(
            'Gerenciamento de Cursos',
            style: context.customTextTheme.textXlSemibold.copyWith(
              color: context.customColorTheme.foreground,
            ),
          ),
          backgroundColor: context.customColorTheme.card,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              height: 1,
              color: context.customColorTheme.border,
            ),
          ),
        ),
        body: Consumer<CursoViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                // Header com controles
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.customColorTheme.card,
                    border: Border(
                      bottom: BorderSide(
                        color: context.customColorTheme.border,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Barra de busca e botão adicionar
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Buscar cursos...',
                                hintStyle: context.customTextTheme.textBase.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.customColorTheme.border,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.customColorTheme.border,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.customColorTheme.primary,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                              style: context.customTextTheme.textBase.copyWith(
                                color: context.customColorTheme.foreground,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => _showCursoForm(),
                            icon: const Icon(Icons.add, size: 18),
                            label: Text(
                              'Novo Curso',
                              style: context.customTextTheme.textSmMedium,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.customColorTheme.primary,
                              foregroundColor: context.customColorTheme.primaryForeground,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Filtros
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedModalidade,
                              decoration: InputDecoration(
                                labelText: 'Modalidade',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.customColorTheme.border,
                                  ),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text(
                                    'Todas',
                                    style: context.customTextTheme.textBase.copyWith(
                                      color: context.customColorTheme.mutedForeground,
                                    ),
                                  ),
                                ),
                                ...['Presencial', 'EaD', 'Híbrido'].map(
                                  (modalidade) => DropdownMenuItem<String>(
                                    value: modalidade,
                                    child: Text(
                                      modalidade,
                                      style: context.customTextTheme.textBase.copyWith(
                                        color: context.customColorTheme.foreground,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedModalidade = value);
                                viewModel.setFiltroModalidade(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGrau,
                              decoration: InputDecoration(
                                labelText: 'Grau',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: context.customColorTheme.border,
                                  ),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                              items: [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text(
                                    'Todos',
                                    style: context.customTextTheme.textBase.copyWith(
                                      color: context.customColorTheme.mutedForeground,
                                    ),
                                  ),
                                ),
                                ...['Bacharel', 'Licenciatura', 'Tecnólogo'].map(
                                  (grau) => DropdownMenuItem<String>(
                                    value: grau,
                                    child: Text(
                                      grau,
                                      style: context.customTextTheme.textBase.copyWith(
                                        color: context.customColorTheme.foreground,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedGrau = value);
                                viewModel.setFiltroGrau(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedModalidade = null;
                                _selectedGrau = null;
                              });
                              viewModel.clearFiltros();
                              _searchController.clear();
                            },
                            icon: Icon(
                              Icons.clear_all,
                              color: context.customColorTheme.mutedForeground,
                            ),
                            tooltip: 'Limpar filtros',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Lista de cursos
                Expanded(
                  child: viewModel.loadCursosCommand.running
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: context.customColorTheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Carregando cursos...',
                                style: context.customTextTheme.textBase.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        )
                      : viewModel.loadCursosCommand.error
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: context.customColorTheme.destructive,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Erro ao carregar cursos',
                                    style: context.customTextTheme.textLgSemibold.copyWith(
                                      color: context.customColorTheme.destructive,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    viewModel.loadCursosCommand.errorMessage ?? 'Erro desconhecido',
                                    style: context.customTextTheme.textBase.copyWith(
                                      color: context.customColorTheme.mutedForeground,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () => viewModel.loadCursos(),
                                    icon: const Icon(Icons.refresh, size: 18),
                                    label: const Text('Tentar novamente'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.customColorTheme.primary,
                                      foregroundColor: context.customColorTheme.primaryForeground,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : viewModel.cursosFiltrados.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.school_outlined,
                                        size: 64,
                                        color: context.customColorTheme.mutedForeground,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        viewModel.termoBusca.isNotEmpty || 
                                        viewModel.filtroModalidade != null ||
                                        viewModel.filtroGrau != null
                                            ? 'Nenhum curso encontrado'
                                            : 'Nenhum curso cadastrado',
                                        style: context.customTextTheme.textLgSemibold.copyWith(
                                          color: context.customColorTheme.mutedForeground,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        viewModel.termoBusca.isNotEmpty || 
                                        viewModel.filtroModalidade != null ||
                                        viewModel.filtroGrau != null
                                            ? 'Tente ajustar os filtros de busca'
                                            : 'Clique em "Novo Curso" para começar',
                                        style: context.customTextTheme.textBase.copyWith(
                                          color: context.customColorTheme.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: viewModel.cursosFiltrados.length,
                                  itemBuilder: (context, index) {
                                    final curso = viewModel.cursosFiltrados[index];
                                    return CursoCard(
                                      curso: curso,
                                      onEdit: () => _showCursoForm(curso),
                                      onDelete: () => _confirmDelete(curso.cursoID, curso.nomeCurso),
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Card individual de exibição de curso
class CursoCard extends StatelessWidget {
  final Cursos curso;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CursoCard({
    super.key,
    required this.curso,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.customColorTheme.card,
        border: Border.all(
          color: context.customColorTheme.border,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: context.customColorTheme.shadowCard,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho com nome e ações
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        curso.nomeCurso,
                        style: context.customTextTheme.textLgSemibold.copyWith(
                          color: context.customColorTheme.foreground,
                        ),
                      ),
                      if (curso.codigoCursoEMEC != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Código MEC: ${curso.codigoCursoEMEC}',
                          style: context.customTextTheme.textSmMedium.copyWith(
                            color: context.customColorTheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: context.customColorTheme.mutedForeground,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: context.customColorTheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Editar',
                            style: context.customTextTheme.textBase.copyWith(
                              color: context.customColorTheme.foreground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: context.customColorTheme.destructive,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Excluir',
                            style: context.customTextTheme.textBase.copyWith(
                              color: context.customColorTheme.destructive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Informações básicas
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  context,
                  Icons.school_outlined,
                  curso.modalidade,
                  context.customColorTheme.primary,
                ),
                _buildInfoChip(
                  context,
                  Icons.workspace_premium_outlined,
                  curso.grauConferido,
                  context.customColorTheme.success,
                ),
                _buildInfoChip(
                  context,
                  Icons.location_on_outlined,
                  '${curso.nomeMunicipio}/${curso.uf}',
                  context.customColorTheme.accent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Título conferido
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.customColorTheme.muted,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.customColorTheme.border,
                  width: 1,
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título Conferido:',
                    style: context.customTextTheme.textSmMedium.copyWith(
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    curso.tituloConferido,
                    style: context.customTextTheme.textBase.copyWith(
                      color: context.customColorTheme.foreground,
                    ),
                  ),
                ],
              ),
            ),
            // Informações de autorização/reconhecimento (se disponíveis)
            if (curso.autorizacaoTipo.isNotEmpty || curso.reconhecimentoTipo.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (curso.autorizacaoTipo.isNotEmpty)
                    Expanded(
                      child: _buildStatusContainer(
                        context,
                        'Autorização',
                        '${curso.autorizacaoTipo} ${curso.autorizacaoNumero}',
                        curso.autorizacaoData,
                        context.customColorTheme.warning,
                      ),
                    ),
                  if (curso.autorizacaoTipo.isNotEmpty && curso.reconhecimentoTipo.isNotEmpty)
                    const SizedBox(width: 12),
                  if (curso.reconhecimentoTipo.isNotEmpty)
                    Expanded(
                      child: _buildStatusContainer(
                        context,
                        'Reconhecimento',
                        '${curso.reconhecimentoTipo} ${curso.reconhecimentoNumero}',
                        curso.reconhecimentoData,
                        context.customColorTheme.success,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.customTextTheme.textSmMedium.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusContainer(
    BuildContext context,
    String title,
    String subtitle,
    DateTime? data,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.customTextTheme.textXsMedium.copyWith(
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.foreground,
            ),
          ),
          if (data != null) ...[
            const SizedBox(height: 2),
            Text(
              '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}',
              style: context.customTextTheme.textXs.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dialog para criação/edição de curso
class CursoFormDialog extends StatefulWidget {
  final CursoViewModel viewModel;
  final Cursos? curso;

  const CursoFormDialog({
    super.key,
    required this.viewModel,
    this.curso,
  });

  @override
  State<CursoFormDialog> createState() => _CursoFormDialogState();
}

class _CursoFormDialogState extends State<CursoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _codigoMecController;
  late final TextEditingController _tituloConferidoController;
  late final TextEditingController _logradouroController;
  late final TextEditingController _bairroController;
  late final TextEditingController _municipioController;
  late final TextEditingController _cepController;

  String _modalidade = 'Presencial';
  String _grauConferido = 'Bacharel';
  String _uf = 'SP';

  bool get _isEditing => widget.curso != null;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.curso?.nomeCurso ?? '');
    _codigoMecController = TextEditingController(
      text: widget.curso?.codigoCursoEMEC?.toString() ?? '',
    );
    _tituloConferidoController = TextEditingController(
      text: widget.curso?.tituloConferido ?? '',
    );
    _logradouroController = TextEditingController(text: widget.curso?.logradouro ?? '');
    _bairroController = TextEditingController(text: widget.curso?.bairro ?? '');
    _municipioController = TextEditingController(text: widget.curso?.nomeMunicipio ?? '');
    _cepController = TextEditingController(text: widget.curso?.cep ?? '');

    if (_isEditing) {
      _modalidade = widget.curso!.modalidade;
      _grauConferido = widget.curso!.grauConferido;
      _uf = widget.curso!.uf;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _codigoMecController.dispose();
    _tituloConferidoController.dispose();
    _logradouroController.dispose();
    _bairroController.dispose();
    _municipioController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final curso = Cursos(
      cursoID: widget.curso?.cursoID ?? 0,
      nomeCurso: _nomeController.text.trim(),
      codigoCursoEMEC: _codigoMecController.text.isNotEmpty 
          ? int.tryParse(_codigoMecController.text) 
          : null,
      modalidade: _modalidade,
      tituloConferido: _tituloConferidoController.text.trim(),
      grauConferido: _grauConferido,
      logradouro: _logradouroController.text.trim(),
      bairro: _bairroController.text.trim(),
      codigoMunicipio: widget.curso?.codigoMunicipio ?? 3550308, // São Paulo por padrão
      nomeMunicipio: _municipioController.text.trim(),
      uf: _uf,
      cep: _cepController.text.trim(),
      autorizacaoTipo: 'Portaria MEC',
      autorizacaoNumero: '${DateTime.now().year}/${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}',
      autorizacaoData: DateTime.now(),
      reconhecimentoTipo: 'Portaria MEC',
      reconhecimentoNumero: '${DateTime.now().year + 3}/${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}',
      reconhecimentoData: DateTime.now().add(const Duration(days: 1095)),
    );

    if (_isEditing) {
      await widget.viewModel.updateCurso(curso);
    } else {
      await widget.viewModel.addCurso(curso);
    }

    if (mounted) {
      Navigator.of(context).pop();
      final command = _isEditing 
          ? widget.viewModel.updateCursoCommand 
          : widget.viewModel.addCursoCommand;
      
      if (command.completed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing 
                  ? 'Curso atualizado com sucesso!' 
                  : 'Curso criado com sucesso!',
            ),
            backgroundColor: context.customColorTheme.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: context.customColorTheme.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: context.customColorTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing ? 'Editar Curso' : 'Novo Curso',
                      style: context.customTextTheme.textLgSemibold.copyWith(
                        color: context.customColorTheme.foreground,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: context.customColorTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome do Curso *',
                          labelStyle: context.customTextTheme.textSm.copyWith(
                            color: context.customColorTheme.mutedForeground,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: context.customColorTheme.input,
                        ),
                        validator: (value) => 
                            value?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _codigoMecController,
                        decoration: InputDecoration(
                          labelText: 'Código MEC',
                          labelStyle: context.customTextTheme.textSm.copyWith(
                            color: context.customColorTheme.mutedForeground,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: context.customColorTheme.input,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _modalidade,
                              decoration: InputDecoration(
                                labelText: 'Modalidade *',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                              items: ['Presencial', 'EaD', 'Híbrido'].map(
                                (modalidade) => DropdownMenuItem<String>(
                                  value: modalidade,
                                  child: Text(modalidade),
                                ),
                              ).toList(),
                              onChanged: (value) => setState(() => _modalidade = value!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _grauConferido,
                              decoration: InputDecoration(
                                labelText: 'Grau *',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                              items: ['Bacharel', 'Licenciatura', 'Tecnólogo'].map(
                                (grau) => DropdownMenuItem<String>(
                                  value: grau,
                                  child: Text(grau),
                                ),
                              ).toList(),
                              onChanged: (value) => setState(() => _grauConferido = value!),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tituloConferidoController,
                        decoration: InputDecoration(
                          labelText: 'Título Conferido *',
                          labelStyle: context.customTextTheme.textSm.copyWith(
                            color: context.customColorTheme.mutedForeground,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: context.customColorTheme.input,
                        ),
                        validator: (value) => 
                            value?.trim().isEmpty ?? true ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Endereço',
                        style: context.customTextTheme.textBaseSemibold.copyWith(
                          color: context.customColorTheme.foreground,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _logradouroController,
                        decoration: InputDecoration(
                          labelText: 'Logradouro',
                          labelStyle: context.customTextTheme.textSm.copyWith(
                            color: context.customColorTheme.mutedForeground,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: context.customColorTheme.input,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _bairroController,
                              decoration: InputDecoration(
                                labelText: 'Bairro',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _cepController,
                              decoration: InputDecoration(
                                labelText: 'CEP',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _municipioController,
                              decoration: InputDecoration(
                                labelText: 'Município',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _uf,
                              decoration: InputDecoration(
                                labelText: 'UF',
                                labelStyle: context.customTextTheme.textSm.copyWith(
                                  color: context.customColorTheme.mutedForeground,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: context.customColorTheme.input,
                              ),
                              items: ['SP', 'RJ', 'MG', 'RS', 'PR', 'SC', 'BA', 'GO', 'PE', 'CE']
                                  .map((uf) => DropdownMenuItem<String>(
                                        value: uf,
                                        child: Text(uf),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _uf = value!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer com botões
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: context.customColorTheme.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.mutedForeground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: widget.viewModel.isAnyCommandRunning ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.customColorTheme.primary,
                      foregroundColor: context.customColorTheme.primaryForeground,
                    ),
                    child: widget.viewModel.isAnyCommandRunning
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.customColorTheme.primaryForeground,
                            ),
                          )
                        : Text(
                            _isEditing ? 'Salvar' : 'Criar',
                            style: context.customTextTheme.textSmMedium,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}