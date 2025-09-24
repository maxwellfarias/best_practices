# 🚀 Guia de Conversão React → Flutter - Arquitetura Completa

## 📋 **INFORMAÇÕES OBRIGATÓRIAS PARA CONVERSÃO**

### 🎯 **Dados Necessários no Prompt**
Ao solicitar uma conversão, você **DEVE** fornecer obrigatoriamente:

1. **Domain Model Path**: `/lib/domain/models/{nome_modelo}.dart`
2. **Tela Nome**: `{nome_tela}_screen`
3. **Componente React**: Path completo do arquivo `.tsx` a ser convertido

**Exemplo de Prompt Obrigatório:**
```
**INFORMAÇÕES OBRIGATÓRIAS:**
- **Domain Model Path**: /lib/domain/models/turma_model.dart
- **Tela Nome**: turmas_screen
- **Componente React**: lovable/src/pages/Classes.tsx

**ARQUITETURA COMPLETA (6 ARQUIVOS):**
1. Domain Model (/lib/domain/models/turma_model.dart)
2. Mock Data (/lib/utils/mocks/turma_mock.dart)  
3. Repository Interface (/lib/data/repositories/turma/turma_repository.dart)
4. Repository Implementation (/lib/data/repositories/turma/turma_repository_impl.dart)
5. ViewModel (/lib/ui/turma_screen/viewmodel/turma_viewmodel.dart)
6. UI Screen (/lib/ui/turma_screen/widget/turma_screen.dart)
```

## 🏗️ **ARQUITETURA OBRIGATÓRIA (6 CAMADAS)**

### 1️⃣ **Domain Model** (OBRIGATÓRIO)
**Path**: `/lib/domain/models/{nome_modelo}.dart`

**Métodos Obrigatórios**: `toJson`, `fromJson`, `copyWith`, `toString`

```dart
/// Modelo de domínio para uma tarefa
///
/// Representa uma tarefa no sistema com todos os dados necessários
/// para a lógica de negócio. Usa Equatable para facilitar comparações
/// em testes.
final class TaskModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });

  factory TaskModel.fromJson(dynamic json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
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
      'is_completed': isCompleted,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  /// Cria uma cópia da tarefa com alguns campos atualizados
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'Task('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'isCompleted: $isCompleted, '
        'createdAt: $createdAt, '
        'completedAt: $completedAt'
        ')';
  }
}
```

### 2️⃣ **Mock Data** (OBRIGATÓRIO)
**Path**: `/lib/utils/mocks/{nome_modelo}_mock.dart`

**Dependências**: `AppException` e `Result<T>`

```dart
/// Classe utilitária para criar dados fictícios de TaskModel
class TaskMock {
  static List<TaskModel> _tasks = [];
  
  /// Inicializa a lista com dados fictícios na primeira chamada
  static void _initializeIfEmpty() {
    if (_tasks.isEmpty) {
      _tasks = _generateInitialTasks();
    }
  }
  
  /// Retorna uma lista de dados fictícios de TaskModel
  static Future<Result<List<TaskModel>>> getMockTasks() async {
    _initializeIfEmpty();
    await Future.delayed(const Duration(seconds: 2)); // Simula atraso de rede
    return Result.ok(List.from(_tasks));
  }
  
  /// Gera os dados iniciais das tasks
  static List<TaskModel> _generateInitialTasks() {
    final now = DateTime.now();

    return [
      TaskModel(
        id: '1',
        title: 'Comprar ingredientes para o jantar',
        description:
            'Ir ao supermercado e comprar vegetais, carne e temperos para preparar o jantar da família',
        isCompleted: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TaskModel(
        id: '2',
        title: 'Estudar Flutter e Dart',
        description:
            'Revisar conceitos de widgets, estado e testes unitários para o projeto atual',
        isCompleted: true,
        createdAt: now.subtract(const Duration(days: 1)),
        completedAt: now.subtract(const Duration(hours: 3)),
      ),
      // ... mais 6 itens conforme modelo
    ];
  }
  
  /// Adiciona uma nova task à lista
  static Result<TaskModel> addTask(TaskModel task) {
    _initializeIfEmpty();
    _tasks.add(task);
    return Result.ok(task);
  }
  
  /// Busca uma task específica pelo ID
  static Result<TaskModel> getTaskById(String id) {
    _initializeIfEmpty();
    try {
      final resposta = _tasks.firstWhere((task) => task.id == id);
      return Result.ok(resposta);
    } catch (e) {
      return Result.error(ErroInternoServidorException());
    }
  }
  
  /// Atualiza uma task existente
  static Result<TaskModel> updateTask(TaskModel updatedTask) {
    _initializeIfEmpty();
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      return Result.ok(updatedTask);
    }
    return Result.error(ErroInternoServidorException());
  }
  
  /// Remove uma task da lista pelo ID
  static Result<bool> deleteTask(String id) {
    _initializeIfEmpty();
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    return _tasks.length < initialLength ? Result.ok(true) : Result.error(ErroInternoServidorException());
  }
  
  /// MÉTODOS UTILITÁRIOS OBRIGATÓRIOS
  static void clearAllTasks() {
    _tasks.clear();
  }
  
  static void resetToInitialState() {
    _tasks.clear();
    _initializeIfEmpty();
  }
}
```

