import 'package:flutter/material.dart';
import 'package:mastering_tests/ui/core/extensions/build_context_extension.dart';
// import '../models/[FILE_NAME]_models.dart';

/// [DESCRIPTION]
/// Réplica fiel do componente [COMPONENT_NAME].tsx do React
class ExampleWidget extends StatelessWidget {
  // Props do React convertidas para parâmetros
  // TODO: Migrar todas as props do componente React
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget? trailing;

  const ExampleWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isLoading = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: context.customColorTheme.card,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
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
          padding: const EdgeInsets.all(16),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout baseado no tamanho disponível
        final isCompact = constraints.maxWidth < 300;
        
        if (isCompact) {
          return _buildCompactLayout(context);
        }
        
        return _buildNormalLayout(context);
      },
    );
  }

  Widget _buildNormalLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: context.customTextTheme.textLgSemibold.copyWith(
                  color: context.customColorTheme.foreground,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: context.customTextTheme.textSm.copyWith(
                    color: context.customColorTheme.mutedForeground,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null || isLoading) ...[
          const SizedBox(width: 12),
          _buildTrailing(context),
        ],
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: context.customTextTheme.textLgSemibold.copyWith(
                  color: context.customColorTheme.foreground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null || isLoading) ...[
              const SizedBox(width: 8),
              _buildTrailing(context),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            context.customColorTheme.primary,
          ),
        ),
      );
    }
    
    return trailing ?? const SizedBox.shrink();
  }
}

/*
TEMPLATE DE WIDGET SIMPLES PARA CONVERSÃO REACT → FLUTTER

USO:
1. Renomear classe ExampleWidget para o nome apropriado
2. Substituir [DESCRIPTION] e [COMPONENT_NAME] pelos valores reais
3. Migrar props do React para parâmetros do construtor
4. Implementar layout específico do componente
5. Ajustar estilos para manter fidelidade visual

CARACTERÍSTICAS:
✓ Estrutura base responsiva
✓ Integração com tema customizado
✓ Estados de loading
✓ Layouts compacto e normal
✓ Overflow handling
✓ Hover effects com InkWell
✓ Gradientes e elevação

CHECKLIST DE CONVERSÃO:
[ ] Props React → parâmetros construtor
[ ] Classes CSS → CustomTextTheme/NewAppColorTheme
[ ] Eventos onClick → onTap callbacks
[ ] Estados condicionais → operadores ternários
[ ] Responsividade → LayoutBuilder
[ ] Animações → AnimatedWidget se necessário
*/