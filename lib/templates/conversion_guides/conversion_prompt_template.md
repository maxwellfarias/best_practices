# 🚀 TEMPLATE DE PROMPT PARA CONVERSÃO REACT → FLUTTER

## 📋 CONTEXTO
Preciso converter o componente React **`{NOME_COMPONENTE}`** para Flutter seguindo os padrões estabelecidos no projeto, incluindo a arquitetura completa: Domain Model, Mock, Repository, ViewModel e Screen.

## 🎯 TAREFA PRINCIPAL
Converta o código React anexado para Flutter implementando a arquitetura completa:
- **Domain Model**: Classe modelo de domínio com métodos obrigatórios
- **Mock Data**: Classe mock para simulação de dados
- **Repository Pattern**: Interface e implementação do repository
- **ViewModel**: Gerenciamento de estado usando Command pattern
- **UI Screen**: Tela Flutter com layout responsivo e funcionalidades completas

## 📁 ARQUIVOS DE REFERÊNCIA ANEXADOS
- [ ] **Código React**: `lovable/src/pages/{nome_da_pagina}.tsx` - Componente principal a ser convertido
- [ ] **CSS/Styles**: `lovable/src/index.css` ou arquivo de estilos relevante
- [ ] **Domain Model**: `lib/domain/models/{NOME_MODELO}_model.dart` - **OBRIGATÓRIO: Informar path da classe modelo**
- [ ] **App Exception**: `lib/exceptions/app_exception.dart` - Sistema de exceções
- [ ] **Result Class**: `lib/utils/result.dart` - Wrapper para resultados
- [ ] **Command Pattern**: `lib/utils/command.dart` - Sistema de comandos
- [ ] **Guia de Conversão**: `lib/templates/conversion_guides/react_to_flutter_guide.md` - Referência completa
- [ ] **Extensões Flutter**: `lib/ui/core/extensions/build_context_extension.dart` - Extensões de contexto
- [ ] **Tema Flutter**: `lib/ui/core/themes/theme.dart` - Tema já configurado

## 🔧 REQUISITOS ESPECÍFICOS

### 🔹 ETAPA 1: DOMAIN MODEL (OBRIGATÓRIO)
**Path**: `/lib/domain/models/{nome_da_classe}_model.dart`

Criar classe de domínio com métodos obrigatórios:
- [ ] **Constructor**: Parâmetros required e opcionais
- [ ] **fromJson**: Factory constructor para desserialização
- [ ] **toJson**: Método para serialização
- [ ] **copyWith**: Método para criar cópias com alterações
- [ ] **toString**: Override para debugging

```dart
/// Modelo de domínio para {DESCRIÇÃO}
final class {NOME_MODELO}Model {
  final String id;
  final String {CAMPO_1};
  final String {CAMPO_2};
  final bool {CAMPO_BOOLEAN};
  final DateTime createdAt;
  final DateTime? {CAMPO_OPCIONAL};

  const {NOME_MODELO}Model({
    required this.id,
    required this.{CAMPO_1},
    required this.{CAMPO_2},
    required this.{CAMPO_BOOLEAN},
    required this.createdAt,
    this.{CAMPO_OPCIONAL},
  });

  factory {NOME_MODELO}Model.fromJson(dynamic json) {
    return {NOME_MODELO}Model(
      id: json['id'] ?? '',
      {CAMPO_1}: json['{CAMPO_1}'] ?? '',
      // ... implementar todos os campos
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      '{CAMPO_1}': {CAMPO_1},
      // ... todos os campos
    };
  }

  {NOME_MODELO}Model copyWith({
    String? id,
    String? {CAMPO_1},
    // ... todos os campos opcionais
  }) {
    return {NOME_MODELO}Model(
      id: id ?? this.id,
      {CAMPO_1}: {CAMPO_1} ?? this.{CAMPO_1},
      // ... implementação completa
    );
  }

  @override
  String toString() {
    return '{NOME_MODELO}Model(id: $id, {CAMPO_1}: ${CAMPO_1}, ...)';
  }
}
```

### 🔹 ETAPA 2: MOCK DATA
**Path**: `/lib/utils/mocks/{nome_da_classe}_mock.dart`