### 3️⃣ **Repository Interface** (OBRIGATÓRIO)
**Path**: `/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository.dart`

**5 Métodos Obrigatórios**:

```dart
abstract interface class TaskRepository {
  /// 1. Buscar todos os itens
  Future<Result<List<TaskModel>>> getAllTasks({required String databaseId});
  
  /// 2. Buscar item por ID
  Future<Result<TaskModel>> getTaskBy({required String databaseId, required String taskId});
  
  /// 3. Criar novo item
  Future<Result<TaskModel>> createTask({required String databaseId, required TaskModel task});
  
  /// 4. Atualizar item existente
  Future<Result<TaskModel>> updateTask({required String databaseId, required TaskModel task});
  
  /// 5. Deletar item
  Future<Result<dynamic>> deleteTask({required String databaseId, required String taskId});
}
```

### 4️⃣ **Repository Implementation** (OBRIGATÓRIO)
**Path**: `/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository_impl.dart`

```dart
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/utils/mocks/task_mock.dart';
import '../../utils/result.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl();
    
  @override
  Future<Result<TaskModel>> createTask({required String databaseId, required TaskModel task}) async {
    return TaskMock.addTask(task);
  }

  @override
  Future<Result<dynamic>> deleteTask({required String databaseId, required String taskId}) async {
    return Result.ok(TaskMock.deleteTask(taskId));
  }

  @override
  Future<Result<List<TaskModel>>> getAllTasks({required String databaseId}) async {
    return TaskMock.getMockTasks();
  }

  @override
  Future<Result<TaskModel>> getTaskBy({required String databaseId, required String taskId}) async {
    return TaskMock.getTaskById(taskId);
  }

  @override
  Future<Result<TaskModel>> updateTask({required String databaseId, required TaskModel task}) async {
    return TaskMock.updateTask(task);
  }
}
```

### 5️⃣ **ViewModel** (OBRIGATÓRIO)
**Path**: `/lib/ui/{nome_tela}/viewmodel/{nome_tela}_viewmodel.dart`

**Command Pattern Obrigatório** com 5 commands:

