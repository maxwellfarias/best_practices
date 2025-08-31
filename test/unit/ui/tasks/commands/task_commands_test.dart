import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mastering_tests/ui/tasks/view_model/task_commands.dart';
import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/utils/result.dart';

// Mocks
class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  group('TaskCommands', () {
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
    });

    setUpAll(() {
      // Register fallback values
      registerFallbackValue(CreateTaskData(title: '', description: ''));
      registerFallbackValue(UpdateTaskData());
    });

    group('CreateTaskCommand', () {
      test('should execute successfully and call onSuccess', () async {
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

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = CreateTaskCommand(
          mockRepository,
          createData,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, true);
        expect(onErrorCalled, null);
        verify(() => mockRepository.createTask(createData)).called(1);
      });

      test('should execute with failure and call onError', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        const errorMessage = 'Failed to create task';
        
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.failure(errorMessage));

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = CreateTaskCommand(
          mockRepository,
          createData,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, false);
        expect(onErrorCalled, errorMessage);
        verify(() => mockRepository.createTask(createData)).called(1);
      });

      test('should execute without callbacks without throwing', () async {
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

        final command = CreateTaskCommand(mockRepository, createData);

        // Act & Assert - Should not throw
        await expectLater(command.execute(), completes);
        
        verify(() => mockRepository.createTask(createData)).called(1);
      });

      test('should execute with only onSuccess callback', () async {
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

        bool onSuccessCalled = false;

        final command = CreateTaskCommand(
          mockRepository,
          createData,
          onSuccess: () async => onSuccessCalled = true,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, true);
        verify(() => mockRepository.createTask(createData)).called(1);
      });

      test('should execute with only onError callback', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        const errorMessage = 'Failed to create task';
        
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.failure(errorMessage));

        String? onErrorCalled;

        final command = CreateTaskCommand(
          mockRepository,
          createData,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onErrorCalled, errorMessage);
        verify(() => mockRepository.createTask(createData)).called(1);
      });
    });

    group('UpdateTaskCommand', () {
      test('should execute successfully and call onSuccess', () async {
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

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = UpdateTaskCommand(
          mockRepository,
          taskId,
          updateData,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, true);
        expect(onErrorCalled, null);
        verify(() => mockRepository.updateTask(taskId, updateData)).called(1);
      });

      test('should execute with failure and call onError', () async {
        // Arrange
        const taskId = '1';
        final updateData = UpdateTaskData(title: 'Updated Task');
        const errorMessage = 'Failed to update task';
        
        when(() => mockRepository.updateTask(taskId, updateData))
          .thenAnswer((_) async => Result.failure(errorMessage));

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = UpdateTaskCommand(
          mockRepository,
          taskId,
          updateData,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, false);
        expect(onErrorCalled, errorMessage);
        verify(() => mockRepository.updateTask(taskId, updateData)).called(1);
      });
    });

    group('DeleteTaskCommand', () {
      test('should execute successfully and call onSuccess', () async {
        // Arrange
        const taskId = '1';
        
        when(() => mockRepository.deleteTask(taskId))
          .thenAnswer((_) async => Result.success(null));

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = DeleteTaskCommand(
          mockRepository,
          taskId,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, true);
        expect(onErrorCalled, null);
        verify(() => mockRepository.deleteTask(taskId)).called(1);
      });

      test('should execute with failure and call onError', () async {
        // Arrange
        const taskId = '1';
        const errorMessage = 'Failed to delete task';
        
        when(() => mockRepository.deleteTask(taskId))
          .thenAnswer((_) async => Result.failure(errorMessage));

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = DeleteTaskCommand(
          mockRepository,
          taskId,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, false);
        expect(onErrorCalled, errorMessage);
        verify(() => mockRepository.deleteTask(taskId)).called(1);
      });
    });

    group('CompleteTaskCommand', () {
      test('should execute successfully and call onSuccess', () async {
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

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = CompleteTaskCommand(
          mockRepository,
          taskId,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, true);
        expect(onErrorCalled, null);
        
        // Verify that update was called with correct data
        final capturedUpdateData = verify(() => mockRepository.updateTask(
          taskId,
          captureAny(),
        )).captured.first as UpdateTaskData;
        
        expect(capturedUpdateData.isCompleted, true);
      });

      test('should execute with failure and call onError', () async {
        // Arrange
        const taskId = '1';
        const errorMessage = 'Failed to complete task';
        
        when(() => mockRepository.updateTask(taskId, any()))
          .thenAnswer((_) async => Result.failure(errorMessage));

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = CompleteTaskCommand(
          mockRepository,
          taskId,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, false);
        expect(onErrorCalled, errorMessage);
      });
    });

    group('UncompleteTaskCommand', () {
      test('should execute successfully and call onSuccess', () async {
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

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = UncompleteTaskCommand(
          mockRepository,
          taskId,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, true);
        expect(onErrorCalled, null);
        
        // Verify that update was called with correct data
        final capturedUpdateData = verify(() => mockRepository.updateTask(
          taskId,
          captureAny(),
        )).captured.first as UpdateTaskData;
        
        expect(capturedUpdateData.isCompleted, false);
      });

      test('should execute with failure and call onError', () async {
        // Arrange
        const taskId = '1';
        const errorMessage = 'Failed to uncomplete task';
        
        when(() => mockRepository.updateTask(taskId, any()))
          .thenAnswer((_) async => Result.failure(errorMessage));

        bool onSuccessCalled = false;
        String? onErrorCalled;

        final command = UncompleteTaskCommand(
          mockRepository,
          taskId,
          onSuccess: () async => onSuccessCalled = true,
          onError: (error) => onErrorCalled = error,
        );

        // Act
        await command.execute();

        // Assert
        expect(onSuccessCalled, false);
        expect(onErrorCalled, errorMessage);
      });
    });

    group('Command integration', () {
      test('should handle multiple commands sequentially', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'Description',
        );
        
        final createdTask = Task(
          id: '1',
          title: 'New Task',
          description: 'Description',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        
        final completedTask = createdTask.copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.success(createdTask));
        
        when(() => mockRepository.updateTask('1', any()))
          .thenAnswer((_) async => Result.success(completedTask));

        int callbackCount = 0;

        final createCommand = CreateTaskCommand(
          mockRepository,
          createData,
          onSuccess: () async => callbackCount++,
        );
        
        final completeCommand = CompleteTaskCommand(
          mockRepository,
          '1',
          onSuccess: () async => callbackCount++,
        );

        // Act
        await createCommand.execute();
        await completeCommand.execute();

        // Assert
        expect(callbackCount, 2);
        verify(() => mockRepository.createTask(createData)).called(1);
        verify(() => mockRepository.updateTask('1', any())).called(1);
      });

      test('should handle error in command chain', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'Description',
        );
        
        const createError = 'Failed to create';
        const updateError = 'Failed to update';
        
        when(() => mockRepository.createTask(createData))
          .thenAnswer((_) async => Result.failure(createError));
        
        when(() => mockRepository.updateTask('1', any()))
          .thenAnswer((_) async => Result.failure(updateError));

        final errors = <String>[];

        final createCommand = CreateTaskCommand(
          mockRepository,
          createData,
          onError: (error) => errors.add(error),
        );
        
        final completeCommand = CompleteTaskCommand(
          mockRepository,
          '1',
          onError: (error) => errors.add(error),
        );

        // Act
        await createCommand.execute();
        await completeCommand.execute();

        // Assert
        expect(errors, hasLength(2));
        expect(errors.first, createError);
        expect(errors.last, updateError);
      });
    });
  });
}
