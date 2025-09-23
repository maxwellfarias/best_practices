# 🚀 Guia de Conversão React → Flutter - Projeto Palliative Care

## 📋 Checklist de Conversão Completo

### 🔍 Fase 1: Análise do Componente React
- [ ] **Props e Estado**: Identificar todas as props e hooks useState do componente
- [ ] **Componentes Externos**: Mapear bibliotecas (shadcn/ui, lucide-react, react-hook-form, etc.)
- [ ] **Hooks Utilizados**: Documentar useEffect, useCallback, useMemo, etc.
- [ ] **Funcionalidades Interativas**: Modais, formulários, navegação, animações
- [ ] **Breakpoints Responsivos**: Identificar classes Tailwind responsivas
- [ ] **Dados Mock**: Listar todas as constantes e arrays de dados
- [ ] **Eventos**: Documentar onClick, onChange, onSubmit, etc.

### 🏗️ Fase 2: Mapeamento de Estrutura Flutter
- [ ] **Tipo de Widget**: Definir StatefulWidget vs StatelessWidget
- [ ] **Estados Necessários**: Mapear useState para variáveis de estado Flutter
- [ ] **Widgets Equivalentes**: Identificar Container, Card, Button, Dialog, etc.
- [ ] **Estrutura de Arquivos**: Planejar organização de pastas e arquivos
- [ ] **Dependências**: Verificar packages Flutter necessários
- [ ] **Modelos de Dados**: Criar classes para objetos complexos

### 🎨 Fase 3: Conversão de Estilos
- [ ] **Tipografia**: Mapear classes CSS para CustomTextTheme
- [ ] **Cores**: Converter variáveis CSS para NewAppColorTheme
- [ ] **Layout Responsivo**: Adaptar para LayoutBuilder e MediaQuery
- [ ] **Animações**: Implementar transições e micro-interações
- [ ] **Espaçamentos**: Converter padding/margin Tailwind para EdgeInsets
- [ ] **Sombras e Elevação**: Mapear box-shadow para elevation

## 🎨 Mapeamento Detalhado de Estilos

### 📝 Tipografia (React Tailwind → Flutter CustomTextTheme)

| React Tailwind Class | Tamanho | Peso | Flutter Equivalent |
|---------------------|---------|------|-------------------|
| `text-4xl font-bold` | 36px | 700 | `context.customTextTheme.text4xlBold` |
| `text-3xl font-bold` | 30px | 700 | `context.customTextTheme.text3xlBold` |
| `text-2xl font-bold` | 24px | 700 | `context.customTextTheme.text2xlBold` |
| `text-xl font-semibold` | 20px | 600 | `context.customTextTheme.textXlSemibold` |
| `text-xl font-medium` | 20px | 500 | `context.customTextTheme.textXlMedium` |
| `text-lg font-semibold` | 18px | 600 | `context.customTextTheme.textLgSemibold` |
| `text-lg font-medium` | 18px | 500 | `context.customTextTheme.textLgMedium` |
| `text-base font-medium` | 16px | 500 | `context.customTextTheme.textBaseMedium` |
| `text-base` | 16px | 400 | `context.customTextTheme.textBase` |
| `text-sm font-semibold` | 14px | 600 | `context.customTextTheme.textSmSemibold` |
| `text-sm font-medium` | 14px | 500 | `context.customTextTheme.textSmMedium` |
| `text-sm` | 14px | 400 | `context.customTextTheme.textSm` |
| `text-xs font-medium` | 12px | 500 | `context.customTextTheme.textXsMedium` |
| `text-xs` | 12px | 400 | `context.customTextTheme.textXs` |

### 🎨 Cores (React CSS → Flutter NewAppColorTheme)