Criar classe mock com operações CRUD completas:
- [ ] **getMock{PLURAL}**: Retorna lista com Future.delayed (2s)
- [ ] **add{NOME_MODELO}**: Adiciona novo item
- [ ] **get{NOME_MODELO}ById**: Busca por ID
- [ ] **update{NOME_MODELO}**: Atualiza existente
- [ ] **delete{NOME_MODELO}**: Remove por ID
- [ ] **clearAll{PLURAL}**: Limpa lista (para testes)
- [ ] **resetToInitialState**: Restaura dados iniciais


O modelo de referência para criar a classe mock encontra-se em `/lib/templates/flutter_templates/simple_mock_template.dart`.


```dart
/// Classe utilitária para dados fictícios de {NOME_MODELO}Model
class {NOME_MODELO}Mock {
  static List<{NOME_MODELO}Model> _{LISTA_PRIVADA} = [];
  
  static void _initializeIfEmpty() {
    if (_{LISTA_PRIVADA}.isEmpty) {
      _{LISTA_PRIVADA} = _generateInitial{PLURAL}();
    }
  }
  
  static Future<Result<List<{NOME_MODELO}Model>>> getMock{PLURAL}() async {
    _initializeIfEmpty();
    await Future.delayed(const Duration(seconds: 2));
    return Result.ok(List.from(_{LISTA_PRIVADA}));
  }
  
  static List<{NOME_MODELO}Model> _generateInitial{PLURAL}() {
    final now = DateTime.now();
    return [
      // Gerar 6-8 itens mock realistas baseados no modelo React
    ];
  }
  
}
```

### 🔹 ETAPA 3: REPOSITORY INTERFACE
**Path**: `/lib/data/repositories/{nome_da_classe}/{nome_da_classe}_repository.dart`

Interface com 5 métodos obrigatórios:
- [ ] **getAll{PLURAL}({required String databaseId})**: Lista completa
- [ ] **get{NOME_MODELO}By({required String databaseId, required String id})**: Item específico
- [ ] **create{NOME_MODELO}({required String databaseId, required Model})**: Criar novo
- [ ] **update{NOME_MODELO}({required String databaseId, required Model})**: Atualizar
- [ ] **delete{NOME_MODELO}({required String databaseId, required String id})**: Deletar

```dart
abstract interface class {NOME_MODELO}Repository {
  Future<Result<List<{NOME_MODELO}Model>>> getAll{PLURAL}({required String databaseId});
  Future<Result<{NOME_MODELO}Model>> get{NOME_MODELO}By({required String databaseId, required String {NOME_MODELO_LOWER}Id});
  Future<Result<{NOME_MODELO}Model>> create{NOME_MODELO}({required String databaseId, required {NOME_MODELO}Model {NOME_MODELO_LOWER}});
  Future<Result<{NOME_MODELO}Model>> update{NOME_MODELO}({required String databaseId, required {NOME_MODELO}Model {NOME_MODELO_LOWER}});
  Future<Result<dynamic>> delete{NOME_MODELO}({required String databaseId, required String {NOME_MODELO_LOWER}Id});
}
```

### 🔹 ETAPA 4: REPOSITORY IMPLEMENTATION
**Path**: `/lib/data/repositories/{nome_da_classe}/{nome_da_classe}_repository_impl.dart`

Implementação usando Mock:
- [ ] **Implementar interface**: Todos os 5 métodos
- [ ] **Usar Mock**: Delegar para {NOME_MODELO}Mock
- [ ] **Result Pattern**: Retornar Result<T> para todos os métodos
- [ ] **Error Handling**: Tratar exceções adequadamente

