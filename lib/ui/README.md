# Interface do Aplicativo de Tarefas

Este diretório contém a interface completa para o aplicativo de tarefas, com design moderno e clean.

## 📱 Telas Implementadas

### 1. HomeScreen (`lib/ui/home/widget/home_screen.dart`)

Tela principal do aplicativo que exibe a listagem de tarefas com as seguintes funcionalidades:

**✨ Características:**
- Design moderno com Material Design 3
- Lista separada por tarefas pendentes e concluídas
- Estatísticas visuais (contador de pendentes/concluídas)
- Pull-to-refresh para atualizar a lista
- Estados de loading, erro e lista vazia
- Animações e transições suaves

**🎯 Funcionalidades:**
- ✅ Marcar/desmarcar tarefas como concluídas
- 🗑️ Excluir tarefas com confirmação
- 👁️ Visualizar detalhes da tarefa (tap no item)
- 🔄 Atualizar lista manualmente
- ➕ Botão para criar nova tarefa (placeholder)

**🎨 Componentes Visuais:**
- AppBar com título e botão de refresh
- Card de estatísticas com gradiente
- Lista com separação por status
- FAB para nova tarefa
- SnackBars para feedback
- Diálogos de confirmação

### 2. TaskDetailScreen (`lib/ui/tasks/task_detail_screen.dart`)

Tela de detalhes da tarefa com informações completas:

**✨ Características:**
- Layout responsivo e organizado
- Cards informativos com elevação
- Gradientes baseados no status
- Ações rápidas na bottom bar

**🎯 Funcionalidades:**
- 📋 Visualização completa da tarefa
- ✏️ Editar tarefa (placeholder)
- ✅ Toggle status concluída/pendente
- 🗑️ Excluir tarefa
- 📅 Informações de data detalhadas

## 🧩 Widgets Auxiliares

### TaskItemWidget
Widget individual para cada item da lista com:
- Checkbox animado para status
- Conteúdo da tarefa com formatação
- Botão de exclusão
- Estados de loading
- Formatação inteligente de datas

### EmptyStateWidget
Estado vazio com:
- Ilustração amigável
- Mensagem motivacional
- Botão de ação para criar primeira tarefa

### LoadingWidget
Indicador de carregamento com:
- Spinner centralizado
- Texto descritivo
- Cores do tema

### TaskErrorWidget
Estado de erro com:
- Ícone visual de erro
- Mensagem de erro clara
- Botão de retry

## 🔌 Integração com ViewModel

As telas estão completamente integradas com o `TaskViewmodel`:

```dart
// Exemplo de uso
final viewModel = TaskViewmodel(repository: taskRepository);

return HomeScreen(viewModel: viewModel);
```

**Comandos Utilizados:**
- `fetchTasks` - Buscar lista de tarefas
- `createTask` - Criar nova tarefa
- `updateTask` - Atualizar tarefa (toggle status)
- `deleteTask` - Excluir tarefa

**Estados Monitorados:**
- `running` - Comando em execução
- `error` - Erro na execução
- `value` - Resultado do comando
- `errorMessage` - Mensagem de erro

## 🎨 Design System

**Cores:**
- Primary: Blue palette
- Success: Green palette  
- Error: Red palette
- Background: Grey[50]
- Cards: White com sombra sutil

**Tipografia:**
- Títulos: FontWeight.w600
- Conteúdo: FontWeight.normal
- Labels: FontWeight.w500
- Tamanhos responsivos

**Espaçamento:**
- Margins: 16px padrão
- Padding: 16-20px para cards
- Radius: 12-16px para bordas

**Elevação:**
- Cards: BoxShadow sutil
- FAB: Elevation 4
- AppBar: Elevation 0

## 📝 Como Usar

1. **Instanciar ViewModel:**
```dart
final viewModel = TaskViewmodel(repository: yourRepository);
```

2. **Usar HomeScreen:**
```dart
return HomeScreen(viewModel: viewModel);
```

3. **Navegação para Detalhes:**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TaskDetailScreen(
      task: task,
      viewModel: viewModel,
    ),
  ),
);
```

## 🧪 Testabilidade

Todos os widgets são:
- Stateless ou com estado bem definido
- Recebem dependências via construtor
- Callbacks para ações
- Fáceis de mockar em testes

## 🚀 Próximos Passos

- [ ] Implementar tela de criação/edição
- [ ] Adicionar animações de lista
- [ ] Implementar filtros e busca
- [ ] Adicionar temas claro/escuro
- [ ] Implementar notificações
- [ ] Adicionar gestos avançados (swipe actions)
