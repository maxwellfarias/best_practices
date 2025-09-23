# 🚀 TEMPLATE DE PROMPT PARA CONVERSÃO REACT → FLUTTER

## 📋 CONTEXTO
Preciso converter o componente React **`{NOME_COMPONENTE}`** para Flutter seguindo os padrões estabelecidos no projeto Palliative Care.

## 🎯 TAREFA PRINCIPAL
Converta o código React anexado para Flutter mantendo:
- **Layout responsivo idêntico** usando LayoutBuilder e breakpoints padrão
- **Funcionalidades interativas** (modais, formulários, navegação, animações)
- **Estilo visual consistente** usando CustomTextTheme e NewAppColorTheme
- **Estrutura de componentes organizada** seguindo padrões do projeto
- **Performance otimizada** com widgets const e gerenciamento eficiente de estado

## 📁 ARQUIVOS DE REFERÊNCIA ANEXADOS
- [ ] **Código React**: `lovable/src/pages/{nome_da_pagina}.tsx` - Componente principal a ser convertido
- [ ] **CSS/Styles**: `lovable/src/index.css` ou arquivo de estilos relevante
- [ ] **Guia de Conversão**: `lib/react_to_flutter_guide.md` - Referência completa
- [ ] **Extensões Flutter**: `build_context_extension.dart` - Extensões de contexto
- [ ] **Tema Flutter**: `theme.dart` - Tema já configurado
- [ ] **Cores**: `new_colors.dart` - Paleta de cores do projeto
- [ ] **Tipografia**: `custom_text_style.dart` - Sistema tipográfico

## 🔧 REQUISITOS ESPECÍFICOS

### 1. 🏗️ Estrutura Flutter
- [ ] **Widget Principal**: Criar `StatefulWidget` em `lib/ui/{nome_tela}/widget/{nome_arquivo}.dart`
- [ ] **Widgets Auxiliares**: Organizar em arquivos separados para componentes complexos
- [ ] **Modelos de Dados**: Criar classes em `lib/ui/{nome_tela}/models/{nome_arquivo}_models.dart`
- [ ] **Gerenciamento de Estado**: Usar `setState` para estados locais
- [ ] **Imports**: Organizar imports em ordem: Flutter, packages, projeto

### 2. 🎨 Mapeamento de Estilos
**Usar o guia de conversão para:**
- [ ] **Tipografia**: Converter classes Tailwind para CustomTextTheme (ex: `text-xl font-bold` → `context.customTextTheme.textXlBold`)
- [ ] **Cores**: Mapear variáveis CSS para NewAppColorTheme (ex: `--primary` → `context.customColorTheme.primary`)
- [ ] **Layout Responsivo**: Implementar com LayoutBuilder usando breakpoints:
  ```dart
  // Mobile: < 640px (1 coluna)
  // Tablet: 640-1024px (2 colunas)  
  // Desktop: > 1024px (3+ colunas)
  ```
- [ ] **Espaçamentos**: Converter classes Tailwind (ex: `p-6` → `EdgeInsets.all(24)`)
- [ ] **Sombras**: Mapear box-shadow para elevation ou BoxShadow

### 3. 🧩 Componentes e Funcionalidades
- [ ] **Modais React → Flutter**: Converter para `showDialog()` com `Dialog` ou `AlertDialog`
- [ ] **Formulários**: Implementar com `Form` + `TextFormField` + validação
- [ ] **Estados de Loading**: Adicionar `CircularProgressIndicator` e feedback visual
- [ ] **Navegação**: Implementar com `Navigator` e transições suaves
- [ ] **Animações**: Manter micro-interações com `AnimatedContainer`, `FadeTransition`, etc.

### 4. 📱 Layout Responsivo OBRIGATÓRIO
Implementar breakpoints responsivos idênticos ao React:
```dart
Widget _buildResponsiveLayout(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      
      if (width >= 1024) {
        return _buildDesktopLayout(context); // 3+ colunas
      } else if (width >= 640) {
        return _buildTabletLayout(context);  // 2 colunas
      } else {
        return _buildMobileLayout(context);   // 1 coluna
      }
    },
  );
}
```

