// FILEPATH: /Users/baris/Desktop/Programmieren/flutter_projects/baristodolistapp/test/domain/entities/todo_entity_test.dart

import 'package:baristodolistapp/domain/entities/todo_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoEntity', () {
    late TodoEntity todoEntity1;
    late TodoEntity todoEntity2;

    setUp(() {
      todoEntity1 = TodoEntity(
        task: 'Test task',
        accomplished: false,
        parentTodoListId: 'abc123',
        thumbnailImageName: 'testImage.jpg',
      );

      todoEntity2 = TodoEntity(
        task: 'Test task 2',
        accomplished: false,
        parentTodoListId: 'abc123',
      );
    });

    test('hasImagePath returns true if thumbnailImageName is not null', () {
      expect(todoEntity1.hasImagePath, true);
    });

    test('hasImagePath returns false if thumbnailImageName is null', () {
      expect(todoEntity2.hasImagePath, false);
    });

    // Write another test for todoEntity
  });
}