| React CSS Variable | Descrição | Flutter Equivalent |
|-------------------|-----------|-------------------|
| `--background` | Fundo principal | `context.customColorTheme.background` |
| `--foreground` | Texto principal | `context.customColorTheme.foreground` |
| `--primary` | Cor primária (azul médico) | `context.customColorTheme.primary` |
| `--primary-foreground` | Texto sobre primário | `context.customColorTheme.primaryForeground` |
| `--primary-light` | Primário claro | `context.customColorTheme.primaryLight` |
| `--primary-dark` | Primário escuro | `context.customColorTheme.primaryShade` |
| `--secondary` | Cor secundária | `context.customColorTheme.secondary` |
| `--secondary-foreground` | Texto sobre secundário | `context.customColorTheme.secondaryForeground` |
| `--success` | Verde de sucesso | `context.customColorTheme.success` |
| `--success-foreground` | Texto sobre sucesso | `context.customColorTheme.successForeground` |
| `--warning` | Laranja de aviso | `context.customColorTheme.warning` |
| `--warning-foreground` | Texto sobre aviso | `context.customColorTheme.warningForeground` |
| `--destructive` | Vermelho de erro | `context.customColorTheme.destructive` |
| `--destructive-foreground` | Texto sobre erro | `context.customColorTheme.destructiveForeground` |
| `--card` | Fundo de cards | `context.customColorTheme.card` |
| `--card-foreground` | Texto em cards | `context.customColorTheme.cardForeground` |
| `--muted` | Fundo neutro | `context.customColorTheme.muted` |
| `--muted-foreground` | Texto secundário | `context.customColorTheme.mutedForeground` |
| `--accent` | Cor de destaque | `context.customColorTheme.accent` |
| `--accent-foreground` | Texto sobre destaque | `context.customColorTheme.accentForeground` |
| `--border` | Bordas | `context.customColorTheme.border` |
| `--input` | Fundo de inputs | `context.customColorTheme.input` |
| `--ring` | Foco/seleção | `context.customColorTheme.ring` |

### 🎨 Classes CSS Customizadas

| React CSS Class | Descrição | Flutter Equivalent |
|----------------|-----------|-------------------|
| `.gradient-text` | Texto com gradiente | `ShaderMask` + `LinearGradient` |
| `.medical-card` | Card médico com gradiente | `Card` + `Container` + `BoxDecoration` |
| `.vital-sign-card` | Card de sinal vital | `Card` + `InkWell` + hover effects |
| `.btn-medical` | Botão primário médico | `ElevatedButton` com tema customizado |
| `.btn-secondary-medical` | Botão secundário | `OutlinedButton` com tema customizado |
| `.input-medical` | Input médico | `TextFormField` com decoração customizada |

## 🧩 Componentes React → Flutter

### 📦 Estrutura Base
| React Component | Flutter Widget | Observações |
|----------------|---------------|-------------|
| `<div className="">` | `Container()` | Para styling específico |
| `<div>` (layout) | `Column()` / `Row()` | Para organização |
| `<section>` | `Container()` / `Card()` | Seções semânticas |
| `<button>` | `ElevatedButton()` | Botão principal |
| `<button variant="outline">` | `OutlinedButton()` | Botão secundário |
| `<button variant="ghost">` | `TextButton()` | Botão sutil |

### 🎴 Componentes de Interface
| React (shadcn/ui) | Flutter Widget | Implementação |
|------------------|---------------|---------------|
| `<Card>` | `Card()` | Com elevation e shape |
| `<Dialog>` | `showDialog()` | Modal overlay |
| `<AlertDialog>` | `AlertDialog()` | Dialog de confirmação |
| `<Badge>` | `Container()` | Com decoration customizada |
| `<Separator>` | `Divider()` | Linha divisória |
| `<ScrollArea>` | `SingleChildScrollView()` | Área rolável |

### 📝 Formulários
| React Component | Flutter Widget | Observações |
|----------------|---------------|-------------|
| `<Input>` | `TextFormField()` | Com validação |
| `<Textarea>` | `TextFormField(maxLines: null)` | Múltiplas linhas |
| `<Select>` | `DropdownButtonFormField()` | Seleção única |
| `<Checkbox>` | `CheckboxListTile()` | Com label |
| `<RadioGroup>` | `Radio()` + `RadioListTile()` | Seleção exclusiva |
| `<Switch>` | `SwitchListTile()` | Toggle |

### 📱 Layout Responsivo
| React Tailwind | Flutter Implementation | Descrição |
|---------------|----------------------|-----------|
| `grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3` | `LayoutBuilder` + `GridView.builder` | Grid responsivo |
| `flex flex-col sm:flex-row` | `LayoutBuilder` + `Column/Row` | Direção responsiva |
| `hidden sm:block` | `MediaQuery` conditional | Visibilidade responsiva |
| `space-y-4` | `Column` + `SizedBox(height: 16)` | Espaçamento vertical |
| `gap-4` | `crossAxisSpacing: 16, mainAxisSpacing: 16` | Espaçamento em grid |

### ⚡ Estados e Hooks
| React Hook | Flutter Equivalent | Exemplo |
|-----------|-------------------|---------|
| `useState(false)` | `bool _variable = false;` + `setState()` | Estado booleano |
| `useState('')` | `String _text = '';` + `setState()` | Estado de texto |
| `useState([])` | `List<T> _items = [];` + `setState()` | Lista de itens |
| `useEffect(() => {}, [])` | `initState()` | Execução inicial |
| `useEffect(() => {}, [dep])` | `didUpdateWidget()` | Dependência mudou |
| `useCallback()` | Método da classe | Cache de função |
| `useMemo()` | `late final` ou getter | Cache de valor |

