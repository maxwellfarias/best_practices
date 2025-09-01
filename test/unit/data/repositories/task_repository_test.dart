import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:mastering_tests/data/repositories/supabase_task_repository.dart';
import 'package:mastering_tests/data/services/api/api_service.dart';
import 'package:mastering_tests/data/models/task_api_model.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/utils/result.dart';

// Mocks
class MockTaskApiService extends Mock implements ApiClient {}

void main() {
  group('SupabaseTaskRepository', () {
    late SupabaseTaskRepository repository;
    late MockTaskApiService mockApiService;

    setUp(() {
      mockApiService = MockTaskApiService();
      repository = SupabaseTaskRepository(mockApiService);
    });

    tearDown(() {
      repository.dispose();
    });

    setUpAll(() {
      // Register fallback values
      registerFallbackValue(CreateTaskData(title: '', description: ''));
      registerFallbackValue(UpdateTaskData());
    });

    group('getTasks', () {
      test('should return success result with tasks when service call is successful', () async {
        // Arrange
        final apiTasks = [
          TaskApiModel(
            id: '1',
            title: 'Task 1',
            description: 'Description 1',
            isCompleted: false,
            createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
          ),
          TaskApiModel(
            id: '2',
            title: 'Task 2',
            description: 'Description 2',
            isCompleted: true,
            createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
            completedAt: DateTime.parse('2023-01-02T00:00:00Z'),
          ),
        ];
        
        when(() => mockApiService.getTasks())
          .thenAnswer((_) async => apiTasks);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (tasks) {
            expect(tasks, hasLength(2));
            expect(tasks.first.id, '1');
            expect(tasks.first.title, 'Task 1');
            expect(tasks.first.isCompleted, false);
            expect(tasks.last.id, '2');
            expect(tasks.last.isCompleted, true);
            expect(tasks.last.completedAt, isNotNull);
          },
          failure: (_) => fail('Should not be failure'),
        );
        
        verify(() => mockApiService.getTasks()).called(1);
      });

      test('should return failure result when service throws DioException', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          message: 'Network error',
          type: DioExceptionType.connectionError,
        );
        
        when(() => mockApiService.getTasks()).thenThrow(dioException);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) {
            expect(error, contains('Erro de conexão'));
            expect(error, contains('Verifique sua internet'));
          },
        );
        
        verify(() => mockApiService.getTasks()).called(1);
      });

      test('should return failure result with timeout error message', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          message: 'Timeout',
          type: DioExceptionType.connectionTimeout,
        );
        
        when(() => mockApiService.getTasks()).thenThrow(dioException);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) {
            expect(error, contains('Tempo limite'));
            expect(error, contains('conexão'));
          },
        );
      });

      test('should return failure result with HTTP error message', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/tasks'),
          ),
        );
        
        when(() => mockApiService.getTasks()).thenThrow(dioException);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) {
            expect(error, contains('Tarefa não encontrada'));
          },
        );
      });

      test('should return failure result for unexpected error', () async {
        // Arrange
        when(() => mockApiService.getTasks())
          .thenThrow(Exception('Unexpected error'));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) {
            expect(error, contains('Erro inesperado'));
            expect(error, contains('Unexpected error'));
          },
        );
      });

      test('should update task stream when successful', () async {
        // Arrange
        final apiTasks = [
          TaskApiModel(
            id: '1',
            title: 'Task 1',
            description: 'Description 1',
            isCompleted: false,
            createdAt: DateTime.now(),
          ),
        ];
        
        when(() => mockApiService.getTasks())
          .thenAnswer((_) async => apiTasks);

        final streamTasks = <List<Task>>[];
        repository.taskStream.listen(streamTasks.add);

        // Act
        await repository.getTasks();

        // Wait for stream to emit
        await Future.delayed(Duration.zero);

        // Assert
        expect(streamTasks, hasLength(1));
        expect(streamTasks.first, hasLength(1));
        expect(streamTasks.first.first.id, '1');
      });
    });

    group('getTask', () {
      test('should return success result with task when service call is successful', () async {
        // Arrange
        const taskId = '1';
        final apiTask = TaskApiModel(
          id: '1',
          title: 'Single Task',
          description: 'Single Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );
        
        when(() => mockApiService.getTask(taskId))
          .thenAnswer((_) async => apiTask);

        // Act
        final result = await repository.getTask(taskId);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (task) {
            expect(task.id, '1');
            expect(task.title, 'Single Task');
            expect(task.description, 'Single Description');
            expect(task.isCompleted, false);
          },
          failure: (_) => fail('Should not be failure'),
        );
        
        verify(() => mockApiService.getTask(taskId)).called(1);
      });

      test('should return failure result when service throws exception', () async {
        // Arrange
        const taskId = 'nonexistent';
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks/$taskId'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/tasks/$taskId'),
          ),
        );
        
        when(() => mockApiService.getTask(taskId)).thenThrow(dioException);

        // Act
        final result = await repository.getTask(taskId);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) => expect(error, contains('Tarefa não encontrada')),
        );
        
        verify(() => mockApiService.getTask(taskId)).called(1);
      });
    });

    group('createTask', () {
      test('should return success result with created task', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        final apiTask = TaskApiModel(
          id: '1',
          title: 'New Task',
          description: 'New Description',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        
        when(() => mockApiService.createTask(createData))
          .thenAnswer((_) async => apiTask);
        
        // Mock for stream refresh
        when(() => mockApiService.getTasks())
          .thenAnswer((_) async => [apiTask]);

        // Act
        final result = await repository.createTask(createData);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (task) {
            expect(task.title, 'New Task');
            expect(task.description, 'New Description');
            expect(task.isCompleted, false);
          },
          failure: (_) => fail('Should not be failure'),
        );
        
        verify(() => mockApiService.createTask(createData)).called(1);
        verify(() => mockApiService.getTasks()).called(1); // Stream refresh
      });

      test('should return failure result when creation fails', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 422,
            requestOptions: RequestOptions(path: '/tasks'),
          ),
        );
        
        when(() => mockApiService.createTask(createData))
          .thenThrow(dioException);

        // Act
        final result = await repository.createTask(createData);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) => expect(error, contains('Dados inválidos')),
        );
        
        verify(() => mockApiService.createTask(createData)).called(1);
        verifyNever(() => mockApiService.getTasks()); // No refresh on failure
      });
    });

    group('updateTask', () {
      test('should return success result with updated task', () async {
        // Arrange
        const taskId = '1';
        final updateData = UpdateTaskData(
          title: 'Updated Task',
          isCompleted: true,
        );
        
        final apiTask = TaskApiModel(
          id: '1',
          title: 'Updated Task',
          description: 'Original Description',
          isCompleted: true,
          createdAt: DateTime.now(),
          completedAt: DateTime.now(),
        );
        
        when(() => mockApiService.updateTask(taskId, updateData))
          .thenAnswer((_) async => apiTask);
        
        // Mock for stream refresh
        when(() => mockApiService.getTasks())
          .thenAnswer((_) async => [apiTask]);

        // Act
        final result = await repository.updateTask(taskId, updateData);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (task) {
            expect(task.id, '1');
            expect(task.title, 'Updated Task');
            expect(task.isCompleted, true);
            expect(task.completedAt, isNotNull);
          },
          failure: (_) => fail('Should not be failure'),
        );
        
        verify(() => mockApiService.updateTask(taskId, updateData)).called(1);
        verify(() => mockApiService.getTasks()).called(1); // Stream refresh
      });
    });

    group('deleteTask', () {
      test('should return success result when deletion is successful', () async {
        // Arrange
        const taskId = '1';
        
        when(() => mockApiService.deleteTask(taskId))
          .thenAnswer((_) async {});
        
        // Mock for stream refresh
        when(() => mockApiService.getTasks())
          .thenAnswer((_) async => []);

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        expect(result.isSuccess, true);
        result.when(
          success: (_) {
            // Success callback called, deletion was successful
          },
          failure: (_) => fail('Should not be failure'),
        );
        
        verify(() => mockApiService.deleteTask(taskId)).called(1);
        verify(() => mockApiService.getTasks()).called(1); // Stream refresh
      });

      test('should return failure result when deletion fails', () async {
        // Arrange
        const taskId = 'nonexistent';
        
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks/$taskId'),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/tasks/$taskId'),
          ),
        );
        
        when(() => mockApiService.deleteTask(taskId))
          .thenThrow(dioException);

        // Act
        final result = await repository.deleteTask(taskId);

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) => expect(error, contains('Tarefa não encontrada')),
        );
        
        verify(() => mockApiService.deleteTask(taskId)).called(1);
        verifyNever(() => mockApiService.getTasks()); // No refresh on failure
      });
    });

    group('taskStream', () {
      test('should emit error when stream refresh fails', () async {
        // Arrange
        final createData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        final apiTask = TaskApiModel(
          id: '1',
          title: 'New Task',
          description: 'New Description',
          isCompleted: false,
          createdAt: DateTime.now(),
        );
        
        when(() => mockApiService.createTask(createData))
          .thenAnswer((_) async => apiTask);
        
        // Mock stream refresh to fail
        when(() => mockApiService.getTasks())
          .thenThrow(Exception('Stream refresh failed'));

        final streamErrors = <String>[];
        repository.taskStream.listen(
          (_) {},
          onError: (error) => streamErrors.add(error.toString()),
        );

        // Act
        await repository.createTask(createData);

        // Wait for stream to emit error
        await Future.delayed(Duration.zero);

        // Assert
        expect(streamErrors, hasLength(1));
        expect(streamErrors.first, contains('Stream refresh failed'));
      });
    });

    group('error handling edge cases', () {
      test('should handle all HTTP status codes correctly', () async {
        final testCases = [
          (400, 'Dados inválidos fornecidos'),
          (401, 'Não autorizado'),
          (403, 'Acesso negado'),
          (404, 'Tarefa não encontrada'),
          (422, 'Dados inválidos ou incompletos'),
          (500, 'Erro interno do servidor'),
          (502, 'Erro no servidor (502)'),
        ];

        for (final (statusCode, expectedMessage) in testCases) {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/tasks'),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: statusCode,
              requestOptions: RequestOptions(path: '/tasks'),
            ),
          );
          
          when(() => mockApiService.getTasks()).thenThrow(dioException);

          // Act
          final result = await repository.getTasks();

          // Assert
          expect(result.isFailure, true);
          result.when(
            success: (_) => fail('Should not be success for status $statusCode'),
            failure: (error) => expect(error, contains(expectedMessage)),
          );
        }
      });

      test('should handle cancellation error', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/tasks'),
          type: DioExceptionType.cancel,
        );
        
        when(() => mockApiService.getTasks()).thenThrow(dioException);

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isFailure, true);
        result.when(
          success: (_) => fail('Should not be success'),
          failure: (error) => expect(error, contains('Operação cancelada')),
        );
      });
    });
  });
}