```dart
import 'package:flutter/widgets.dart';
import 'package:mastering_tests/data/repositories/task/task_repository.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/utils/command.dart';
import 'package:mastering_tests/utils/result.dart';

final class TaskViewModel extends ChangeNotifier {
  TaskViewModel({required TaskRepository taskRepository}) : _taskRepository = taskRepository {
    getAllTasks = Command0(_getAllTasks);
    getTaskBy = Command1(_getTaskBy);
    createTask = Command1(_createTask);
    updateTask = Command1(_updateTask);
    deleteTask = Command1(_deleteTask);
  }
  final TaskRepository _taskRepository;

  final List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;
  
  /// 5 COMMANDS OBRIGATÓRIOS
  late final Command0<List<TaskModel>> getAllTasks;
  late final Command1<TaskModel, String> getTaskBy;
  late final Command1<TaskModel, TaskModel> createTask;
  late final Command1<TaskModel, TaskModel> updateTask;
  late final Command1<dynamic, String> deleteTask;

  Future<Result<List<TaskModel>>> _getAllTasks() async {
    return await _taskRepository.getAllTasks(databaseId: 'default')
    .map((tasks) {
      _tasks
      ..clear()
      ..addAll(tasks);
      notifyListeners();
      return tasks;
    });
  }

  Future<Result<TaskModel>> _getTaskBy(String taskId) async {
    return await _taskRepository.getTaskBy(databaseId: 'default', taskId: taskId);
  }

  Future<Result<TaskModel>> _createTask(TaskModel task) async {
    return await _taskRepository.createTask(databaseId: 'default', task: task)
    .map((createdTask) {
      _tasks.add(createdTask);
      notifyListeners();
      return createdTask;
    });
  }

  Future<Result<TaskModel>> _updateTask(TaskModel task) async {
    return await _taskRepository.updateTask(databaseId: 'default', task: task)
    .map((updatedTask) {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      return updatedTask;
    });
  }

  Future<Result<dynamic>> _deleteTask(String taskId) async {
    return await _taskRepository.deleteTask(databaseId: 'default', taskId: taskId)
    .map((_) {
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
      return Result.ok(null);
    });
  }
}
```

### 6️⃣ **UI Screen** (OBRIGATÓRIO)
**Path**: `/lib/ui/{nome_tela}/widget/{nome_tela}.dart`

**Padrões Obrigatórios**:
- `initState`: Listeners para 3 commands (update, delete, create) + `getAllTasks.execute()`
- `dispose`: Remover todos os listeners
- `_onResult`: Feedback visual para operações CRUD
- `ListenableBuilder`: Estados loading/error/empty/success

```dart
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mastering_tests/domain/models/task_model.dart';
import 'package:mastering_tests/ui/todo/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/utils/command.dart';

final class TodoListScreen extends StatefulWidget {
  final TaskViewModel viewModel;

  const TodoListScreen({super.key, required this.viewModel});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // LISTENERS OBRIGATÓRIOS PARA 3 COMMANDS
    widget.viewModel.updateTask.addListener(() => _onResult(command: widget.viewModel.updateTask, successMessage: 'Tarefa atualizada com sucesso!'));
    widget.viewModel.deleteTask.addListener(() => _onResult(command: widget.viewModel.deleteTask, successMessage: 'Tarefa excluída com sucesso!'));
    widget.viewModel.createTask.addListener(() => _onResult(command: widget.viewModel.createTask, successMessage: 'Tarefa criada com sucesso!'));
    // EXECUTAR GET ALL OBRIGATÓRIO
    widget.viewModel.getAllTasks.execute();
  }

  @override
  void dispose() {
    // DISPOSE DE TODOS OS LISTENERS OBRIGATÓRIO
    widget.viewModel.updateTask.removeListener(() => _onResult(command: widget.viewModel.updateTask, successMessage: 'Tarefa atualizada com sucesso!'));
    widget.viewModel.deleteTask.removeListener(() => _onResult(command: widget.viewModel.deleteTask, successMessage: 'Tarefa excluída com sucesso!'));
    widget.viewModel.createTask.removeListener(() => _onResult(command: widget.viewModel.createTask, successMessage: 'Tarefa criada com sucesso!'));
    super.dispose();
  }

  /// MÉTODO _onResult OBRIGATÓRIO PARA FEEDBACK VISUAL
  void _onResult({required Command command, required String successMessage}) {
    if(command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}'),
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
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => widget.viewModel.getAllTasks.execute(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.getAllTasks,
        ]),
        builder: (context, _) {
          /// ESTADO LOADING OBRIGATÓRIO
          if (widget.viewModel.getAllTasks.running) {
            return const Center(child: CupertinoActivityIndicator());
          }

          /// ESTADO ERROR OBRIGATÓRIO
          if (widget.viewModel.getAllTasks.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Erro ao carregar tarefas: ${widget.viewModel.getAllTasks.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          /// ESTADO EMPTY OBRIGATÓRIO
          if (widget.viewModel.tasks.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada'));
          }

          /// ESTADO SUCCESS - LISTA DE DADOS
          return ListView.builder(
            itemCount: widget.viewModel.tasks.length,
            itemBuilder: (context, index) {
              final task = widget.viewModel.tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) => _toggleTaskCompletion(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editTask(task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ],
                  ),
                  onTap: () => _showTaskDetails(task),
                ),
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

  // ... métodos CRUD implementados conforme modelo
}
```

