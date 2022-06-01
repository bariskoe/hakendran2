import 'package:baristodolistapp/domain/entities/todo_list_update_entity.dart';
import 'package:baristodolistapp/models/todolist_model.dart';
import 'package:equatable/equatable.dart';

class TodoListUpdateModel extends TodoListUpdateEntity with EquatableMixin {
  TodoListUpdateModel(
      {required int id,
      required String listName,
      required TodoListCategory todoListCategory})
      : super(
          id: id,
          listName: listName,
          todoListCategory: todoListCategory,
        );

  @override
  List<Object?> get props => [id, listName, todoListCategory];
}
