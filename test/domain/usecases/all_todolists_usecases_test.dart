import 'package:baristodolistapp/domain/entities/todolist_entity.dart';
import 'package:baristodolistapp/domain/repositories/allTodolists_repository.dart';
import 'package:baristodolistapp/domain/usecases/allTodoLists_usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'all_todolists_usecases_test.mocks.dart';

@GenerateMocks([AllTodoListsRepository])
void main() {
  late AllTodoListsUsecases allTodoListsUsecases;
  late MockAllTodoListsRepository mockAllTodoListsRepository;

  setUp(() {
    mockAllTodoListsRepository = MockAllTodoListsRepository();
    allTodoListsUsecases = AllTodoListsUsecases(
        allTodoListsRepository: mockAllTodoListsRepository);
  });

  group('createNewTodoList usecase', () {
    final TodoListEntity t_todoListEntity = TodoListEntity(
      id: null,
      listName: 'Sport',
      todoModels: [],
    );

    test('should return an integer', () async {
      // arrange
      when(mockAllTodoListsRepository.createNewTodoList(
              todoListEntity: t_todoListEntity))
          .thenAnswer((realInvocation) async => const Right(1));
      // act
      final result = await allTodoListsUsecases.createNewTodoList(
          todoListEntity: t_todoListEntity);
      //assert
      expect(result, Right(1));
      verify(mockAllTodoListsRepository.createNewTodoList(
          todoListEntity: t_todoListEntity));
      verifyNoMoreInteractions(mockAllTodoListsRepository);
    });
  });
}
