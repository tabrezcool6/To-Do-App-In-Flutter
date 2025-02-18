import 'package:hive/hive.dart';
import 'package:to_do_app_flutter/features/to_dos/data/model/todo_model.dart';

abstract interface class TodoLocalDataSource {
  ///
  void uploadTodosLocally({required List<ToDoModel> todos});

  ///
  List<ToDoModel> fetchTodosLocally();
}

class TodoLocalDataSourceImplementation implements TodoLocalDataSource {
  Box box;
  TodoLocalDataSourceImplementation(this.box);

  @override
  List<ToDoModel> fetchTodosLocally() {
    List<ToDoModel> todos = [];
    box.read(() {
      for (var i = 0; i < box.length; i++) {
        todos.add(ToDoModel.fromJson(box.get(i.toString())));
      }
    });
    print('///// BOX FETCH ${todos.first}');

    return todos;
  }

  @override
  void uploadTodosLocally({required List<ToDoModel> todos}) {
    box.clear();
    box.write(() {
      for (var i = 0; i < todos.length; i++) {
        box.put(i.toString(), todos[i].toJson());
      }
    });
  }
}
