import 'package:flutter_test/flutter_test.dart';
import 'package:mastering_tests/domain/models/task.dart';

void main() {
  group('Task', () {
    test('should create task with required fields', () {
      // Arrange & Act
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: false,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      );

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, false);
      expect(task.createdAt, DateTime.parse('2023-01-01T00:00:00Z'));
      expect(task.completedAt, null);
    });

    test('should create completed task with completedAt date', () {
      // Arrange
      final completedDate = DateTime.parse('2023-01-02T00:00:00Z');
      
      // Act
      final task = Task(
        id: '1',
        title: 'Completed Task',
        description: 'Completed Description',
        isCompleted: true,
        createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        completedAt: completedDate,
      );

      // Assert
      expect(task.isCompleted, true);
      expect(task.completedAt, completedDate);
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        final createdAt = DateTime.parse('2023-01-01T00:00:00Z');
        
        final task1 = Task(
          id: '1',
          title: 'Task',
          description: 'Description',
          isCompleted: false,
          createdAt: createdAt,
        );
        
        final task2 = Task(
          id: '1',
          title: 'Task',
          description: 'Description',
          isCompleted: false,
          createdAt: createdAt,
        );

        // Act & Assert
        expect(task1, equals(task2));
        expect(task1.hashCode, equals(task2.hashCode));
      });

      test('should not be equal when properties differ', () {
        // Arrange
        final createdAt = DateTime.parse('2023-01-01T00:00:00Z');
        
        final task1 = Task(
          id: '1',
          title: 'Task 1',
          description: 'Description',
          isCompleted: false,
          createdAt: createdAt,
        );
        
        final task2 = Task(
          id: '2',
          title: 'Task 2',
          description: 'Description',
          isCompleted: false,
          createdAt: createdAt,
        );

        // Act & Assert
        expect(task1, isNot(equals(task2)));
        expect(task1.hashCode, isNot(equals(task2.hashCode)));
      });
    });

    group('copyWith', () {
      test('should create new instance with updated properties', () {
        // Arrange
        final originalTask = Task(
          id: '1',
          title: 'Original Title',
          description: 'Original Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        // Act
        final updatedTask = originalTask.copyWith(
          title: 'Updated Title',
          isCompleted: true,
          completedAt: DateTime.parse('2023-01-02T00:00:00Z'),
        );

        // Assert
        expect(updatedTask.id, originalTask.id);
        expect(updatedTask.title, 'Updated Title');
        expect(updatedTask.description, originalTask.description);
        expect(updatedTask.isCompleted, true);
        expect(updatedTask.createdAt, originalTask.createdAt);
        expect(updatedTask.completedAt, DateTime.parse('2023-01-02T00:00:00Z'));
        
        // Original should remain unchanged
        expect(originalTask.title, 'Original Title');
        expect(originalTask.isCompleted, false);
      });

      test('should return same instance when no changes provided', () {
        // Arrange
        final originalTask = Task(
          id: '1',
          title: 'Original Title',
          description: 'Original Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        // Act
        final copiedTask = originalTask.copyWith();

        // Assert
        expect(copiedTask, equals(originalTask));
      });
    });

    group('toString', () {
      test('should return formatted string representation', () {
        // Arrange
        final task = Task(
          id: '1',
          title: 'Test Task',
          description: 'Test Description',
          isCompleted: false,
          createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
        );

        // Act
        final stringRepresentation = task.toString();

        // Assert
        expect(stringRepresentation, contains('Task('));
        expect(stringRepresentation, contains('id: 1'));
        expect(stringRepresentation, contains('title: Test Task'));
        expect(stringRepresentation, contains('description: Test Description'));
        expect(stringRepresentation, contains('isCompleted: false'));
      });
    });
  });

  group('CreateTaskData', () {
    test('should create with required fields', () {
      // Arrange & Act
      final createData = CreateTaskData(
        title: 'New Task',
        description: 'New Description',
      );

      // Assert
      expect(createData.title, 'New Task');
      expect(createData.description, 'New Description');
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final data1 = CreateTaskData(
        title: 'Task',
        description: 'Description',
      );
      
      final data2 = CreateTaskData(
        title: 'Task',
        description: 'Description',
      );

      // Act & Assert
      expect(data1, equals(data2));
      expect(data1.hashCode, equals(data2.hashCode));
    });
  });

  group('UpdateTaskData', () {
    test('should create with optional fields', () {
      // Arrange & Act
      final updateData = UpdateTaskData(
        title: 'Updated Title',
        isCompleted: true,
      );

      // Assert
      expect(updateData.title, 'Updated Title');
      expect(updateData.description, null);
      expect(updateData.isCompleted, true);
    });

    test('should create with all null fields', () {
      // Arrange & Act
      final updateData = UpdateTaskData();

      // Assert
      expect(updateData.title, null);
      expect(updateData.description, null);
      expect(updateData.isCompleted, null);
    });

    test('should be equal when properties are the same', () {
      // Arrange
      final data1 = UpdateTaskData(title: 'Title');
      final data2 = UpdateTaskData(title: 'Title');

      // Act & Assert
      expect(data1, equals(data2));
    });
  });
}
