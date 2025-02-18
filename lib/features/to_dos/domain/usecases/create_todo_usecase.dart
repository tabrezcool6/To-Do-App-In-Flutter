import 'dart:io';

import 'package:to_do_app_flutter/core/error/failures.dart';
import 'package:to_do_app_flutter/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/entities/todo_entity.dart';
import 'package:to_do_app_flutter/features/to_dos/domain/repositories/todo_repository.dart';

class CreateTodoUsecase implements UseCase<ToDoEntity, CreateTodoParams> {
  final TodoRepository todoRepository;
  CreateTodoUsecase(this.todoRepository);

  @override
  Future<Either<Failure, ToDoEntity>> call(CreateTodoParams params) async {
    return await todoRepository.createTodo(
      // image: params.imageUrl,
      title: params.title,
      desc: params.desc,
      posterId: params.posterId,
      // topics: params.topics,
    );
  }
}

class CreateTodoParams {
  final String posterId;
  final String title;
  final String desc;
  // final File imageUrl;
  // final List<String> topics;

  CreateTodoParams({
    required this.posterId,
    required this.title,
    required this.desc,
    // required this.imageUrl,
    // required this.topics,
  });
}