```dart
class {NOME_MODELO}RepositoryImpl implements {NOME_MODELO}Repository {
  {NOME_MODELO}RepositoryImpl();
  
  @override
  Future<Result<{NOME_MODELO}Model>> create{NOME_MODELO}({required String databaseId, required {NOME_MODELO}Model {NOME_MODELO_LOWER}}) async {
    return {NOME_MODELO}Mock.add{NOME_MODELO}({NOME_MODELO_LOWER});
  }
  
  @override
  Future<Result<dynamic>> delete{NOME_MODELO}({required String databaseId, required String {NOME_MODELO_LOWER}Id}) async {
    return Result.ok({NOME_MODELO}Mock.delete{NOME_MODELO}({NOME_MODELO_LOWER}Id));
  }
  
  @override
  Future<Result<List<{NOME_MODELO}Model>>> getAll{PLURAL}({required String databaseId}) async {
    return {NOME_MODELO}Mock.getMock{PLURAL}();
  }
  
  @override
  Future<Result<{NOME_MODELO}Model>> get{NOME_MODELO}By({required String databaseId, required String {NOME_MODELO_LOWER}Id}) async {
    return {NOME_MODELO}Mock.get{NOME_MODELO}ById({NOME_MODELO_LOWER}Id);
  }
  
  @override
  Future<Result<{NOME_MODELO}Model>> update{NOME_MODELO}({required String databaseId, required {NOME_MODELO}Model {NOME_MODELO_LOWER}}) async {
    return {NOME_MODELO}Mock.update{NOME_MODELO}({NOME_MODELO_LOWER});
  }
}
```

### 🔹 ETAPA 5: VIEWMODEL
**Path**: `/lib/ui/{nome_da_tela}/viewmodel/{nome_da_tela}_viewmodel.dart`

ViewModel com Command pattern:
- [ ] **Constructor**: Injeção de dependência do Repository
- [ ] **Lista privada**: `List<{NOME_MODELO}Model> _{LISTA_PRIVADA} = []`
- [ ] **Getter público**: `List<{NOME_MODELO}Model> get {LISTA_PUBLICA} => _{LISTA_PRIVADA}`
- [ ] **5 Commands**: getAll, getBy, create, update, delete
- [ ] **Métodos privados**: Implementação com notifyListeners()

```dart
final class {NOME_TELA}ViewModel extends ChangeNotifier {
  {NOME_TELA}ViewModel({required {NOME_MODELO}Repository {NOME_MODELO_LOWER}Repository}) : _{NOME_MODELO_LOWER}Repository = {NOME_MODELO_LOWER}Repository {
    getAll{PLURAL} = Command0(_getAll{PLURAL});
    get{NOME_MODELO}By = Command1(_get{NOME_MODELO}By);
    create{NOME_MODELO} = Command1(_create{NOME_MODELO});
    update{NOME_MODELO} = Command1(_update{NOME_MODELO});
    delete{NOME_MODELO} = Command1(_delete{NOME_MODELO});
  }
  final {NOME_MODELO}Repository _{NOME_MODELO_LOWER}Repository;

  final List<{NOME_MODELO}Model> _{LISTA_PRIVADA} = [];
  List<{NOME_MODELO}Model> get {LISTA_PUBLICA} => _{LISTA_PRIVADA};
  
  late final Command0<List<{NOME_MODELO}Model>> getAll{PLURAL};
  late final Command1<{NOME_MODELO}Model, String> get{NOME_MODELO}By;
  late final Command1<{NOME_MODELO}Model, {NOME_MODELO}Model> create{NOME_MODELO};
  late final Command1<{NOME_MODELO}Model, {NOME_MODELO}Model> update{NOME_MODELO};
  late final Command1<dynamic, String> delete{NOME_MODELO};

  // Implementar métodos privados com Result.map() e notifyListeners()
}
```

### 🔹 ETAPA 6: UI SCREEN
**Path**: `/lib/ui/{nome_da_tela}/widget/{nome_da_tela}_screen.dart`

Tela completa com padrões obrigatórios:
- [ ] **initState**: Listeners para update, delete, create + execute getAll
- [ ] **dispose**: removeListener para todos os commands
- [ ] **_onResult**: Feedback visual com SnackBar (sucesso/erro)
- [ ] **ListenableBuilder**: Merge viewModel + getAllCommand
- [ ] **Estados**: Loading (CupertinoActivityIndicator), Error, Empty, Success
- [ ] **Layout Responsivo**: LayoutBuilder com breakpoints

