import 'package:flutter/material.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';
// import '../models/[FILE_NAME]_models.dart';

/// [DESCRIPTION]
/// Réplica fiel do componente [COMPONENT_NAME].tsx do React
final class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // Estados do componente
  // TODO: Adicionar estados necessários baseados nos hooks React
  // Exemplo:
  // bool _isLoading = false;
  // String _selectedFilter = '';
  // List<{MODEL_NAME}> _items = [];

  // Dados mock (manter idênticos ao React)
  // TODO: Migrar dados do componente React

  @override
  void initState() {
    super.initState();
    // TODO: Migrar lógica do useEffect(() => {}, [])
  }

  @override
  void dispose() {
    // TODO: Limpar controllers, listeners, etc.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColorTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 640;
        
        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTitle(context),
              const SizedBox(height: 16),
              _buildHeaderActions(context),
            ],
          );
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildHeaderTitle(context)),
            _buildHeaderActions(context),
          ],
        );
      },
    );
  }

  Widget _buildHeaderTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: Converter título com gradiente do React
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              context.customColorTheme.primary,
              context.customColorTheme.primaryShade,
            ],
          ).createShader(bounds),
          child: Text(
            '{TITLE}', // TODO: Substituir pelo título real
            style: context.customTextTheme.displaySmBold.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '{SUBTITLE}', // TODO: Substituir pelo subtítulo real
          style: context.customTextTheme.textSm.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TODO: Migrar botões do header React
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Implementar ação
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Ação Principal'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.customColorTheme.primary,
            foregroundColor: context.customColorTheme.primaryForeground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Implementar ação secundária
          },
          icon: const Icon(Icons.download, size: 16),
          label: const Text('Ação Secundária'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: context.customColorTheme.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TODO: Implementar layout responsivo baseado no React
        final width = constraints.maxWidth;
        
        if (width >= 1024) {
          return _buildDesktopLayout(context);
        } else if (width >= 640) {
          return _buildTabletLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    // TODO: Layout para desktop (3+ colunas)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildMainContent(context)),
        const SizedBox(width: 24),
        Expanded(flex: 1, child: _buildSidebar(context)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    // TODO: Layout para tablet (2 colunas)
    return Column(
      children: [
        _buildMainContent(context),
        const SizedBox(height: 24),
        _buildSidebar(context),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    // TODO: Layout para mobile (1 coluna)
    return Column(
      children: [
        _buildMainContent(context),
        const SizedBox(height: 24),
        _buildSidebar(context),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    // TODO: Implementar conteúdo principal
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: context.customColorTheme.card,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.customColorTheme.card,
              context.customColorTheme.muted.withOpacity(0.3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conteúdo Principal',
              style: context.customTextTheme.textLgSemibold.copyWith(
                color: context.customColorTheme.foreground,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Adicionar widgets do conteúdo
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    // TODO: Implementar sidebar/conteúdo lateral
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: context.customColorTheme.card,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.customColorTheme.card,
              context.customColorTheme.muted.withOpacity(0.3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conteúdo Lateral',
              style: context.customTextTheme.textLgSemibold.copyWith(
                color: context.customColorTheme.foreground,
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Adicionar widgets laterais
          ],
        ),
      ),
    );
  }

  // TODO: Métodos auxiliares
  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Modal Título',
                style: context.customTextTheme.textLgBold.copyWith(
                  color: context.customColorTheme.foreground,
                ),
              ),
              const SizedBox(height: 16),
              // TODO: Conteúdo do modal
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: context.customTextTheme.textSmMedium.copyWith(
                        color: context.customColorTheme.mutedForeground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar ação
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.customColorTheme.primary,
                      foregroundColor: context.customColorTheme.primaryForeground,
                    ),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
TODO: CHECKLIST DE CONVERSÃO

ESTRUTURA:
[ ] Migrar props React para parâmetros do construtor
[ ] Converter hooks useState para variáveis de estado
[ ] Implementar useEffect com initState/didChangeDependencies
[ ] Organizar métodos por funcionalidade

LAYOUT:
[ ] Implementar LayoutBuilder para responsividade
[ ] Converter grid CSS para GridView.builder
[ ] Adaptar flex CSS para Column/Row
[ ] Manter breakpoints idênticos (640px, 1024px)

ESTILOS:
[ ] Mapear classes Tailwind para CustomTextTheme
[ ] Converter variáveis CSS para NewAppColorTheme  
[ ] Implementar gradientes e sombras
[ ] Adicionar hover effects com InkWell

FUNCIONALIDADES:
[ ] Converter modais React para showDialog
[ ] Implementar formulários com validação
[ ] Adicionar estados de loading
[ ] Manter animações e transições

DADOS:
[ ] Migrar dados mock idênticos
[ ] Criar classes de modelo tipadas
[ ] Implementar enums para estados
[ ] Adicionar métodos auxiliares

QUALIDADE:
[ ] Adicionar const em widgets estáticos
[ ] Implementar dispose para cleanup
[ ] Comentar código complexo
[ ] Testar responsividade
*/