import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mastering_tests/ui/tasks/view_model/task_view_model.dart';
import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/utils/result.dart';

// Mocks
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  group('TaskViewModel', () {
    late TaskViewModel viewModel;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      viewModel = TaskViewModel(mockRepository);
    });

    tearDown(() {
      try {
        viewModel.dispose();
      } catch (_) {
        // Already disposed
      }
    });

    setUpAll(() {
      // Register fallback values
      registerFallbackValue(CreateTaskData(title: '', description: ''));
      registerFallbackValue(UpdateTaskData());
    });

    group('initial state', () {
      test('should have correct initial values', () {
        // Assert
        expect(viewModel.tasks, isEmpty);
        expect(viewModel.isLoading, false);
        expect(viewModel.error, null);
        expect(viewModel.totalTasks, 0);
        expect(viewModel.completedCount, 0);
        expect(viewModel.pendingCount, 0);
        expect(viewModel.completedTasks, isEmpty);
        expect(viewModel.pendingTasks, isEmpty);
      });
    });

    group('loadTasks', () {
      test('should emit loading states and load tasks successfully', () async {
        // Arrange
        final tasks = [
          Task(
            id: '1',
            title: 'Task 1',
            description: 'Description 1',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          Task(
            id: '2',
            title: 'Task 2',
            description: 'Description 2',
            isCompleted: true,
            createdAt: DateTime.now(),
            completedAt: DateTime.now(),
          ),
        ];
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success(tasks));

        // Track state changes
        final loadingStates = <bool>[];
        final taskStates = <List<Task>>[];
        final errorStates = <String?>[];

        viewModel.addListener(() {
          loadingStates.add(viewModel.isLoading);
          taskStates.add(List.from(viewModel.tasks));
          errorStates.add(viewModel.error);
        });

        // Act
        await viewModel.loadTasks();

        // Assert
        // The ViewModel notifies: loading=true, error=null, tasks=loaded, loading=false
        expect(loadingStates.first, true); // Started loading
        expect(loadingStates.last, false); // Finished loading
        expect(taskStates.last, tasks);
        expect(errorStates.last, null);
        expect(viewModel.totalTasks, 2);
        expect(viewModel.completedCount, 1);
        expect(viewModel.pendingCount, 1);
        
        verify(() => mockRepository.getTasks()).called(1);
      });

      test('should emit loading states and handle error', () async {
        // Arrange
        const errorMessage = 'Failed to load tasks';
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.failure(errorMessage));

        // Track state changes
        final loadingStates = <bool>[];
        final errorStates = <String?>[];

        viewModel.addListener(() {
          loadingStates.add(viewModel.isLoading);
          errorStates.add(viewModel.error);
        });

        // Act
        await viewModel.loadTasks();

        // Assert
        expect(loadingStates.first, true); // Started loading
        expect(loadingStates.last, false); // Finished loading
        expect(errorStates.last, errorMessage);
        expect(viewModel.tasks, isEmpty);
        expect(viewModel.totalTasks, 0);
        
        verify(() => mockRepository.getTasks()).called(1);
      });

      test('should clear previous error when loading starts', () async {
        // Arrange
        const errorMessage = 'Initial error';
        
        // First, cause an error
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.failure(errorMessage));
        
        await viewModel.loadTasks();
        expect(viewModel.error, errorMessage);

        // Now clear error and setup successful call
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([]));

        // Act - Load again (this should clear error)
        await viewModel.loadTasks();

        // Assert
        expect(viewModel.error, null);
      });
    });

    group('createTask', () {
      test('should create task and reload tasks on success', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        final createdTask = Task(
          id: '1',
          title: 'New Task',
          description: 'New Description',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.success(createdTask));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([createdTask]));

        // Act
        await viewModel.createTask(createData);

        // Assert
        expect(viewModel.tasks, [createdTask]);
        expect(viewModel.error, null);
        expect(viewModel.totalTasks, 1);
        expect(viewModel.pendingCount, 1);
        expect(viewModel.completedCount, 0);
        
        verify(() => mockRepository.createTask(createData)).called(1);
        verify(() => mockRepository.getTasks()).called(1); // Apenas reload
      });

      test('should set error when create task fails', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        const errorMessage = 'Failed to create task';
        
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.failure(errorMessage));

        // Act
        await viewModel.createTask(createData);

        // Assert
        expect(viewModel.error, errorMessage);
        expect(viewModel.tasks, isEmpty);
        expect(viewModel.totalTasks, 0);
        
        verify(() => mockRepository.createTask(createData)).called(1);
        verifyNever(() => mockRepository.getTasks());
      });
    });

    group('updateTask', () {
      test('should update task and reload tasks on success', () async {
        // Arrange
        const taskId = '1';
        final updateData = UpdateTaskData(
          title: 'Updated Task',
          isCompleted: true,
        );
        
        final updatedTask = Task(
          id: taskId,
          title: 'Updated Task',
          description: 'Description',
          isCompleted: true,
          createdAt: DateTime.now(),
          completedAt: DateTime.now(),
        );
        
        when(() => mockRepository.updateTask(taskId, updateData))
          .thenAnswer((_) async => Result.success(updatedTask));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([updatedTask]));

        // Act
        await viewModel.updateTask(taskId, updateData);

        // Assert
        expect(viewModel.tasks, [updatedTask]);
        expect(viewModel.error, null);
        expect(viewModel.totalTasks, 1);
        expect(viewModel.completedCount, 1);
        expect(viewModel.pendingCount, 0);
        
        verify(() => mockRepository.updateTask(taskId, updateData)).called(1);
        verify(() => mockRepository.getTasks()).called(1); // Apenas reload
      });

      test('should set error when update task fails', () async {
        // Arrange
        const taskId = '1';
        final updateData = UpdateTaskData(title: 'Updated Task');
        const errorMessage = 'Failed to update task';
        
        when(() => mockRepository.updateTask(taskId, updateData))
          .thenAnswer((_) async => Result.failure(errorMessage));

        // Act
        await viewModel.updateTask(taskId, updateData);

        // Assert
        expect(viewModel.error, errorMessage);
        expect(viewModel.tasks, isEmpty);
        
        verify(() => mockRepository.updateTask(taskId, updateData)).called(1);
        verifyNever(() => mockRepository.getTasks());
      });
    });

    group('deleteTask', () {
      test('should delete task and reload tasks on success', () async {
        // Arrange
        const taskId = '1';
        
        when(() => mockRepository.deleteTask(taskId))
          .thenAnswer((_) async => Result.success(null));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([]));

        // Act
        await viewModel.deleteTask(taskId);

        // Assert
        expect(viewModel.tasks, isEmpty);
        expect(viewModel.error, null);
        expect(viewModel.totalTasks, 0);
        
        verify(() => mockRepository.deleteTask(taskId)).called(1);
        verify(() => mockRepository.getTasks()).called(1); // Apenas reload
      });

      test('should set error when delete task fails', () async {
        // Arrange
        const taskId = '1';
        const errorMessage = 'Failed to delete task';
        
        when(() => mockRepository.deleteTask(taskId))
          .thenAnswer((_) async => Result.failure(errorMessage));

        // Act
        await viewModel.deleteTask(taskId);

        // Assert
        expect(viewModel.error, errorMessage);
        
        verify(() => mockRepository.deleteTask(taskId)).called(1);
        verifyNever(() => mockRepository.getTasks());
      });
    });

    group('completeTask', () {
      test('should complete task and reload tasks on success', () async {
        // Arrange
        const taskId = '1';
        
        final completedTask = Task(
          id: taskId,
          title: 'Task',
          description: 'Description',
          isCompleted: true,
          createdAt: DateTime.now(),
          completedAt: DateTime.now(),
        );
        
        when(() => mockRepository.updateTask(taskId, any()))
          .thenAnswer((_) async => Result.success(completedTask));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([completedTask]));

        // Act
        await viewModel.completeTask(taskId);

        // Assert
        expect(viewModel.tasks, [completedTask]);
        expect(viewModel.error, null);
        expect(viewModel.completedCount, 1);
        expect(viewModel.pendingCount, 0);
        
        // Verify correct update data was used
        final capturedUpdateData = verify(() => mockRepository.updateTask(
          taskId,
          captureAny(),
        )).captured.first as UpdateTaskData;
        
        expect(capturedUpdateData.isCompleted, true);
        verify(() => mockRepository.getTasks()).called(1); // Apenas reload
      });
    });

    group('uncompleteTask', () {
      test('should uncomplete task and reload tasks on success', () async {
        // Arrange
        const taskId = '1';
        
        final uncompletedTask = Task(
          id: taskId,
          title: 'Task',
          description: 'Description',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        
        when(() => mockRepository.updateTask(taskId, any()))
          .thenAnswer((_) async => Result.success(uncompletedTask));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([uncompletedTask]));

        // Act
        await viewModel.uncompleteTask(taskId);

        // Assert
        expect(viewModel.tasks, [uncompletedTask]);
        expect(viewModel.error, null);
        expect(viewModel.completedCount, 0);
        expect(viewModel.pendingCount, 1);
        
        // Verify correct update data was used
        final capturedUpdateData = verify(() => mockRepository.updateTask(
          taskId,
          captureAny(),
        )).captured.first as UpdateTaskData;
        
        expect(capturedUpdateData.isCompleted, false);
        verify(() => mockRepository.getTasks()).called(1); // Apenas reload
      });
    });

    group('toggleTaskCompletion', () {
      test('should complete task when currently incomplete', () async {
        // Arrange
        const taskId = '1';
        
        final incompleteTask = Task(
          id: taskId,
          title: 'Task',
          description: 'Description',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        
        final completedTask = incompleteTask.copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        
        // Set up initial state with incomplete task
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([incompleteTask]));
        
        await viewModel.loadTasks();
        
        // Set up completion
        when(() => mockRepository.updateTask(taskId, any()))
          .thenAnswer((_) async => Result.success(completedTask));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([completedTask]));

        // Act
        await viewModel.toggleTaskCompletion(taskId);

        // Assert
        final capturedUpdateData = verify(() => mockRepository.updateTask(
          taskId,
          captureAny(),
        )).captured.first as UpdateTaskData;
        
        expect(capturedUpdateData.isCompleted, true);
      });

      test('should uncomplete task when currently complete', () async {
        // Arrange
        const taskId = '1';
        
        final completedTask = Task(
          id: taskId,
          title: 'Task',
          description: 'Description',
          isCompleted: true,
          createdAt: DateTime.now(),
          completedAt: DateTime.now(),
        );
        
        final incompleteTask = completedTask.copyWith(
          isCompleted: false,
          completedAt: null,
        );
        
        // Set up initial state with completed task
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([completedTask]));
        
        await viewModel.loadTasks();
        
        // Set up uncompletion
        when(() => mockRepository.updateTask(taskId, any()))
          .thenAnswer((_) async => Result.success(incompleteTask));
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success([incompleteTask]));

        // Act
        await viewModel.toggleTaskCompletion(taskId);

        // Assert
        final capturedUpdateData = verify(() => mockRepository.updateTask(
          taskId,
          captureAny(),
        )).captured.first as UpdateTaskData;
        
        expect(capturedUpdateData.isCompleted, false);
      });
    });

    group('utility methods', () {
      test('should clear error correctly', () async {
        // Arrange - First set an error by causing a failure
        const errorMessage = 'Test error';
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.failure(errorMessage));
        
        await viewModel.loadTasks();
        expect(viewModel.error, errorMessage);
        
        // Act
        viewModel.clearError();

        // Assert
        expect(viewModel.error, null);
      });

      test('should get task by ID correctly', () async {
        // Arrange
        final tasks = [
          Task(
            id: '1',
            title: 'Task 1',
            description: 'Description 1',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          Task(
            id: '2',
            title: 'Task 2',
            description: 'Description 2',
            isCompleted: true,
            createdAt: DateTime.now(),
          ),
        ];
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success(tasks));
        
        await viewModel.loadTasks();

        // Act & Assert
        final task1 = viewModel.getTaskById('1');
        final task2 = viewModel.getTaskById('2');
        final nonExistentTask = viewModel.getTaskById('999');

        expect(task1, isNotNull);
        expect(task1!.title, 'Task 1');
        expect(task2, isNotNull);
        expect(task2!.title, 'Task 2');
        expect(nonExistentTask, null);
      });

      test('should get tasks by status correctly', () async {
        // Arrange
        final tasks = [
          Task(
            id: '1',
            title: 'Incomplete Task',
            description: 'Description',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          Task(
            id: '2',
            title: 'Complete Task',
            description: 'Description',
            isCompleted: true,
            createdAt: DateTime.now(),
            completedAt: DateTime.now(),
          ),
          Task(
            id: '3',
            title: 'Another Incomplete Task',
            description: 'Description',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success(tasks));
        
        await viewModel.loadTasks();

        // Act
        final completedTasks = viewModel.getTasksByStatus(true);
        final incompleteTasks = viewModel.getTasksByStatus(false);

        // Assert
        expect(completedTasks, hasLength(1));
        expect(completedTasks.first.title, 'Complete Task');
        
        expect(incompleteTasks, hasLength(2));
        expect(incompleteTasks.map((t) => t.title), contains('Incomplete Task'));
        expect(incompleteTasks.map((t) => t.title), contains('Another Incomplete Task'));
      });

      test('should provide correct derived state', () async {
        // Arrange
        final tasks = [
          Task(
            id: '1',
            title: 'Task 1',
            description: 'Description',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
          Task(
            id: '2',
            title: 'Task 2',
            description: 'Description',
            isCompleted: true,
            createdAt: DateTime.now(),
            completedAt: DateTime.now(),
          ),
          Task(
            id: '3',
            title: 'Task 3',
            description: 'Description',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success(tasks));
        
        await viewModel.loadTasks();

        // Assert derived state
        expect(viewModel.totalTasks, 3);
        expect(viewModel.completedCount, 1);
        expect(viewModel.pendingCount, 2);
        expect(viewModel.completedTasks, hasLength(1));
        expect(viewModel.pendingTasks, hasLength(2));
        expect(viewModel.completedTasks.first.isCompleted, true);
        expect(viewModel.pendingTasks.every((task) => !task.isCompleted), true);
      });
    });

    group('state notifications', () {
      test('should notify listeners when state changes', () async {
        // Arrange
        int notificationCount = 0;
        viewModel.addListener(() => notificationCount++);
        
        final tasks = [
          Task(
            id: '1',
            title: 'Task 1',
            description: 'Description',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];
        
        when(() => mockRepository.getTasks())
          .thenAnswer((_) async => Result.success(tasks));

        // Act
        await viewModel.loadTasks();

        // Assert
        // Should notify at least 3 times: loading=true, error=null, tasks=set, loading=false
        expect(notificationCount, greaterThanOrEqualTo(3));
      });

      test('should dispose without throwing', () {
        // Act & Assert - Dispose should not throw
        expect(() => viewModel.dispose(), returnsNormally);
        
        // Verify that the object is disposed (this would throw if used after dispose)
        expect(() => viewModel.addListener(() {}), throwsFlutterError);
      });
    });

    group('error scenarios', () {
      test('should handle multiple consecutive operations', () async {
        // Arrange
        final createData = CreateTaskData(title: 'Task', description: 'Desc');
        const taskId = '1';
        
        // Setup different responses for different calls
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.failure('Create failed'));
        
        when(() => mockRepository.deleteTask(taskId))
          .thenAnswer((_) async => Result.failure('Delete failed'));

        // Act
        await viewModel.createTask(createData);
        final firstError = viewModel.error;
        
        await viewModel.deleteTask(taskId);
        final secondError = viewModel.error;

        // Assert
        expect(firstError, 'Create failed');
        expect(secondError, 'Delete failed');
      });
    });
  });
}