```dart
class _${NOME_TELA}ScreenState extends State<{NOME_TELA}Screen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.update{NOME_MODELO}.addListener(() => _onResult(command: widget.viewModel.update{NOME_MODELO}, successMessage: '{MODELO} atualizado com sucesso!'));
    widget.viewModel.delete{NOME_MODELO}.addListener(() => _onResult(command: widget.viewModel.delete{NOME_MODELO}, successMessage: '{MODELO} excluído com sucesso!'));
    widget.viewModel.create{NOME_MODELO}.addListener(() => _onResult(command: widget.viewModel.create{NOME_MODELO}, successMessage: '{MODELO} criado com sucesso!'));
    widget.viewModel.getAll{PLURAL}.execute();
  }

  @override
  void dispose() {
    widget.viewModel.update{NOME_MODELO}.removeListener(() => _onResult(command: widget.viewModel.update{NOME_MODELO}, successMessage: '{MODELO} atualizado com sucesso!'));
    widget.viewModel.delete{NOME_MODELO}.removeListener(() => _onResult(command: widget.viewModel.delete{NOME_MODELO}, successMessage: '{MODELO} excluído com sucesso!'));
    widget.viewModel.create{NOME_MODELO}.removeListener(() => _onResult(command: widget.viewModel.create{NOME_MODELO}, successMessage: '{MODELO} criado com sucesso!'));
    super.dispose();
  }

  void _onResult({required Command command, required String successMessage}) {
    if(command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: \${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{TITULO_TELA}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.viewModel.getAll{PLURAL}.execute(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.getAll{PLURAL},
        ]),
        builder: (context, _) {
          if (widget.viewModel.getAll{PLURAL}.running) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (widget.viewModel.getAll{PLURAL}.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Erro ao carregar {PLURAL_LOWER}: \${widget.viewModel.getAll{PLURAL}.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: widget.viewModel.{LISTA_PUBLICA}.isEmpty
                    ? const Center(child: Text('Nenhum {MODELO_LOWER} encontrado'))
                    : _buildResponsiveList(context),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create{NOME_MODELO},
        child: const Icon(Icons.add),
      ),
    );
  }

  // Implementar métodos CRUD e layout responsivo
}
```

### 2. 🎨 Conversão de Estilos e Layout Responsivo
- [ ] **Tipografia**: Mapear classes CSS para CustomTextTheme
- [ ] **Cores**: Converter variáveis CSS para NewAppColorTheme
- [ ] **Layout Responsivo**: Adaptar para LayoutBuilder e MediaQuery
- [ ] **Animações**: Implementar transições e micro-interações
- [ ] **Espaçamentos**: Converter padding/margin Tailwind para EdgeInsets
- [ ] **Sombras e Elevação**: Mapear box-shadow para elevation
- [ ] **LayoutBuilder**: Implementar breakpoints (mobile < 640px, tablet 640-1024px, desktop > 1024px)
- [ ] **Responsividade**: GridView adaptativo baseado em largura da tela

## 🎨 Mapeamento Detalhado de Estilos

### 📝 Tipografia (React Tailwind → Flutter CustomTextTheme)

| React Tailwind Class | Tamanho | Peso | Flutter Equivalent |
|---------------------|---------|------|-------------------|
| `text-4xl font-bold` | 36px | 700 | `context.customTextTheme.text4XlBold` |
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

### 📐 Espaçamentos (Tailwind → Flutter EdgeInsets)

| Tailwind Class | Valor | Flutter Equivalent |
|---------------|-------|-------------------|
| `p-1` | 4px | `EdgeInsets.all(4)` |
| `p-2` | 8px | `EdgeInsets.all(8)` |
| `p-3` | 12px | `EdgeInsets.all(12)` |
| `p-4` | 16px | `EdgeInsets.all(16)` |
| `p-6` | 24px | `EdgeInsets.all(24)` |
| `p-8` | 32px | `EdgeInsets.all(32)` |
| `px-4` | 16px horizontal | `EdgeInsets.symmetric(horizontal: 16)` |
| `py-2` | 8px vertical | `EdgeInsets.symmetric(vertical: 8)` |
| `pt-4` | 16px top | `EdgeInsets.only(top: 16)` |
| `pb-2` | 8px bottom | `EdgeInsets.only(bottom: 8)` |
| `pl-3` | 12px left | `EdgeInsets.only(left: 12)` |
| `pr-6` | 24px right | `EdgeInsets.only(right: 24)` |

### 🌟 Componentes React → Flutter