## 📱 Breakpoints e Responsividade

### 🔧 Implementação de Breakpoints
```dart
// Breakpoints padrão do projeto
class Breakpoints {
  static const double mobile = 640;
  static const double tablet = 1024;
  static const double desktop = 1200;
}

// Uso em LayoutBuilder
Widget _buildResponsiveLayout(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      
      if (width >= Breakpoints.desktop) {
        return _buildDesktopLayout(context);
      } else if (width >= Breakpoints.tablet) {
        return _buildTabletLayout(context);
      } else {
        return _buildMobileLayout(context);
      }
    },
  );
}

// Helpers para breakpoints
extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < Breakpoints.mobile;
  bool get isTablet => MediaQuery.of(this).size.width >= Breakpoints.mobile && 
                       MediaQuery.of(this).size.width < Breakpoints.tablet;
  bool get isDesktop => MediaQuery.of(this).size.width >= Breakpoints.tablet;
  bool get isLargeDesktop => MediaQuery.of(this).size.width >= Breakpoints.desktop;
}
```

### 📐 Grid Responsivo
```dart
Widget _buildResponsiveGrid(BuildContext context, List<Widget> items) {
  return LayoutBuilder(
    builder: (context, constraints) {
      int crossAxisCount = 1; // Mobile
      
      if (constraints.maxWidth >= Breakpoints.desktop) {
        crossAxisCount = 4; // Large Desktop
      } else if (constraints.maxWidth >= Breakpoints.tablet) {
        crossAxisCount = 3; // Desktop
      } else if (constraints.maxWidth >= Breakpoints.mobile) {
        crossAxisCount = 2; // Tablet
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      );
    },
  );
}
```

## 🔧 Templates de Código Prontos

### 📄 Estrutura de Arquivos
```
lib/ui/{nome_tela}/
├── domain/models/
│   └── {nome_tela}_model.dart         # Classes de dados e enums
├── ui/{nome_tela}/widget/
    ├── {nome_tela}.dart                # Widget principal
    ├── {componente}_card.dart          # Cards específicos
    ├── {componente}_detail.dart        # Modais de detalhes
    └── {componente}_form.dart          # Formulários
```

### 🎯 Checklist de Qualidade
- [ ] **Performance**: Widgets const onde possível
- [ ] **Acessibilidade**: Semantics e labels adequados
- [ ] **Internacionalização**: Textos externalizáveis
- [ ] **Testes**: Widgets testáveis
- [ ] **Documentação**: Comentários explicativos
- [ ] **Erro Handling**: Estados de erro e loading
- [ ] **Validação**: Formulários com validação robusta

## 🎨 Padrões de Design

### 🎭 Animações e Transições
```dart
// Transição suave entre widgets
AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: currentWidget,
)

// Fade in para novos elementos
FadeTransition(
  opacity: _animationController,
  child: widget,
)

// Slide transition para modais
SlideTransition(
  position: Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(_animationController),
  child: modal,
)
```

### 🎪 Estados de Loading
```dart
// Loading button
ElevatedButton(
  onPressed: _isLoading ? null : _handleSubmit,
  child: _isLoading 
    ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : const Text('Salvar'),
)

// Loading overlay
Stack(
  children: [
    content,
    if (_isLoading)
      Container(
        color: Colors.black54,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
  ],
)
```

## 🚀 Workflow de Conversão

### 1️⃣ Preparação (5 min)
1. Analisar componente React
2. Identificar dependências
3. Mapear estados e props
4. Planejar estrutura Flutter

### 2️⃣ Implementação (20-30 min)
1. Criar estrutura de arquivos
2. Implementar widget principal
3. Converter estilos
4. Adicionar interatividade

### 3️⃣ Refinamento (10 min)
1. Testar responsividade
2. Ajustar animações
3. Validar funcionalidades
4. Documentar código

### 4️⃣ Validação (5 min)
1. Verificar fidelidade visual
2. Testar em diferentes tamanhos
3. Confirmar performance
4. Review de código

---

## 📚 Recursos Adicionais

- **Documentação Flutter**: https://flutter.dev/docs
- **Material Design**: https://material.io/design
- **Tailwind CSS Reference**: https://tailwindcss.com/docs
- **shadcn/ui Components**: https://ui.shadcn.com/docs

---

*Este guia garante conversões consistentes e de alta qualidade do React para Flutter no projeto Palliative Care.*