## 📋 Checklist de Conversão Completo

## 📋 **CHECKLIST DE CONVERSÃO OBRIGATÓRIO**

### ✅ **Fase 1: Verificação de Arquitetura (OBRIGATÓRIA)**
- [ ] **Domain Model**: Classe criada com 4 métodos obrigatórios (`toJson`, `fromJson`, `copyWith`, `toString`)
- [ ] **Mock Data**: Classe criada com CRUD completo e métodos utilitários
- [ ] **Repository Interface**: Interface com 5 métodos obrigatórios declarados
- [ ] **Repository Implementation**: Implementação usando classe Mock
- [ ] **ViewModel**: Command pattern com 5 commands obrigatórios
- [ ] **UI Screen**: ListenableBuilder com 4 estados obrigatórios

### ✅ **Fase 2: Padrões Arquiteturais (OBRIGATÓRIOS)**
- [ ] **Command Pattern**: 5 commands implementados (getAll, getBy, create, update, delete)
- [ ] **Result Pattern**: Retornos tipados para tratamento de erros
- [ ] **Repository Pattern**: Inversão de dependência na ViewModel
- [ ] **Observer Pattern**: ChangeNotifier + ListenableBuilder
- [ ] **Future Simulation**: Mock com Future.delayed(2 seconds)

### ✅ **Fase 3: Estados da UI (OBRIGATÓRIOS)**
- [ ] **Loading State**: CupertinoActivityIndicator quando `command.running == true`
- [ ] **Error State**: Widget de erro quando `command.error == true`
- [ ] **Empty State**: Widget vazio quando lista está vazia
- [ ] **Success State**: Lista de dados quando `command.completed == true`

### ✅ **Fase 4: Lifecycle Obrigatório**
- [ ] **initState**: 3 listeners (create, update, delete) + `getAllTasks.execute()`
- [ ] **dispose**: Remoção de todos os listeners
- [ ] **_onResult**: Feedback visual com SnackBar para success/error

### ✅ **Fase 5: Análise do Componente React**
- [ ] **Props e Estado**: Identificar todas as props e hooks useState do componente
- [ ] **Componentes Externos**: Mapear bibliotecas (shadcn/ui, lucide-react, react-hook-form, etc.)
- [ ] **Hooks Utilizados**: Documentar useEffect, useCallback, useMemo, etc.
- [ ] **Funcionalidades Interativas**: Modais, formulários, navegação, animações
- [ ] **Breakpoints Responsivos**: Identificar classes Tailwind responsivas
- [ ] **Dados Mock**: Listar todas as constantes e arrays de dados
- [ ] **Eventos**: Documentar onClick, onChange, onSubmit, etc.

### ✅ **Fase 6: Mapeamento de Estrutura Flutter**
- [ ] **Tipo de Widget**: Definir StatefulWidget vs StatelessWidget
- [ ] **Estados Necessários**: Mapear useState para variáveis de estado Flutter
- [ ] **Widgets Equivalentes**: Identificar Container, Card, Button, Dialog, etc.
- [ ] **Estrutura de Arquivos**: Planejar organização de pastas e arquivos
- [ ] **Dependências**: Verificar packages Flutter necessários
- [ ] **Modelos de Dados**: Criar classes para objetos complexos

### ✅ **Fase 7: Conversão de Estilos**
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

## 🚀 **WORKFLOW DE CONVERSÃO OBRIGATÓRIO**

### 📝 **Ordem de Implementação (SEGUIR EXATAMENTE)**

#### **1. Domain Model** (5 min)
```bash
# Criar arquivo
/lib/domain/models/{nome_modelo}.dart

# Implementar obrigatoriamente:
✅ Classe final com propriedades
✅ factory fromJson(dynamic json)
✅ Map<String, dynamic> toJson()
✅ copyWith() para atualizações
✅ toString() para debug
```