| React Component | Propriedades | Flutter Equivalent |
|----------------|-------------|-------------------|
| `<Button>` | primary, secondary, outline | `ElevatedButton`, `OutlinedButton`, `TextButton` |
| `<Input>` | type, placeholder, value | `TextFormField` com `InputDecoration` |
| `<Badge>` | variant, color | `Chip` ou `Container` customizado |
| `<Card>` | className, children | `Card` com `CardContent` |
| `<Dialog>` | open, onOpenChange | `showDialog()` com `AlertDialog` |
| `<Form>` | onSubmit, validation | `Form` com `GlobalKey<FormState>` |
| `<Select>` | value, onValueChange | `DropdownButtonFormField` |

### ⚠️ IMPORTANTE: Componentes Importados
**Observação**: As páginas em `/lovable/src/pages/` importam componentes de outros lugares:

```tsx
// Exemplo de imports comuns:
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
```

**🔍 Sempre considere TODOS os componentes utilizados na conversão, não apenas o arquivo principal!**
### 3. 🧩 Componentes e Funcionalidades
- [ ] **Modais React → Flutter**: Converter para `showDialog()` com `Dialog` ou `AlertDialog`
- [ ] **Formulários**: Implementar com `Form` + `TextFormField` + validação usando padrão Command
- [ ] **Estados de Loading**: CupertinoActivityIndicator quando Command.running == true
- [ ] **Estados de Erro**: Feedback visual quando Command.error == true
- [ ] **Navegação**: Implementar com `Navigator` e transições suaves
- [ ] **CRUD Operations**: Create, Update, Delete usando Commands da ViewModel

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

## 📤 ENTREGÁVEIS ESPERADOS

### 📁 Estrutura de Arquivos OBRIGATÓRIA
```
lib/
├── domain/models/
│   └── {nome_modelo}_model.dart           # 1. Domain Model
├── utils/mocks/
│   └── {nome_modelo}_mock.dart            # 2. Mock Data
├── data/repositories/{nome_modelo}/
│   ├── {nome_modelo}_repository.dart      # 3. Repository Interface
│   └── {nome_modelo}_repository_impl.dart # 4. Repository Implementation
└── ui/{nome_tela}/
    ├── viewmodel/
    │   └── {nome_tela}_viewmodel.dart      # 5. ViewModel
    └── widget/
        ├── {nome_tela}_screen.dart         # 6. Main Screen
        ├── {componente}_dialog.dart        # Dialogs/Modals
        └── {componente}_form.dart          # Forms
```

### 📝 Código Esperado (6 ARQUIVOS OBRIGATÓRIOS)
1. **Domain Model**: Classe final com fromJson, toJson, copyWith, toString
2. **Mock Class**: Operações CRUD completas com dados realistas
3. **Repository Interface**: 5 métodos abstratos com Result<T>
4. **Repository Implementation**: Delegação para Mock com tratamento de erros
5. **ViewModel**: Command pattern com gerenciamento de estado reativo
6. **UI Screen**: StatefulWidget com listeners, responsividade e feedback visual

### 🎯 PADRÕES ESPECÍFICOS OBRIGATÓRIOS

#### Command Pattern na ViewModel:
```dart
// Command0 para métodos sem parâmetros
late final Command0<List<TaskModel>> getAllTasks;

// Command1 para métodos com 1 parâmetro
late final Command1<TaskModel, String> getTaskBy;
late final Command1<TaskModel, TaskModel> createTask;
```

#### Result Pattern em Repository:
```dart
Future<Result<List<TaskModel>>> getAllTasks({required String databaseId}) async {
  return TaskMock.getMockTasks();
}
```

#### ListenableBuilder na UI:
```dart
ListenableBuilder(
  listenable: Listenable.merge([
    widget.viewModel,
    widget.viewModel.getAllTasks,
  ]),
  builder: (context, _) {
    // Estados: loading, error, empty, success
  },
)
```

## ✅ CRITÉRIOS DE VALIDAÇÃO

### 🏗️ Arquitetura Completa
- [ ] **Domain Model**: Classe com fromJson, toJson, copyWith, toString implementados
- [ ] **Mock Data**: CRUD completo com 6-8 itens realistas e Future.delayed
- [ ] **Repository**: Interface + Implementation usando Mock
- [ ] **ViewModel**: Command pattern com 5 commands + notifyListeners
- [ ] **UI Screen**: ListenableBuilder + Command listeners + responsividade

