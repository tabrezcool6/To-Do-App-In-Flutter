import 'dart:io';

import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/repositories/todo_repository.dart';

class UpdateTodoUsecase implements UseCase<ToDoEntity, UpdateTodoParams> {
  TodoRepository todoRepository;
  UpdateTodoUsecase(this.todoRepository);

  @override
  Future<Either<Failure, ToDoEntity>> call(params) async {
    return await todoRepository.updateTodo(
      todoEntity: params.todoEntity,
      todoId: params.todoId,
      title: params.title,
      desc: params.desc,
      // imageUrl: params.imageUrl,
      // topics: params.topics,
    );
  }
}

class UpdateTodoParams {
  final ToDoEntity todoEntity;
  final String todoId;
  String? title;
  String? desc;
  // File? imageUrl;
  // List<String>? topics;

  UpdateTodoParams({
    required this.todoEntity,
    required this.todoId,
    this.title,
    this.desc,
    // this.imageUrl,
    // this.topics,
  });
}
