import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:mastering_tests/data/services/task_api_service.dart';
import 'package:mastering_tests/domain/models/task.dart';

// Mocks
class MockDio extends Mock implements Dio {}

void main() {
  group('SupabaseTaskApiService', () {
    late SupabaseTaskApiService service;
    late MockDio mockDio;
    const baseUrl = 'https://api.example.com';

    setUp(() {
      mockDio = MockDio();
      service = SupabaseTaskApiService(dio: mockDio, baseUrl: baseUrl);
    });

    setUpAll(() {
      // Register fallback values
      registerFallbackValue(RequestOptions(path: ''));
      registerFallbackValue(CreateTaskData(title: '', description: ''));
      registerFallbackValue(UpdateTaskData());
    });

    group('getTasks', () {
      test('should return list of tasks when API call is successful', () async {
        // Arrange
        final responseData = [
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
            'created_at': '2023-01-01T00:00:00Z',
            'completed_at': '2023-01-02T00:00:00Z',
          },
        ];
        
        when(() => mockDio.get('$baseUrl/tasks')).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '$baseUrl/tasks'),
          ),
        );

        // Act
        final result = await service.getTasks();

        // Assert
        expect(result, hasLength(2));
        expect(result.first.id, '1');
        expect(result.first.title, 'Task 1');
        expect(result.first.isCompleted, false);
        expect(result.last.id, '2');
        expect(result.last.isCompleted, true);
        expect(result.last.completedAt, isNotNull);
        
        verify(() => mockDio.get('$baseUrl/tasks')).called(1);
      });

      test('should throw DioException when API returns error status', () async {
        // Arrange
        when(() => mockDio.get('$baseUrl/tasks')).thenAnswer(
          (_) async => Response(
            data: {'error': 'Internal server error'},
            statusCode: 500,
            requestOptions: RequestOptions(path: '$baseUrl/tasks'),
          ),
        );

        // Act & Assert
        expect(() => service.getTasks(), throwsA(isA<DioException>()));
        verify(() => mockDio.get('$baseUrl/tasks')).called(1);
      });

      test('should throw DioException when network error occurs', () async {
        // Arrange
        when(() => mockDio.get('$baseUrl/tasks')).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '$baseUrl/tasks'),
            message: 'Network error',
            type: DioExceptionType.connectionError,
          ),
        );

        // Act & Assert
        expect(() => service.getTasks(), throwsA(isA<DioException>()));
        verify(() => mockDio.get('$baseUrl/tasks')).called(1);
      });

      test('should handle unexpected error and wrap in DioException', () async {
        // Arrange
        when(() => mockDio.get('$baseUrl/tasks')).thenThrow(
          FormatException('Invalid JSON'),
        );

        // Act & Assert
        expect(() => service.getTasks(), throwsA(isA<DioException>()));
        verify(() => mockDio.get('$baseUrl/tasks')).called(1);
      });
    });

    group('getTask', () {
      test('should return single task when API call is successful', () async {
        // Arrange
        const taskId = '1';
        final responseData = {
          'id': '1',
          'title': 'Single Task',
          'description': 'Single Description',
          'is_completed': false,
          'created_at': '2023-01-01T00:00:00Z',
        };
        
        when(() => mockDio.get('$baseUrl/tasks/$taskId')).thenAnswer(
          (_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ),
        );

        // Act
        final result = await service.getTask(taskId);

        // Assert
        expect(result.id, '1');
        expect(result.title, 'Single Task');
        expect(result.description, 'Single Description');
        expect(result.isCompleted, false);
        
        verify(() => mockDio.get('$baseUrl/tasks/$taskId')).called(1);
      });

      test('should throw DioException when task not found', () async {
        // Arrange
        const taskId = 'nonexistent';
        
        when(() => mockDio.get('$baseUrl/tasks/$taskId')).thenAnswer(
          (_) async => Response(
            data: {'error': 'Task not found'},
            statusCode: 404,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ),
        );

        // Act & Assert
        expect(() => service.getTask(taskId), throwsA(isA<DioException>()));
        verify(() => mockDio.get('$baseUrl/tasks/$taskId')).called(1);
      });
    });

    group('createTask', () {
      test('should return created task when API call is successful', () async {
        // Arrange
        final taskData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        final responseData = {
          'id': '3',
          'title': 'New Task',
          'description': 'New Description',
          'is_completed': false,
          'created_at': '2023-01-01T00:00:00Z',
        };
        
        when(() => mockDio.post('$baseUrl/tasks', data: any(named: 'data')))
          .thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 201,
            requestOptions: RequestOptions(path: '$baseUrl/tasks'),
          ));

        // Act
        final result = await service.createTask(taskData);

        // Assert
        expect(result.id, '3');
        expect(result.title, 'New Task');
        expect(result.description, 'New Description');
        expect(result.isCompleted, false);
        
        // Verify correct data was sent
        final capturedData = verify(() => mockDio.post(
          '$baseUrl/tasks',
          data: captureAny(named: 'data'),
        )).captured.first as Map<String, dynamic>;
        
        expect(capturedData['title'], 'New Task');
        expect(capturedData['description'], 'New Description');
        expect(capturedData['is_completed'], false);
        expect(capturedData['created_at'], isNotNull);
      });

      test('should throw DioException when creation fails', () async {
        // Arrange
        final taskData = CreateTaskData(
          title: 'New Task',
          description: 'New Description',
        );
        
        when(() => mockDio.post('$baseUrl/tasks', data: any(named: 'data')))
          .thenAnswer((_) async => Response(
            data: {'error': 'Validation failed'},
            statusCode: 422,
            requestOptions: RequestOptions(path: '$baseUrl/tasks'),
          ));

        // Act & Assert
        expect(() => service.createTask(taskData), throwsA(isA<DioException>()));
      });
    });

    group('updateTask', () {
      test('should return updated task when API call is successful', () async {
        // Arrange
        const taskId = '1';
        final updateData = UpdateTaskData(
          title: 'Updated Task',
          isCompleted: true,
        );
        
        final responseData = {
          'id': '1',
          'title': 'Updated Task',
          'description': 'Original Description',
          'is_completed': true,
          'created_at': '2023-01-01T00:00:00Z',
          'completed_at': '2023-01-02T00:00:00Z',
        };
        
        when(() => mockDio.patch('$baseUrl/tasks/$taskId', data: any(named: 'data')))
          .thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ));

        // Act
        final result = await service.updateTask(taskId, updateData);

        // Assert
        expect(result.id, '1');
        expect(result.title, 'Updated Task');
        expect(result.isCompleted, true);
        expect(result.completedAt, isNotNull);
        
        // Verify correct data was sent
        final capturedData = verify(() => mockDio.patch(
          '$baseUrl/tasks/$taskId',
          data: captureAny(named: 'data'),
        )).captured.first as Map<String, dynamic>;
        
        expect(capturedData['title'], 'Updated Task');
        expect(capturedData['is_completed'], true);
        expect(capturedData['completed_at'], isNotNull);
      });

      test('should only send non-null fields in update data', () async {
        // Arrange
        const taskId = '1';
        final updateData = UpdateTaskData(title: 'Updated Title');
        
        final responseData = {
          'id': '1',
          'title': 'Updated Title',
          'description': 'Original Description',
          'is_completed': false,
          'created_at': '2023-01-01T00:00:00Z',
        };
        
        when(() => mockDio.patch('$baseUrl/tasks/$taskId', data: any(named: 'data')))
          .thenAnswer((_) async => Response(
            data: responseData,
            statusCode: 200,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ));

        // Act
        await service.updateTask(taskId, updateData);

        // Assert
        final capturedData = verify(() => mockDio.patch(
          '$baseUrl/tasks/$taskId',
          data: captureAny(named: 'data'),
        )).captured.first as Map<String, dynamic>;
        
        expect(capturedData['title'], 'Updated Title');
        expect(capturedData.containsKey('description'), false);
        expect(capturedData.containsKey('is_completed'), false);
      });
    });

    group('deleteTask', () {
      test('should complete successfully when API returns 204', () async {
        // Arrange
        const taskId = '1';
        
        when(() => mockDio.delete('$baseUrl/tasks/$taskId'))
          .thenAnswer((_) async => Response(
            statusCode: 204,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ));

        // Act & Assert
        await expectLater(service.deleteTask(taskId), completes);
        verify(() => mockDio.delete('$baseUrl/tasks/$taskId')).called(1);
      });

      test('should complete successfully when API returns 200', () async {
        // Arrange
        const taskId = '1';
        
        when(() => mockDio.delete('$baseUrl/tasks/$taskId'))
          .thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ));

        // Act & Assert
        await expectLater(service.deleteTask(taskId), completes);
        verify(() => mockDio.delete('$baseUrl/tasks/$taskId')).called(1);
      });

      test('should throw DioException when deletion fails', () async {
        // Arrange
        const taskId = '1';
        
        when(() => mockDio.delete('$baseUrl/tasks/$taskId'))
          .thenAnswer((_) async => Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '$baseUrl/tasks/$taskId'),
          ));

        // Act & Assert
        expect(() => service.deleteTask(taskId), throwsA(isA<DioException>()));
        verify(() => mockDio.delete('$baseUrl/tasks/$taskId')).called(1);
      });
    });
  });
}