### 🎨 Fidelidade Visual
- [ ] Layout idêntico ao React em todos os breakpoints
- [ ] Tipografia consistente com CustomTextTheme
- [ ] Espaçamentos e proporções mantidos
- [ ] Estados visuais (loading, error, empty, success) implementados

### 🔧 Funcionalidade
- [ ] **CRUD Completo**: Create, Read, Update, Delete funcionando
- [ ] **Command Pattern**: Estados de loading, error, completed
- [ ] **Feedback Visual**: SnackBars para sucesso/erro de operações
- [ ] **Validação**: Formulários com validação robusta
- [ ] **Responsividade**: Mobile, tablet e desktop

### 💎 Qualidade de Código
- [ ] Sem erros de compilação ou warnings
- [ ] Padrões arquiteturais seguidos rigorosamente
- [ ] Dispose de listeners implementado corretamente
- [ ] Performance otimizada com const widgets
- [ ] Código bem estruturado e documentado

## 📊 EXEMPLO DE CONVERSÃO COMPLETA

### 🔹 1. Domain Model
```dart
/// Modelo de domínio para uma tarefa médica
final class MedicalTaskModel {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const MedicalTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  factory MedicalTaskModel.fromJson(dynamic json) {
    return MedicalTaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.normal,
      ),
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.name,
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  MedicalTaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return MedicalTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'MedicalTaskModel(id: $id, title: $title, priority: $priority, isCompleted: $isCompleted)';
  }
}

enum TaskPriority { low, normal, high, critical }
```

### 🔹 2. ViewModel com Commands
```dart
final class MedicalTaskViewModel extends ChangeNotifier {
  MedicalTaskViewModel({required MedicalTaskRepository taskRepository}) 
      : _taskRepository = taskRepository {
    getAllTasks = Command0(_getAllTasks);
    getTaskBy = Command1(_getTaskBy);
    createTask = Command1(_createTask);
    updateTask = Command1(_updateTask);
    deleteTask = Command1(_deleteTask);
  }
  
  final MedicalTaskRepository _taskRepository;

  final List<MedicalTaskModel> _tasks = [];
  List<MedicalTaskModel> get tasks => _tasks;
  
  late final Command0<List<MedicalTaskModel>> getAllTasks;
  late final Command1<MedicalTaskModel, String> getTaskBy;
  late final Command1<MedicalTaskModel, MedicalTaskModel> createTask;
  late final Command1<MedicalTaskModel, MedicalTaskModel> updateTask;
  late final Command1<dynamic, String> deleteTask;

  Future<Result<List<MedicalTaskModel>>> _getAllTasks() async {
    return await _taskRepository.getAllTasks(databaseId: 'default')
        .map((tasks) {
      _tasks
        ..clear()
        ..addAll(tasks);
      notifyListeners();
      return tasks;
    });
  }

  Future<Result<MedicalTaskModel>> _createTask(MedicalTaskModel task) async {
    return await _taskRepository.createTask(databaseId: 'default', task: task)
        .map((createdTask) {
      _tasks.add(createdTask);
      notifyListeners();
      return createdTask;
    });
  }

  // ... outros métodos
}
```

### 🔹 3. UI Screen com ListenableBuilder
```dart
class MedicalTaskScreen extends StatefulWidget {
  final MedicalTaskViewModel viewModel;
  const MedicalTaskScreen({super.key, required this.viewModel});

  @override
  State<MedicalTaskScreen> createState() => _MedicalTaskScreenState();
}

class _MedicalTaskScreenState extends State<MedicalTaskScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.updateTask.addListener(() => _onResult(
      command: widget.viewModel.updateTask, 
      successMessage: 'Tarefa médica atualizada com sucesso!'
    ));
    widget.viewModel.deleteTask.addListener(() => _onResult(
      command: widget.viewModel.deleteTask, 
      successMessage: 'Tarefa médica excluída com sucesso!'
    ));
    widget.viewModel.createTask.addListener(() => _onResult(
      command: widget.viewModel.createTask, 
      successMessage: 'Tarefa médica criada com sucesso!'
    ));
    widget.viewModel.getAllTasks.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.getAllTasks,
        ]),
        builder: (context, _) {
          if (widget.viewModel.getAllTasks.running) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (widget.viewModel.getAllTasks.error) {
            return Center(
              child: Text(
                'Erro ao carregar tarefas: ${widget.viewModel.getAllTasks.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 1;
              if (width >= 1024) crossAxisCount = 3;
              else if (width >= 640) crossAxisCount = 2;

              return widget.viewModel.tasks.isEmpty
                  ? const Center(child: Text('Nenhuma tarefa médica encontrada'))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: widget.viewModel.tasks.length,
                      itemBuilder: (context, index) {
                        final task = widget.viewModel.tasks[index];
                        return _MedicalTaskCard(
                          task: task,
                          onEdit: () => _editTask(task),
                          onDelete: () => _deleteTask(task.id),
                          onToggleComplete: () => _toggleTaskCompletion(task),
                        );
                      },
                    );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onResult({required Command command, required String successMessage}) {
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${command.errorMessage ?? 'Erro desconhecido'}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ... métodos CRUD
}
```