#### **2. Mock Data** (10 min)
```bash
# Criar arquivo
/lib/utils/mocks/{nome_modelo}_mock.dart

# Implementar obrigatoriamente:
✅ Lista estática privada _items
✅ _initializeIfEmpty() com dados fictícios
✅ getMock{Modelo}s() com Future.delayed(2s)
✅ addItem(item) com Result<T>
✅ getItemById(id) com Result<T>
✅ updateItem(item) com Result<T>
✅ deleteItem(id) com Result<bool>
✅ clearAllItems() utilitário
✅ resetToInitialState() utilitário
```

#### **3. Repository Interface** (3 min)
```bash
# Criar arquivo
/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository.dart

# Implementar obrigatoriamente:
✅ abstract interface class
✅ getAll{Modelo}({required String databaseId})
✅ get{Modelo}By({required String databaseId, required String id})
✅ create{Modelo}({required String databaseId, required {Modelo} item})
✅ update{Modelo}({required String databaseId, required {Modelo} item})
✅ delete{Modelo}({required String databaseId, required String id})
```

#### **4. Repository Implementation** (5 min)
```bash
# Criar arquivo
/lib/data/repositories/{nome_modelo}/{nome_modelo}_repository_impl.dart

# Implementar obrigatoriamente:
✅ class implements {Modelo}Repository
✅ Todos os 5 métodos chamando Mock correspondente
✅ Imports corretos (domain, mock, result, interface)
```

#### **5. ViewModel** (15 min)
```bash
# Criar arquivo
/lib/ui/{nome_tela}/viewmodel/{nome_tela}_viewmodel.dart

# Implementar obrigatoriamente:
✅ class extends ChangeNotifier
✅ Constructor com Repository injection
✅ Lista privada _items + getter public
✅ 5 Commands (getAll, getBy, create, update, delete)
✅ 5 métodos privados _métodoCommand() com notifyListeners()
✅ Usar .map() para atualizar estado local
```

#### **6. UI Screen** (20-30 min)
```bash
# Criar arquivo
/lib/ui/{nome_tela}/widget/{nome_tela}.dart

# Implementar obrigatoriamente:
✅ StatefulWidget com ViewModel injection
✅ initState() com 3 listeners + getAllItems.execute()
✅ dispose() removendo todos os listeners
✅ _onResult() para feedback SnackBar
✅ ListenableBuilder com Listenable.merge()
✅ 4 estados: loading, error, empty, success
✅ CRUD UI (create, edit, delete dialogs)
```

### ⚡ **Templates de Comando Rápido**

#### **Comando para Domain Model**
```dart
// Gerar automaticamente com:
final class {Nome}Model {
  // propriedades...
  const {Nome}Model({required...});
  factory {Nome}Model.fromJson(dynamic json) => {Nome}Model(/*...*/);
  Map<String, dynamic> toJson() => {/*...*/};
  {Nome}Model copyWith({/*...*/}) => {Nome}Model(/*...*/);
  @override String toString() => '{Nome}(/*...*/)';}
```

#### **Comando para Mock Data**
```dart
// Template automático:
class {Nome}Mock {
  static List<{Nome}Model> _{items} = [];
  static void _initializeIfEmpty() {/*...*/}
  static Future<Result<List<{Nome}Model>>> getMock{Nome}s() async {/*...*/}
  // + 4 métodos CRUD + 2 utilitários
}
```

#### **Comando para Repository Interface**
```dart
// Template automático:
abstract interface class {Nome}Repository {
  Future<Result<List<{Nome}Model>>> getAll{Nome}s({required String databaseId});
  // + 4 métodos restantes
}
```

### 🎯 **Checklist Final de Qualidade**

#### **Arquitetura ✅**
- [ ] 6 arquivos criados na estrutura correta
- [ ] Domain Model com 4 métodos obrigatórios
- [ ] Mock com CRUD completo + utilitários
- [ ] Repository interface com 5 métodos
- [ ] Repository implementation conectado ao Mock
- [ ] ViewModel com 5 Commands + ChangeNotifier
- [ ] UI Screen com 4 estados + lifecycle completo