### 5. 💾 Dados e Modelos
- [ ] **Dados Mock**: Manter exatamente os mesmos dados do React
- [ ] **Classes Tipadas**: Criar modelos com `copyWith`, `const constructors`
- [ ] **Enums**: Implementar para status, tipos, estados (ex: `enum VitalStatus { normal, warning, critical }`)
- [ ] **Extensões**: Adicionar métodos úteis aos enums (ex: `extension VitalStatusExtension on VitalStatus`)

### 6. ⚡ Performance e Qualidade
- [ ] **Widgets Const**: Usar `const` em todos os widgets estáticos possíveis
- [ ] **Keys**: Adicionar `Key` em widgets de lista e animados
- [ ] **Lazy Loading**: Usar `ListView.builder` para listas grandes
- [ ] **Memory Management**: Dispose de controllers e listeners
- [ ] **Acessibilidade**: Adicionar `Semantics` e labels apropriados

## 📤 ENTREGÁVEIS ESPERADOS

### 📁 Estrutura de Arquivos
```
lib/ui/{nome_tela}/
├── models/
│   └── {nome_tela}_models.dart         # Classes de dados e enums
├── widget/
│   ├── {nome_tela}.dart                # Widget principal
│   ├── {componente}_card.dart          # Cards específicos
│   ├── {componente}_detail.dart        # Modais de detalhes
│   └── {componente}_form.dart          # Formulários
└── {nome_tela}_example.dart            # Exemplo de uso e documentação
```

### 📝 Código Esperado
1. **Widget Principal**: StatefulWidget completo com todas as funcionalidades
2. **Widgets Auxiliares**: Componentes reutilizáveis e bem organizados
3. **Modelos de Dados**: Classes tipadas com validação e métodos auxiliares
4. **Comentários**: Documentação clara explicando escolhas de implementação
5. **Exemplo de Uso**: Demonstração de como integrar o componente

## ✅ CRITÉRIOS DE VALIDAÇÃO

### 🎨 Fidelidade Visual
- [ ] Layout idêntico ao React em todos os breakpoints
- [ ] Cores exatamente equivalentes usando NewAppColorTheme
- [ ] Tipografia consistente com CustomTextTheme
- [ ] Espaçamentos e proporções mantidos
- [ ] Animações e transições suaves

### 🔧 Funcionalidade
- [ ] Todas as interações implementadas (cliques, formulários, modais)
- [ ] Estados gerenciados corretamente (loading, erro, sucesso)
- [ ] Validação de formulários robusta
- [ ] Navegação funcionando perfeitamente
- [ ] Responsividade em mobile, tablet e desktop

### 💎 Qualidade de Código
- [ ] Sem erros de compilação ou warnings
- [ ] Performance otimizada (60 FPS)
- [ ] Código bem estruturado e legível
- [ ] Padrões do projeto seguidos
- [ ] Documentação adequada

### 🧪 Testes
- [ ] Widget pode ser testado facilmente
- [ ] Estados são verificáveis
- [ ] Funcionalidades isoladas
- [ ] Sem vazamentos de memória

## 📊 EXEMPLO DE CONVERSÃO

### React Original
```tsx
<div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
  <Card className="medical-card">
    <CardHeader>
      <CardTitle className="text-lg font-semibold gradient-text">
        Título
      </CardTitle>
    </CardHeader>
  </Card>
</div>
```

### Flutter Convertido
```dart
LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount = 1;
    if (constraints.maxWidth > 1200) crossAxisCount = 3;
    else if (constraints.maxWidth > 768) crossAxisCount = 2;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) => Card(
        color: context.customColorTheme.card,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(/* gradiente médico */),
          ),
          child: Column(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    context.customColorTheme.primary,
                    context.customColorTheme.primaryShade,
                  ],
                ).createShader(bounds),
                child: Text(
                  'Título',
                  style: context.customTextTheme.textLgSemibold.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
)
```

---

## 🚀 EXECUTAR CONVERSÃO

Execute a conversão completa seguindo este template e o guia de conversão anexado. 

**Objetivo**: Criar uma réplica Flutter perfeita do componente React, mantendo 100% da fidelidade visual e funcional, otimizada para performance e seguindo os padrões estabelecidos no projeto.

---

*Use este template preenchendo os campos `{NOME_COMPONENTE}`, `{nome_arquivo}`, `{nome_tela}` com os valores específicos da conversão.*