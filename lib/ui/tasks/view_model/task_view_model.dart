// import 'package:flutter/foundation.dart';
// import '../../../domain/models/task.dart';
// import '../../../data/repositories/task_repository.dart';
// import 'task_commands.dart';

// /// ViewModel para gerenciar estado e lógica da lista de tarefas
// /// 
// /// Usa ChangeNotifier para notificar a UI sobre mudanças de estado.
// /// Implementa o padrão Command oficial do Flutter para operações assíncronas.
// class TaskViewModel extends ChangeNotifier {
//   final TaskRepository _repository;
  
//   List<Task> _tasks = [];
//   bool _isLoading = false;
//   String? _error;

//   // Commands para operações CRUD
//   late final Command1<Task, CreateTaskData> createTaskCommand;
//   late final Command1<Task, ({String id, UpdateTaskData data})> updateTaskCommand;
//   late final Command1<void, String> deleteTaskCommand;
//   late final Command1<Task, String> completeTaskCommand;
//   late final Command1<Task, String> uncompleteTaskCommand;
//   late final Command0<List<Task>> loadTasksCommand;

//   TaskViewModel(this._repository) {
//     _initializeCommands();
//     _setupCommandListeners();
//   }

//   // Getters para acesso ao estado
//   List<Task> get tasks => List.unmodifiable(_tasks);
//   bool get isLoading => _isLoading;
//   String? get error => _error;
  
//   // Getters derivados
//   List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
//   List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
//   int get totalTasks => _tasks.length;
//   int get completedCount => completedTasks.length;
//   int get pendingCount => pendingTasks.length;

//   /// Inicializa todos os comandos
//   void _initializeCommands() {
//     // Comando para carregar tarefas
//     loadTasksCommand = Command0<List<Task>>(() async {
//       return await _repository.getTasks();
//     });

//     // Comando para criar tarefa
//     createTaskCommand = Command1<Task, CreateTaskData>((data) async {
//       final result = await _repository.createTask(data);
//       if (result.isSuccess) {
//         // Recarrega as tarefas após criar
//         await loadTasksCommand.execute();
//       }
//       return result;
//     });

//     // Comando para atualizar tarefa
//     updateTaskCommand = Command1<Task, ({String id, UpdateTaskData data})>((params) async {
//       final result = await _repository.updateTask(params.id, params.data);
//       if (result.isSuccess) {
//         // Recarrega as tarefas após atualizar
//         await loadTasksCommand.execute();
//       }
//       return result;
//     });

//     // Comando para deletar tarefa
//     deleteTaskCommand = Command1<void, String>((id) async {
//       final result = await _repository.deleteTask(id);
//       if (result.isSuccess) {
//         // Recarrega as tarefas após deletar
//         await loadTasksCommand.execute();
//       }
//       return result;
//     });

//     // Comando para completar tarefa
//     completeTaskCommand = Command1<Task, String>((id) async {
//       final updateData = UpdateTaskData(isCompleted: true);
//       final result = await _repository.updateTask(id, updateData);
//       if (result.isSuccess) {
//         // Recarrega as tarefas após completar
//         await loadTasksCommand.execute();
//       }
//       return result;
//     });

//     // Comando para descompletar tarefa
//     uncompleteTaskCommand = Command1<Task, String>((id) async {
//       final updateData = UpdateTaskData(isCompleted: false);
//       final result = await _repository.updateTask(id, updateData);
//       if (result.isSuccess) {
//         // Recarrega as tarefas após descompletar
//         await loadTasksCommand.execute();
//       }
//       return result;
//     });
//   }

//   /// Configura listeners para os comandos
//   void _setupCommandListeners() {
//     // Listener para loadTasksCommand
//     loadTasksCommand.addListener(() {
//       _setLoading(loadTasksCommand.running);
      
//       final result = loadTasksCommand.result;
//       if (result != null) {
//         result.when(
//           success: (tasks) {
//             _setTasks(tasks);
//             _setError(null);
//           },
//           failure: (error) => _setError(error),
//         );
//       }
//     });

//     // Listeners para comandos que mostram erros
//     _addErrorListener(createTaskCommand);
//     _addErrorListener(updateTaskCommand);
//     _addErrorListener(deleteTaskCommand);
//     _addErrorListener(completeTaskCommand);
//     _addErrorListener(uncompleteTaskCommand);
//   }

//   /// Adiciona listener de erro para um comando
//   void _addErrorListener(Command command) {
//     command.addListener(() {
//       final result = command.result;
//       if (result != null && result.isFailure) {
//         result.when(
//           success: (_) {},
//           failure: (error) => _setError(error),
//         );
//       }
//     });
//   }

//   /// Carrega todas as tarefas
//   Future<void> loadTasks() async {
//     await loadTasksCommand.execute();
//   }

//   /// Cria uma nova tarefa
//   Future<void> createTask(CreateTaskData data) async {
//     await createTaskCommand.execute(data);
//   }

//   /// Atualiza uma tarefa existente
//   Future<void> updateTask(String id, UpdateTaskData data) async {
//     await updateTaskCommand.execute((id: id, data: data));
//   }

//   /// Exclui uma tarefa
//   Future<void> deleteTask(String id) async {
//     await deleteTaskCommand.execute(id);
//   }

//   /// Marca uma tarefa como concluída
//   Future<void> completeTask(String id) async {
//     await completeTaskCommand.execute(id);
//   }

//   /// Marca uma tarefa como não concluída
//   Future<void> uncompleteTask(String id) async {
//     await uncompleteTaskCommand.execute(id);
//   }

//   /// Alterna o status de conclusão de uma tarefa
//   Future<void> toggleTaskCompletion(String id) async {
//     final task = _tasks.firstWhere((t) => t.id == id);
    
//     if (task.isCompleted) {
//       await uncompleteTask(id);
//     } else {
//       await completeTask(id);
//     }
//   }

//   /// Limpa o erro atual
//   void clearError() {
//     if (_error != null) {
//       _setError(null);
//     }
//   }

//   /// Busca uma tarefa por ID
//   Task? getTaskById(String id) {
//     try {
//       return _tasks.firstWhere((task) => task.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Filtra tarefas por status
//   List<Task> getTasksByStatus(bool isCompleted) {
//     return _tasks.where((task) => task.isCompleted == isCompleted).toList();
//   }

//   // Métodos privados para gerenciar estado

//   void _setTasks(List<Task> tasks) {
//     _tasks = tasks;
//     notifyListeners();
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String? error) {
//     _error = error;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     // Dispose dos comandos
//     loadTasksCommand.dispose();
//     createTaskCommand.dispose();
//     updateTaskCommand.dispose();
//     deleteTaskCommand.dispose();
//     completeTaskCommand.dispose();
//     uncompleteTaskCommand.dispose();
    
//     super.dispose();
//   }
// }
