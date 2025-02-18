import 'package:to_do_app_flutter/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:to_do_app_flutter/features/to_dos/data/model/todo_model.dart';

abstract interface class TodoSupabaseDataSource {
  // Abstract method to Create ToDo to database
  Future<ToDoModel> createTodo(ToDoModel todoModel);

  // abstract meethod to Read ToDo from database
  Future<List<ToDoModel>> readTodo({required String posterId});

  // abstract method to Update ToDo from database
  Future<ToDoModel> updateTodo({
    required String todoId,
    String? title,
    String? desc,
  });

  // abstract meethod to Delete ToDo from database
  Future<void> deleteTodo({required String todoId});
}

// concrete Implementatiion of abstract
class TodoSupabaseDataSourceImplementation extends TodoSupabaseDataSource {
  SupabaseClient supabaseClient;
  TodoSupabaseDataSourceImplementation(this.supabaseClient);

  /// concrete Implementatiion of Creating a ToDo to upload it to Server
  @override
  Future<ToDoModel> createTodo(ToDoModel todoModel) async {
    try {
      final todoData = await supabaseClient
          .from('todos')
          .insert(todoModel.toJson())
          .select();

      return ToDoModel.fromJson(todoData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Reading ToDos to display in thee application
  @override
  Future<List<ToDoModel>> readTodo({required String posterId}) async {
    try {
      final todos =
          await supabaseClient.from('todos').select().eq('poster_id', posterId);

      // method to sort todos based on ToDo created time
      // i.e, newly created ToDo will be displayed on the top of the list
      todos.sort((a, b) =>
          (b["updated_at"] as String).compareTo(a["updated_at"] as String));

      return todos.map((todo) => ToDoModel.fromJson(todo)).toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Updating ToDos on the Server
  @override
  Future<ToDoModel> updateTodo({
    String? title,
    String? desc,
    required String todoId,
  }) async {
    try {
      final todoData = await supabaseClient
          .from('todos')
          .update({
            'title': title,
            'descp': desc,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', todoId)
          .select();

      return ToDoModel.fromJson(todoData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  /// concrete Implementatiion of Deleting ToDos from the Server
  @override
  Future<void> deleteTodo({required String todoId}) async {
    try {
      await supabaseClient.from('todos').delete().eq('id', todoId);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
