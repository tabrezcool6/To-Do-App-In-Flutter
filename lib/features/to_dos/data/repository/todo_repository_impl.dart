
import 'package:to_do_app_flutter/core/constants.dart';
import 'package:to_do_app_flutter/core/error/exceptions.dart';
import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:to_do_app_flutter/features/to_dos/data/datasource/todo_local_data_source.dart';
import 'package:to_do_app_flutter/features/to_dos/data/datasource/todo_supabase_data_source.dart';
import 'package:to_do_app_flutter/features/to_dos/data/model/todo_model.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/repositories/todo_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:fpdart/fpdart.dart';

class TodoRepositoryImplementation implements TodoRepository {
  final TodoSupabaseDataSource todoSupabaseDataSource;
  final TodoLocalDataSource todoLocalDataSource;
  final InternetConnection internetConnection;

  TodoRepositoryImplementation(
    this.todoSupabaseDataSource,
    this.todoLocalDataSource,
    this.internetConnection,
  );

  @override
  Future<Either<Failure, ToDoEntity>> createTodo({
    // required File image,
    required String title,
    required String desc,
    required String posterId,
    // required List<String> topics,
  }) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }

      ToDoModel todoModel = ToDoModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        desc: desc,
        // imageUrl: '',
        // topics: topics,
        updatedAt: DateTime.now(),
      );

      // final imageUrl = await todoSupabaseDataSource.uploadTodoImage(
      //   image: image,
      //   todoId: todoModel.id,
      // );

      // todoModel = todoModel.copyWith(imageUrl: imageUrl);

      final uploadingTodo = await todoSupabaseDataSource.createTodo(todoModel);

      return right(uploadingTodo);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ToDoEntity>>> readTodo({required String posterId}) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        final todos = todoLocalDataSource.fetchTodosLocally();
        return right(todos);
      }
      final todos = await todoSupabaseDataSource.readTodo(posterId:posterId);
      todoLocalDataSource.uploadTodosLocally(todos: todos);
      return right(todos);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, ToDoEntity>> updateTodo({
    required ToDoEntity todoEntity,
    required String todoId,
    String? title,
    String? desc,
    // File? imageUrl,
    // List<String>? topics,
  }) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }

      // final uploadImageUrl = imageUrl != null
      //     ? await todoSupabaseDataSource.updateTodoImage(
      //         todoId: todoId,
      //         image: imageUrl,
      //       )
      //     : todoData.imageUrl;

      final uploadingTodo = await todoSupabaseDataSource.updateTodo(
        todoId: todoId,
        title: title,
        desc: desc,
        // imageUrl: uploadImageUrl,
        // topics: topics,
      );

      return right(uploadingTodo);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> deleteTodo({required String todoId}) async {
    try {
      if (!await (internetConnection.hasInternetAccess)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }
      await todoSupabaseDataSource.deleteTodo(todoId: todoId);
      return right('deleted');
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
