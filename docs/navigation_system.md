# Sistema de Navegação GoRouter - TODO App

Este documento explica como o sistema de navegação está estruturado no aplicativo TODO usando GoRouter.

## Rotas Disponíveis

### Autenticação
- **`/`** - Tela inicial (DashboardScreen)
- **`/sign-in`** - Tela de login (LoginScreen)
- **`/sign-up`** - Tela de cadastro (SignUpScreen)

### Gerenciamento de Tarefas
- **`/create-task`** - Criar nova tarefa (CreateTaskScreen)
- **`/edit-task/:taskId`** - Editar tarefa existente (EditTaskScreen)
- **`/view-task/:taskId`** - Visualizar detalhes da tarefa (ViewTaskScreen)
- **`/task-detail/:taskId`** - Tela moderna de detalhes (TaskDetailScreen)

## Como Usar a Navegação

### Extensões de Navegação

O arquivo `navigation_extensions.dart` fornece métodos convenientes para navegação:

```dart
import 'package:mastering_tests/routing/navigation_extensions.dart';

// Navegação básica
context.goToHome();
context.goToSignIn();
context.goToSignUp();
context.goToCreateTask();

// Navegação com dados
context.goToEditTask(taskId, taskData);
context.goToViewTask(taskId, taskData);
context.goToTaskDetail(taskId, domainTask, viewModel);

// Push navigation (mantém a pilha)
context.pushCreateTask();
context.pushEditTask(taskId, taskData);
```

### Exemplo de Uso no DashboardScreen

```dart
// Botão para criar nova tarefa
ElevatedButton(
  onPressed: () => context.goToCreateTask(),
  child: Text('Create New Task'),
)

// Card de tarefa para visualizar detalhes
GestureDetector(
  onTap: () {
    final taskMap = TaskNavigationHelper.taskToMap(domainTask);
    context.goToViewTask(task.id, taskMap);
  },
  child: TaskCard(...),
)
```

### Exemplo de Uso no ViewTaskScreen

```dart
// Botão para editar tarefa
ElevatedButton(
  onPressed: () => context.goToEditTask(widget.task['id'], widget.task),
  child: Text('Edit Task'),
)
```

## Conversão entre Formatos de Task

O `TaskNavigationHelper` facilita a conversão entre diferentes formatos:

```dart
// Converter Task domain para Map (para telas antigas)
final taskMap = TaskNavigationHelper.taskToMap(domainTask);

// Converter Map para Task domain
final domainTask = TaskNavigationHelper.mapToTask(taskMap);
```

## Passagem de Dados

### Para Telas Antigas (Map<String, dynamic>)
```dart
context.goToEditTask(taskId, {
  'id': task.id,
  'title': task.title,
  'description': task.description,
  'completed': task.completed,
  // ... outros campos
});
```

### Para TaskDetailScreen (Task domain + ViewModel)
```dart
context.goToTaskDetail(taskId, domainTask, viewModel);
```

## Tratamento de Erros

O router inclui tratamento de erros automático:
- Páginas não encontradas são redirecionadas para uma tela de erro
- Dados inválidos redirecionam para home
- Botão "Go to Home" sempre disponível na tela de erro

## Integração com Telas Existentes

### DashboardScreen
- ✅ Navegação para CreateTaskScreen
- ✅ Navegação para ViewTaskScreen ao tocar nos cards
- ✅ Todas as ações conectadas

### CreateTaskScreen
- ✅ Navegação de volta para home após criar tarefa
- ✅ Botão de fechar usa Navigator.pop (mantido para UX)

### ViewTaskScreen
- ✅ Navegação para EditTaskScreen
- ✅ Todas as ações conectadas

### EditTaskScreen
- ✅ Navegação de volta para home após editar
- ✅ Confirmação de exclusão mantida

### TaskDetailScreen (Nova)
- ✅ Totalmente integrada com domain models
- ✅ Recebe Task domain + ViewModel
- ✅ Interface moderna Material Design 3

## Fluxo de Navegação Recomendado

1. **Dashboard → Create Task**: `context.goToCreateTask()`
2. **Dashboard → View Task**: `context.goToViewTask(id, data)`
3. **View Task → Edit Task**: `context.goToEditTask(id, data)`
4. **Edit/Create → Dashboard**: `context.goToHome()`
5. **Anywhere → TaskDetail**: `context.goToTaskDetail(id, task, viewModel)`

## Benefícios

1. **Type Safety**: Extensões garantem parâmetros corretos
2. **Consistency**: Todas as telas usam o mesmo padrão
3. **Deep Linking**: URLs funcionais para todas as telas
4. **Error Handling**: Tratamento robusto de erros
5. **Data Conversion**: Conversão automática entre formatos
6. **Backward Compatibility**: Telas antigas continuam funcionando

## Próximos Passos

1. **Integração com Provider**: Passar ViewModels através do contexto
2. **Autenticação**: Implementar guards de autenticação
3. **Animações**: Adicionar transições customizadas
4. **Deep Linking**: Configurar URLs amigáveis
5. **Estado Global**: Sincronizar estado entre telas
