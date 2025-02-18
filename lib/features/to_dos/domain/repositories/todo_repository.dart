import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';

abstract interface class TodoRepository {
  Future<Either<Failure, ToDoEntity>> createTodo({
    // required File image,
    required String title,
    required String desc,
    required String posterId,
    // required List<String> topics,
  });

  Future<Either<Failure, List<ToDoEntity>>> readTodo({required String posterId});

  Future<Either<Failure, ToDoEntity>> updateTodo({
    required ToDoEntity todoEntity,
    required String todoId,
    String? title,
    String? desc,
    // File? imageUrl,
    // List<String>? topics,
  });

  Future<Either<Failure, String>> deleteTodo({
    required String todoId,
  });
}