#### **Funcionalidade ✅**
- [ ] CRUD completo funcionando
- [ ] Feedback visual (SnackBar success/error)
- [ ] Estados loading/error/empty/success
- [ ] Future.delayed(2s) simulando rede
- [ ] ListenableBuilder reagindo a mudanças

#### **Performance ✅**
- [ ] Widgets const onde possível
- [ ] dispose() de listeners
- [ ] Listenable.merge() otimizado
- [ ] Result<T> pattern para error handling

#### **Código Limpo ✅**
- [ ] Imports organizados
- [ ] Comentários em métodos complexos
- [ ] Nomes seguindo padrão
- [ ] Estrutura de pastas correta

---

## 🚀 Workflow de Conversão

### 1️⃣ **Preparação (5 min) - ATUALIZADA**
1. ✅ Analisar componente React
2. ✅ Confirmar Domain Model path obrigatório
3. ✅ Mapear estados e props para Model
4. ✅ Planejar 6 arquivos da arquitetura

### 2️⃣ **Implementação Arquitetural (30-40 min) - NOVA**
1. ✅ **Domain Model** (5 min): Criar classe com 4 métodos obrigatórios
2. ✅ **Mock Data** (10 min): CRUD completo com Future.delayed
3. ✅ **Repository Interface** (3 min): 5 métodos abstratos
4. ✅ **Repository Implementation** (5 min): Conectar ao Mock
5. ✅ **ViewModel** (15 min): Command pattern + ChangeNotifier
6. ✅ **UI Screen** (20-30 min): 4 estados + lifecycle completo

### 3️⃣ **Conversão de Interface (20-30 min) - ATUALIZADA**
1. ✅ Implementar React → Flutter widgets
2. ✅ Converter estilos Tailwind → CustomTextTheme/NewAppColorTheme
3. ✅ Adicionar responsividade com LayoutBuilder
4. ✅ Conectar CRUD à ViewModel via Commands

### 4️⃣ **Validação Final (10 min) - NOVA**
1. ✅ Testar todos os 4 estados da UI
2. ✅ Verificar feedback visual (SnackBars)
3. ✅ Confirmar CRUD completo funcionando
4. ✅ Validar arquitetura com 6 arquivos
5. ✅ Review checklist obrigatório

---

## 📚 **RECURSOS OBRIGATÓRIOS**

### 🔗 **Dependências Internas**
- **Result Pattern**: `/lib/utils/result.dart`
- **Command Pattern**: `/lib/utils/command.dart`
- **App Exceptions**: `/lib/exceptions/app_exception.dart`
- **Build Context Extensions**: `/lib/ui/core/extensions/build_context_extension.dart`

### � **Recursos Adicionais**

- **Documentação Flutter**: https://flutter.dev/docs
- **Material Design**: https://material.io/design
- **Tailwind CSS Reference**: https://tailwindcss.com/docs
- **shadcn/ui Components**: https://ui.shadcn.com/docs

---

*Este guia garante conversões consistentes e de alta qualidade do React para Flutter seguindo a arquitetura obrigatória de 6 camadas com Command Pattern, Repository Pattern e Result Pattern.*

## 🎯 **RESUMO EXECUTIVO**

### **Arquitetura Obrigatória: 6 Arquivos**
1. **Domain Model** → Classe com 4 métodos obrigatórios
2. **Mock Data** → CRUD completo com simulação de rede
3. **Repository Interface** → 5 métodos abstratos
4. **Repository Implementation** → Conecta ao Mock
5. **ViewModel** → 5 Commands + ChangeNotifier  
6. **UI Screen** → 4 estados + lifecycle completo

### **Padrões Arquiteturais Obrigatórios**
- ✅ **Command Pattern**: Gerenciamento de estados assíncronos
- ✅ **Repository Pattern**: Abstração de dados
- ✅ **Result Pattern**: Tratamento de erros tipado
- ✅ **Observer Pattern**: Reatividade com ChangeNotifier

### **Informações Obrigatórias no Prompt**
```
**INFORMAÇÕES OBRIGATÓRIAS:**
- **Domain Model Path**: /lib/domain/models/{nome}.dart
- **Tela Nome**: {nome}_screen
- **Componente React**: path/para/Component.tsx
```

**🚀 Esta arquitetura garante código limpo, testável e mantível!**