import 'package:flutter_test/flutter_test.dart';
import 'package:mastering_tests/data/repositories/task_repository.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';
import 'package:mastering_tests/ui/dashboard/viewmodel/task_viewmodel.dart';
import 'package:mastering_tests/utils/result.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/test_helpers.dart';


class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  setupTestHelpers();
  
  late TaskViewmodel viewModel;
  late MockTaskRepository mockRepository;
  
  // Dados para testes
  final testTask = Task(
    id: 'test-id-1',
    title: 'Test Task',
    description: 'Test Description',
    isCompleted: false,
    createdAt: DateTime(2025, 9, 13),
  );
  
  final testTasks = [
    testTask,
    Task(
      id: 'test-id-2',
      title: 'Test Task 2',
      description: 'Test Description 2',
      isCompleted: true,
      createdAt: DateTime(2025, 9, 12),
      completedAt: DateTime(2025, 9, 13),
    ),
  ];
  
  final testException = UnknownErrorException();

  setUpAll(() {
    // Register fallback values for Task to avoid issues with mocktail. When using any() with custom classes,
    // a fallback value must be provided.
    registerFallbackValue(
      Task(
        id: 'fallback-id',
        title: 'Fallback Task',
        description: 'Fallback Description',
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
    );
  });
  
  setUp(() {
    mockRepository = MockTaskRepository();
    
    //Configure default behaviors to prevent null returns and decrease boilerplate - this can be overridden
    //in individual tests as needed. Once we create the viewModel, it calls fetchTasks automatically.
     when(() => mockRepository.getTasks())
      .thenAnswer((_) async => Result.ok([]));

    viewModel = TaskViewmodel(repository: mockRepository);
  });
  
  group('TaskViewModel', () {
    group('initialization', () {
      test('should initialize all commands on creation', () {
        // Assert
        expect(viewModel.fetchTasks, isNotNull);
        expect(viewModel.createTask, isNotNull);
        expect(viewModel.updateTask, isNotNull);
        expect(viewModel.deleteTask, isNotNull);
      });
      
      test('should auto-execute fetchTasks on initialization', () {
        // Assert - O viewModel do setUp já executou fetchTasks automaticamente
        verify(() => mockRepository.getTasks()).called(1);
        expect(viewModel.fetchTasks.running, isFalse);
      });
    });
    
    group('fetchTasks', () {
      test('should return tasks on success', () async {
        // Arrange
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => Result.ok(testTasks));
        
        // Act
        await viewModel.fetchTasks.execute();
        
        // Assert
        expect(viewModel.fetchTasks.completed, isTrue);
        expect(viewModel.fetchTasks.error, isFalse);
        expect(viewModel.fetchTasks.value, equals(testTasks));
      });
      
      test('should handle error when fetching tasks fails', () async {
        // Arrange
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => Result.error(testException));
        
        // Act
        await viewModel.fetchTasks.execute();
        
        // Assert
        expect(viewModel.fetchTasks.completed, isFalse);
        expect(viewModel.fetchTasks.error, isTrue);
        expect(viewModel.fetchTasks.exception, equals(testException));
        expect(viewModel.fetchTasks.value, isNull);
      });
      
      test('should set running state correctly during execution', () async {
        // Arrange
        when(() => mockRepository.getTasks()).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return Result.ok(testTasks);
        });
        
        // Act
        final future = viewModel.fetchTasks.execute();
        
        // Assert - During execution
        expect(viewModel.fetchTasks.running, isTrue);
        
        // Wait for completion
        await future;
        
        // Assert - After completion
        expect(viewModel.fetchTasks.running, isFalse);
        expect(viewModel.fetchTasks.completed, isTrue);
      });
    });
    
    group('createTask', () {
      test('should create task successfully', () async {
        // Arrange
        when(() => mockRepository.createTask(task: testTask))
            .thenAnswer((_) async => const Result.ok(null));
        
        // Act
        await viewModel.createTask.execute(testTask);
        
        // Assert
        verify(() => mockRepository.createTask(task: testTask)).called(1);
        expect(viewModel.createTask.completed, isTrue);
        expect(viewModel.createTask.error, isFalse);
      });
      
      test('should handle error when creating task fails', () async {
        // Arrange
        when(() => mockRepository.createTask(task: testTask))
            .thenAnswer((_) async => Result.error(testException));
        
        // Act
        await viewModel.createTask.execute(testTask);
        
        // Assert
        verify(() => mockRepository.createTask(task: testTask)).called(1);
        expect(viewModel.createTask.completed, isFalse);
        expect(viewModel.createTask.error, isTrue);
        expect(viewModel.createTask.exception, equals(testException));
      });
      
      test('should set running state correctly during execution', () async {
        // Arrange
        when(() => mockRepository.createTask(task: testTask)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return const Result.ok(null);
        });
        
        // Act
        final future = viewModel.createTask.execute(testTask);
        
        // Assert - During execution
        expect(viewModel.createTask.running, isTrue);
        
        // Wait for completion
        await future;
        
        // Assert - After completion
        expect(viewModel.createTask.running, isFalse);
        expect(viewModel.createTask.completed, isTrue);
      });
    });
    
    group('updateTask', () {
      test('should update task successfully', () async {
        // Arrange
        when(() => mockRepository.updateTask(task: testTask))
            .thenAnswer((_) async => const Result.ok(null));
        
        // Act
        await viewModel.updateTask.execute(testTask);
        
        // Assert
        verify(() => mockRepository.updateTask(task: testTask)).called(1);
        expect(viewModel.updateTask.completed, isTrue);
        expect(viewModel.updateTask.error, isFalse);
      });
      
      test('should handle error when updating task fails', () async {
        // Arrange
        when(() => mockRepository.updateTask(task: testTask))
            .thenAnswer((_) async => Result.error(testException));
        
        // Act
        await viewModel.updateTask.execute(testTask);
        
        // Assert
        verify(() => mockRepository.updateTask(task: testTask)).called(1);
        expect(viewModel.updateTask.completed, isFalse);
        expect(viewModel.updateTask.error, isTrue);
        expect(viewModel.updateTask.exception, equals(testException));
      });
      
      test('should set running state correctly during execution', () async {
        // Arrange
        when(() => mockRepository.updateTask(task: testTask)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return const Result.ok(null);
        });
        
        // Act
        final future = viewModel.updateTask.execute(testTask);
        
        // Assert - During execution
        expect(viewModel.updateTask.running, isTrue);
        
        // Wait for completion
        await future;
        
        // Assert - After completion
        expect(viewModel.updateTask.running, isFalse);
        expect(viewModel.updateTask.completed, isTrue);
      });
    });
    
    group('deleteTask', () {
      test('should delete task successfully', () async {
        // Arrange
        const taskId = 'test-id-1';
        when(() => mockRepository.deleteTask(id: taskId))
            .thenAnswer((_) async => const Result.ok(null));
        
        // Act
        await viewModel.deleteTask.execute(taskId);
        
        // Assert
        verify(() => mockRepository.deleteTask(id: taskId)).called(1);
        expect(viewModel.deleteTask.completed, isTrue);
        expect(viewModel.deleteTask.error, isFalse);
      });
      
      test('should handle error when deleting task fails', () async {
        // Arrange
        const taskId = 'test-id-1';
        when(() => mockRepository.deleteTask(id: taskId))
            .thenAnswer((_) async => Result.error(testException));
        
        // Act
        await viewModel.deleteTask.execute(taskId);
        
        // Assert
        verify(() => mockRepository.deleteTask(id: taskId)).called(1);
        expect(viewModel.deleteTask.completed, isFalse);
        expect(viewModel.deleteTask.error, isTrue);
        expect(viewModel.deleteTask.exception, equals(testException));
      });
      
      test('should set running state correctly during execution', () async {
        // Arrange
        const taskId = 'test-id-1';
        when(() => mockRepository.deleteTask(id: taskId)).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 10));
          return const Result.ok(null);
        });
        
        // Act
        final future = viewModel.deleteTask.execute(taskId);
        
        // Assert - During execution
        expect(viewModel.deleteTask.running, isTrue);
        
        // Wait for completion
        await future;
        
        // Assert - After completion
        expect(viewModel.deleteTask.running, isFalse);
        expect(viewModel.deleteTask.completed, isTrue);
      });
    });
    
    group('command state management', () {
      test('clearResult should reset command state', () async {
        // Arrange
        when(() => mockRepository.getTasks())
            .thenAnswer((_) async => Result.ok(testTasks));
        await viewModel.fetchTasks.execute();
        
        // Act
        viewModel.fetchTasks.clearResult();
        
        // Assert
        expect(viewModel.fetchTasks.result, isNull);
        expect(viewModel.fetchTasks.completed, isFalse);
        expect(viewModel.fetchTasks.error, isFalse);
      });
    });
  });
}
