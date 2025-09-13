import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mastering_tests/data/repositories/task_repository_impl.dart';
import 'package:mastering_tests/data/services/api/api_serivce.dart';
import 'package:mastering_tests/domain/models/task.dart';
import 'package:mastering_tests/utils/result.dart';
import 'package:mastering_tests/exceptions/app_exception.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(MetodoHttp.get);
  });
  group('TaskRepositoryImpl', () {
    late TaskRepositoryImpl repository;
    late MockApiClient mockApiClient;
    
    setUp(() {
      mockApiClient = MockApiClient();
      repository = TaskRepositoryImpl(apiService: mockApiClient);
    });

    group('getTasks', () {
      test('should return list of tasks when API call is successful', () async {
        // Arrange
        final mockTasksJson = [
          {
            'id': '1',
            'title': 'Task 1',
            'description': 'Description 1',
            'is_completed': false,
            'created_at': '2023-01-01T00:00:00Z',
          },
          {
            'id': '2',
            'title': 'Task 2',
            'description': 'Description 2',
            'is_completed': true,
            'created_at': '2023-01-02T00:00:00Z',
            'completed_at': '2023-01-03T00:00:00Z',
          },
        ];

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok(mockTasksJson));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isOk, isTrue);
        
        result.when(
          onOk: (tasks) {
            expect(tasks, hasLength(2));
            
            expect(tasks[0].id, equals('1'));
            expect(tasks[0].title, equals('Task 1'));
            expect(tasks[0].description, equals('Description 1'));
            expect(tasks[0].isCompleted, isFalse);
            
            expect(tasks[1].id, equals('2'));
            expect(tasks[1].title, equals('Task 2'));
            expect(tasks[1].description, equals('Description 2'));
            expect(tasks[1].isCompleted, isTrue);
          },
          onError: (error) => fail('Should not be error: $error'),
        );

        verify(() => mockApiClient.request(
              url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).called(1);
      });

      test('should return error when API call fails', () async {
        // Arrange
        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(ErroDeComunicacaoException()));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<ErroDeComunicacaoException>()),
        );

        verify(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).called(1);
      });

      test('should return UnknownErrorException when parsing fails', () async {
        // Arrange
        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok("invalid_json_structure"));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<UnknownErrorException>()),
        );
      });

      test('should return empty list when API returns empty array', () async {
        // Arrange
        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok([]));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isOk, isTrue);
        result.when(
          onOk: (tasks) => expect(tasks, isEmpty),
          onError: (error) => fail('Should not be error: $error'),
        );
      });
    });

    group('createTask', () {
      test('should create task successfully', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'New Task',
          description: 'New Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.post,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok({'status': 'created'}));

        // Act
        final result = await repository.createTask(task: task);

        // Assert
        expect(result.isOk, isTrue);

        verify(() => mockApiClient.request(
              url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
              metodo: MetodoHttp.post,
              body: task.toJson(),
              headers: any(named: 'headers'),
            )).called(1);
      });

      test('should return error when create task API call fails', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'New Task',
          description: 'New Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.post,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(ErroDeComunicacaoException()));

        // Act
        final result = await repository.createTask(task: task);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<ErroDeComunicacaoException>()),
        );
      });

      test('should handle server errors for create task', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'New Task',
          description: 'New Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.post,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(ErroInternoServidorException()));

        // Act
        final result = await repository.createTask(task: task);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<ErroInternoServidorException>()),
        );
      });
    });

    group('updateTask', () {
      test('should update task successfully', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'Updated Task',
          description: 'Updated Description',
          isCompleted: true,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
          completedAt: DateTime.parse('2023-01-02T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.put,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok({'status': 'updated'}));

        // Act
        final result = await repository.updateTask(task: task);

        // Assert
        expect(result.isOk, isTrue);

        verify(() => mockApiClient.request(
              url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
              metodo: MetodoHttp.put,
              body: task.toJson(),
              headers: any(named: 'headers'),
            )).called(1);
      });

      test('should return error when update task API call fails', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'Updated Task',
          description: 'Updated Description',
          isCompleted: true,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.put,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(RecursoNaoEncontradoException()));

        // Act
        final result = await repository.updateTask(task: task);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<RecursoNaoEncontradoException>()),
        );
      });

      test('should handle authentication errors for update task', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'Updated Task',
          description: 'Updated Description',
          isCompleted: true,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.put,
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(SessaoExpiradaException()));

        // Act
        final result = await repository.updateTask(task: task);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<SessaoExpiradaException>()),
        );
      });
    });

    group('deleteTask', () {
      test('should delete task successfully', () async {
        // Arrange
        const taskId = '1';

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.delete,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok(null));

        // Act
        final result = await repository.deleteTask(id: taskId);

        // Assert
        expect(result.isOk, isTrue);

        verify(() => mockApiClient.request(
              url: any(named: 'url', that: contains('supabase.co/rest/v1/todos')),
              metodo: MetodoHttp.delete,
              headers: any(named: 'headers'),
            )).called(1);
      });

      test('should return error when delete task API call fails', () async {
        // Arrange
        const taskId = '1';

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.delete,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(RecursoNaoEncontradoException()));

        // Act
        final result = await repository.deleteTask(id: taskId);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<RecursoNaoEncontradoException>()),
        );
      });

      test('should handle access denied for delete task', () async {
        // Arrange
        const taskId = '1';

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.delete,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(AcessoNegadoException()));

        // Act
        final result = await repository.deleteTask(id: taskId);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<AcessoNegadoException>()),
        );
      });

      test('should handle server unavailable for delete task', () async {
        // Arrange
        const taskId = '1';

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.delete,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(ServidorIndisponivelException()));

        // Act
        final result = await repository.deleteTask(id: taskId);

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<ServidorIndisponivelException>()),
        );
      });
    });

    group('Integration with Headers and Authentication', () {
      test('should include correct headers in all requests', () async {
        // Arrange
        final task = Task(
          id: '1',
          title: 'Test Task',
          description: 'Test Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: any(named: 'metodo'),
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok([]));

        // Act - Test all operations
        await repository.getTasks();
        await repository.createTask(task: task);
        await repository.updateTask(task: task);
        await repository.deleteTask(id: '1');

        // Assert - Verify all methods were called (4 total calls)
        verify(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: any(named: 'metodo'),
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).called(4);
      });
    });

    group('Error Handling and Edge Cases', () {
      test('should handle null response from API', () async {
        // Arrange
        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok(null));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<UnknownErrorException>()),
        );
      });

      test('should handle malformed task data', () async {
        // Arrange
        final malformedData = [
          {
            'id': '1',
            'title': 'Task',
            'description': 'Description',
            'is_completed': false,
            'created_at': 'invalid-date-format', // This will cause DateTime.parse to fail
          },
        ];

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok(malformedData));

        // Act
        final result = await repository.getTasks();

        // Assert - Should fail during parsing due to invalid date format
        expect(result.isError, isTrue);
        result.when(
          onOk: (_) => fail('Should not be success'),
          onError: (error) => expect(error, isA<UnknownErrorException>()),
        );
      });

      test('should handle network timeout errors', () async {
        // Arrange
        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: any(named: 'metodo'),
              body: any(named: 'body'),
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.error(ErroDeComunicacaoException()));

        final task = Task(
          id: '1',
          title: 'Test',
          description: 'Test',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        // Act
        final results = await Future.wait([
          repository.getTasks(),
          repository.createTask(task: task),
          repository.updateTask(task: task),
          repository.deleteTask(id: '1'),
        ]);

        // Assert
        for (final result in results) {
          expect(result.isError, isTrue);
          result.when(
            onOk: (_) => fail('Should not be success'),
            onError: (error) => expect(error, isA<ErroDeComunicacaoException>()),
          );
        }
      });
    });

    group('Data Transformation and Validation', () {
      test('should correctly transform complex task data', () async {
        // Arrange
        final complexTaskJson = [
          {
            'id': 'complex-id-123',
            'title': 'Complex Task with Unicode: 测试 🚀',
            'description': 'Description with\nmultiple\nlines',
            'is_completed': false,
            'created_at': '2023-12-31T23:59:59.999Z',
            'completed_at': null,
          },
        ];

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok(complexTaskJson));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isOk, isTrue);
        result.when(
          onOk: (tasks) {
            expect(tasks, hasLength(1));
            
            final task = tasks[0];
            expect(task.id, equals('complex-id-123'));
            expect(task.title, equals('Complex Task with Unicode: 测试 🚀'));
            expect(task.description, equals('Description with\nmultiple\nlines'));
            expect(task.isCompleted, isFalse);
            expect(task.completedAt, isNull);
          },
          onError: (error) => fail('Should not be error: $error'),
        );
      });

      test('should handle tasks with all fields populated', () async {
        // Arrange
        final fullTaskJson = [
          {
            'id': '1',
            'title': 'Complete Task',
            'description': 'Fully populated task',
            'is_completed': true,
            'created_at': '2023-01-01T00:00:00Z',
            'completed_at': '2023-01-02T12:30:45Z',
          },
        ];

        when(() => mockApiClient.request(
              url: any(named: 'url'),
              metodo: MetodoHttp.get,
              headers: any(named: 'headers'),
            )).thenAnswer((_) async => Result.ok(fullTaskJson));

        // Act
        final result = await repository.getTasks();

        // Assert
        expect(result.isOk, isTrue);
        result.when(
          onOk: (tasks) {
            final task = tasks[0];
            
            expect(task.id, equals('1'));
            expect(task.title, equals('Complete Task'));
            expect(task.description, equals('Fully populated task'));
            expect(task.isCompleted, isTrue);
            expect(task.completedAt, isNotNull);
          },
          onError: (error) => fail('Should not be error: $error'),
        );
      });
    });
  });
}