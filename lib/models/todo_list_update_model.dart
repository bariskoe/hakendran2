import '../domain/entities/todo_list_update_entity.dart';
import 'todolist_model.dart';
import 'package:equatable/equatable.dart';

class TodoListUpdateModel extends TodoListUpdateEntity with EquatableMixin {
  TodoListUpdateModel(
      {required String uuid,
      required String listName,
      required TodoListCategory todoListCategory})
      : super(
          uuid: uuid,
          listName: listName,
          todoListCategory: todoListCategory,
        );

  @override
  List<Object?> get props => [uuid, listName, todoListCategory];
}