---

## 🚀 EXECUTAR CONVERSÃO

### 📝 PROMPT FINAL PARA USO:

**Copie e cole este template preenchendo as variáveis `{VARIAVEL}` com os valores específicos do seu projeto:**

```
Converta o componente React {NOME_COMPONENTE} para Flutter seguindo a arquitetura completa estabelecida no projeto.

**INFORMAÇÕES OBRIGATÓRIAS:**
- **Domain Model Path**: /lib/domain/models/{NOME_MODELO}_model.dart
- **Tela Nome**: {NOME_TELA}
- **Componente React**: lovable/src/pages/{NOME_PAGINA}.tsx

**ARQUITETURA COMPLETA (6 ARQUIVOS):**
1. Domain Model (/lib/domain/models/{NOME_MODELO}_model.dart)
2. Mock Data (/lib/utils/mocks/{NOME_MODELO}_mock.dart)  
3. Repository Interface (/lib/data/repositories/{NOME_MODELO}/{NOME_MODELO}_repository.dart)
4. Repository Implementation (/lib/data/repositories/{NOME_MODELO}/{NOME_MODELO}_repository_impl.dart)
5. ViewModel (/lib/ui/{NOME_TELA}/viewmodel/{NOME_TELA}_viewmodel.dart)
6. UI Screen (/lib/ui/{NOME_TELA}/widget/{NOME_TELA}_screen.dart)

**PADRÕES OBRIGATÓRIOS:**
- Domain Model: fromJson, toJson, copyWith, toString
- Mock: CRUD completo com Future.delayed(2s)
- Repository: 5 métodos com Result<T>
- ViewModel: Command pattern com notifyListeners
- UI: ListenableBuilder + Command listeners + responsividade

**FUNCIONALIDADES:**
- Layout responsivo (mobile/tablet/desktop)
- CRUD completo funcionando
- Estados loading/error/empty/success
- Feedback visual com SnackBars
- Formulários com validação
- Conversão fiel de estilos usando CustomTextTheme e NewAppColorTheme
- Todos os componentes importados devem ser considerados na conversão

**IMPORTANTE**: Analisar TODOS os imports do arquivo React, incluindo componentes de @/components/ui/*, pois estes são essenciais para a renderização completa da página.

Implemente seguindo exatamente o template de conversão anexado.
```

### 🎯 VARIÁVEIS PARA PREENCHER:
- `{NOME_COMPONENTE}`: Nome do componente React (ex: "MedicalDashboard")  
- `{NOME_MODELO}`: Nome da classe modelo (ex: "MedicalTask")
- `{NOME_TELA}`: Nome da tela Flutter (ex: "medical_dashboard")
- `{NOME_PAGINA}`: Nome do arquivo React (ex: "medical-dashboard")

### ✅ CHECKLIST FINAL:
- [ ] Path do Domain Model informado
- [ ] Componente React anexado
- [ ] Template de conversão anexado
- [ ] Arquivos de referência anexados (AppException, Result, Command)
- [ ] Variáveis preenchidas no prompt

---

**Objetivo**: Criar uma arquitetura Flutter completa e funcional que replique perfeitamente o componente React, seguindo todos os padrões estabelecidos no projeto e garantindo máxima qualidade de código.