import '../domain/entities/todo_list_update_entity.dart';
import 'todolist_model.dart';
import 'package:equatable/equatable.dart';

class TodoListUpdateModel extends TodoListUpdateEntity with EquatableMixin {
  TodoListUpdateModel(
      {required String uid,
      required String listName,
      required TodoListCategory todoListCategory})
      : super(
          uid: uid,
          listName: listName,
          todoListCategory: todoListCategory,
        );

  @override
  List<Object?> get props => [uid, listName, todoListCategory];
}
