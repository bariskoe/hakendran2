import 'package:baristodolistapp/domain/parameters/todolist_entity_parameters.dart';
import 'package:baristodolistapp/domain/repositories/all_todolists_repository.dart';
import 'package:baristodolistapp/domain/usecases/all_todolists_usecases.dart';
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
    final TodoListEntityParameters tTodoListEntityParameters =
        TodoListEntityParameters(
      listName: 'Sport',
      todoModels: [],
    );

    test('should return an integer', () async {
      // arrange
      when(mockAllTodoListsRepository.createNewTodoList(
              todoListEntityParameters: tTodoListEntityParameters))
          .thenAnswer((realInvocation) async => const Right(1));
      // act
      final result = await allTodoListsUsecases.createNewTodoList(
          todoListEntityParameters: tTodoListEntityParameters);
      //assert
      expect(result, const Right(1));
      verify(mockAllTodoListsRepository.createNewTodoList(
          todoListEntityParameters: tTodoListEntityParameters));
      verifyNoMoreInteractions(mockAllTodoListsRepository);
    });
  });
}
